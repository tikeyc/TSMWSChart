//
//  WSChinaMapViewController.h
//  SgmTest
//
//  Created by Ansonyc on 14-5-22.
//  Copyright (c) 2014年 T. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WSAreaInfo.h"

/**
 @name 地图类型
 @param  Analysis_ModelMapType 分析
 @param  Predict_ModelMapType 预测
 */
typedef enum
{
    Analysis_ModelMapType = 1,
    Predict_ModelMapType = 2
}ModelMapType;


@class WSChinaMapViewController;

@protocol WSChinaMapViewDelegate <NSObject>
- (void)chinaMapView:(WSChinaMapViewController *)mapView
       didSelectArea:(WSAreaInfo *)areInfo;
@end

@interface WSChinaMapViewController : UIViewController
@property (nonatomic, strong) NSArray *areaList;
@property (nonatomic, strong) WSAreaInfo *selectedArea;
@property (nonatomic, strong) WSAreaInfo *areaInfo;
@property (nonatomic, weak) NSObject<WSChinaMapViewDelegate> *delegate;
@property (nonatomic, assign)ModelMapType mapType;
@end