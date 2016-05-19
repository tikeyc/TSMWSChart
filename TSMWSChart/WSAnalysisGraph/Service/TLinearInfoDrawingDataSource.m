//
//  ServiceLinearDrawingDataSource.m
//  GTMA
//
//  Created by Ansonyc on 14-3-18.
//  Copyright (c) 2014年 public. All rights reserved.
//

#import "TLinearInfoDrawingDataSource.h"


@interface TLinearInfoDrawingDataSource()

@end

@implementation TLinearInfoDrawingDataSource


- (BOOL)linearDrawing:(TSMWSLinearDrawing *)drawing
    IsMSRPLineAtIndex:(NSUInteger)index
{
    return NO;
}


#pragma mark - set data


- (void)setLineSectionDatas:(NSMutableArray *)lineSectionDatas{
    if (_lineSectionDatas != lineSectionDatas) {
        _lineSectionDatas = nil;
        _lineSectionDatas = lineSectionDatas;
    }
    
    NSMutableArray *lineInexDatas = [NSMutableArray array];
    for (NSArray *lineInexData in _lineSectionDatas) {
        [lineInexDatas addObjectsFromArray:lineInexData];
    }
    self.lineIndexDatas = lineInexDatas;
}

- (void)setLineIndexDatas:(NSMutableArray *)lineIndexDatas{
    if (_lineIndexDatas != lineIndexDatas) {
        _lineIndexDatas = nil;
        _lineIndexDatas = lineIndexDatas;
    }

}

#pragma mark - dataSource

//X轴的刻度数量：平均分配
- (NSUInteger)numberOfXGroups:(id<TSMWSDrawingStrategy>)strategy
{
    NSInteger  max = 0;
    for (NSArray *array in self.lineSectionDatas) {
        if (array.count > max) {
            max = array.count;
        }
    }
    return max;
    
}

//在X轴的第groupIndex刻度上的（折线点上!）显示几个点（几个直方图） 个人认为其实就是相当于该图标中有几根折线（几组直方图）
- (NSUInteger)drawingStrategy:(id<TSMWSDrawingStrategy>)strategy numberOfItemsInGroup:(NSUInteger)groupIndex
{
    return self.lineSectionDatas.count;
}
//Y轴的刻度的最小值
- (CGFloat)minValueForDrawingStrategy:(id<TSMWSDrawingStrategy>)strategy
{
    return 0;
}
//Y轴的刻度的最大值
- (CGFloat)maxValueForDrawingStrategy:(id<TSMWSDrawingStrategy>)strategy
{
    
    //    NSNumber *max = [self.lineIndexDatas valueForKeyPath:@"@max.value"];
    //    return [max floatValue];
    
    
    return 100;//[[self maxValue] floatValue];
}



//index 指的是这个图标中的第几根线
//设置返回第index跟线条的颜色
- (UIColor *)linearDrawing:(TSMWSLinearDrawing *)drawing lineColorForLineAtIndex:(NSUInteger)index
{
    if (index < self.lineIndexColors.count) {
        if ([self.lineIndexColors[index] isKindOfClass:[UIColor class]]) {
            return self.lineIndexColors[index];
        }
    }
    
    return [UIColor redColor];
}
//groupIndex指的是X轴刻度中的第几个刻度   index指的是这个图标中的第几根线
//设置在第index根线中 X轴的第groupIndex刻度上的（折线点上!）显示的数据字符串
//drawing的dataSource指的就是self
- (NSString *)linearDrawing:(TSMWSLinearDrawing *)drawing
               textForGroup:(NSInteger)groupIndex
                    atIndex:(NSInteger)index
{
    TLineBaseModel *lineModel = self.lineSectionDatas[index][groupIndex];
    return [lineModel.value stringValue];

}


//groupIndex指的是X轴刻度中的第几个刻度   index指的是这个图标中的第几根线
//设置在第index根线中 X轴的第groupIndex刻度上的（折线点上!）的Y轴的具体数据  相当于直角坐标系的坐标点信息：（groupIndex,CGFloat_Y轴数值）
- (CGFloat)drawingStrategy:(id<TSMWSDrawingStrategy>)strategy
             valueForGroup:(NSUInteger)groupIndex
                   atIndex:(NSUInteger)index
{
    TLineBaseModel *lineModel = self.lineSectionDatas[index][groupIndex];
    return [lineModel.value floatValue];

    return CGFLOAT_MAX;
}


@end








//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - ServiceLinearSecondDrawingDataSource


@interface TSecondLinearInfoDrawingDataSource ()

@end

@implementation TSecondLinearInfoDrawingDataSource

//?????????
- (BOOL)linearDrawing:(TSMWSLinearDrawing *)drawing IsMSRPLineAtIndex:(NSUInteger)index
{
    return NO;
}

//X轴的刻度数量：平均分配
- (NSUInteger)numberOfXGroups:(id<TSMWSDrawingStrategy>)strategy
{
    NSInteger  max = 0;
    for (NSArray *array in self.lineSectionDatas) {
        if (array.count > max) {
            max = array.count;
        }
    }
    return max;
    
}

//在X轴的第groupIndex刻度上的（折线点上!）显示几个点（几个直方图）
- (NSUInteger)drawingStrategy:(id<TSMWSDrawingStrategy>)strategy numberOfItemsInGroup:(NSUInteger)groupIndex
{
    return self.lineSectionDatas.count;
}

//Y轴的刻度的最小值
- (CGFloat)maxValueForDrawingStrategy:(id<TSMWSDrawingStrategy>)strategy
{
    return 200;
    
}
//Y轴的刻度的最大值
- (CGFloat)minValueForDrawingStrategy:(id<TSMWSDrawingStrategy>)strategy
{
    return 0;
}



//index 指的是这个图标中的第几根线
//设置返回第index跟线条的颜色
- (UIColor *)linearDrawing:(TSMWSLinearDrawing *)drawing lineColorForLineAtIndex:(NSUInteger)index
{
    if (index < self.lineIndexColors.count) {
        if ([self.lineIndexColors[index] isKindOfClass:[UIColor class]]) {
            return self.lineIndexColors[index];
        }
    }
    
    return [UIColor whiteColor];
}
//groupIndex指的是X轴刻度中的第几个刻度   index指的是这个图标中的第几根线
//设置在第index根线中 X轴的第groupIndex刻度上的（折线点上!）显示的数据字符串
- (NSString *)linearDrawing:(TSMWSLinearDrawing *)drawing
               textForGroup:(NSInteger)groupIndex
                    atIndex:(NSInteger)index
{
    TLineBaseModel *lineModel = self.lineSectionDatas[index][groupIndex];
    return [lineModel.value stringValue];
    
}
//groupIndex指的是X轴刻度中的第几个刻度   index指的是这个图标中的第几根线
//设置在第index根线中 X轴的第groupIndex刻度上的（折线点上!）的Y轴的具体数据  相当于直角坐标系的坐标点信息：（groupIndex,CGFloat_Y轴数值）
- (CGFloat)drawingStrategy:(id<TSMWSDrawingStrategy>)strategy
             valueForGroup:(NSUInteger)groupIndex
                   atIndex:(NSUInteger)index
{
    TLineBaseModel *lineModel = self.lineSectionDatas[index][groupIndex];
    return [lineModel.value floatValue];
    
    
}




@end