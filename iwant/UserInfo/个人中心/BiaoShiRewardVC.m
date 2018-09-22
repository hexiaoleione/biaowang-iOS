//
//  BiaoShiRewardVC.m
//  iwant
//
//  Created by 公司 on 2017/5/4.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "BiaoShiRewardVC.h"
#import "EcoinWebViewController.h"
//按比例获取高度
#define  WGiveHeight(HEIGHT) HEIGHT * [UIScreen mainScreen].bounds.size.height/568.0

//按比例获取宽度
#define  WGiveWidth(WIDTH) WIDTH * [UIScreen mainScreen].bounds.size.width/320.0
#define WEBVIEW_H   WINDOW_HEIGHT *0.4//webView高度

@interface BiaoShiRewardVC (){
    
    UIWebView *_webView;
    UILabel * _label1;
    UILabel * _label2;
    UILabel * _label3;

    NSString * _driverCount;
    NSString * _message;
    NSString * _activityMoney; //奖励金额
    int _buttunSwitch; //是否到达一定单数
    int _ifReciveMoney; //是否已领取
    UIButton * btn;
}

@end

@implementation BiaoShiRewardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setCostomeTitle:@"镖师奖励"];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configWebView];
    [self creatNewUI];
    [self creatDataNew];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(shuoming)
     forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 40, 30);
    [button setTitle:@"说明" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = menuButton;
}

-(void)shuoming{
    EcoinWebViewController * vc = [[EcoinWebViewController alloc]init];
    vc.web_type = WEB_BiaoShiReward;
    [self.navigationController pushViewController:vc animated:YES];
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
    NSString *urlStr = [NSString stringWithFormat:@"http://www.efamax.com/mobile_document/driver.html?%@",strDate];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [_webView loadRequest:request];
    
    [self.view addSubview:_webView];
}
#pragma mark ----只展示镖师接单量统计
-(void)creatNewUI{
  _label1 = [[UILabel alloc]initWithFrame:CGRectMake(WGiveWidth(10), _webView.bottom+WGiveHeight(10), SCREEN_WIDTH - WGiveWidth(20), WGiveWidth(30))];
  _label1.textAlignment = NSTextAlignmentCenter;
    _label1.font = FONT(15, NO);
  _label1.text = @"镖师接单量统计";
  
 _label2= [[UILabel alloc]initWithFrame:CGRectMake(80*RATIO_WIDTH, _label1.bottom+WGiveHeight(10), SCREEN_WIDTH-160*RATIO_WIDTH, WGiveWidth(30))];
    _label2.text = @"本月接单量：0 次";
    
 _label3 = [[UILabel alloc]initWithFrame:CGRectMake(80*RATIO_WIDTH, _label2.bottom+WGiveHeight(10), SCREEN_WIDTH-160*RATIO_WIDTH, WGiveWidth(30))];
 _label3.text = @"接单总量：0 次";
    
    [self.view addSubview:_label1];
    [self.view addSubview:_label2];
    [self.view addSubview:_label3];
}

-(void)creatDataNew{
     [ExpressRequest sendWithParameters:nil MethodStr:[NSString stringWithFormat:@"%@driver/driveInfo?userId=%@",BaseUrl,[UserManager getDefaultUser].userId]  reqType:k_GET success:^(id object) {
//         driverRouteCount;//接单次数
//         activityCount    周期次数
         NSDictionary * dict = [object objectForKey:@"data"][0];
         NSString * driverRouteCount = [dict objectForKey:@"driverRouteCount"];
         NSString * activityCount = [dict objectForKey:@"activityCount"];
         
         NSMutableAttributedString *string1=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"本月接单量：%@ 次",activityCount]];
         NSInteger lenth = string1.length;
         [self useStr:string1 withRange:NSMakeRange(0, lenth) withColor:[UIColor redColor] withFont:FONT(32, NO)];
         [self useStr:string1 withRange:[[string1 string]rangeOfString:@"本月接单量："] withColor:[UIColor blackColor] withFont:FONT(18, NO)];
         [self useStr:string1 withRange:[[string1 string]rangeOfString:@" 次"] withColor:[UIColor blackColor] withFont:FONT(18, NO)];
         _label2.attributedText=string1;
         
         NSMutableAttributedString *string2=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"接单总量：%@ 次",driverRouteCount]];
         NSInteger lenth1 = string2.length;
         [self useStr:string2 withRange:NSMakeRange(0, lenth1) withColor:[UIColor redColor] withFont:FONT(32, NO)];
         [self useStr:string2 withRange:[[string2 string]rangeOfString:@"接单总量："] withColor:[UIColor blackColor] withFont:FONT(18, NO)];
         [self useStr:string2 withRange:[[string2 string]rangeOfString:@"次"] withColor:[UIColor blackColor] withFont:FONT(18, NO)];
         _label3.attributedText=string2;
         
     } failed:^(NSString *error) {
         [SVProgressHUD showErrorWithStatus:error];
         _label2.text = @"本月接单量：0 次";
         _label3.text = @"接单总量：0 次";
     }];
}
- (void)useStr:(NSMutableAttributedString *)string withRange:(NSRange)range withColor:(UIColor *)color withFont:(UIFont *)font {
    [string addAttribute:NSFontAttributeName value:font range:range];
    [string addAttribute:NSForegroundColorAttributeName value:color range:range];
}

