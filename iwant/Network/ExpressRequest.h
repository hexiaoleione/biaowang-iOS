//
//  ExpressRequest.h
//  Express
//
//  Created by 张宾 on 15/7/15.
//  Copyright (c) 2015年 SCHT. All rights reserved.
//



#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "RequestConfig.h"
#define WIFI_START      @"WIFI_START"
#define WWAN_START           @"3G/4G"
typedef void(^RequestSuccessBlock)(id object);
typedef void(^RequestFailedBlock)(NSString *error);

@interface ExpressRequest : NSObject

+ (void)sendWithParameters:(NSDictionary*)parameters
                    MethodStr:(NSString*)methodStr
                   reqType:(int)type
                   success:(RequestSuccessBlock)success
                    failed:(RequestFailedBlock)failed;

+ (void)sendWithParameters:(NSDictionary *)parameters
                 MethodStr:(NSString *)methodStr
                      fileDic:(NSDictionary *)fileDic
                   success:(RequestSuccessBlock)success
                    failed:(RequestFailedBlock)failed;

+ (void)sendDownLoadRequestWithParameters:(NSDictionary *)parameters
                                MethodStr:(NSString *)methodStr
                                  success:(RequestSuccessBlock)success
                                   failed:(RequestFailedBlock)failed;


+ (BOOL)checkNetReachablityOK;

//开始监测网络连接
+ (void)StartNetReachablityListen;

//+ (void)sendParameters:(NSDictionary *)parameters
//             MethodStr:(NSString *)methodStr
//               reqType:(int)type
//               success:(RequestSuccessBlock)success failed:(RequestFailedBlock)failed;
//
@end
