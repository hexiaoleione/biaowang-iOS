//
//  TouBaoRuleVC.m
//  iwant
//
//  Created by 公司 on 2017/5/18.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "TouBaoRuleVC.h"

@interface TouBaoRuleVC ()<UIScrollViewDelegate,UIWebViewDelegate>
{
    UIWebView * _webView;
}
@property (nonatomic, strong) UIView *backView;

@end

@implementation TouBaoRuleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCostomeTitle:@"保险协议"];
    // Do any additional setup after loading the view.
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)];
    NSString *urlStr = @"";
//    NSString *title;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHH"];
//    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *strDateSecond = [dateFormatter stringFromDate:[NSDate date]];
    urlStr = [NSString stringWithFormat:@"http://www.efamax.com/mobile/manual/inSureRule.html?%@",strDateSecond];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [_webView loadRequest:request];
    [_webView setScalesPageToFit:NO];
    [self.view addSubview:_webView];
    _webView.delegate = self;

}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString * requestString = request.URL.absoluteString;
    NSLog(@"请求的地址：%@",requestString);
    if ([requestString containsString:@"next_y://"]){
        //做你想要的操作
        if (_Block) {
            _Block(1);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else if([requestString containsString:@"next_n://"]){
        if (_Block) {
            _Block(0);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{

    }
    return YES;
}

- (void)configNavgationBar {
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"home_btn_selection"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(backToMenuView)];
    leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}
- (void)backToMenuView{
    if (_Block) {
        _Block(0);
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
