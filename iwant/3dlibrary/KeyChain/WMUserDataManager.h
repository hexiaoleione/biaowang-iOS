//
//  WMUserDataManager.h
//  用户机密的储存
//
//  Created by wangmiao on 16/2/25.
//  Copyright © 2016年 wangmiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMUserDataManager : NSObject

/**储存密码*/
+ (void)savePassWord:(NSString *)password;

/**读取密码*/
+ (id)readPassWord;

/**删除密码*/
+ (void)deletePassWord;

@end
