//
//  WSLinearDrawing.m
//  AnalysisGraph
//
//  Created by Ansonyc on 13-9-9.
//  Copyright (c) 2013年 Ways.cn. All rights reserved.
//

#import "TSMWSLinearDrawing.h"
#import <QuartzCore/QuartzCore.h>
#import "TSMWSBaseAxisRenderer.h"

@interface TSMWSLinearDrawing ()
@property (nonatomic, strong) NSMutableArray *lineLayers;
@property (nonatomic, strong) NSMutableArray *circleLayers;
@property (nonatomic, strong) NSMutableDictionary *textLayers;
@end

@implementation TSMWSLinearDrawing
@synthesize gapBetweenGroups, groupWidth, dataSource, hiddenIndexs, animated;

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

- (void)SGM_refreshTextLayers:(NSMutableDictionary *)points
                 contentLayer:(CAShapeLayer *)contentLayer
{
    NSArray *allPoints = [points allValues];
    CGPoint center;
    
    NSInteger groupIndex = 0;
    
    for (int i = 0; i < [allPoints count]; i++)
    {
        if ([[self dataSource] linearDrawing:self IsMSRPLineAtIndex:i])
        {
            if ([[self hiddenIndexs] containsObject:@(i+(TWSElementTypeDashLineSpot<<16))])
            {
                continue;
            }
        }
        else
        {
            if ([[self hiddenIndexs] containsObject:@(i+(TWSElementTypeLineSpot<<16))])
            {
                continue;
            }
        }

        UIColor *color = [[self dataSource] linearDrawing:self
                                  lineColorForLineAtIndex:i];
        BOOL reuse = NO;
        NSArray *pointsInOneLine = allPoints[i];

        for (int j = 0; j < [pointsInOneLine count]; j+=2)
        {
            center = [pointsInOneLine[j] CGPointValue];
            
//            currentX += 2*[self gapBetweenGroups]+[self groupWidth]/2;
//            currentX += [self groupWidth]/2;

            groupIndex = (int)center.x/(int)(2*[self gapBetweenGroups]+[self groupWidth]);
            NSString *key = [NSString stringWithFormat:@"%d-%ld", i,(long)groupIndex];
            CATextLayer *textLayer;
            if ([self textLayers][key])
            {
                reuse = YES;
                textLayer = [self textLayers][key];
            }
            else
            {
                reuse = NO;
                textLayer = [CATextLayer layer];
                [self textLayers][key] = textLayer;
                [textLayer setFontSize:12];
                [textLayer setBounds:CGRectMake(0, 0, 150, 20)];
                [textLayer setAnchorPoint:CGPointMake(.5, 1)];
                [textLayer setAlignmentMode:kCAAlignmentCenter];
            }
            [textLayer setForegroundColor:[color CGColor]];
            [contentLayer addSublayer:textLayer];

            [textLayer setString:[[self dataSource] linearDrawing:self
                                                     textForGroup:groupIndex
                                                          atIndex:i]];
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

- (void)SGM_refreshCircleLayers:(NSMutableDictionary *)points
                   contentLayer:(CAShapeLayer *)contentLayer
{
    NSArray *allPoints = [points allValues];
    CGPoint center;

    for (int i = 0; i < [allPoints count]; i++)
    {
        if ([[self dataSource] linearDrawing:self IsMSRPLineAtIndex:i])
        {
            if ([[self hiddenIndexs] containsObject:@(i+(TWSElementTypeDashLineSpot<<16))])
            {
                continue;
            }
        }
        else
        {
            if ([[self hiddenIndexs] containsObject:@(i+(TWSElementTypeLineSpot<<16))])
            {
                continue;
            }
        }

        UIColor *color = [[self dataSource] linearDrawing:self
                                  lineColorForLineAtIndex:i];
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
        CGFloat redius = 0.0,xGap = 0.0,lineWidth = 0.0;
        if (/* DISABLES CODE */ (0)) {//实心圆
            redius = 2.5;//任意数值
            xGap = redius*2;
            lineWidth = redius*2;
        }else{//空心圆
            redius = 5.0;//任意数值
            xGap = redius;
            lineWidth = 2;//任意数值
        }
        for (int j = 0; j < [pointsInOneLine count]; j+=2)
        {
            if (j == 0 || !CGPointEqualToPoint([pointsInOneLine[j] CGPointValue],
                                               [pointsInOneLine[j-1] CGPointValue]))
            {
                center = [pointsInOneLine[j] CGPointValue];
                center.x+=xGap;
                [circlePath moveToPoint:center];
                [circlePath addArcWithCenter:[pointsInOneLine[j] CGPointValue]
                                      radius:redius
                                  startAngle:0
                                    endAngle:M_PI*2
                                   clockwise:YES];
            }
            center = [pointsInOneLine[j+1] CGPointValue];
            center.x+=xGap;
            [circlePath moveToPoint:center];
            [circlePath addArcWithCenter:[pointsInOneLine[j+1] CGPointValue]
                                  radius:redius
                              startAngle:0
                                endAngle:M_PI*2
                               clockwise:YES];
        }
        
        [circleLayer setLineWidth:lineWidth];
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

- (void)SGM_refreshLineLayers:(NSMutableDictionary *)points
                 contentLayer:(CAShapeLayer *)contentLayer
{
    NSArray *allPoints = [points allValues];
    for (int i = 0; i < [allPoints count]; i++)
    {
        NSArray *lineDash = nil;
        UIColor *color = [[self dataSource] linearDrawing:self
                                  lineColorForLineAtIndex:i];
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        if ([[self dataSource] linearDrawing:self IsMSRPLineAtIndex:i])
        {
            lineDash = @[@16.,@8.];
            if ([[self hiddenIndexs] containsObject:@(i+(TWSElementTypeDashLineSpot<<16))])
            {
                continue;
            }
        }
        else
        {
            if ([[self hiddenIndexs] containsObject:@(i+(TWSElementTypeLineSpot<<16))])
            {
                continue;
            }
        }

        BOOL reuse = NO;
        NSArray *pointsInOneLine = allPoints[i];
        CAShapeLayer *lineLayer;
        if ([[self lineLayers] count] > i)
        {
            reuse = YES;
            lineLayer = [self lineLayers][i];
        }
        else
        {
            reuse = NO;
            lineLayer = [CAShapeLayer layer];
            [[self lineLayers] addObject:lineLayer];
        }

        [contentLayer addSublayer:lineLayer];
        
        for (int j = 0; j < [pointsInOneLine count]; j+=2)
        {
            if (j==0)
            {
                [path moveToPoint:[pointsInOneLine[j] CGPointValue]];
            }
            [path addLineToPoint:[pointsInOneLine[j+1] CGPointValue]];
        }

        [lineLayer setLineDashPhase:0];
        [lineLayer setLineDashPattern:lineDash];
        [lineLayer setLineWidth:2];
        [lineLayer setStrokeColor:[color CGColor]];
        [lineLayer setStrokeStart:0];
        [lineLayer setStrokeEnd:1];
        [lineLayer setFillColor:[[UIColor clearColor] CGColor]];
        [lineLayer setBounds:[contentLayer bounds]];
        [lineLayer setAnchorPoint:CGPointMake(0, 0)];
        [lineLayer setPosition:CGPointMake(0, 0)];

        if (!reuse)
        {
            [lineLayer setPath:[path CGPath]];
            [self SGM_addLayerAnimation:lineLayer
                                keyPath:@"strokeEnd"
                              fromValue:@0
                                toValue:@1];
        }
        else
        {
            [self SGM_addLayerAnimation:lineLayer
                                keyPath:@"path"
                              fromValue:(id)[lineLayer path]
                                toValue:(id)[path CGPath]];
        }
    }
}

- (CALayer *)contentLayerForSize:(CGSize)size reuseLayer:(CALayer *)reuseLayer
{
    CAShapeLayer *contentLayer = reuseLayer ? reuseLayer : [CAShapeLayer layer];
    //
    while ([[contentLayer sublayers] count] > 0)
    {
        [[[contentLayer sublayers] lastObject] removeFromSuperlayer];
    }
    
    CGFloat maxValue = [[self dataSource] maxValueForDrawingStrategy:self];
    CGFloat minValue = [[self dataSource] minValueForDrawingStrategy:self];
    CGFloat maxY = maxValue-minValue;
    if (maxY == 0)
    {
        return nil;
    }

    // 计算整个内容区域的宽度和高度
    size.width = 2*[self gapBetweenGroups]+([self gapBetweenGroups]*2+[self groupWidth])*[[self dataSource] numberOfXGroups:self];
    CGFloat startY = 0;
    CGFloat contentHeight = size.height+startY;
    [contentLayer setBounds:CGRectMake(0, 0, size.width, size.height)];

    CGFloat currentX = -[self gapBetweenGroups];
    
    NSMutableDictionary *points = [[NSMutableDictionary alloc] init];
    // 计算出所有线段的点
    for (int i = 0; i < [[self dataSource] numberOfXGroups:self]; i++)
    {
        currentX += 2*[self gapBetweenGroups]+[self groupWidth]/2;
        for (int j = 0;
             j < [[self dataSource] drawingStrategy:self
                               numberOfItemsInGroup:i];
             j++)
        {
            CGFloat currentPointValue = [[self dataSource] drawingStrategy:self
                                                             valueForGroup:i
                                                                   atIndex:j];
            CGFloat nextPointValue = i+1==[[self dataSource] numberOfXGroups:self]?
            CGFLOAT_MAX : [[self dataSource] drawingStrategy:self
                                               valueForGroup:i+1
                                                     atIndex:j];
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
                     [NSValue valueWithCGPoint:CGPointMake(currentX+[self groupWidth]/2+
                                                           [self gapBetweenGroups]*2+
                                                           [self groupWidth]/2,
                                                           startY+
                                                           contentHeight*
                                                           (1-(nextPointValue-minValue)/maxY))]];
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

    // 根据当前所有的点刷新线段、每个点的圈以及每个点的字符串
    [self SGM_refreshLineLayers:points contentLayer:contentLayer];
    [self SGM_refreshCircleLayers:points contentLayer:contentLayer];
    [self SGM_refreshTextLayers:points contentLayer:contentLayer];

    return contentLayer;
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

- (NSMutableArray *)circleLayers
{
    if (!_circleLayers)
    {
        _circleLayers = [[NSMutableArray alloc] init];
    }

    return _circleLayers;
}

- (NSMutableArray *)lineLayers
{
    if (!_lineLayers)
    {
        _lineLayers = [[NSMutableArray alloc] init];
    }

    return _lineLayers;
}

@end