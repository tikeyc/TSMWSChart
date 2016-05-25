//
//  WSHistogramDrawing.h
//  AnalysisGraph
//
//  Created by Ansonyc on 13-9-9.
//  Copyright (c) 2013年 Ways.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TSMWSDrawingStrategy.h"
@class TSMWSHistogramDrawing;

@protocol TSMWSHistogramDataSource <TSMWSDrawingStrategyDataSource>
@required
/**
 @name histogramDrawing:colorsForGroup:atIndex:
 @param drawingStrategy 绘制策略
 @param groupIndex 分组的索引
 @param index 元素在分组内的索引
 @return 在groupInde分组内第index个对象的颜色(CGColorRef对象)数组
 */
- (NSArray *)histogramDrawing:(TSMWSHistogramDrawing*)drawingStrategy
               colorsForGroup:(NSUInteger)groupIndex
                      atIndex:(NSUInteger)index;
/**
 @name histogramDrawing:textForGroup:atIndex:
 @param drawingStrategy 绘制策略
 @param groupIndex 分组的索引
 @param index 元素在分组内的索引
 @return 第groupIndex个分组内第index个元素的字符串
 */
- (NSString *)histogramDrawing:(TSMWSHistogramDrawing *)drawingStrategy
                  textForGroup:(NSUInteger)groupIndex
                       atIndex:(NSUInteger)index;
@end

@interface TSMWSHistogramDrawing : NSObject<TSMWSDrawingStrategy>
@property (nonatomic, weak) id<TSMWSHistogramDataSource> dataSource;



@end
