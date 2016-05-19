//
//  ServiceLinearDrawingDataSource.h
//  GTMA
//
//  Created by Ansonyc on 14-3-18.
//  Copyright (c)z 2014年 public. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TSMWSLinearDrawing.h"
#import "TSMWSCommon.h"

@interface TLinearInfoDrawingDataSource : NSObject<TSMWSLinearDrawingDataSource>

@property (nonatomic,strong)NSMutableArray *lineSectionDatas;//new

@property (nonatomic,strong)NSMutableArray *lineIndexDatas;//new

@property (nonatomic,strong)NSArray *lineIndexColors;//第几根线的颜色

@end


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface TSecondLinearInfoDrawingDataSource : TLinearInfoDrawingDataSource<TSMWSLinearDrawingDataSource>


@end






////////////////以上是折线图的数据配置类 主要是配置 坐标点数据信息 