//
//  ServiceAxisDrawing.m
//  GTMA
//
//  Created by Ansonyc on 14-3-18.
//  Copyright (c) 2014年 public. All rights reserved.
//

#import "TAxisXYInfoDrawingDataSource.h"

@interface TAxisXYInfoDrawingDataSource ()

@end


@implementation TAxisXYInfoDrawingDataSource

//x轴显示的刻度字符串数组
- (NSArray *)segmentsAtAxisX:(TSMWSBaseAxisRenderer *)renderer
{
    return self.segmentsAtAxisXs;
    
}
//y轴显示的刻度字符串数组
- (NSArray *)segmentsAtAxisY:(TSMWSBaseAxisRenderer *)renderer
{
    return self.segmentsAtAxisYs;
    
}
//头部的按钮 ，按钮对应于线图，点击隐藏和显示
- (NSArray *)headerElementsForAxisRenderer:(TSMWSBaseAxisRenderer *)renderer
{
    NSMutableArray *headers = [[NSMutableArray alloc] init];
    
    
    for (NSDictionary *dic in self.headerElements) {
        
        NSString *text = dic[headerElements_text_key];
        UIColor *color = dic[headerElements_color_key];
        NSInteger index = [dic[headerElements_index_key] integerValue];
        TWSHeaderElementType headerElementType = [dic[headerElements_type_key] intValue];
        if ([color isKindOfClass:[UIColor class]]) {
            [headers addObject:[TSMWSHeaderElement headerElementWithText:[text stringByAppendingString:@"    "]
                                                                  color:color
                                                                  index:index//关联到第几跟线或第几组直方图，点击隐藏和显示.折线和直方图类型分别从0开始
                                                                   type:headerElementType]];
        }
        index++;
    }

    return headers;

}

//X轴Y轴的长度
- (CGPoint)lengthForBothAxis:(TSMWSBaseAxisRenderer *)renderer
{
//    return CGPointMake(200, 100);
    return CGPointMake(850./900., 1);
}
@end








//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation TSecondAxisXYInfoDrawingDataSource


- (CGPoint)startPositionForBothAxis:(TSMWSBaseAxisRenderer *)renderer
{
    return CGPointMake(850./900., 1);
}
//X轴Y轴的长度
- (CGPoint)lengthForBothAxis:(TSMWSBaseAxisRenderer *)renderer
{
    return CGPointMake(0, 1);
}
//X轴显示的刻度字符串数组 一个坐标系一般只显示 一个 X轴 刻度
- (NSArray *)segmentsAtAxisX:(TSMWSBaseAxisRenderer *)renderer
{
    return self.segmentsAtAxisXs;//与第一个datasource共用X轴刻度
    return nil;
}

//y轴显示的刻度字符串数组 一个坐标系可左右分别显示不同的 Y轴 刻度
- (NSArray *)segmentsAtAxisY:(TSMWSBaseAxisRenderer *)renderer
{
    return self.segmentsAtAxisYs;
    
}

//头部的按钮 ，按钮对应于线图，点击隐藏和显示 与第一个datasource共用头部按钮
- (NSArray *)headerElementsForAxisRenderer:(TSMWSBaseAxisRenderer *)renderer
{
    NSMutableArray *headers = [[NSMutableArray alloc] init];
    
    
    for (NSDictionary *dic in self.headerElements) {
        
        NSString *text = dic[headerElements_text_key];
        UIColor *color = dic[headerElements_color_key];
        NSInteger index = [dic[headerElements_index_key] integerValue];
        TWSHeaderElementType headerElementType = [dic[headerElements_type_key] intValue];
        if ([color isKindOfClass:[UIColor class]]) {
            [headers addObject:[TSMWSHeaderElement headerElementWithText:[text stringByAppendingString:@"    "]
                                                                  color:color
                                                                  index:index//关联到第几跟线或第几组直方图，点击隐藏和显示.折线和直方图类型分别从0开始
                                                                   type:headerElementType]];
        }
        index++;
    }
    
    return headers;
    return nil;
}

@end
