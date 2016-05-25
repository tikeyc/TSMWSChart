//
//  WSBaseAxisRenderer.m
//  AnalysisGraph
//
//  Created by Ansonyc on 13-9-11.
//  Copyright (c) 2013年 Ways.cn. All rights reserved.
//

#import "TSMWSBaseAxisRenderer.h"
#import <QuartzCore/QuartzCore.h>
#import "TSMWSDrawingStrategy.h"

const CGFloat smfontSize = 15;
const CGFloat smrectWidth = 36;       // 矩形类型头部元素的宽度
const CGFloat smelementHeight = 24;
const CGFloat smtextWidth = 150;      // 头部元素文字部分的最大宽度

@implementation TSMWSHeaderElement

+ (id)headerElementWithText:(NSString *)text
                      color:(UIColor *)color
                      index:(NSInteger)index
                       type:(TWSHeaderElementType)type
{
    TSMWSHeaderElement *header = [[TSMWSHeaderElement alloc] init];

    [header setIndex:index];
    [header setText:text];
    [header setColor:color];
    [header setType:type];

    return header;
}

+ (id)headerElementWithText:(NSString *)text
                      color:(UIColor *)color
                      index:(NSInteger)index
                       type:(TWSHeaderElementType)type
      shouldFollowWithSpace:(BOOL)shouldFollowedWithSpace
{
    TSMWSHeaderElement *header = [self headerElementWithText:text
                                                    color:color
                                                    index:index
                                                     type:type];
    [header setShouldFollowedWithSpace:shouldFollowedWithSpace];
    return header;
}

@end

@implementation TSMWSBaseAxisRenderer

- (CGFloat)headerHeight
{
    return _headerHeight == 0 ? 50 : _headerHeight;
}

- (void)renderBackgroundLayer:(CALayer *)backgroundLayer view:(UIView *)view
{
    // 删除原有的在backgroundlayer上的头部元素
    while ([[backgroundLayer sublayers] count] > 0)
    {
        [[[backgroundLayer sublayers] lastObject] removeFromSuperlayer];
    }

    for (int i = [[view subviews] count]-1;i >= 0; i--)
    {
        if ([[view subviews][i] isKindOfClass:[UIButton class]])
        {
            [[view subviews][i] removeFromSuperview];
        }
    }

    // 在backgroundLayer上添加新的头部元素
    if ([[self dataSource] respondsToSelector:@selector(headerElementsForAxisRenderer:)])
    {
        CGFloat currentX = 0;
        for (TSMWSHeaderElement *headerElement in [[self dataSource] headerElementsForAxisRenderer:self])
        {
            switch ([headerElement type])
            {
                case TWSElementTypePlainText:
                {
                    [self WS_addTextHeader:headerElement
                               parentLayer:backgroundLayer
                                    startX:&currentX];
                    break;
                }
                case TWSElementTypeColorRect:
                {
                    [self WS_addColorRectHeader:headerElement
                                           view:view
                                         startX:&currentX];
                    break;
                }
                case TWSElementTypeLineSpot:
                case TWSElementTypeDashLineSpot:
                {
                    [self WS_addLineSpotHeader:headerElement
                                          view:view
                                        startX:&currentX];
                    break;
                }
                default:
                    break;
            }
        }
    }
}

- (void)WS_addTextHeader:(TSMWSHeaderElement *)element
             parentLayer:(CALayer *)parentLayer
                  startX:(CGFloat*)pStartX
{
    CGSize textSize = [[element text] sizeWithFont:[UIFont boldSystemFontOfSize:smfontSize]
                                 constrainedToSize:CGSizeMake(100,
                                                              20)];
    if (*pStartX == 0)
    {
        *pStartX = [self leftMargin]-textSize.width;
    }
    else
    {
        *pStartX += 10;
    }

    CATextLayer *layer = [CATextLayer layer];
    [layer setString:[element text]];
    [layer setFont:@"Helvetica"];
    [layer setBounds:CGRectMake(0, 0, textSize.width, textSize.height)];
    [layer setAnchorPoint:CGPointMake(0, 0)];
    [layer setPosition:CGPointMake(parentLayer.bounds.size.width-(*pStartX+textSize.width),
                                   .5*([self topMargin]-textSize.height))];
    [layer setFontSize:smfontSize];
    [layer setForegroundColor:[[UIColor colorWithRed:93.0/255.0
                                               green:103.0/255.0
                                                blue:108.0/255.0
                                               alpha:1] CGColor]];

    [parentLayer addSublayer:layer];
    *pStartX += layer.bounds.size.width;
    if ([element shouldFollowedWithSpace])
    {
        *pStartX += 15;
    }
}

