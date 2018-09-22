//
//  activityViewController.m
//  iwant
//
//  Created by 公司 on 2016/11/21.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "activityViewController.h"

@interface activityViewController () //活动页面的web页面

@end

@implementation activityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupWebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupWebView{
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIWebView *webView = [[UIWebView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    webView.height = SCREEN_HEIGHT-64;
    webView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 60)];
    label.textColor = [UIColor whiteColor];
    label.text = @"活动详情";
    label.textAlignment = NSTextAlignmentCenter;
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(pop)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    self.navigationItem.titleView = label;
    [self.view addSubview:webView];
    NSURL *url = [NSURL URLWithString:_urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [webView loadRequest:request];
    webView.scrollView.bounces = NO;
}
- (void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
