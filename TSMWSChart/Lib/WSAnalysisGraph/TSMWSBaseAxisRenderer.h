//
//  WSBaseAxisRenderer.h
//  AnalysisGraph
//
//  Created by Ansonyc on 13-9-11.
//  Copyright (c) 2013年 Ways.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TSMWSBaseAxisRenderProtectedMethod <NSObject>
@optional

/**
 @name renderBackgroundLayer:
 @param backgroundLayer 将要绘制坐标和背景网格的leyer
 @param view 将要把坐标layer以及头部元素添加到的view
 */
- (void)renderBackgroundLayer:(CALayer *)backgroundLayer view:(UIView *)view;

/**
 @name renderAxisX:size:
 @param xLayer 将要绘制x轴的layer
 @param size 该layer的大小
 */
- (void)renderAxisX:(CALayer *)xLayer size:(CGSize)size;
@end

typedef enum
{
    TWSElementTypePlainText = 0,//文字
    TWSElementTypeColorRect = 1,//直方图
    TWSElementTypeLineSpot = 2,//折线
    TWSElementTypeDashLineSpot = 3
} TWSHeaderElementType;

@interface TSMWSHeaderElement : NSObject
+ (id)headerElementWithText:(NSString *)text
                      color:(UIColor *)color
                      index:(NSInteger)index
                       type:(TWSHeaderElementType)type;

/**
 @name 创建可视化的头部元素
 @param text 该元素显示的文字
 @param color 该元素的颜色
 @param index 该元素代表的分组索引
 @param type 元素的显示类型
 @param shouldFollowedWithSpace 是否应该与后面的元素保持一段距离
 @return 可视化头部元素
 */
+ (id)headerElementWithText:(NSString *)text
                      color:(UIColor *)color
                      index:(NSInteger)index
                       type:(TWSHeaderElementType)type
      shouldFollowWithSpace:(BOOL)shouldFollowedWithSpace;

@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) TWSHeaderElementType type;
@property (nonatomic, assign) BOOL shouldFollowedWithSpace;
@end

@class TSMWSBaseAxisRenderer;

@protocol TSMWSAxisRendererDataSource <NSObject>
@optional

/**
 @name startPositionForBothAxis:
 @param renderer 坐标绘制对象
 @return x、y轴的起始位移
 */
- (CGPoint)startPositionForBothAxis:(TSMWSBaseAxisRenderer *)renderer;

/**
 @name lengthForBothAxis:
 @param renderer 坐标绘制对象
 @return x、y轴的长度
 */
- (CGPoint)lengthForBothAxis:(TSMWSBaseAxisRenderer *)renderer;

/**
 @name segmentsAtAxisX:
 @param renderer 坐标绘制对象
 @return x轴的刻度字符串
 */
- (NSArray *)segmentsAtAxisX:(TSMWSBaseAxisRenderer *)renderer;

/**
 @name segmentsAtAxisY:
 @param renderer 坐标绘制对象
 @return y轴的刻度显示字符串
 */
- (NSArray *)segmentsAtAxisY:(TSMWSBaseAxisRenderer *)renderer;

/**
 @name headerElementsForAxisRenderer:
 @param renderer 坐标绘制对象
 @return 可视化头部的元素对象集合
 */
- (NSArray *)headerElementsForAxisRenderer:(TSMWSBaseAxisRenderer *)renderer;

@end

@interface TSMWSBaseAxisRenderer : NSObject<TSMWSBaseAxisRenderProtectedMethod>
/**
 @name 左方的空位
 */
@property (nonatomic, assign) CGFloat leftMargin;

/**
 @name 上方的空位
 */
@property (nonatomic, assign) CGFloat topMargin;

/**
 @name 下方的空位
 */
@property (nonatomic, assign) CGFloat bottomMargin;

/**
 @name 头部的高度
 */
@property (nonatomic, assign) CGFloat headerHeight;

/**
 @name 分组的间隙
 */
@property (nonatomic, assign) CGFloat gapBetweenXGroups;

/**
 @name 分组的宽度
 */
@property (nonatomic, assign) CGFloat groupWidth;

@property (nonatomic, weak) id<TSMWSAxisRendererDataSource> dataSource;

@end