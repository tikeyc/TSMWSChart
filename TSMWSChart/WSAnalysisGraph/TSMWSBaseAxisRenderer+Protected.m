//
//  WSBaseAxisRenderer+Protected.m
//  SGM
//
//  Created by Ansonyc on 13-10-30.
//  Copyright (c) 2013年 广州威尔森企业管理咨询有限公司. All rights reserved.
//

#import "TSMWSBaseAxisRenderer+Protected.h"

@implementation TSMWSBaseAxisRenderer (Protected)
#pragma mark - Properties
- (CGPoint)WS_startPosition
{
    return [[self dataSource] respondsToSelector:@selector(startPositionForBothAxis:)] ?
    [[self dataSource] startPositionForBothAxis:self] : CGPointMake(0, 0);
}

- (NSArray *)WS_segmentsAtX
{
    return [[self dataSource] respondsToSelector:@selector(segmentsAtAxisX:)] ?
    [[self dataSource] segmentsAtAxisX:self] : nil;
}

- (NSArray *)WS_segmentsAtY
{
    return [[self dataSource] respondsToSelector:@selector(segmentsAtAxisY:)] ?
    [[self dataSource] segmentsAtAxisY:self] : nil;
}

- (CGPoint)WS_lengthInPercentage
{
    return [[self dataSource] respondsToSelector:@selector(lengthForBothAxis:)] ?
    [[self dataSource] lengthForBothAxis:self] : CGPointMake(1, 1);
}

@end
