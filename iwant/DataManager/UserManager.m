//
//  UserManager.m
//  Express
//
//  Created by 张宾 on 15/7/20.
//  Copyright (c) 2015年 SCHT. All rights reserved.
//

#import "UserManager.h"
#import "MainHeader.h"

@implementation UserManager

+ (void)saveUser:(User *)user
{
    NSDictionary *dic = [user dictionaryValues];
    [[NSUserDefaults standardUserDefaults]setObject:dic forKey:@"userid"];
     [[NSUserDefaults standardUserDefaults] synchronize];
//    [[NSUserDefaults standardUserDefaults]setObject:user.userid forKey:@"userid"];
//    [[NSUserDefaults standardUserDefaults]setObject:user.username forKey:@"userName"];
//    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInteger:user.ecoin] forKey:@"ecion"];
}

+ (void)removeDefaultUser
{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userid"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:User_HEAD_URL];
//    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userName"];

}
+ (User *)getDefaultUser
{
    User *user = NULL;
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"userid"]) {
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults]valueForKey:@"userid"];
        user = [[User alloc]initWithJsonDict:dic];
        
//        user.username = [[NSUserDefaults standardUserDefaults]valueForKey:@"userName"];
//        user.userid = [[NSUserDefaults standardUserDefaults]valueForKey:@"userid"];
//        user.ecoin = [[[NSUserDefaults standardUserDefaults]valueForKey:@"ecion"] integerValue];
    }
    return user;
}

+ (void)clearDefaultAddress;
{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:K_DEFAULT_SEND_ADDRESS];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:K_DEFAULT_RECE_ADDRESS];

}

+ (void)saveDefaultSendAddress:(Address*)address
{
    [[NSUserDefaults standardUserDefaults]setObject:[address dictionaryValues] forKey:K_DEFAULT_SEND_ADDRESS];
    
}
+ (void)saveDefaultReceiveAddress:(Address*)address
{
    [[NSUserDefaults standardUserDefaults]setObject:[address dictionaryValues] forKey:K_DEFAULT_RECE_ADDRESS];
}


+ (Address*)getDefaultSendAddress
{
    Address *address = NULL;
    if ([[NSUserDefaults standardUserDefaults]valueForKey:K_DEFAULT_SEND_ADDRESS]) {
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults]valueForKey:K_DEFAULT_SEND_ADDRESS];
        address = [[Address alloc]initWithJsonDict:dic];
    }
    return address;
}


+ (Address*)getDefaultReceAddress
{
    Address *address = NULL;
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:K_DEFAULT_RECE_ADDRESS]) {
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults]valueForKey:K_DEFAULT_RECE_ADDRESS];
        address = [[Address alloc]initWithJsonDict:dic];
        
}
    
    return address;
}

+ (void)saveCompanyArray:(NSMutableArray*)array
{
//    [[NSUserDefaults standardUserDefaults]setObject:array forKey:@"EXP_COMPANY"];
}


+ (NSMutableArray*)getCompanyArray
{
    return (NSMutableArray*)[[NSUserDefaults standardUserDefaults]objectForKey:@"EXP_COMPANY"];
}


@end