// 添加矩形颜色块类型的头部元素
- (void)WS_addColorRectHeader:(TSMWSHeaderElement *)element
                         view:(UIView *)parentView
                       startX:(CGFloat*)pStartX
{
    // 绘制正常状态的图片
    if (*pStartX == 0)
    {
        *pStartX = [self leftMargin];
    }

    CGSize textSize = [[element text] sizeWithFont:[UIFont boldSystemFontOfSize:smfontSize]
                                 constrainedToSize:CGSizeMake(smtextWidth, CGFLOAT_MAX)
                                     lineBreakMode:NSLineBreakByTruncatingMiddle];
    if (textSize.width > 0)
    {
        textSize.width += 4;
    }
    CGSize imageSize = CGSizeMake(smrectWidth+textSize.width, MAX(smelementHeight, textSize.height));
    UIGraphicsBeginImageContext(CGSizeMake(imageSize.width*[[UIScreen mainScreen] scale],
                                           imageSize.height*[[UIScreen mainScreen] scale]));
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(contextRef,
                      [[UIScreen mainScreen] scale],
                      [[UIScreen mainScreen] scale]);
    CGContextSetFillColorWithColor(contextRef, [[element color] CGColor]);
    CGContextFillRect(contextRef, CGRectInset(CGRectMake(0, 0, smrectWidth, imageSize.height),
                                              3, imageSize.height/2-5));
    
    CGContextSetFillColorWithColor(contextRef, [[element color] CGColor]);
    
    [[element text] drawInRect:CGRectMake(smrectWidth+4,
                                          .5*(imageSize.height-textSize.height),
                                          textSize.width,
                                          textSize.height)
                      withFont:[UIFont boldSystemFontOfSize:smfontSize]
                 lineBreakMode:NSLineBreakByTruncatingMiddle
                     alignment:NSTextAlignmentLeft];
    [[UIColor whiteColor] setStroke];
    CGContextSetLineWidth(contextRef, 2);
    CGContextStrokeRect(contextRef, CGRectInset(CGRectMake(0,
                                                           0,
                                                           smrectWidth,
                                                           imageSize.height),
                                                3,
                                                imageSize.height/2-5));

    // position the button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(parentView.frame.size.width-(*pStartX+imageSize.width),
                                ([self topMargin]-imageSize.height)/2,
                                imageSize.width,
                                imageSize.height)];
    [button setImage:UIGraphicsGetImageFromCurrentImageContext()
            forState:UIControlStateNormal];
    
    // 设置按钮的tag，tag由分组的index和可视化对象的类型决定
    [button setTag:[element index]+(TWSElementTypeColorRect<<16)];

    // 绘制disable状态下的按钮图片
    [[UIColor grayColor] setStroke];
    [[UIColor grayColor] setFill];
    CGContextFillRect(contextRef, CGRectInset(CGRectMake(0, 0, smrectWidth, imageSize.height),
                                              3, imageSize.height/2-5));
    CGContextSetLineWidth(contextRef, 2);
    CGContextStrokeRect(contextRef,
                        CGRectInset(CGRectMake(0, 0, smrectWidth, imageSize.height),
                                    3,
                                    imageSize.height/2-5));
    [button setImage:UIGraphicsGetImageFromCurrentImageContext()
            forState:UIControlStateSelected];
    
    UIGraphicsEndImageContext();
    [parentView addSubview:button];

    *pStartX += imageSize.width;
    if ([element shouldFollowedWithSpace])
    {
        *pStartX += 15;
    }
}

