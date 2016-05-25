//
//  WSHistogramDrawing.m
//  AnalysisGraph
//
//  Created by Ansonyc on 13-9-9.
//  Copyright (c) 2013年 Ways.cn. All rights reserved.
//

#import "TSMWSHistogramDrawing.h"
#import <QuartzCore/QuartzCore.h>
#import "TSMWSBaseAxisRenderer.h"

@interface TSMWSHistogramDrawing ()
@property (nonatomic, strong) NSMutableDictionary *histogramLayers;
@property (nonatomic, strong) NSMutableDictionary *textLayers;
@end

@implementation TSMWSHistogramDrawing
{
    CGSize _size;
}

@synthesize dataSource, gapBetweenGroups, groupWidth, hiddenIndexs, animated;
- (CALayer *)contentLayerForSize:(CGSize)size reuseLayer:(CALayer *)layer
{
    layer = [CALayer layer];

    // 使用传入的size.height，绘制柱状的过程中计算总宽度
    _size = size;
    _size.width = [self gapBetweenGroups];

    for (int i = 0; i < [[self dataSource] numberOfXGroups:self]; i++)
    {
        [self WS_addLayerForGroupAtIndex:i parentLayer:layer];
        _size.width += [self groupWidth]+2*[self gapBetweenGroups];
    }
    [layer setBounds:CGRectMake(0, 0, _size.width, _size.height)];

    return layer;
}

- (CATextLayer *)WS_addTextLayer:(NSString *)key
                           index:(int)i
                      groupIndex:(NSUInteger)groupIndex
                           width:(CGFloat)width
                          colors:(CGColorRef)color
                           layer:(CALayer *)layer
{
    BOOL reuse;
    CATextLayer *textLayer;
    if ([self textLayers][key])
    {
        textLayer = [self textLayers][key];
        reuse = YES;
    }
    else
    {
        textLayer = [CATextLayer layer];
        [textLayer setAnchorPoint:CGPointMake(0.5, 0)];
        [self textLayers][key] = textLayer;
        [textLayer setFontSize:10];
        [textLayer setAlignmentMode:kCAAlignmentCenter];
        [textLayer setWrapped:YES];
        reuse = NO;
    }
    NSString *string = [NSString stringWithFormat:@"%d",
                        (int)[[self dataSource] drawingStrategy:self
                                                  valueForGroup:groupIndex
                                                        atIndex:i]];
    if ([[self dataSource] respondsToSelector:@selector(histogramDrawing:
                                                        textForGroup:
                                                        atIndex:)])
    {
        string = [[self dataSource] histogramDrawing:self
                                        textForGroup:groupIndex
                                             atIndex:i];
    }
    
    [textLayer setString:string];
    [textLayer setBounds:CGRectMake(0, 0, width, 20)];
    [textLayer setForegroundColor:color];
    
    if (animated)
    {
        CABasicAnimation *animation =
        [CABasicAnimation animationWithKeyPath:@"position.y"];
        
        if (!reuse)
        {
            // animation
            [animation setFromValue:[NSNumber numberWithFloat:_size.height-15]];
            [animation setToValue:[NSNumber numberWithFloat:_size.height-layer.bounds.size.height-15]];
        }
        else
        {
            [animation setFromValue:@(textLayer.position.y)];
            [animation setToValue:@(_size.height-layer.bounds.size.height-15)];
        }
        [animation setDuration:.5];
        [animation setRemovedOnCompletion:YES];
        [textLayer addAnimation:animation forKey:@"grow"];
    }
    [textLayer setPosition:CGPointMake(layer.position.x, _size.height-layer.bounds.size.height-15)];
    return textLayer;
}

