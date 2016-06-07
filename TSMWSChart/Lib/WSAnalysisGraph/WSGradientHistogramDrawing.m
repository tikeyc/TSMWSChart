//
//  WSGradientHistogramDrawing.m
//  LinerGraphDemo
//
//  Created by ways_IOS on 14/7/22.
//  Copyright (c) 2014年 ways. All rights reserved.
//

#import "WSGradientHistogramDrawing.h"
#import <QuartzCore/QuartzCore.h>
#import "TSMWSBaseAxisRenderer.h"

@interface WSGradientHistogramDrawing ()
@property (nonatomic, strong) NSMutableDictionary *histogramLayers;
@property (nonatomic, strong) NSMutableDictionary *textLayers;
@property (nonatomic, strong) NSMutableArray *circleLayers;
@end

@implementation GradientDataModel
{
    
}
@end

@implementation WSGradientHistogramDrawing
{
    CGSize _size;
}

@synthesize dataSource, gapBetweenGroups, groupWidth, hiddenIndexs, animated;
- (CALayer *)contentLayerForSize:(CGSize)size reuseLayer:(CALayer *)layer
{
    while ([[layer sublayers] count] > 0)
    {
        [[[layer sublayers] lastObject] removeFromSuperlayer];
    }
    layer = [CALayer layer];
    
    // 使用传入的size.height，绘制柱状的过程中计算总宽度
    _size = size;
    
    for (int i = 0; i < [[self dataSource] numberOfXGroups:self]; i++)
    {
        [self WS_addLayerForGroupAtIndex:i parentLayer:layer];
        _size.width += [self groupWidth];
    }
    [layer setBounds:CGRectMake(0, 0, _size.width, _size.height)];
    
    CGFloat maxValue = [[self dataSource] maxValueForDrawingStrategy:self];
    CGFloat minValue = [[self dataSource] minValueForDrawingStrategy:self];
    CGFloat maxY = maxValue-minValue;
    if (maxY == 0)
    {
        return nil;
    }
    // 计算整个内容区域的宽度和高度
    //size.width = ([self groupWidth])*[[self dataSource] numberOfXGroups:self];
    CGFloat startY = 0;
    CGFloat contentHeight = size.height+startY;
    for(int index = 0; index < 3; index ++)
    {
        
        CGFloat currentX = 0;
        
        NSMutableDictionary *points = [[NSMutableDictionary alloc] init];
        // 计算出所有线段的点
        for (int i = 0; i < [[self dataSource] numberOfXGroups:self]; i++)
        {
            currentX += [self groupWidth]/2;
            for (int j = 0;
                 j < [[self dataSource] drawingStrategy:self
                                   numberOfItemsInGroup:i];
                 j++)
            {
                GradientDataModel *currentModel = [[self dataSource] gradientHistogramDrawingStrategy:self
                                                                                        valueForGroup:i
                                                                                              atIndex:j];
                CGFloat currentPointValue = currentModel.realValue;
                if(index == 0)
                    currentPointValue = currentModel.topValue;
                else if(index == 2)
                    currentPointValue = currentModel.bottomValue;
                
                CGFloat nextPointValue;
                if(i+1 == [[self dataSource] numberOfXGroups:self])
                {
                    nextPointValue = CGFLOAT_MAX;
                }
                else
                {
                    GradientDataModel *nextModel = [[self dataSource] gradientHistogramDrawingStrategy:self
                                                                                         valueForGroup:i+1
                                                                                               atIndex:j];
                    nextPointValue =nextModel.realValue;
                    if(index == 0)
                        nextPointValue = nextModel.topValue;
                    else if(index == 2)
                        nextPointValue = nextModel.bottomValue;
                }
                
                NSMutableArray *pointsInOneLine = points[@(j)];
                if (!pointsInOneLine)
                {
                    pointsInOneLine = [[NSMutableArray alloc] init];
                    points[@(j)] = pointsInOneLine;
                }
                
                if (currentPointValue == CGFLOAT_MAX || currentPointValue == CGFLOAT_MIN)
                {
                    continue;
                }
                
                if (i < [[self dataSource] numberOfXGroups:self]-1)
                {
                    if (nextPointValue != CGFLOAT_MIN && nextPointValue != CGFLOAT_MAX)
                    {
                        [pointsInOneLine addObject:
                         [NSValue valueWithCGPoint:CGPointMake(currentX, startY+contentHeight*
                                                               (1-(currentPointValue-minValue)/maxY))]];
                        
                        [pointsInOneLine addObject:
                         [NSValue valueWithCGPoint:CGPointMake(currentX+[self groupWidth]/2+[self groupWidth]/2,startY+ contentHeight*(1-(nextPointValue-minValue)/maxY))]];
                    }
                    else
                    {
                        [pointsInOneLine addObject:
                         [NSValue valueWithCGPoint:CGPointMake(currentX, startY+contentHeight*
                                                               (1-(currentPointValue-minValue)/maxY))]];
                        [pointsInOneLine addObject:
                         [NSValue valueWithCGPoint:CGPointMake(currentX, startY+contentHeight*
                                                               (1-(currentPointValue-minValue)/maxY))]];
                    }
                }
                else if (i==[[self dataSource] numberOfXGroups:self]-1)
                {
                    [pointsInOneLine addObject:
                     [NSValue valueWithCGPoint:CGPointMake(currentX, startY+contentHeight*
                                                           (1-(currentPointValue-minValue)/maxY))]];
                    [pointsInOneLine addObject:
                     [NSValue valueWithCGPoint:CGPointMake(currentX, startY+contentHeight*
                                                           (1-(currentPointValue-minValue)/maxY))]];
                }
                
            }
            
            currentX += [self groupWidth]/2;
        }
        if(index == 1)
            [self SGM_refreshCircleLayers:points contentLayer:layer];
        
        [self SGM_refreshTextLayers:points contentLayer:layer positionIndex:index];
    }
    
    return layer;
}

