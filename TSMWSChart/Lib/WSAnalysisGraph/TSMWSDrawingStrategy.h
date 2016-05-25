//
//  WSDrawingStrategy.h
//  AnalysisGraph
//
//  Created by Ansonyc on 13-9-9.
//  Copyright (c) 2013年 Ways.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kGreenColor [UIColor greenColor]

@protocol TSMWSDrawingStrategyDataSource;

@protocol TSMWSDrawingStrategy <NSObject>

/**
 @name 本策略里分组间的间隙
 */
@property (nonatomic, assign) CGFloat gapBetweenGroups;

/**
 @name 本策略里每个分组所占宽度
 */
@property (nonatomic, assign) CGFloat groupWidth;

/**
 @name 策略的数据源
 */
@property (nonatomic, weak) id<TSMWSDrawingStrategyDataSource> dataSource;

/**
 @name 代表隐藏的可视化元素的索引对象（nsnumber类型，格式为index+WSHeaderElementType<<16）
 */
@property (nonatomic, strong) NSSet *hiddenIndexs;

/**
 @name 重绘时是否需要动画效果
 */
@property (nonatomic, assign) BOOL animated;

@optional
/**
 @warning contentLayerForSize:将不被调用
 @name 内容layer，在本方法实现的情况下
 @param size 内容区域的大小
 @param layer 重用的layer
 @return 包含绘制内容的大小位size的可重用layer
 */
- (CALayer *)contentLayerForSize:(CGSize)size reuseLayer:(CALayer *)layer;

/**
 @name 内容layer
 @param size 内容区域的大小
 @return 大小为size的包含绘制内容的layer
 */
- (CALayer *)contentLayerForSize:(CGSize)size;

@end

@protocol TSMWSDrawingStrategyDataSource <NSObject>
@required
/**
 @name x轴上分组数量
 @param strategy 绘制策略对象
 @return x轴上分组的数量
 */
- (NSUInteger)numberOfXGroups:(id<TSMWSDrawingStrategy>)strategy;

/**
 @name 分组内元素的个数
 @param strategy 绘制策略对象
 @param groupIndex 分组的索引
 @return 分组内元素的个数
 */
- (NSUInteger)drawingStrategy:(id<TSMWSDrawingStrategy>)strategy
         numberOfItemsInGroup:(NSUInteger)groupIndex;

/**
 @name 绘制策略的数值下限
 @param strategy 绘制策略对象
 @return 绘制策略的数值下限
 */
- (CGFloat)minValueForDrawingStrategy:(id<TSMWSDrawingStrategy>)strategy;

/**
 @name 绘制策略的数值上限
 @param strategy 绘制策略对象
 @return 绘制策略的数值上限
 */
- (CGFloat)maxValueForDrawingStrategy:(id<TSMWSDrawingStrategy>)strategy;

/**
 @name 分组内元素的值
 @param strategy 绘制策略
 @param groupIndex 分组索引
 @param index 分组内元素的索引
 @return 位于groupIndex分组内index位置的元素的值
 */
- (CGFloat)drawingStrategy:(id<TSMWSDrawingStrategy>)strategy
             valueForGroup:(NSUInteger)groupIndex
                   atIndex:(NSUInteger)index;
@end