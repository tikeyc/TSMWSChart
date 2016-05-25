//
//  WSBaseAxisRenderer+Protected.h
//  SGM
//
//  Created by Ansonyc on 13-10-30.
//  Copyright (c) 2013年 广州威尔森企业管理咨询有限公司. All rights reserved.
//

#import "TSMWSBaseAxisRenderer.h"

@interface TSMWSBaseAxisRenderer (Protected)
/**
 @name 坐标的x轴和y轴的起始位移
 @return 坐标周x轴和y轴的起始位移
 */
- (CGPoint)WS_startPosition;

/**
 @name x轴的刻度字符串数组
 @return x轴的刻度字符串数组
 */
- (NSArray *)WS_segmentsAtX;

/**
 @name y轴的刻度字符串数组
 @return y轴的刻度字符串数组
 */
- (NSArray *)WS_segmentsAtY;

/**
 @name x轴和y轴的长度
 @return x轴和y轴的长度（取值0～1）
 */
- (CGPoint)WS_lengthInPercentage;
@end
