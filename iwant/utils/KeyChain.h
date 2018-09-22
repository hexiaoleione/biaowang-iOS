//
//  KeyChain.h
//  iwant
//
//  Created by dongba on 16/3/9.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>

@interface KeyChain : NSObject

+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)delete:(NSString *)service;

@end
