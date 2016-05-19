//
//  WSLinearDrawing.h
//  AnalysisGraph
//
//  Created by Ansonyc on 13-9-9.
//  Copyright (c) 2013年 Ways.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TSMWSDrawingStrategy.h"

@class TSMWSLinearDrawing;

@protocol TSMWSLinearDrawingDataSource <TSMWSDrawingStrategyDataSource>
@optional
/**
 @name linearDrawing:textForGroup:atIndex:
 @param drawing 绘制策略
 @param groupIndex 分组的索引
 @param index 元素在分组内的索引
 @return 第groupIndex个分组的第index个元素的字符串
 */
- (NSString *)linearDrawing:(TSMWSLinearDrawing *)drawing
               textForGroup:(NSInteger)groupIndex
                    atIndex:(NSInteger)index;
@required
/**
 @name linearDrawing:lineColorForLineAtIndex:
 @param drawing 绘制策略
 @param index 分组内的索引
 @return 分组内索引为index的线段颜色
 */
- (UIColor *)linearDrawing:(TSMWSLinearDrawing *)drawing
   lineColorForLineAtIndex:(NSUInteger)index;

/**
 @name linearDrawing:IsMSRPLineAtIndex:
 @param drawing 绘制策略
 @param index 分组内的索引
 @return 分组内索引为index的线段是否代表MSRP
 */
- (BOOL)linearDrawing:(TSMWSLinearDrawing *)drawing IsMSRPLineAtIndex:(NSUInteger)index;
@end

@interface TSMWSLinearDrawing : NSObject<TSMWSDrawingStrategy>
@property (nonatomic, weak) id<TSMWSLinearDrawingDataSource> dataSource;
@end