#pragma mark ----镖师奖励一共多少钱  （提现）
-(void)creatData{
    [ExpressRequest sendWithParameters:nil MethodStr:[NSString stringWithFormat:@"%@activity/driverActivity?userId=%@",BaseUrl,[UserManager getDefaultUser].userId]  reqType:k_GET success:^(id object) {
        NSDictionary * dict = [object objectForKey:@"data"][0];
        _driverCount = [dict objectForKey:@"driverCount"];
        _activityMoney = [dict objectForKey:@"activityMoney"];
        _message = [object objectForKey:@"message"];
        _buttunSwitch = [[dict objectForKey:@"buttunSwitch"] intValue];
        _ifReciveMoney = [[dict objectForKey:@"ifReciveMoney"] intValue];
        _label1.text = [NSString stringWithFormat:@"奖励金额：%@元",_activityMoney];
        _label2.text = [NSString stringWithFormat:@"接镖次数：%@",_driverCount];
        if (_ifReciveMoney == 1) {
            [btn setTitle:@"已 提 现" forState:UIControlStateNormal];
            [btn setTintColor:[UIColor whiteColor]];
            btn.backgroundColor = [UIColor lightGrayColor];
        }else{
            [btn setTitle:@"提   现" forState:UIControlStateNormal];
            [btn setTintColor:[UIColor whiteColor]];
            btn.backgroundColor = COLOR_MainColor;
        }
    } failed:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
        _message = error;
    }];
}
-(void)creatUI{
    _label1 = [[UILabel alloc]initWithFrame:CGRectMake(WGiveWidth(10), _webView.bottom+WGiveHeight(10), SCREEN_WIDTH - WGiveWidth(20), WGiveWidth(30))];
    _label2 = [[UILabel alloc]initWithFrame:CGRectMake(WGiveWidth(10), _label1.bottom+WGiveWidth(10), SCREEN_WIDTH - WGiveWidth(20), WGiveWidth(30))];
   
    btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(0, _label2.bottom + WGiveHeight(20), SCREEN_WIDTH/3 , WGiveHeight(40));
    btn.centerX = SCREEN_WIDTH/2;
    btn.layer.cornerRadius = WGiveHeight(5);
    btn.layer.masksToBounds = YES;
    if (_ifReciveMoney == 1) {
      [btn setTitle:@"已 提 现" forState:UIControlStateNormal];
      [btn setTintColor:[UIColor whiteColor]];
      btn.backgroundColor = [UIColor lightGrayColor];
    }else{
      [btn setTitle:@"提   现" forState:UIControlStateNormal];
      [btn setTintColor:[UIColor whiteColor]];
      btn.backgroundColor = COLOR_MainColor;
    }
    btn.titleLabel.font = FONT(18, NO);
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_label1];
    [self.view addSubview:_label2];
    [self.view addSubview:btn];
}
-(void)btnClick:(UIButton *)sender{
    if (_buttunSwitch == 1) {
       //可以提现发请求
     [ExpressRequest sendWithParameters:nil MethodStr:[NSString stringWithFormat:@"%@activity/driverActivityReceive?userId=%@",BaseUrl,[UserManager getDefaultUser].userId]  reqType:k_GET success:^(id object) {
            [[NSNotificationCenter defaultCenter] postNotificationName:TRANSFERMONEY object:nil];
            [SVProgressHUD showSuccessWithStatus:[object objectForKey:@"message"]];
            [sender setTitle:@"已 提 现" forState:UIControlStateNormal];
            [sender setTintColor:[UIColor whiteColor]];
            sender.backgroundColor = [UIColor lightGrayColor];
        } failed:^(NSString *error) {
            [SVProgressHUD showErrorWithStatus:error];
      }];

    }else{
        //提示语句
        HHAlertView *alert = [[HHAlertView alloc]initWithTitle:@"温馨提示" detailText:_message cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alert show];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
