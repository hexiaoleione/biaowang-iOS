//
//  DwHelp.h
//  iwant
//
//  Created by 公司 on 2017/11/1.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DwHelp : NSObject

+(NSDictionary *)LHGetStartTime;
//获取当前控制器
+ (UIViewController *)getCurrentVC;
+ (void)updateUser;
@end
