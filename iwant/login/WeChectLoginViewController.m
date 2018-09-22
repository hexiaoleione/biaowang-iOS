//
//  WeChectLoginViewController.m
//  iwant
//
//  Created by dongba on 16/9/21.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "WeChectLoginViewController.h"
#import "SDCycleScrollView.h"
#import "MMZCViewController.h"
#import "MMZCHMViewController.h"
#define RATIO WINDOW_HEIGHT/736.0
CGFloat centerY = 0;
@interface WeChectLoginViewController ()<SDCycleScrollViewDelegate>{
    NSString  *_openId;
    NSString *_accessToken;
}

@end

@implementation WeChectLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setSubViews];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    self.navigationController.navigationBarHidden = YES;
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)setSubViews{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setTitle:@"< 返回" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15*RATIO, 50 *RATIO, 100, 30);
    [backBtn sizeToFit];
    [self.view addSubview:backBtn];

    UIButton *pwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [pwdBtn setTitle:@"手机号登录 >" forState:UIControlStateNormal];
    [pwdBtn addTarget:self action:@selector(pwdLogin) forControlEvents:UIControlEventTouchUpInside];
    [pwdBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    pwdBtn.frame = CGRectMake(25*RATIO, 50 *RATIO, 100, 30);
    [pwdBtn sizeToFit];
    pwdBtn.right = WINDOW_WIDTH - 15*RATIO;
    pwdBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:pwdBtn];
    
    
    NSArray *imagesURLStrings = @[
                                  @"http://www.efamax.com/images/lunbo_0.jpg",
                                  @"http://www.efamax.com/images/lunbo_1.jpg",
                                  @"http://www.efamax.com/images/lunbo_2.jpg"
                                  ];
    CGFloat y = 64+60*RATIO_HEIGHT;
    if (WINDOW_WIDTH == 320) {
        y = 64+50*RATIO_HEIGHT;
    }
    if (WINDOW_HEIGHT == 480) {
        y = 64 + 10;
    }
    
    // 网络加载 --- 创建自定义图片的pageControlDot的图片轮播器
    SDCycleScrollView *cycleScrollView3 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(10, y, WINDOW_WIDTH - 20, (WINDOW_WIDTH - 20)*380/700) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    cycleScrollView3.pageControlBottomOffset = - 10;
    cycleScrollView3.currentPageDotImage = [UIImage imageNamed:@"pageControlCurrentDot"];
    cycleScrollView3.pageDotImage = [UIImage imageNamed:@"pageControlDot"];
    cycleScrollView3.imageURLStringsGroup = imagesURLStrings;
    
    [self.view addSubview:cycleScrollView3];
    
    
//    UIImageView *imagev = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"share_wechat"]];
//    imagev.frame = CGRectMake(0, 0, 60 , 60);
//    imagev.y = cycleScrollView3.bottom + 100;
//    imagev.centerX = self.view.centerX;
//    [self.view addSubview:imagev];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:@"weixin_clear"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(weixinLogin) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, 0, 150 , 150);
    btn.y = cycleScrollView3.bottom + 100;
    if (WINDOW_HEIGHT == 480) {
         btn.y = cycleScrollView3.bottom + 50;
    }
    btn.centerX = self.view.centerX;
    [self.view addSubview:btn];
    
    UIButton *realBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    realBtn.frame = btn.frame;
    [realBtn addTarget:self action:@selector(weixinLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:realBtn];
    
    UILabel *label = [UILabel new];
    label.text = @"微信体验，一键登录";
    label.font = [UIFont systemFontOfSize:25];
    [label sizeToFit];
    label.centerX = self.view.centerX;
    label.bottom = self.view.bottom - 100*RATIO_HEIGHT;
    [self.view addSubview:label];
    
    btn.bottom = label.top;
    centerY = btn.centerY;

    UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clearBtn.frame = label.frame;
    [clearBtn addTarget:self action:@selector(weixinLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clearBtn];
    
    [self creatAnimationWith:btn];
}

#pragma mark ---微信登录按钮动画
- (void)creatAnimationWith:(UIButton *)btn{
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:.5 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
        if (btn.tag != 1) {
            btn.tag = 1;
            btn.size = CGSizeMake(120, 120);
            btn.centerX = self.view.centerX;
            btn.centerY = centerY;
        }else{
            btn.tag = 0;
            btn.size = CGSizeMake(150, 150);
            btn.centerX = self.view.centerX;
            btn.centerY = centerY;

        }
    } completion:^(BOOL finished) {
        [self creatAnimationWith:btn];
    }];

}

