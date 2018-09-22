//
//  LDInputView.h
//  PasswordDemo
//
//  Created by dongba on 16/6/2.
//  Copyright © 2016年 bing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PasswordView.h"
@interface LDInputView : UIView

@property (nonatomic, copy) void(^passWordBlock)(NSString *passWord);//输入密码
@property (nonatomic, copy) void(^settingPassWordBlock)(NSString *passWord);//设置成功后的密码
/*firstPassWord*/
@property (strong, nonatomic)  NSString *firstPassWord;


/*TITLE*/
@property (strong, nonatomic)  UILabel *titleLabel;
/*PasswordView*/
@property (strong, nonatomic)  PasswordView *passView;
- (instancetype)initWithTitle:(NSString *)title frame:(CGRect)frame;//输入密码

- (instancetype)initWithSettingTitle:(NSString *)settingtitle frame:(CGRect)frame;//设置密码
- (void)cleanLastState;
@end
