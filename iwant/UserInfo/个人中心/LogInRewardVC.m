//
//  LogInRewardVC.m
//  iwant
//
//  Created by 公司 on 2017/5/12.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "LogInRewardVC.h"
#import "EcoinWebViewController.h"
#import "AdView.h"
#import "ActivityNewVC.h"
#import "RedRewardView.h"
//按比例获取高度
#define  WGiveHeight(HEIGHT) HEIGHT * [UIScreen mainScreen].bounds.size.height/568.0

//按比例获取宽度
#define  WGiveWidth(WIDTH) WIDTH * [UIScreen mainScreen].bounds.size.width/320.0
#define WEBVIEW_H   WINDOW_HEIGHT *0.4//webView高度

@interface LogInRewardVC (){
    
    UIWebView *_webView;
    UILabel * _label1;
    NSString * _driverCount;
    NSString * _message;
    NSString * _rewardCount; //奖励总金额
    int _buttunSwitch; //是否到达一定单数
    int _ifReward; //是否已领取
    UIButton * btn;
    
    RedRewardView * _rewardView;  //奖励
}

@end

@implementation LogInRewardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setCostomeTitle:@"登录奖励"];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configNavgationBar];
    [self configWebView];
    [self creatUI];
    [self creatData];
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
    vc.web_type = WEB_LOGIN_Reward;
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
    NSString *urlStr = [NSString stringWithFormat:@"http://www.efamax.com/mobile_document/loginReward.html?%@",strDate];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [_webView loadRequest:request];
    
    [self.view addSubview:_webView];
}

-(void)creatData{
    [ExpressRequest sendWithParameters:nil MethodStr:[NSString stringWithFormat:@"%@activity/loginRewardInfo?userId=%@",BaseUrl,[UserManager getDefaultUser].userId]  reqType:k_GET success:^(id object) {
        NSDictionary * dict = [object objectForKey:@"data"][0];
        _rewardCount = [[dict objectForKey:@"rewardCount"] stringValue];
        _message = [object objectForKey:@"message"];
        _ifReward = [[dict objectForKey:@"ifReward"] intValue];
        _label1.text = [NSString stringWithFormat:@"奖励总金额：%.2f 元",[_rewardCount floatValue]];
        if (_ifReward == 0) {
//            btn.hidden  = YES;
            [btn setBackgroundImage:[UIImage imageNamed:@"Reward_qiangNo"] forState:UIControlStateNormal];
        }else{
            [btn setBackgroundImage:[UIImage imageNamed:@"Reward_qiang"] forState:UIControlStateNormal];
//            btn.hidden  = NO;
        }
    } failed:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
        _message = error;
    }];
}
-(void)creatUI{
    _label1 = [[UILabel alloc]initWithFrame:CGRectMake(WGiveWidth(10), _webView.bottom+WGiveHeight(10), SCREEN_WIDTH - WGiveWidth(20), WGiveWidth(30))];
    
    btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setBackgroundImage:[UIImage imageNamed:@"Reward_qiang"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, _label1.bottom + WGiveHeight(30),246*RATIO_WIDTH , 180*RATIO_HEIGHT);
    btn.centerX = SCREEN_WIDTH/2;
    if (_ifReward == 0) {
//        btn.hidden = YES;
        [btn setBackgroundImage:[UIImage imageNamed:@"Reward_qiangNo"] forState:UIControlStateNormal];
    }else{
        [btn setBackgroundImage:[UIImage imageNamed:@"Reward_qiang"] forState:UIControlStateNormal];
//        btn.hidden = NO;
    }
    btn.titleLabel.font = FONT(18, NO);
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_label1];
    [self.view addSubview:btn];
}
-(void)btnClick:(UIButton *)sender{
        //可以提现发请求
        [ExpressRequest sendWithParameters:nil MethodStr:[NSString stringWithFormat:@"%@activity/getLoginReward?userId=%@",BaseUrl,[UserManager getDefaultUser].userId]  reqType:k_GET success:^(id object) {
            [[NSNotificationCenter defaultCenter] postNotificationName:TRANSFERMONEY object:nil];
            _rewardView =[[NSBundle mainBundle] loadNibNamed:@"RedRewardView" owner:nil options:nil].firstObject;
            [_rewardView show];
            NSDictionary * dict = [object objectForKey:@"data"][0];
            NSString * recordMoney = [[dict objectForKey:@"recordMoney"] stringValue];
            NSMutableAttributedString *string1=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"恭喜您获得%.2f元",[recordMoney floatValue]]];
            NSInteger lenth = string1.length;
            [self useStr:string1 withRange:NSMakeRange(0, lenth) withColor:UIColorFromRGB(0xfff548) withFont:FONT(27, NO)];
            [self useStr:string1 withRange:[[string1 string]rangeOfString:@"恭喜您获得"] withColor:[UIColor whiteColor] withFont:FONT(18, NO)];
            [self useStr:string1 withRange:[[string1 string]rangeOfString:@"元"] withColor:UIColorFromRGB(0xfff548) withFont:FONT(18, NO)];
            _rewardView.noticeLabel.attributedText=string1;
            
             __weak LogInRewardVC * weakSelf = self;
            _rewardView.Block = ^(NSInteger tag) {
                if (tag == 0) {
                  [weakSelf dismiss];
                }else{
                    [weakSelf dismiss];
                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                }
            };
            [self creatData];
        } failed:^(NSString *error) {
            [SVProgressHUD showErrorWithStatus:error];
        }];
}
-(void)dismiss{
   [_rewardView dismiss];
}

- (void)configNavgationBar {
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(backToMenuView)];
    leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}
- (void)backToMenuView{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)useStr:(NSMutableAttributedString *)string withRange:(NSRange)range withColor:(UIColor *)color withFont:(UIFont *)font {
    [string addAttribute:NSFontAttributeName value:font range:range];
    [string addAttribute:NSForegroundColorAttributeName value:color range:range];
}



@end
