//
//  WSBaseGraphView.h
//  AnalysisGraph
//
//  Created by Ansonyc on 13-9-3.
//  Copyright (c) 2013年 Ways.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSMWSDrawingStrategy.h"
#import "TSMWSBaseAxisRenderer.h"

@interface TSMWSBaseGraphView : UIView

- (void)reloadData;
- (void)scrollToRight;

@property (nonatomic, assign) CGFloat leftMargin;
@property (nonatomic, assign) CGFloat rightMargin;
@property (nonatomic, assign) CGFloat bottomMargin;
@property (nonatomic, assign) CGFloat topMargin;
@property (nonatomic, assign) CGFloat groupWidth;

/**
 @name 内容绘制策略数组，内容绘制先后顺序与策略在数组内的排列顺序一致
 */
@property (nonatomic, strong) NSArray *drawingStrategys;

/**
 @name 坐标绘制策略，支持多个y坐标，共用x坐标   数组元素的先后顺序觉得了头部按钮的显示以那个的设置为准，以lastObject为准
 */
@property (nonatomic, strong) NSArray *axisRenderers;

@end
