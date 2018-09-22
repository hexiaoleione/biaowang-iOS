//
//  MyFaViewController.m
//  iwant
//
//  Created by 公司 on 2017/6/13.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "MyFaViewController.h"
#import "XianShiDingDanFaVC.h"
#import "ShunFengDingdanVC.h"
#import "UserLogListViewController.h"
#import "MainHeader.h"
@interface MyFaViewController (){
    ShunFengDingdanVC * _shunfengFaVC;  //顺风发
    XianShiDingDanFaVC * _xianshiFaVC;  //限时发
    UserLogListViewController * _wuliuFaVC; //物流发
}
@end

@implementation MyFaViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0x222231)];
    self.navigationController.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configNavgationBar];
    self.title =@"我的发单";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    _shunfengFaVC =[[ShunFengDingdanVC alloc]init];
    _shunfengFaVC.title = @"顺路送";
    _xianshiFaVC = [[XianShiDingDanFaVC alloc]init];
    _xianshiFaVC.title = @"专程送";
    _wuliuFaVC = [[UserLogListViewController alloc]init];
    _wuliuFaVC.title = @"物流/冷链";
    self.viewControllers = @[_shunfengFaVC,_xianshiFaVC,_wuliuFaVC];
}

- (void)configNavgationBar {
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self
    action:@selector(backToMenuView)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

-(void)backToMenuView{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
