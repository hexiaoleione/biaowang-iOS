//
//  LogistRoleViewController.m
//  iwant
//
//  Created by dongba on 16/9/5.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "LogistRoleViewController.h"
#import "DriverRoleViewController.h"
#import "LogistCompanyViewController.h"
#import "CompanyRoleFirstViewController.h"
typedef void (^ClickBlock) (UIButton *btn);
@interface LogistRoleViewController (){
    UIView *_flyView;
    CompanyRoleFirstViewController *_logistCompanyVC;
}

@end

@implementation LogistRoleViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_isRegist) {
        _logistCompanyVC.isRegist = YES;
//        _logVC.isRegist = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCostomeTitle:@"物流公司认证"];
    [self configSubViews];
    self.view.layer.masksToBounds = YES;
}

- (void)configSubViews{

    _logistCompanyVC = [CompanyRoleFirstViewController new];
    if (_isRegist) {
        _logistCompanyVC.isRegist = YES;
    }
    _logistCompanyVC.view.top = 0;
    _logistCompanyVC.view.left = 0;
    [self addChildViewController:_logistCompanyVC];
    [self.view addSubview:_logistCompanyVC.view];
}

@end