- (void)back{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)pwdLogin{
    MMZCViewController *vc = [[MMZCViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)weixinLogin{
    [self ifAllowLocation];
}
#pragma mark ---- 判断是否开启定位
-(void)ifAllowLocation{
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请打开[定位服务]来允许[镖王]确定您的位置，否则将影响您继续使用软件" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置" , nil];
        alertView.delegate = self;
        alertView.tag = 1;
        [alertView show];
    }else{
        //开启了定位服务的
        [OpenShare WeixinAuth:@"snsapi_userinfo" Success:^(NSDictionary *message) {
            NSLog(@"微信登录成功:\n%@",message);
            [OpenShare WeixinLoginCode:message[@"code"] Success:^(NSDictionary *message) {
                [self getUserInfoAccessToken:message[@"access_token"] OpenID:message[@"openid"]];
                _openId = message[@"openid"];
                _accessToken = message[@"access_token"];
            } Fail:^(NSDictionary *message, NSError *error) {
                NSLog(@"获取token失败:%@",error);
            }];
        } Fail:^(NSDictionary *message, NSError *error) {
            NSLog(@"微信登录失败:\n%@\n%@",message,error);
        }];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1) {
        if (buttonIndex == 1) {
            //跳转到定位权限页面
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if( [[UIApplication sharedApplication]canOpenURL:url] ) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }else{
            //取消了 没开启
        }
    }
}

- (void)getUserInfoAccessToken:(NSString *)token OpenID:(NSString *)openId{
    [SVProgressHUD show];
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",token,openId];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"获取个人信息:%@",dic);
        [self thirdLogin :dic];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"获取个人信息失败:%@",error);
    }];
    
}

- (void)thirdLogin:(NSDictionary *)dic{
    [RequestManager thirdLoginWithOpenId:dic[@"openid"]
                             accessToken:_accessToken
                                nickName:dic[@"nickname"]
                                     sex:dic[@"sex"]
                            headImageUrl:dic[@"headimgurl"]
                                 unionId:dic[@"unionid"] success:^(id object) {
                                     NSNumber *errNumber = [object objectForKey:@"errCode"];
                                     NSInteger errcode = [errNumber integerValue];
                                     NSString *message =[object valueForKey:@"message"];
                                     NSString *mobile = nil;
                                     if ([object objectForKey:@"data"]) {
                                         NSDictionary *dataDic = [object objectForKey:@"data"][0];
                                         mobile = [NSString stringWithFormat:@"%@",[dataDic valueForKey:@"mobile"]];
                                     }
                                     //        [PXAlertView showAlertWithTitle:nil message:[NSString stringWithFormat:@"%d",result]];
                                     //        [SVProgressHUD showSuccessWithStatus:@"登陆成功!"];
                                     //        [[NSNotificationCenter defaultCenter] postNotificationName:ISLOGIN object:nil];
                                     //        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                                     if (errcode == 0) {
                                         [[NSNotificationCenter defaultCenter] postNotificationName:ISLOGIN object:nil];
                                         [self dismissViewControllerAnimated:YES completion:nil];
                                         [SVProgressHUD showSuccessWithStatus:@"登录成功"];
                                     }else if (errcode == -1){
                                         [SVProgressHUD showSuccessWithStatus:@"登录失败"];
                                     }else if (errcode == -2){
                                         [SVProgressHUD showSuccessWithStatus:@"登录异常"];
                                     }
                                     else if (errcode == -3)
                                     {
                                         [SVProgressHUD dismiss];
                                         //            @"请您先绑定手机号"
                                         HHAlertView *alert = [[HHAlertView alloc]initWithTitle:@"温馨提示" detailText:message cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"]];
                                         [alert showWithBlock:^(NSInteger index) {
                                             if (index != 0) {
                                                 MMZCHMViewController *zcVC = [[MMZCHMViewController alloc]init];
                                                 zcVC.type = 2;
                                                 zcVC.dic = dic;
                                                 zcVC.acctoken = _accessToken;
                                                 [self.navigationController pushViewController:zcVC animated:YES];
                                             }
                                         }];
                                     }
                                     //        @"您的账号已经在其他设备登陆，请先验证手机号"
                                     else if (errcode == -5)
                                     {
                                         [SVProgressHUD dismiss];
                                         HHAlertView *alert = [[HHAlertView alloc]initWithTitle:@"温馨提示" detailText:message cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"]];
                                         [alert showWithBlock:^(NSInteger index) {
                                             if (index != 0) {
                                                 MMZCHMViewController *zcVC = [[MMZCHMViewController alloc]init];
                                                 zcVC.type = 1;
                                                 zcVC.dic = dic;
                                                 zcVC.isThird = YES;
                                                 zcVC.phoneNumber = mobile;
                                                 zcVC.acctoken = _accessToken;
                                                 [self.navigationController pushViewController:zcVC animated:YES];
                                             }
                                         }];
                                     }
                                     
                                     
                                     
                                     
                                 } Failed:^(NSString *error) {
                                     [SVProgressHUD showErrorWithStatus:error];
                                 }];}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    
}

@end