- (void)WS_addLineSpotHeader:(TSMWSHeaderElement *)element
                        view:(UIView *)parentView
                      startX:(CGFloat*)pStartX
{
    // 绘制正常状态按钮的图片
    CGSize textSize = [[element text] sizeWithFont:[UIFont boldSystemFontOfSize:smfontSize]
                                 constrainedToSize:CGSizeMake(smtextWidth, CGFLOAT_MAX)
                                     lineBreakMode:NSLineBreakByTruncatingMiddle];
    CGSize imageSize = CGSizeMake(smrectWidth+textSize.width,
                                  MAX(smelementHeight, textSize.height));
    UIGraphicsBeginImageContext(CGSizeMake(imageSize.width*[[UIScreen mainScreen] scale],
                                           imageSize.height*[[UIScreen mainScreen] scale]));
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(contextRef,
                      [[UIScreen mainScreen] scale],
                      [[UIScreen mainScreen] scale]);
    [[UIColor whiteColor] setFill];
    CGContextSetLineWidth(contextRef, 2);
    CGContextSetStrokeColorWithColor(contextRef,
                                     [[element color] CGColor]);
    CGContextSaveGState(contextRef);
    if ([element type]==TWSElementTypeDashLineSpot)
    {
        CGFloat lengths[] = {8.,4.};
        CGContextSetLineDash(contextRef, 0, lengths, 2);
    }
    CGContextMoveToPoint(contextRef, 2, imageSize.height/2);
    CGContextAddLineToPoint(contextRef, smrectWidth-2, imageSize.height/2);
    CGContextStrokePath(contextRef);
    CGContextRestoreGState(contextRef);
    CGContextFillEllipseInRect(contextRef,
                               CGRectInset(CGRectMake(0,
                                                      0,
                                                      smrectWidth,
                                                      imageSize.height),
                                           smrectWidth*.5-4,
                                           imageSize.height/2-4));
    CGContextStrokeEllipseInRect(contextRef,
                                 CGRectInset(CGRectMake(0,
                                                        0,
                                                        smrectWidth,
                                                        imageSize.height),
                                             smrectWidth*.5-4,
                                             imageSize.height/2-4));

    CGContextSetFillColorWithColor(contextRef, [[element color] CGColor]);
    [[element text] drawInRect:CGRectMake(smrectWidth,
                                          .5*(imageSize.height-textSize.height),
                                          textSize.width,
                                          textSize.height)
                      withFont:[UIFont boldSystemFontOfSize:smfontSize]
                 lineBreakMode:NSLineBreakByTruncatingMiddle
                     alignment:NSTextAlignmentLeft];

    // position the button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (*pStartX == 0)
    {
        *pStartX = [self leftMargin];
    }

    [button setFrame:CGRectMake(parentView.frame.size.width-(*pStartX+imageSize.width),
                                ([self topMargin]-imageSize.height)/2,
                                imageSize.width,
                                imageSize.height)];
    [button setImage:UIGraphicsGetImageFromCurrentImageContext()
            forState:UIControlStateNormal];

    // 绘制disable状态下按钮的图片
    [[UIColor grayColor] setFill];
    [[UIColor grayColor] setStroke];
    CGContextFillEllipseInRect(contextRef, CGRectInset(CGRectMake(0,
                                                                  0,
                                                                  smrectWidth,
                                                                  imageSize.height),
                                                       smrectWidth*.5-4,
                                                       imageSize.height/2-4));
    CGContextStrokeEllipseInRect(contextRef, CGRectInset(CGRectMake(0,
                                                                    0,
                                                                    smrectWidth,
                                                                    imageSize.height),
                                                         smrectWidth*.5-4,
                                                         imageSize.height/2-4));
    [button setImage:UIGraphicsGetImageFromCurrentImageContext()
            forState:UIControlStateSelected];
    
    // 设置按钮的tag，tag由分组的index和可视化对象的类型决定
    [button setTag:[element index]+([element type]<<16)];

    UIGraphicsEndImageContext();
    [parentView addSubview:button];

    *pStartX += imageSize.width;
    if ([element shouldFollowedWithSpace])
    {
        *pStartX += 15;
    }
}

@end