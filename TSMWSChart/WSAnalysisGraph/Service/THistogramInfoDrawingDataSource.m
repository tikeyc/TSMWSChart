//
//  ServiceHistogramDrawingDataSource.m
//  GTMA
//
//  Created by Ansonyc on 14-3-18.
//  Copyright (c) 2014年 public. All rights reserved.
//

#import "THistogramInfoDrawingDataSource.h"

@interface THistogramInfoDrawingDataSource ()

@end


@implementation THistogramInfoDrawingDataSource

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

//groupIndex指的是X轴刻度中的第几个刻度   index指的是这个图标中的第几根线
//设置在第index根线中 X轴的第groupIndex刻度上的直方图的颜色
- (NSArray *)histogramDrawing:(TSMWSHistogramDrawing *)drawingStrategy
               colorsForGroup:(NSUInteger)groupIndex
                      atIndex:(NSUInteger)index
{
    if (index < self.lineIndexColors.count) {
        if ([self.lineIndexColors[index] isKindOfClass:[UIColor class]]) {
            
            return @[(id)[self.lineIndexColors[index] CGColor]];
        }
    }
    
    return @[(id)[UIColor redColor].CGColor];

    
    
}
//groupIndex指的是X轴刻度中的第几个刻度   index指的是这个图标中的第几根线
//设置在第index根线中 X轴的第groupIndex刻度上的（直方图上!）显示的数据字符串
- (NSString *)histogramDrawing:(TSMWSHistogramDrawing *)drawingStrategy
                  textForGroup:(NSUInteger)groupIndex
                       atIndex:(NSUInteger)index
{
    TLineBaseModel *lineModel = self.lineSectionDatas[index][groupIndex];
    return [lineModel.value stringValue];

}
//在X轴的第groupIndex刻度上 显示几个直方图 个人认为其实就是相当于该图标中有几根折线（几组直方图）（颜色相同的算一组）
- (NSUInteger)drawingStrategy:(id<TSMWSDrawingStrategy>)strategy
         numberOfItemsInGroup:(NSUInteger)groupIndex
{
    return self.lineSectionDatas.count;
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
    return 200;

}

@end