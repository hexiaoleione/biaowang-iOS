//
//  WMKeyChain.h
//  用户机密的储存
//
//  Created by wangmiao on 16/2/25.
//  Copyright © 2016年 wangmiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMKeyChain : NSObject

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service;

+ (void)save:(NSString *)service data:(id)data;

+ (id)load:(NSString *)service;

+ (void)delete:(NSString *)service;

@end
