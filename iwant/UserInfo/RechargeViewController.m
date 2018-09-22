//
//  RechargeViewController.m
//  iwant
//
//  Created by pro on 16/3/8.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "RechargeViewController.h"
#import "UserManager.h"
#import "AlipayHeader.h"
#import "MainHeader.h"
#import "NSStringAdditions.h"
#import "SVProgressHUD.h"
#import "WechatPayRequestConfig.h"
#import "WXPayManager.h"
#import "EcoinWebViewController.h"
#import "FindGoodsViewController.h" //找货界面
#import "InforWebViewController.h"
#define WIDTH [UIScreen mainScreen].bounds.size.width

#define HEIGHT [UIScreen mainScreen].bounds.size.height
#define WINDOW_WIDTH    [[UIScreen mainScreen] bounds].size.width
#define WINDOW_HEIGHT   [[UIScreen mainScreen] bounds].size.height
#define COLOR_APP_BASIC_BK   [UIColor colorWithWhite:1 alpha:1] //===tablecell 背景色
#define FONT_SYS_(A)         [UIFont systemFontOfSize:A]
#define COLOR_SET(R,G,B)    [UIColor colorWithRed: R/225.0 green: G/225.0 blue: B/225.0 alpha:1]


//按比例获取高度
#define  WGiveHeight(HEIGHT) HEIGHT * [UIScreen mainScreen].bounds.size.height/568.0

//按比例获取宽度
#define  WGiveWidth(WIDTH) WIDTH * [UIScreen mainScreen].bounds.size.width/320.0
#define WEBVIEW_H   WINDOW_HEIGHT *0.224//webView高度
@interface RechargeViewController ()<UITextFieldDelegate>
{
    
    
    UIView *_topView;
    UIWebView *_webView;
    UIButton *_courentBtn;//当前按钮
    UIButton *_firstBtn;//10000元的按钮
    UIButton *_secBtn;
    UIButton *_thirdBtn;
    UIButton *_fourthBtn;//100元按钮
    UIButton *_fiveBtn; //200元按钮
    UIButton *_sixdBtn;//500元按钮
    
    UIButton * readBtn;
    
    
    UITextField *_moneyTF;
    UITextField *_mobile;//推荐人手机号
    
    BOOL _ifAvalid;
}
@end

@implementation RechargeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configNavgationBar];
    [self configWebView];
    [self configView];
    //用户获取
    [self requestRechargechange];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}
-(void)requestRechargechange
{
    [RequestManager getRechargechangeuserId:[UserManager getDefaultUser].userId success:^(id object) {
        NSString *str = [object valueForKey:@"ifAvalid"];
        if ([str integerValue] == 0) {
            _ifAvalid = NO;
        }else{
            _ifAvalid = YES;
        }
//  private String agreementType;    //普通用户 0或空 海南代理 1  海南用户 2
        if ([[UserManager getDefaultUser].agreementType intValue] == 1 || [[UserManager getDefaultUser].agreementType intValue] == 2) {
            _ifAvalid = NO;
            [SVProgressHUD showErrorWithStatus:@"您是海南特约用户不可进行充值"];
        }
    } Failed:^(NSString *error) {
        
    }];
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
        NSString *urlStr = [NSString stringWithFormat:@"http://www.efamax.com/mobile_document/discount_1.html?%@",strDate];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
        [_webView loadRequest:request];
        [self.view addSubview:_webView];
}

- (void)gotoWEB{
    EcoinWebViewController *detaiVC = [EcoinWebViewController new];
    detaiVC.web_type = WEB_USER_EXPLANE;
    [self.navigationController pushViewController:detaiVC animated:YES];
}