- (void)SGM_addLayerAnimation:(CALayer *)layer
                      keyPath:(NSString *)keyPath
                    fromValue:(id)fromValue
                      toValue:(id)toValue
{
    [layer setValue:toValue forKeyPath:keyPath];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:keyPath];
    [animation setFromValue:fromValue];
    [animation setToValue:toValue];
    [animation setDuration:.5];
    [layer addAnimation:animation forKey:keyPath];
}

- (void)WS_addLayerForGroupAtIndex:(NSUInteger)groupIndex
                       parentLayer:(CALayer *)parentLayer
{
    if ([[self dataSource] drawingStrategy:self numberOfItemsInGroup:groupIndex] == 0)
    {
        return;
    }
    
    // 根据分组index计算当前的x坐标
    CGFloat currentX = 0.0;
    for (int i = 0; i < groupIndex; i++)
    {
        currentX += [self groupWidth];
    }
    
    // 本分组内每个元素的可用宽度
    //CGFloat width = [self groupWidth]/[[self dataSource] drawingStrategy:self
    //                                                numberOfItemsInGroup:groupIndex];
    
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
        GradientDataModel *model = [[self dataSource] gradientHistogramDrawingStrategy:self
                                                                         valueForGroup:groupIndex
                                                                               atIndex:i];
        
        
        // 不绘制被隐藏的柱
        if ([[self hiddenIndexs] containsObject:@(i+(TWSElementTypeColorRect<<16))]
            || model.topValue==CGFLOAT_MAX || model.topValue==CGFLOAT_MIN || model.bottomValue==CGFLOAT_MAX || model.bottomValue==CGFLOAT_MIN || model.realValue==CGFLOAT_MAX || model.realValue==CGFLOAT_MIN)
        {
            continue;
        }
        
        
        CALayer *layer = nil;
        NSArray *colors = [[self dataSource] gradientHistogramDrawing:self
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
        [layer setAnchorPoint:CGPointMake(0.5, 0)];
        
        if (animated)
        {
            CABasicAnimation *animation =
            [CABasicAnimation animationWithKeyPath:@"bounds.size.height"];
            if (!reuse)
            {
                animation.fromValue = @(layer.bounds.size.height);
                animation.toValue = @(_size.height*((model.topValue-minValue)/maxY));
            }
            else
            {
                animation.fromValue = @(0);
                animation.toValue = @(_size.height*((model.bottomValue
                                                     -minValue)/maxY));
            }
            
            [animation setDuration:.5];
            [animation setRemovedOnCompletion:YES];
            [layer addAnimation:animation forKey:@"grow"];
        }
        
        [layer setBounds:CGRectMake(0,
                                    _size.height*((model.topValue)/maxY),
                                    60,
                                    _size.height*(abs(model.topValue - model.bottomValue)/maxY))];
        // 计算柱的位置
        NSInteger count = [[self dataSource] drawingStrategy:self
                                        numberOfItemsInGroup:groupIndex];
        
        [layer setPosition:CGPointMake(centerX+layer.bounds.size.width*.5*(2*i-count+1),
                                       _size.height * maxValue/maxY -  _size.height*((model.topValue)/maxY))];
        
        [layer setBorderColor:[[UIColor whiteColor] CGColor]];
        [layer setBorderWidth:1.0];
        
        [parentLayer addSublayer:layer];
    }
}

