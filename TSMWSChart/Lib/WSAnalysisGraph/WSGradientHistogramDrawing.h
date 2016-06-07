//
//  WSGradientHistogramDrawing.h
//  LinerGraphDemo
//
//  Created by ways_IOS on 14/7/22.
//  Copyright (c) 2014年 ways. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TSMWSDrawingStrategy.h"

@interface GradientDataModel : NSObject
@property (nonatomic, assign)CGFloat topValue;
@property (nonatomic, assign)CGFloat bottomValue;
@property (nonatomic, assign)CGFloat realValue;
@end

@class WSGradientHistogramDrawing;

@protocol WSGradientHistogramDataSource <TSMWSDrawingStrategyDataSource>
@required
/**
 @name gradientHistogramDrawing:colorsForGroup:atIndex:
 @param drawingStrategy 绘制策略
 @param groupIndex 分组的索引
 @param index 元素在分组内的索引
 @return 在groupInde分组内第index个对象的颜色(CGColorRef对象)数组
 */
- (NSArray *)gradientHistogramDrawing:(WSGradientHistogramDrawing*)drawingStrategy
                       colorsForGroup:(NSUInteger)groupIndex
                              atIndex:(NSUInteger)index;
/**
 @name gradientHistogramDrawing:textForGroup:atIndex:
 @param drawingStrategy 绘制策略
 @param groupIndex 分组的索引
 @param index 元素在分组内的索引
 @return 第groupIndex个分组内第index个元素的字符串
 */
- (NSString *)gradientHistogramDrawing:(WSGradientHistogramDrawing *)drawingStrategy
                          textForGroup:(NSUInteger)groupIndex
                               atIndex:(NSUInteger)index
                          positionIndex:(NSInteger)positionIndex;
/**
 @name 分组内元素的值
 @param strategy 绘制策略
 @param groupIndex 分组索引
 @param index 分组内元素的索引
 @return 位于groupIndex分组内index位置的元素的值
 */
- (GradientDataModel *)gradientHistogramDrawingStrategy:(WSGradientHistogramDrawing *)drawingStrategy
                                          valueForGroup:(NSUInteger)groupIndex
                                                atIndex:(NSUInteger)index;
@end
@interface WSGradientHistogramDrawing : NSObject<TSMWSDrawingStrategy>
@property (nonatomic, weak) id<WSGradientHistogramDataSource> dataSource;
@end
