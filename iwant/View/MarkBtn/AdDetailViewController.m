//
//  AdDetailViewController.m
//  iwant
//
//  Created by 公司 on 2016/11/18.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "AdDetailViewController.h"
@interface AdDetailViewController ()

@end

@implementation AdDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupWebView];
}

-(void)setupWebView{
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIWebView *webView = [[UIWebView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    webView.height = SCREEN_HEIGHT-64;
    webView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 60)];
    label.textColor = [UIColor whiteColor];
    label.text = @"详细信息";
    label.textAlignment = NSTextAlignmentCenter;
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(pop)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    self.navigationItem.titleView = label;
    [self.view addSubview:webView];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.adModel.advertiseHtmlUrl]];
    [webView loadRequest:request];
    webView.scrollView.bounces = NO;
}
- (void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