- (void)configView{
    [self creatLabel:0 font:13 text:@"充值金额" color:[UIColor grayColor] bgcolor:nil X:WGiveWidth(15) Y:WEBVIEW_H W:WGiveWidth(100) H:WGiveHeight(40)];
    [self setBtn];
}
- (void)setBtn{
    /*
    _fourthBtn = [self creatBtnWithTitle:@"50元"
                                       X:WGiveWidth(7)
                                       Y:WEBVIEW_H +WGiveHeight(45)
                                       W:(WINDOW_WIDTH )*0.3
                                       H:WGiveHeight(35) tag:6];
    _courentBtn = _fourthBtn;
    _courentBtn.backgroundColor = COLOR_MainColor;
    _fourthBtn.selected = YES;
    _fiveBtn = [self creatBtnWithTitle:@"100元"
                                     X:WGiveWidth(17) + (WINDOW_WIDTH )*0.3
                                     Y:WEBVIEW_H +WGiveHeight(45)
                                     W:(WINDOW_WIDTH )*0.3
                                     H:WGiveHeight(35) tag:7];
    _sixdBtn = [self creatBtnWithTitle:@"200元"
                                     X:WGiveWidth(27) + (WINDOW_WIDTH )*0.6
                                     Y:WEBVIEW_H +WGiveHeight(45)
                                     W:(WINDOW_WIDTH )*0.3
                                     H:WGiveHeight(35) tag:8];
    
    _firstBtn = [self creatBtnWithTitle:@"500元"
                                      X:WGiveWidth(7)
                                      Y:WEBVIEW_H +WGiveHeight(85)
                                      W:(WINDOW_WIDTH )*0.3
                                      H:WGiveHeight(35) tag:0];
    _secBtn   = [self creatBtnWithTitle:@"1000元"
                                      X:WGiveWidth(17) + (WINDOW_WIDTH )*0.3
                                      Y:WEBVIEW_H +WGiveHeight(85)
                                      W:(WINDOW_WIDTH )*0.3
                                      H:WGiveHeight(35) tag:1];
//    _thirdBtn = [self creatBtnWithTitle:@"1000元"
//                                      X:WGiveWidth(27) + (WINDOW_WIDTH )*0.6
//                                      Y:WEBVIEW_H +WGiveHeight(70)
//                                      W:(WINDOW_WIDTH )*0.3
//                                      H:WGiveHeight(35)
//                                    tag:2];
     
     */
    _fourthBtn = [self creatBtnWithTitle:@"100元"
                                       X:WGiveWidth(15)
                                       Y:WEBVIEW_H +WGiveHeight(45)
                                       W:(WINDOW_WIDTH )*0.4
                                       H:WGiveHeight(35) tag:6];
    _courentBtn = _fourthBtn;
    _courentBtn.backgroundColor = COLOR_MainColor;
    _fourthBtn.selected = YES;
    _fiveBtn = [self creatBtnWithTitle:@"200元"
                                     X:WINDOW_WIDTH-(WGiveWidth(15) + (WINDOW_WIDTH )*0.4)
                                     Y:WEBVIEW_H +WGiveHeight(45)
                                     W:(WINDOW_WIDTH )*0.4
                                     H:WGiveHeight(35) tag:7];
    _sixdBtn = [self creatBtnWithTitle:@"500元"
                                     X:WGiveWidth(15)
                                     Y:WEBVIEW_H +WGiveHeight(90)
                                     W:(WINDOW_WIDTH )*0.4
                                     H:WGiveHeight(35) tag:8];
    
    _firstBtn = [self creatBtnWithTitle:@"1000元"
                                      X:WINDOW_WIDTH-(WGiveWidth(15) + (WINDOW_WIDTH )*0.4)
                                      Y:WEBVIEW_H +WGiveHeight(90)
                                      W:(WINDOW_WIDTH )*0.4
                                      H:WGiveHeight(35) tag:0];
    
    readBtn = [[UIButton alloc]initWithFrame:CGRectMake(WGiveWidth(10), CGRectGetMaxY(_firstBtn.frame)+ WGiveHeight(35),WGiveWidth(150) , WGiveHeight(25))];
    [readBtn setImage:[UIImage imageNamed:@"Fa_toubao"] forState:UIControlStateNormal];
    [readBtn setImage:[UIImage imageNamed:@"Fa_toubaoY"] forState:UIControlStateSelected];
    [readBtn setTitle:@"我已阅读并同意镖王的" forState:UIControlStateNormal];
    [readBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    readBtn.titleLabel.font = FONT(15, NO);
    [readBtn addTarget:self action:@selector(readBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * ruleBtn = [[UIButton alloc]initWithFrame:CGRectMake(readBtn.right, readBtn.top,WGiveWidth(80) , readBtn.height)];
    [ruleBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [ruleBtn setTitle:@"《充值说明》" forState:UIControlStateNormal];
    ruleBtn.titleLabel.font = FONT(15, NO);
    [ruleBtn addTarget:self action:@selector(explain) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:readBtn];
    [self.view addSubview:ruleBtn];
  
   UIButton * wxBtn =  [self creatBtnWithTitle:@"微信充值"
                          X:WGiveWidth(20)
                          Y:CGRectGetMaxY(_firstBtn.frame)+ WGiveHeight(100)
                          W:WINDOW_WIDTH/2
                          H:WGiveHeight(40) tag:4];
   [self creatBtnWithTitle:@"充值"
                          X:WGiveWidth(20)
                          Y:CGRectGetMaxY(wxBtn.frame) + WGiveHeight(25)
                          W:WINDOW_WIDTH/2
                          H:WGiveHeight(40)
                        tag:5];
}

-(void)readBtnClick:(UIButton *)sender{
    sender.selected = !sender.selected;
}

-(UIImageView *)createImageViewFrame:(CGRect)frame imageName:(NSString *)imageName color:(UIColor *)color
{
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:frame];
    
    if (imageName)
    {
        imageView.image=[UIImage imageNamed:imageName];
    }
    if (color)
    {
        imageView.backgroundColor=color;
    }
    
    return imageView;
}
- (void)creatLabel:(NSString *)str font:(int)font X:(CGFloat)x Y:(CGFloat)y W:(CGFloat)w H:(CGFloat)h isUP:(BOOL)isUP{
    UILabel *label;
    if (isUP) {
        label = [[UILabel alloc]initWithFrame:CGRectMake(x,y,w,h)];
        label.textColor = COLOR_APP_BASIC_BK;
    }else{
        label = [[UILabel alloc]initWithFrame:CGRectMake(WGiveWidth(40), y, WINDOW_WIDTH - WGiveWidth(60), WGiveHeight(50))];
        label.textColor = [UIColor redColor];
        label.alpha = 0.5;
    }
    label.text = str;
    label.font = FONT_SYS_(font);
    [self.view addSubview:label];
}
- (void)creatLabel:(int)tag font:(int)font text:(NSString*)text color:(UIColor*)color bgcolor:(UIColor *)bgcolor X:(CGFloat)x Y:(CGFloat)y W:(CGFloat)w H:(CGFloat)h{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(x, y, w, h)];
    label.backgroundColor = bgcolor;
    label.tag = 0;
    label.text = text;
    label.textColor = color;
    label.font = FONT_SYS_(font);
    [self.view addSubview:label];
}
-(UIButton *)creatBtnWithTitle:(NSString *)title X:(CGFloat)x Y:(CGFloat)y W:(CGFloat)w H:(CGFloat)h tag:(int)tag{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(x, y, w, h)];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:COLOR_MainColor forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    btn.layer.borderColor = COLOR_MainColor.CGColor;
    btn.layer.cornerRadius = 5.0;
    btn.layer.borderWidth = 0.5;
    btn.backgroundColor = [UIColor whiteColor];
    btn.tag = tag;
    if ([title isEqualToString:@"微信充值"]) {
        [btn setTitle:@"" forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"btn_2"] forState:UIControlStateNormal];
        btn.layer.borderColor = [[UIColor grayColor]CGColor];
        btn.centerX = SCREEN_WIDTH/2;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.layer.borderWidth = 0.0;
        btn.backgroundColor = [UIColor whiteColor];

    }else if ([title isEqualToString:@"充值"]){
        [btn setTitle:@"" forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"btn_1"] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor whiteColor]];
        btn.centerX = SCREEN_WIDTH/2;
        btn.layer.borderColor = [[UIColor grayColor]CGColor];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.layer.borderWidth = 0.0;
        btn.backgroundColor = [UIColor whiteColor];
    }
    [btn addTarget:self action:@selector(tapBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    return btn;
}
- (void)tapBtn:(UIButton *)sender{
    
    UIButton *btn = (UIButton*)sender;
    switch (btn.tag) {
        case 0:
            [_moneyTF resignFirstResponder];
            _firstBtn.selected = YES;
            _courentBtn = _firstBtn;
            _secBtn.selected = NO;
            _thirdBtn.selected = NO;
            _fourthBtn.selected = NO;
            _fiveBtn.selected = NO;
            _sixdBtn.selected = NO;
            _firstBtn.backgroundColor = COLOR_MainColor;
            _secBtn.backgroundColor = [UIColor whiteColor];
            _thirdBtn.backgroundColor = [UIColor whiteColor];
            _fourthBtn.backgroundColor = [UIColor whiteColor];
            _fiveBtn.backgroundColor = [UIColor whiteColor];
            _sixdBtn.backgroundColor = [UIColor whiteColor];
            _moneyTF.text = @"";
            break;
        case 1:
            [_moneyTF resignFirstResponder];
            _firstBtn.selected = NO;
            _secBtn.selected = YES;
            _courentBtn = _secBtn;
            _thirdBtn.selected = NO;
            _fourthBtn.selected = NO;
            _fiveBtn.selected = NO;
            _sixdBtn.selected = NO;
            _moneyTF.text = @"";
            _firstBtn.backgroundColor = [UIColor whiteColor];
            _secBtn.backgroundColor = COLOR_MainColor;
            _thirdBtn.backgroundColor = [UIColor whiteColor];
            _fourthBtn.backgroundColor = [UIColor whiteColor];
            _fiveBtn.backgroundColor = [UIColor whiteColor];
            _sixdBtn.backgroundColor = [UIColor whiteColor];

            break;
        case 2:
            [_moneyTF resignFirstResponder];
            _firstBtn.selected = NO;
            _secBtn.selected = NO;
            _thirdBtn.selected = YES;
            _fourthBtn.selected = NO;
            _fiveBtn.selected = NO;
            _sixdBtn.selected = NO;
            _courentBtn = _thirdBtn;
            _firstBtn.backgroundColor = [UIColor whiteColor];
            _secBtn.backgroundColor = [UIColor whiteColor];
            _thirdBtn.backgroundColor = COLOR_MainColor;
            _fourthBtn.backgroundColor = [UIColor whiteColor];
            _fiveBtn.backgroundColor = [UIColor whiteColor];
            _sixdBtn.backgroundColor = [UIColor whiteColor];
            _moneyTF.text = @"";
            break;
        case 3:
            _firstBtn.selected = NO;
            _secBtn.selected = NO;
            _thirdBtn.selected = NO;
            _fourthBtn.selected = NO;
            _fiveBtn.selected = NO;
            _sixdBtn.selected = NO;
            _moneyTF.text = @"";
            break;
        case 4:
        {
            NSString *money;
            switch (_courentBtn.tag) {
                case 0:
                    money = @"1000";
                    break;
                case 1:
                    money = @"1000";
                    break;
                case 2:
                    money = @"2000";
                    break;
                case 6:
                    money = @"100";
                    break;
                case 7:
                    money = @"200";
                    break;
                case 8:
                    money = @"500";
                    break;
                default:
                    break;
            }
            if (!readBtn.selected) {
                [SVProgressHUD showErrorWithStatus:@"请先阅读并同意镖王的《充值说明》"];
                return;
            }
#pragma mark- 微信充值
            //判断是否有权限充值
            if (_ifAvalid) {
                NSLog(@"可以冲---");
                
                [SVProgressHUD show];
                if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
                    [SVProgressHUD dismiss];
                    [SVProgressHUD showInfoWithStatus:@"您没有安装微信客户端"];
                    return;
                }
                //判断是否从预支付的界面跳转过来
                if (self.model) {
                    [SVProgressHUD show];
                    NSString * payType = @"5";
                    NSString * newBillcode = [NSString stringWithFormat:@"%@D%@",self.model.billCode,[UserManager getDefaultUser].userId];
                    NSString *URLStr = [NSString stringWithFormat:@"%@logistics/task/pay/wechat/pre?billCode=%@&price=%@&type=%@",BaseUrl,newBillcode,money,payType];
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notice) name:WECHAT_BACK_WL object:nil];
                    [ExpressRequest sendWithParameters:nil MethodStr:URLStr
                                               reqType:k_GET
                                               success:^(id object) {
                                                   NSDictionary *preDic = [object objectForKey:ARG_DATA][0];
                                                   [SVProgressHUD dismiss];
                                                   
                                                   PayReq* req = [[PayReq alloc] init];
                                                   req.partnerId           = [preDic valueForKey:@"partnerId"];
                                                   req.prepayId            = [preDic valueForKey:@"prepayid"];
                                                   req.nonceStr            = [preDic valueForKey:@"nonceStr"];
                                                   req.timeStamp           = [[preDic valueForKey:@"timestamp"] intValue];
                                                   req.package             = [preDic valueForKey:@"package_"];
                                                   req.sign                = [preDic valueForKey:@"sign"];
                                                   [WXApi sendReq:req];
                                                   WXPayManager *wxManager = [WXPayManager shareManager];
                                                   wxManager.billCode = newBillcode;
                                                   
                                               }
                                                failed:^(NSString *error) {
                                                    [SVProgressHUD showErrorWithStatus:error];
                                                }];
                    
                }else{
                
                [RequestManager getRechargePreUserId:[UserManager getDefaultUser].userId rechargeMoney:money recommandMobile:@" " success:^(NSDictionary *result) {
                    [SVProgressHUD dismiss];
                    PayReq* req             = [[PayReq alloc] init];
                    req.partnerId           = [result valueForKey:@"partnerId"];
                    req.prepayId            = [result valueForKey:@"prepayid"];
                    req.nonceStr            = [result valueForKey:@"nonceStr"];
                    req.timeStamp           = [[result valueForKey:@"timestamp"] intValue];
                    req.package             = [result valueForKey:@"package_"];
                    req.sign                = [result valueForKey:@"sign"];
                    [WXApi sendReq:req];
                    WXPayManager *manager = [WXPayManager shareManager];
                    manager.billCode = [result valueForKey:@"billCode"];
                    [self requestRechargechange];
                    
                } Failed:^(NSString *error) {
                    [SVProgressHUD showErrorWithStatus:error];
                }];
              }
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:@"您今日已经没有充值机会"];
            }
        }
            break;
        case 5:{
            NSString *money;
            switch (_courentBtn.tag) {
                case 0:
                    money = @"1000";
                    break;
                case 1:
                    money = @"1000";
                    break;
                case 2:
                    money = @"2000";
                    break;
                case 6:
                    money = @"100";
                    break;
                case 7:
                    money = @"200";
                    break;
                case 8:
                    money = @"500";
                    break;
                default:
                    break;
            }
            NSLog(@"========%@============",money);
            if (!readBtn.selected) {
                [SVProgressHUD showErrorWithStatus:@"请先阅读并同意镖王的《充值说明》"];
                return;
            }
#pragma mark- 支付宝充值
            
            if (_ifAvalid)
            {
                //判断是否从报价界面传过来
                if (self.model) {
                     [SVProgressHUD show];
                    NSString *newBillCode = [NSString stringWithFormat:@"%@D%@",self.model.billCode,[UserManager getDefaultUser].userId];
                    [AlipayRequestConfig alipayWithPartner:kPartnerID seller:kSellerAccount tradeNO:newBillCode productName:@"镖王" productDescription:@"(物流)平台使用费" amount:money notifyURL:kNotifyURL itBPay:@"30m" standbyCallback:^(NSDictionary *resultDic) {
                        [SVProgressHUD dismiss];
                        if ([[resultDic objectForKey:@"resultStatus"] integerValue]==9000) {
                            NSLog(@"支付宝充值成功");
                            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"恭喜您支付成功%@元！",self.model.playMoneyMax]];
                            [self checkResultWithBillCode:newBillCode];
                        }
                        else {
                            NSLog(@"%@",resultDic);
                            [SVProgressHUD showErrorWithStatus:[resultDic objectForKey:@"memo"] ];
                        }
                    }];
                }else{
                [SVProgressHUD show];
                [AlipayRequestConfig alipayWithPartner:kPartnerID seller:kSellerAccount tradeNO:[self creatTradeNO] productName:@"镖王" productDescription:@"镖王充值" amount:money notifyURL:kNotifyURL itBPay:@"30m" standbyCallback:^(NSDictionary *resultDic)
                 {
                     [SVProgressHUD dismiss];
                     
                     if ([[resultDic objectForKey:@"resultStatus"] integerValue]==9000) {
                         NSLog(@"支付宝充值成功");
                         [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"恭喜您成功充值%@元！",money] ];
                         [[NSNotificationCenter defaultCenter] postNotificationName:TRANSFERMONEY object:nil];
                         [self.navigationController popViewControllerAnimated:YES];
                         [self requestRechargechange];
                     }
                     else {
                         [SVProgressHUD showErrorWithStatus:@"支付失败" ];
                     }
                 }];
                }
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:@"您今日已经没有充值机会"];
            }
        }
        break;
        case 6:
            [_moneyTF resignFirstResponder];
            _firstBtn.selected = NO;
            _secBtn.selected = NO;
            _courentBtn = _fourthBtn;
            _thirdBtn.selected = NO;
            _fourthBtn.selected = YES;
            _fiveBtn.selected = NO;
            _sixdBtn.selected = NO;
            _firstBtn.backgroundColor = [UIColor whiteColor];
            _secBtn.backgroundColor = [UIColor whiteColor];
            _thirdBtn.backgroundColor = [UIColor whiteColor];
            _fourthBtn.backgroundColor = COLOR_MainColor;
            _fiveBtn.backgroundColor = [UIColor whiteColor];
            _sixdBtn.backgroundColor = [UIColor whiteColor];

            _moneyTF.text = @"";
            break;
        case 7:
            [_moneyTF resignFirstResponder];
            _firstBtn.selected = NO;
            _secBtn.selected = NO;
            _courentBtn = _fiveBtn;
            _thirdBtn.selected = NO;
            _fourthBtn.selected = NO;
            _fiveBtn.selected = YES;
            _sixdBtn.selected = NO;
            _moneyTF.text = @"";
            _firstBtn.backgroundColor = [UIColor whiteColor];
            _secBtn.backgroundColor = [UIColor whiteColor];
            _thirdBtn.backgroundColor = [UIColor whiteColor];
            _fourthBtn.backgroundColor = [UIColor whiteColor];
            _fiveBtn.backgroundColor = COLOR_MainColor;
            _sixdBtn.backgroundColor = [UIColor whiteColor];
            
            break;
        case 8:
            [_moneyTF resignFirstResponder];
            _firstBtn.selected = NO;
            _secBtn.selected = NO;
            _courentBtn = _sixdBtn;
            _thirdBtn.selected = NO;
            _fourthBtn.selected = NO;
            _fiveBtn.selected = NO;
            _sixdBtn.selected = YES;
            _firstBtn.backgroundColor = [UIColor whiteColor];
            _secBtn.backgroundColor = [UIColor whiteColor];
            _thirdBtn.backgroundColor = [UIColor whiteColor];
            _fourthBtn.backgroundColor = [UIColor whiteColor];
            _fiveBtn.backgroundColor = [UIColor whiteColor];
            _sixdBtn.backgroundColor = COLOR_MainColor;
            _moneyTF.text = @"";
            break;
        default:
            break;
    }
}
- (void)setNav{
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backToPresentVC)];
    self.navigationItem.leftBarButtonItem  =leftItem;
}
-(void)backToPresentVC{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mork -- textFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    _firstBtn.selected = NO;
    _courentBtn.selected = NO;
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if ([_moneyTF.text isEqualToString:@""]) {
        _fourthBtn.selected = YES;
        _courentBtn = _fourthBtn;
        _secBtn.selected = NO;
        _thirdBtn.selected = NO;
    }
    
    return YES;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_moneyTF resignFirstResponder];
    
    [_mobile resignFirstResponder];
