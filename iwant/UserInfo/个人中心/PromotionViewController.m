//
//  PromotionViewController.m
//  iwant
//
//  Created by 公司 on 2017/4/20.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "PromotionViewController.h"
//按比例获取高度
#define  WGiveHeight(HEIGHT) HEIGHT * [UIScreen mainScreen].bounds.size.height/568.0

//按比例获取宽度
#define  WGiveWidth(WIDTH) WIDTH * [UIScreen mainScreen].bounds.size.width/320.0
#define WEBVIEW_H   WINDOW_HEIGHT *0.4//webView高度

@interface PromotionViewController (){
    
   UIWebView *_webView;
    NSString * count;
    NSString * countMax;
    NSString * message;
    NSString * price;
    
    UILabel * _label1;
    UILabel * _label2;
}

@end

@implementation PromotionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setCostomeTitle:@"推广收入"];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configWebView];
    [self creatData];
    [self creatUI];
}
- (void)configWebView{
    //使用一张照片
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHH"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(WGiveWidth(0), WGiveWidth(0) ,WINDOW_WIDTH - WGiveWidth(0),WEBVIEW_H)];
    //  禁止滚动
    _webView.scrollView.bounces = NO;
    _webView.backgroundColor = [UIColor whiteColor];
    NSString *urlStr = [NSString stringWithFormat:@"http://www.efamax.com/mobile_document/extend.html?%@",strDate];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [_webView loadRequest:request];
    
    [self.view addSubview:_webView];
}

-(void)creatData{
    [ExpressRequest sendWithParameters:nil MethodStr:[NSString stringWithFormat:@"%@wallet/getExtend?userId=%@",BaseUrl,[UserManager getDefaultUser].userId]  reqType:k_GET success:^(id object) {
        NSDictionary * dict = [object objectForKey:@"data"][0];
        count = [dict objectForKey:@"high"];
        countMax = [dict objectForKey:@"length"];
        price = [dict objectForKey:@"price"];
        message = [dict objectForKey:@"matName"];
        _label1.text = [NSString stringWithFormat:@"推广人数：%@",count];
        _label2.text = [NSString stringWithFormat:@"推广收入：%@元",price];
    } failed:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
}

-(void)creatUI{
    _label1 = [[UILabel alloc]initWithFrame:CGRectMake(WGiveWidth(10), _webView.bottom+WGiveHeight(10), SCREEN_WIDTH - WGiveWidth(20), WGiveWidth(30))];
    _label2 = [[UILabel alloc]initWithFrame:CGRectMake(WGiveWidth(10), _label1.bottom+WGiveWidth(10), SCREEN_WIDTH - WGiveWidth(20), WGiveWidth(30))];
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(0, _label2.bottom + WGiveHeight(20), SCREEN_WIDTH/3 , WGiveHeight(40));
    btn.centerX = SCREEN_WIDTH/2;
    btn.backgroundColor = COLOR_MainColor;
    btn.layer.cornerRadius = WGiveHeight(5);
    btn.layer.masksToBounds = YES;
    [btn setTitle:@"提   现" forState:UIControlStateNormal];
    [btn setTintColor:[UIColor whiteColor]];
    btn.titleLabel.font = FONT(18, NO);
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_label1];
    [self.view addSubview:_label2];
    [self.view addSubview:btn];
}
-(void)btnClick:(UIButton *)btn{
    if ([count intValue] >= [countMax intValue]) {
        //崩溃
        [btn performSelector:@selector(haha)];
    }else{
        //提示语句
        HHAlertView *alert = [[HHAlertView alloc]initWithTitle:@"温馨提示" detailText:message cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
