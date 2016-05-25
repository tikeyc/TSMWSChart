//
//  WSSalesAreaInfo.h
//  SGM
//
//  Created by Ansonyc on 14-5-20.
//  Copyright (c) 2014年 Ways.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 @name 区域类型
 @param Buick_SalesWholeMarket 别克
 @param Chevrolet_SalesWholeMarket 雪佛兰
 @param Cadillac_SalesWholeMarket 凯迪拉克
 @param Province_SalesWholeMarket 省份
 */
typedef enum
{
    UnDefinedArea_SalesWholeMarket = -1,
    Buick_SalesWholeMarket = 15,
    Chevrolet_SalesWholeMarket = 14,
    Cadillac_SalesWholeMarket = 46,
    Province_SalesWholeMarket = 4,
    City_SalesWholeMarket = 5
} AreaType_SalesWholeMarket;

/**
 @name 预测or分析
 @param Predict_SalesWholeMarket 预测
 @param Analysis_SalesWholeMarket 分析
 */
typedef enum
{
    Analysis_SalesWholeMarket = 1,
    Predict_SalesWholeMarket = 2
    
} ModelType_SalesWholeMarket;

@interface WSAreaInfo : NSObject
/**
 @name 区域ID
 */
@property (nonatomic, strong) NSString *areaID;

/**
 @name 区域名称
 */
@property (nonatomic, strong) NSString *areaName;

/**
 @name 区域类型
 */
@property (nonatomic, assign) AreaType_SalesWholeMarket areaType;
@property (nonatomic, assign) ModelType_SalesWholeMarket modelType;
@property (nonatomic, strong) NSArray *children;
@property (nonatomic, weak) WSAreaInfo *parent;

@property (nonatomic, readonly) BOOL isProvince;
@property (nonatomic, readonly) AreaType_SalesWholeMarket superAreaType;

+ (instancetype)areaFromDictionary:(NSDictionary *)dictionary  with:(ModelType_SalesWholeMarket )type;

@end