//  [self.view endEditing:YES];
    
}
-(NSString *)creatTradeNO{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    NSString *result = [NSString stringWithFormat:@"%@%@%@",[UserManager getDefaultUser].userId,@"CZ",strDate];
    NSLog(@"————————%@",result);
    return result;
}

- (void)configNavgationBar {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 60)];
    label.textColor = [UIColor whiteColor];
    label.text = @"充值";
    label.textAlignment = 1;
    self.navigationItem.titleView = label;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(backToMenuView)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(explain) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 100, 30);
    [button setTitle:@"充值说明" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = menuButton;
}
//充值说明
-(void)explain{
    InforWebViewController * webVC =[[InforWebViewController alloc]init];
    webVC.info_type = INFO_RECHARGE_RULE;
    [self.navigationController pushViewController:webVC animated:YES];
   
}

- (void)backToMenuView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)checkResultWithBillCode:(NSString *)billCode{
    [RequestManager getPayResultWithBillCode:billCode success:^(NSDictionary *result) {
        NSLog(@"%@",result);
        [self notice];
    } Failed:^(NSString *error) {
        [PXAlertView showAlertWithTitle:error];
    }];
}

- (void)notice{
    NSDictionary *dic = @{CLASS_NAME:@"FindGoodsViewController"};
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:GOTOVC object:dic];
}
@end
