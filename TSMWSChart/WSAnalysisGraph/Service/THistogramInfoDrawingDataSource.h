//
//  ServiceHistogramDrawingDataSource.h
//  GTMA
//
//  Created by Ansonyc on 14-3-18.
//  Copyright (c) 2014年 public. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TSMWSHistogramDrawing.h"
#import "TSMWSCommon.h"


@interface THistogramInfoDrawingDataSource : NSObject<TSMWSHistogramDataSource>



@property (nonatomic,strong)NSMutableArray *lineSectionDatas;//new

@property (nonatomic,strong)NSMutableArray *lineIndexDatas;//new


@property (nonatomic,strong)NSArray *lineIndexColors;//第几组直方图的颜色 （颜色相同的算一组）

@end