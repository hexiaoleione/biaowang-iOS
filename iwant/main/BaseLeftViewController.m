//
//  BaseLeftViewController.m
//  iwant
//
//  Created by 公司 on 2017/6/6.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "BaseLeftViewController.h"

@interface BaseLeftViewController ()

@end

@implementation BaseLeftViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0x222231)];
    self.navigationController.navigationBar.translucent = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self configNavgationBar];
    
}
- (void)configNavgationBar {
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(backToMenuView)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

-(void)backToMenuView{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setCostomeTitle:(NSString *)title{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 60)];
    label.textColor = [UIColor whiteColor];
    label.text = title;
    label.textAlignment = 1;
    self.navigationItem.titleView = label;
}
-(void)viewWillDisappear:(BOOL)animated{
    //把导航栏的属性改回去 YES是透明效果并且主view不会偏移 NO是导航栏不透明 主view会向下偏移64px
//   self.navigationController.navigationBar.translucent = YES;
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
