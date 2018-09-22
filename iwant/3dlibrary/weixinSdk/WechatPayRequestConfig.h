//
//  WechatPayRequestConfig.h
//  PayDemo
//
//  Created by 张宾 on 15/9/21.
//  Copyright © 2015年 张宾. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WechatPayHeader.h"
@interface WechatPayRequestConfig : NSObject

+ (void)sendPay;

+ (void)sendPayNative;

@end
