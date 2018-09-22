//
//  LogistCompanyViewController.h
//  iwant
//
//  Created by dongba on 16/9/6.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "BaseViewController.h"
#import "LogistCompanyInfo.h"
typedef void (^ClickBlock)(UIButton *btn);
@interface LogistCompanyViewController : BaseViewController

/*<#uttext#>*/
@property (copy, nonatomic)  ClickBlock block;
/*<#uttext#>*/
@property (strong, nonatomic)   LogistCompanyInfo *fieldview;;

@property(nonatomic,copy) NSString *idCardOpenPath; //身份证正面
@property(nonatomic,copy) NSString *idCardObversePath; //身份证反面
@property(nonatomic,copy) NSString *businessLicensePath; //营业执照

//是否注册跳转认证过来的
@property (nonatomic,assign) BOOL isRegist;

@end
