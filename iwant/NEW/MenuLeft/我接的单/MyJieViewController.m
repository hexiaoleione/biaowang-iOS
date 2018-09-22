//
//  MyJieViewController.m
//  iwant
//
//  Created by 公司 on 2017/6/15.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "MyJieViewController.h"
#import "MainHeader.h"
#import "ShunFengDingdanJieVC.h"
#import "XianshiDingdanJieVC.h"
#import "CompanyLogistViewController.h"
@interface MyJieViewController (){
    ShunFengDingdanJieVC * _shunfengJie;
    XianshiDingdanJieVC * _xianshiJie;
    CompanyLogistViewController * _wuliuJie;
}

@end

@implementation MyJieViewController

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
    self.title = @"我的接单";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    _shunfengJie = [[ShunFengDingdanJieVC alloc]init];
    _shunfengJie.title = @"顺路送";
    _xianshiJie = [[XianshiDingdanJieVC alloc]init];
    _xianshiJie.title = @"专程送";
    _wuliuJie = [[CompanyLogistViewController alloc]init];
    _wuliuJie.title = @"物流/冷链";
    
    if([[UserManager getDefaultUser].wlid intValue] != 0){
        self.viewControllers = @[_shunfengJie,_xianshiJie,_wuliuJie];
    }else{
        self.viewControllers = @[_shunfengJie,_xianshiJie];
    }
}
- (void)configNavgationBar {
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]style:UIBarButtonItemStylePlain  target:self action:@selector(backToMenuView)];
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
