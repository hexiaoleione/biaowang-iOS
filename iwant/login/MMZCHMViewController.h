//
//  MMZCHMViewController.h
//  MMR
//
//  Created by qianfeng on 15/6/30.
//  Copyright © 2015年 MaskMan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMZCHMViewController : UIViewController

@property (assign, nonatomic)  int type;//0 注册1/3 ,1 多设备登陆验证,2 第三方登录绑定手机号
@property (copy, nonatomic)  NSString *phoneNumber;

@property (assign, nonatomic)  BOOL isThird;


@property (copy, nonatomic)  NSString *acctoken;
@property (copy, nonatomic)  NSDictionary *dic;//三方登陆dic

@end