- (NSArray *)SGM_allPointValues:(NSDictionary *)allPoints
{
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"self"
                                                           ascending:YES];
    NSArray *sortedKeys = [[allPoints allKeys] sortedArrayUsingDescriptors:@[sort]];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < [sortedKeys count]; i++)
    {
        [array addObject:allPoints[sortedKeys[i]]];
    }
    return array;
}

- (void)SGM_refreshCircleLayers:(NSMutableDictionary *)points
                   contentLayer:(CALayer *)contentLayer
{
    NSArray *allPoints = [self SGM_allPointValues:points];//[points allValues];
    CGPoint center;
    
    for (int i = 0; i < [allPoints count]; i++)
    {
        if ([[self hiddenIndexs] containsObject:[NSNumber numberWithLong:131071]])
        {
            continue;
        }
        
        
        UIColor *color = [UIColor whiteColor
                          ];
        BOOL reuse = NO;
        NSArray *pointsInOneLine = allPoints[i];
        CAShapeLayer *circleLayer;
        if ([[self circleLayers] count]>i)
        {
            reuse = YES;
            circleLayer = [self circleLayers][i];
        }
        else
        {
            reuse = NO;
            circleLayer = [CAShapeLayer layer];
            [[self circleLayers] addObject:circleLayer];
        }
        [contentLayer addSublayer:circleLayer];
        
        UIBezierPath *circlePath = [UIBezierPath bezierPath];
        for (int j = 0; j < [pointsInOneLine count]; j+=2)
        {
            if (j == 0 || !CGPointEqualToPoint([pointsInOneLine[j] CGPointValue],
                                               [pointsInOneLine[j-1] CGPointValue]))
            {
                CGPoint pointCenter = [pointsInOneLine[j] CGPointValue];
                center = [pointsInOneLine[j] CGPointValue];
                center.x+=3;
                if(i %2 != 0)
                {
                    center.x+= 30;
                    pointCenter.x+=30;
                }
                else
                {
                    center.x-= 30;
                    pointCenter.x-=30;
                }
                
                [circlePath moveToPoint:center];
                [circlePath addArcWithCenter:pointCenter
                                      radius:1.5
                                  startAngle:0
                                    endAngle:M_PI*2
                                   clockwise:YES];
            }
            CGPoint pointCenter = [pointsInOneLine[j+1] CGPointValue];
            center = [pointsInOneLine[j+1] CGPointValue];
            
            center.x+=3;
            if(i %2 != 0)
            {
                center.x+= 30;
                pointCenter.x+=30;
            }
            else
            {
                center.x-= 30;
                pointCenter.x-=30;
            }
            [circlePath moveToPoint:center];
            
            
            [circlePath addArcWithCenter:pointCenter
                                  radius:1.5
                              startAngle:0
                                endAngle:M_PI*2
                               clockwise:YES];
        }
        
        [circleLayer setLineWidth:3];
        [circleLayer setStrokeColor:[color CGColor]];
        [circleLayer setStrokeStart:0];
        [circleLayer setStrokeEnd:1];
        [circleLayer setFillColor:[[UIColor whiteColor] CGColor]];
        [circleLayer setBounds:[contentLayer bounds]];
        [circleLayer setAnchorPoint:CGPointMake(0, 0)];
        [circleLayer setPosition:CGPointMake(0, 0)];
        
        if (!reuse)
        {
            [circleLayer setPath:[circlePath CGPath]];
            [self SGM_addLayerAnimation:circleLayer
                                keyPath:@"strokeEnd"
                              fromValue:@0
                                toValue:@1];
        }
        else
        {
            [self SGM_addLayerAnimation:circleLayer
                                keyPath:@"path"
                              fromValue:(id)[circleLayer path]
                                toValue:(id)[circlePath CGPath]];
        }
    }
}