- (void)WS_addLayerForGroupAtIndex:(NSUInteger)groupIndex
                       parentLayer:(CALayer *)parentLayer
{
    if ([[self dataSource] drawingStrategy:self numberOfItemsInGroup:groupIndex] == 0)
    {
        return;
    }

//    if ([[self hiddenIndexs] containsObject:@(groupIndex+(WSElementTypeColorRect<<16))])
//    {
//        return;
//    }

    // 根据分组index计算当前的x坐标
    CGFloat currentX = [self gapBetweenGroups];
    for (int i = 0; i < groupIndex; i++)
    {
        currentX += [self groupWidth]+2*[self gapBetweenGroups];
    }

    // 本分组内每个元素的可用宽度
    CGFloat width = [self groupWidth]/[[self dataSource] drawingStrategy:self
                                                    numberOfItemsInGroup:groupIndex];

    CGFloat maxY = 0;
    CGFloat maxValue = [[self dataSource] maxValueForDrawingStrategy:self];
    CGFloat minValue = [[self dataSource] minValueForDrawingStrategy:self];
    maxY = maxValue - minValue;

    if (maxY==0)
    {
        return;
    }

    BOOL reuse = NO;
    CGFloat centerX = currentX+[self groupWidth]*.5;
    
    // 配置每个元素的柱
    
    for (int i = 0;
         i < [[self dataSource] drawingStrategy:self numberOfItemsInGroup:groupIndex];
         i++)
    {
        CGFloat value = [[self dataSource] drawingStrategy:self
                                             valueForGroup:groupIndex
                                                   atIndex:i];
        
        // 不绘制被隐藏的柱
        /*[[self dataSource] drawingStrategy:self numberOfItemsInGroup:0]返回的是有几组直方图（颜色相同的算一组）。
         *一般也就2组算多了，再多，就不好显示了！！！
         *所以当需要隐藏X刻度某一个点上的组装图，就需要在下面判断了
         */
        if ([[self hiddenIndexs] containsObject:@(i+(TWSElementTypeColorRect<<16))]
            || value==CGFLOAT_MAX || value==CGFLOAT_MIN)
        {
            continue;
        }

        CALayer *layer = nil;
        NSArray *colors = [[self dataSource] histogramDrawing:self
                                               colorsForGroup:groupIndex
                                                      atIndex:i];

        NSString *key = [NSString stringWithFormat:@"%lu-%d", (unsigned long)groupIndex, i];
        if ([self histogramLayers][key])
        {
            layer = [self histogramLayers][key];
            reuse = YES;
        }
        else
        {
            layer = [CALayer layer];
            [self histogramLayers][key] = layer;
            reuse = NO;
        }

        [layer setBackgroundColor:(__bridge CGColorRef)[colors lastObject]];
        [layer setAnchorPoint:CGPointMake(0.5, 1)];

        if (animated)
        {
            CABasicAnimation *animation =
            [CABasicAnimation animationWithKeyPath:@"bounds.size.height"];
            if (!reuse)
            {
                animation.fromValue = @(0);
                animation.toValue = @(_size.height*((value-minValue)/maxY));
            }
            else
            {
                animation.fromValue = @(layer.bounds.size.height);
                animation.toValue = @(_size.height*((value-minValue)/maxY));
            }

            [animation setDuration:.5];
            [animation setRemovedOnCompletion:YES];
            [layer addAnimation:animation forKey:@"grow"];
        }
        
        [layer setBounds:CGRectMake(0,
                                    0,
                                    MIN(width, 50),
                                    _size.height*((value-minValue)/maxY))];
        // 计算柱的位置
        NSInteger count = [[self dataSource] drawingStrategy:self
                                        numberOfItemsInGroup:groupIndex];

        [layer setPosition:CGPointMake(centerX+layer.bounds.size.width*.5*(2*i-count+1),
                                       _size.height)];

        [layer setBorderColor:[[UIColor whiteColor] CGColor]];
        [layer setBorderWidth:2];

        CALayer *textLayer =
        [self WS_addTextLayer:key
                        index:i
                   groupIndex:groupIndex
                        width:layer.bounds.size.width
                       colors:(__bridge CGColorRef)([colors lastObject])
                        layer:layer];
        [parentLayer addSublayer:textLayer];
        [parentLayer addSublayer:layer];
    }
}

#pragma mark - Properties
- (NSMutableDictionary *)textLayers
{
    if (!_textLayers)
    {
        _textLayers = [[NSMutableDictionary alloc] init];
    }

    return _textLayers;
}

- (NSMutableDictionary *)histogramLayers
{
    if (!_histogramLayers)
    {
        _histogramLayers = [[NSMutableDictionary alloc] init];
    }

    return _histogramLayers;
}

@end