//
//  CommenHeader.h
//  TSMWSChart
//
//  Created by ways on 16/5/27.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#ifndef CommenHeader_h
#define CommenHeader_h


#ifdef DEBUG
# define DLog(fmt, ...) NSLog((@"[文件名:%s]\n" "[函数名:%s]\n" "[行号:%d] \n" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
# define DLog(...);
#endif

#endif /* CommenHeader_h */
