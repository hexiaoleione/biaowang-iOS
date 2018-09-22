//
//  WMUserDataManager.m
//  用户机密的储存
//
//  Created by wangmiao on 16/2/25.
//  Copyright © 2016年 wangmiao. All rights reserved.
//

#import "WMUserDataManager.h"
#import "WMKeyChain.h"

@implementation WMUserDataManager


static NSString * const KEY_IN_KEYCHAIN = @"com.wuqian.app.allinfo";
static NSString * const KEY_PASSWORD = @"com.wuqian.app.password";

+ (id)readPassWord
{
    NSMutableDictionary *usernamepasswordKVPair = (NSMutableDictionary *)[WMKeyChain load:KEY_IN_KEYCHAIN];
    return [usernamepasswordKVPair objectForKey:KEY_PASSWORD];
}

+ (void)savePassWord:(NSString *)password
{
    NSMutableDictionary *usernamepasswordKVPairs = [NSMutableDictionary dictionary];
    [usernamepasswordKVPairs setObject:password forKey:KEY_PASSWORD];
    [WMKeyChain save:KEY_IN_KEYCHAIN data:usernamepasswordKVPairs];
}

+ (void)deletePassWord
{
    [WMKeyChain delete:KEY_IN_KEYCHAIN];
}

@end
