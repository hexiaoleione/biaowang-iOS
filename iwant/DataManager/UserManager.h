//
//  UserManager.h
//  Express
//
//  Created by 张宾 on 15/7/20.
//  Copyright (c) 2015年 SCHT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Address.h"
@interface UserManager : NSObject

+ (void)saveUser:(User *)user;
+ (void)removeDefaultUser;
+ (User *)getDefaultUser;

+ (void)saveDefaultSendAddress:(Address*)address;
+ (void)saveDefaultReceiveAddress:(Address*)address;

+ (void)clearDefaultAddress;
+ (Address*)getDefaultSendAddress;
+ (Address*)getDefaultReceAddress;

+ (void)saveCompanyArray:(NSMutableArray*)array;
+ (NSMutableArray*)getCompanyArray;

@end