- (void)SGM_refreshTextLayers:(NSMutableDictionary *)points
                 contentLayer:(CALayer *)contentLayer
                positionIndex:(NSInteger)index
{
    NSArray *allPoints = [self SGM_allPointValues:points];
    CGPoint center;
    
    NSInteger groupIndex = 0;
    
    for(int i = 0; i < [allPoints count]; i ++)
    {
        UIColor *color = [UIColor blackColor];
        BOOL reuse = NO;
        NSArray *pointsInOneLine = allPoints[i];
        for (int j = 0; j < [pointsInOneLine count]; j+=2)
        {
            if ([[self hiddenIndexs] containsObject:@(i+(TWSElementTypeColorRect<<16))])
            {
                continue;
            }
            
            if ([[self hiddenIndexs] containsObject:[NSNumber numberWithLong:131071]] && index == 1)
            {
                continue;
            }
            
            center = [pointsInOneLine[j] CGPointValue];
            if(i %2 != 0)
            {
                center.x+= 30;
            }
            else
            {
                center.x-= 30;
            }
            if(index == 0)
                center.y+= 5;
            else if(index == 2)
                center.y+=20;
            
            
            groupIndex = (int)center.x/(int)[self groupWidth];
            NSString *key = [NSString stringWithFormat:@"%d-%ld-%d", i,(long)groupIndex,index];
            CATextLayer *textLayer;
            if ([self textLayers][key])
            {
                reuse = YES;
                textLayer = [self textLayers][key];
                [textLayer setFontSize:12];
                [textLayer setContentsScale:2];
                [textLayer setBounds:CGRectMake(0, 0, 150, 20)];
                [textLayer setAnchorPoint:CGPointMake(.5, 1)];
                [textLayer setAlignmentMode:kCAAlignmentCenter];
            }
            else
            {
                reuse = NO;
                textLayer = [CATextLayer layer];
                [self textLayers][key] = textLayer;
                [textLayer setFontSize:12];
                [textLayer setContentsScale:2];
                [textLayer setBounds:CGRectMake(0, 0, 150, 20)];
                [textLayer setAnchorPoint:CGPointMake(.5, 1)];
                [textLayer setAlignmentMode:kCAAlignmentCenter];
            }
            [textLayer setAllowsEdgeAntialiasing:YES];
            [textLayer setForegroundColor:[color CGColor]];
            [contentLayer addSublayer:textLayer];
            
            [textLayer setString:[[self dataSource] gradientHistogramDrawing:self
                                                                textForGroup:groupIndex
                                                                     atIndex:i
                                                               positionIndex:index]];
            
            if (reuse)
            {
                [self SGM_addLayerAnimation:textLayer
                                    keyPath:@"position"
                                  fromValue:[NSValue valueWithCGPoint:[textLayer position]]
                                    toValue:[NSValue valueWithCGPoint:center]];
            }
            else
            {
                [textLayer setPosition:center];
            }
        }
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
