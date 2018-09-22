//
//  MoneyRuleWebVC.m
//  iwant
//
//  Created by 公司 on 2016/12/15.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "MoneyRuleWebVC.h"

@interface MoneyRuleWebVC ()

@end

@implementation MoneyRuleWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setCostomeTitle:@"规则说明"];
    UIWebView *webView = [[UIWebView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    webView.height = SCREEN_HEIGHT-64;
    webView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
    [self.view addSubview:webView];
    NSURL *url = [NSURL URLWithString:@"http://www.efamax.com/mobile/moneyPolicy.html"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [webView loadRequest:request];
    webView.scrollView.bounces = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
