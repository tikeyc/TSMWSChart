//
//  ServiceAxisDrawing.h
//  GTMA
//
//  Created by Ansonyc on 14-3-18.
//  Copyright (c) 2014年 public. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TSMWSBaseAxisRenderer.h"

#import "TSMWSCommon.h"


//头部的按钮属性数组
#define headerElements_text_key @"headerElements_text_ley"
#define headerElements_color_key @"headerElements_color_key"
#define headerElements_type_key @"headerElements_type_key"

#define headerElements_index_key @"headerElements_index_key"


@interface TAxisXYInfoDrawingDataSource : NSObject<TSMWSAxisRendererDataSource>



@property (nonatomic, strong) NSArray *segmentsAtAxisXs;//X轴显示的刻度字符串数组
@property (nonatomic, strong) NSArray *segmentsAtAxisYs;//Y轴显示的刻度字符串数组
@property (nonatomic, strong) NSArray *headerElements;//头部的按钮属性数组（数组有序，字典无序，避免乱色），里面存的是字典：文字，颜色,类型,第几跟（几组）折线和直方图类型分别从0开始

@end


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


@interface TSecondAxisXYInfoDrawingDataSource : TAxisXYInfoDrawingDataSource<TSMWSAxisRendererDataSource>


@end



////////////////以上是线图的数据配置类 主要是配置 X轴，Y轴刻度。 以及头部的按钮，按钮对应于线图，点击隐藏和显示