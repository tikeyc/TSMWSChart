//
//  WSSalesAreaInfo.m
//  SGM
//
//  Created by Ansonyc on 14-5-20.
//  Copyright (c) 2014年 Ways.cn. All rights reserved.
//

#import "WSAreaInfo.h"

@implementation WSAreaInfo

+ (instancetype)areaFromDictionary:(NSDictionary *)dictionary with:(ModelType_SalesWholeMarket )type
{
    WSAreaInfo *area = [[WSAreaInfo alloc] init];
    [area setModelType:type];

    [area setAreaID:[dictionary[@"id"] description]];
    if ([[area areaID] isKindOfClass:[NSString class]])
    {
        NSString *type = [(NSString *)[area areaID] componentsSeparatedByString:@"_"][0];
        if ([type isEqualToString:@"p"])
        {
            [area setAreaType:Province_SalesWholeMarket];
        }
        else if ([type isEqualToString:@"c"])
        {
            [area setAreaType:City_SalesWholeMarket];
        }
        else if ([type isEqualToString:@"a"])
        {
            [area setAreaType:UnDefinedArea_SalesWholeMarket];
        }
        else
        {
            if ([[area areaID] intValue]==0)
            {
                [area setAreaType:Province_SalesWholeMarket];
            }
            else
            {
                [area setAreaType:[[area areaID] intValue]];
            }
        }
    }

    if ([[[area areaID] componentsSeparatedByString:@"_"] count]==2)
    {
        [area setAreaID:[[area areaID] componentsSeparatedByString:@"_"][1]];
    }

    [area setAreaName:dictionary[@"text"]];
    NSArray *data = dictionary[@"data"];
    NSMutableArray *children = [[NSMutableArray alloc] init];
    for (int i = 0; i < [data count]; i++)
    {
        WSAreaInfo *child = [WSAreaInfo areaFromDictionary:data[i] with:area.modelType];
        
        if (child)
        {

            if (area.modelType == Analysis_SalesWholeMarket) {
                   [children addObject:child];
            }else if(area.modelType == Predict_SalesWholeMarket){
                if (child.areaType != City_SalesWholeMarket) {
                    [children addObject:child];
                }
            }
        }
        [child setParent:area];
        if ([child areaType]==UnDefinedArea_SalesWholeMarket)
        {
            [child setAreaType:[area areaType]];
        }
    }

    if ([children count] > 0)
    {
        [area setChildren:children];
    }

    return area;
}

- (BOOL)isProvince
{
    WSAreaInfo *parent = self;
    while ([parent parent])
    {
        parent = [parent parent];
    }

    return [parent areaType]==Province_SalesWholeMarket;
}

- (AreaType_SalesWholeMarket)superAreaType
{
    WSAreaInfo *parent = self;
    while ([parent parent])
    {
        parent = [parent parent];
    }

    return [parent areaType];
}

@end
