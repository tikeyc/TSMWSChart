//
//  WSStandardAxisRenderer.m
//  AnalysisGraph
//
//  Created by Ansonyc on 13-9-11.
//  Copyright (c) 2013年 Ways.cn. All rights reserved.
//

#import "TSMWSStandardAxisRenderer.h"
#import "TSMWSBaseAxisRenderer+Protected.h"

@implementation TSMWSStandardAxisRenderer

- (void)renderBackgroundLayer:(CALayer *)backgroundLayer view:(UIView *)view
{
    [super renderBackgroundLayer:backgroundLayer view:view];
    CGSize size = backgroundLayer.bounds.size;
    CGFloat scale = [[UIScreen mainScreen] scale];
    
    UIGraphicsBeginImageContext(CGSizeMake(size.width*scale, size.height*scale));
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(contextRef, scale, scale);

    if ([backgroundLayer contents])
    {
        UIImage *image = [UIImage imageWithCGImage:(__bridge CGImageRef)([backgroundLayer contents])];
        [image drawInRect:[backgroundLayer bounds]];
    }

    NSArray *yTitles = [self WS_segmentsAtY];

    CGPoint translate = [self WS_startPosition];
    CGPoint length = [self WS_lengthInPercentage];

    CGContextSaveGState(contextRef);
    CGContextTranslateCTM(contextRef, translate.x*(size.width-[self leftMargin]), 0);

    [[UIColor colorWithWhite:144.0/255.0 alpha:1] setStroke];
    [[UIColor colorWithWhite:144.0/255.0 alpha:1] setFill];
    CGFloat yAxisTop = (size.height-[self bottomMargin]+1)-(size.height-[self bottomMargin]-[self topMargin])*length.y-20;
    CGContextMoveToPoint(contextRef, [self leftMargin], yAxisTop);
    CGContextAddLineToPoint(contextRef, [self leftMargin]+4, yAxisTop+5);
    CGContextAddLineToPoint(contextRef, [self leftMargin]-4, yAxisTop+5);
    CGContextClosePath(contextRef);
    CGContextFillPath(contextRef);

    CGContextMoveToPoint(contextRef, [self leftMargin], size.height-[self bottomMargin]+1);
    CGContextAddLineToPoint(contextRef, [self leftMargin], yAxisTop);
    CGContextStrokePath(contextRef);
    CGContextRestoreGState(contextRef);

    if ([yTitles count] > 0)
    {
        CGFloat ySpan = (size.height-[self bottomMargin]-[self topMargin])*length.y;
        if ([yTitles count]>1)
        {
            ySpan /= [yTitles count]-1;
        }

        CGFloat currentY = size.height-[self bottomMargin];

        [[UIColor colorWithRed:93.0/255.0
                         green:103.0/255.0
                          blue:108.0/255.0
                         alpha:1] setFill];
        [[UIColor colorWithWhite:196./255. alpha:1] setStroke];
        CGRect yAxisTitleRect;
        for (int i = 0; i < [yTitles count]; i++)
        {
            NSString *title = yTitles[i];
            CGFloat fontSize = 12;
            CGSize textSize = [title sizeWithFont:[UIFont systemFontOfSize:12]
                                      minFontSize:5
                                   actualFontSize:&fontSize
                                         forWidth:[self leftMargin]
                                    lineBreakMode:NSLineBreakByClipping];
            if (translate.x > .5)
            {
                yAxisTitleRect = CGRectMake([self leftMargin]+translate.x*(size.width-[self leftMargin])+3,
                                            currentY-textSize.height/2,
                                            textSize.width,
                                            textSize.height);
            }
            else
            {
                yAxisTitleRect =  CGRectMake([self leftMargin]-textSize.width-3,
                                             currentY-textSize.height/2,
                                             textSize.width,
                                             textSize.height);
            }
            [title drawInRect:yAxisTitleRect
                     withFont:[UIFont systemFontOfSize:fontSize]
                lineBreakMode:NSLineBreakByClipping
                    alignment:NSTextAlignmentCenter];

            if (i != 0)
            {
                CGFloat contentWidth = size.width-[self leftMargin];
                CGFloat startX = [self leftMargin]+1+contentWidth*translate.x;
                CGContextMoveToPoint(contextRef, startX, currentY);
                CGContextAddLineToPoint(contextRef, startX+contentWidth*length.x, currentY);
            }

            currentY -= ySpan;
        }
    }

    CGContextStrokePath(contextRef);

    [backgroundLayer setContents:(id)
     [UIGraphicsGetImageFromCurrentImageContext() CGImage]];
    UIGraphicsEndImageContext();
}

- (void)renderAxisX:(CALayer *)xLayer size:(CGSize)size
{
    NSArray *xTitles = [self WS_segmentsAtX];

    CGFloat width = size.width;
    size.width = [self gapBetweenXGroups];
    for (int i = 0; i < [xTitles count]; i++)
    {
        size.width += [self gapBetweenXGroups]*2+[self groupWidth];
    }
    size.width = MAX(width, size.width);
    [CATransaction setAnimationDuration:0];
    [xLayer setBounds:CGRectMake(0, 0, size.width, size.height)];

    UIGraphicsBeginImageContext(CGSizeMake(size.width*[[UIScreen mainScreen] scale],
                                           size.height*[[UIScreen mainScreen] scale]));
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(contextRef,
                      [[UIScreen mainScreen] scale],
                      [[UIScreen mainScreen] scale]);

    [[UIColor blackColor] setFill];
    
    if ([xTitles count] > 0)
    {
        [[UIColor colorWithRed:93.0/255.0
                         green:103.0/255.0
                          blue:108.0/255.0
                         alpha:1] setFill];
        [[UIColor colorWithWhite:196./255.0 alpha:1] setStroke];
        CGFloat currentX = [self gapBetweenXGroups];
        for (int i = 0; i < [xTitles count]; i++)
        {
            NSString *title = xTitles[i];
            CGSize textSize = [title sizeWithFont:[UIFont systemFontOfSize:12]
                                constrainedToSize:CGSizeMake([self groupWidth], CGFLOAT_MAX)
                                    lineBreakMode:NSLineBreakByCharWrapping];
            CGRect textRect = CGRectMake(currentX+.5*([self groupWidth]-textSize.width),
                                         size.height-[self bottomMargin]+5,
                                         textSize.width,
                                         textSize.height);
            [title drawInRect:textRect
                     withFont:[UIFont systemFontOfSize:12]
                lineBreakMode:NSLineBreakByClipping
                    alignment:NSTextAlignmentCenter];
            currentX += [self gapBetweenXGroups]*2 + [self groupWidth];

            CGContextMoveToPoint(contextRef,
                                 CGRectGetMidX(textRect),
                                 size.height-[self bottomMargin]);
            CGContextAddLineToPoint(contextRef,
                                    CGRectGetMidX(textRect),
                                    [self topMargin]);
        }

        CGContextStrokePath(contextRef);
    }

    [[UIColor lightGrayColor] setStroke];

    [xLayer setContents:(id)[UIGraphicsGetImageFromCurrentImageContext() CGImage]];
    UIGraphicsEndImageContext();
}

@end
