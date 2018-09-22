//
//  BaseViewController.m
//  iwant
//
//  Created by dongba on 16/5/26.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
//    self.navigationController.navigationBar.translucent = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavgationBar];
    self.view.backgroundColor = [UIColor whiteColor];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //把导航栏的属性改回去 YES是透明效果并且主view不会偏移 NO是导航栏不透明 主view会向下偏移64px
//    self.navigationController.navigationBar.translucent = YES;
}
- (void)setCostomeTitle:(NSString *)title{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 60)];
    label.textColor = [UIColor blackColor];
    label.text = title;
    label.textAlignment = 1;
    self.navigationItem.titleView = label;
}

- (void)configNavgationBar {
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"home_btn_selection"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(backToMenuView)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

-(void)ShowNavgationView{
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f,SCREEN_WIDTH - 120.f , 30.0f)];
    UIImageView *imageview= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LOGO"]];
    imageview.centerX = (SCREEN_WIDTH - 120.f)/2.0;
    imageview.centerY = navView.centerY;
    [navView addSubview:imageview];
    self.navigationItem.titleView = navView;
}

- (void)backToMenuView{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
