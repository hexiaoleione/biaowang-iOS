//
//  MMZCViewController.m
//  MMR
//
//  Created by qianfeng on 15/6/30.
//  Copyright © 2015年 MaskMan. All rights reserved.
//

#import "MMZCViewController.h"
#import "forgetPassWardViewController.h"
#import "AppDelegate.h"
#import "MMZCHMViewController.h"
#import "RequestManager.h"
#import "SVProgressHUD.h"
#import "MainHeader.h"
#import "AFNetworking.h"
#import "PXAlertView.h"
#define RATIO   WINDOW_HEIGHT/736.0
#define RATIO_W WINDOW_WIDTH/414.0

@interface MMZCViewController ()
{
    UIImageView *View;
    UIView *bgView;
    UITextField *pwd;
    UITextField *user;
    UIButton *QQBtn;
    UIButton *weixinBtn;
    UIButton *xinlangBtn;
    
    NSString *_openId;
    NSString *_accessToken;
    
    UIImageView * _logoImgView;
    
}
@property(copy,nonatomic) NSString * accountNumber;
@property(copy,nonatomic) NSString * mmmm;
@property(copy,nonatomic) NSString * user;


@end

@implementation MMZCViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.view.backgroundColor=[UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
    //设置NavigationBar背景颜色
    View=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    //View.backgroundColor=[UIColor redColor];
    View.image=[UIImage imageNamed:@"beijingLmg"];
    [self.view addSubview:View];

    //为了显示背景图片自定义navgationbar上面的三个按钮
    UIButton *but =[[UIButton alloc]initWithFrame:CGRectMake(25*RATIO, 50 *RATIO, 35, 35)];
    [but setImage:[UIImage imageNamed:@"goback_back_orange_on"] forState:UIControlStateNormal];
    [but addTarget:self action:@selector(clickaddBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:but];
    
//    UILabel *lanel=[[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width-30)/2, 30, 50, 30)];
////    lanel.text=@"登录";
//    lanel.textColor=[UIColor colorWithRed:248/255.0f green:144/255.0f blue:34/255.0f alpha:1];
//    [self.view addSubview:lanel];
    
//    _logoImgView = [[UIImageView alloc]init];
//    _logoImgView.sd_layout
//    .heightIs(64*RATIO_W)
//    .widthIs(64*RATIO_W)
//    .xIs(SCREEN_WIDTH/2);
//    _logoImgView.image = [UIImage imageNamed:@"biaowangLmg"];
//    [self.view addSubview:_logoImgView];
    
    [self createButtons];
    [self createImageViews];
    [self createTextFields];
    
    [self createLabel];
}

- (void)dismiss{
    if (![self.navigationController popToRootViewControllerAnimated:YES]) {
        [self dismissViewControllerAnimated:YES completion:nil];
        self.view.backgroundColor=[UIColor whiteColor];
    }
}

- (void)login{
    [SVProgressHUD show];
    [RequestManager loginWithMobile:user.text Password:pwd.text deviceId:nil success:^(NSString *reslut) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ISLOGIN object:nil];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:User_HEAD_URL];
        [self dismissViewControllerAnimated:YES completion:nil];
        [SVProgressHUD showSuccessWithStatus:reslut];
    } Failed:^(NSString *error) {
        int errCode = [[[NSUserDefaults standardUserDefaults] valueForKey:@"logAuthCode"] intValue];
        if (errCode == -5) {
            [SVProgressHUD dismiss];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"logAuthCode"];
            //多设备登陆
            HHAlertView *alert = [[HHAlertView alloc]initWithTitle:@"温馨提示" detailText:error cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"]];
            [alert showWithBlock:^(NSInteger index) {
                if (index != 0) {
                    MMZCHMViewController *zzVC = [[MMZCHMViewController alloc]init];
                    zzVC.type = 1;
                    zzVC.phoneNumber = user.text;
                    [self.navigationController pushViewController:zzVC animated:YES];
                }
            }];
        }else{
            [SVProgressHUD showErrorWithStatus:error];
        }
        
    }];

}
- (void)loginSuccess{
    
}
#pragma mark --leftbarbottonitem
-(void)clickaddBtn:(UIButton *)button
{
    if (![self.navigationController popToRootViewControllerAnimated:YES]) {
         [self dismissViewControllerAnimated:YES completion:nil];
        self.view.backgroundColor=[UIColor whiteColor];
    }
}


-(void)createLabel
{
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width-100)/2, 480 *RATIO, 100, 21)];
    label.text=@"第 三 方 登 录";
    label.textColor=[UIColor blackColor];
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont systemFontOfSize:13];
    [self.view addSubview:label];
    if ((![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]])&&(![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]])) {
        label.hidden = YES;
    }
    
}

-(void)createTextFields
{

    UIView *userView = [[UIView alloc]initWithFrame:CGRectMake(30,270 *RATIO, WINDOW_WIDTH - 60, 100 *RATIO)];
//    userView.backgroundColor  = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:0.8];
    userView.backgroundColor = [UIColor whiteColor];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 50 *RATIO, WINDOW_WIDTH - 60, 1 *RATIO)];
    line.backgroundColor = [UIColor lightGrayColor];
    userView.layer.cornerRadius = 5;
    user=[self createTextFielfFrame:CGRectMake(40, 0, WINDOW_WIDTH - 100, 50 *RATIO) font:[UIFont systemFontOfSize:16] placeholder:@"请输入您的手机号码"];
//    [user setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    UIImageView *userImageView=[self createImageViewFrame:CGRectMake(5 *RATIO_W, 10 *RATIO, 30*RATIO_W, 30*RATIO) imageName:@"ic_landing_nickname" color:nil];
    userImageView.centerY = user.centerY;
    user.keyboardType=UIKeyboardTypeNumberPad;
    user.clearButtonMode = UITextFieldViewModeWhileEditing;
    [userView addSubview:user];
    
    pwd=[self createTextFielfFrame:CGRectMake(40, 51 *RATIO, WINDOW_WIDTH - 100, 50 *RATIO) font:[UIFont systemFontOfSize:16]  placeholder:@"密码" ];
    UIImageView *pwdImageView=[self createImageViewFrame:CGRectMake(5 *RATIO_W, 63 *RATIO, 30*RATIO_W, 30*RATIO) imageName:@"mm_normal" color:nil];
    pwdImageView.centerY = pwd.centerY;
//    pwd.backgroundColor = [UIColor whiteColor];
    pwd.clearButtonMode = UITextFieldViewModeWhileEditing;
//    [pwd setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    //pwd.text=@"123456";
    //密文样式
    pwd.secureTextEntry=YES;
    //pwd.keyboardType=UIKeyboardTypeNumberPad;
    [userView addSubview:pwd];
    [userView addSubview:line];
    [userView addSubview:userImageView];
    [userView addSubview:pwdImageView];
    
    
    
//    UIImageView *line1=[self createImageViewFrame:CGRectMake(20, 50, bgView.frame.size.width-40, 1) imageName:nil color:[UIColor colorWithRed:180/255.0f green:180/255.0f blue:180/255.0f alpha:.3]];
    
    [self.view addSubview:userView];
//    [self.view addSubview:pwdView];
}


-(void)touchesEnded:(nonnull NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    [user resignFirstResponder];
    [pwd resignFirstResponder];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [user resignFirstResponder];
    [pwd resignFirstResponder];
}

-(void)createImageViews
{
    //两根线    三方登录旁边
    UIImageView *line3=[self createImageViewFrame:CGRectMake(2, 490 *RATIO, (WINDOW_WIDTH - 100 )*0.5, 1) imageName:nil color:[UIColor whiteColor]];
    UIImageView *line4=[self createImageViewFrame:CGRectMake(WINDOW_WIDTH - (WINDOW_WIDTH - 100 )*0.5, 490 *RATIO, (WINDOW_WIDTH - 100 )*0.5, 1) imageName:nil color:[UIColor whiteColor]];
    
    //    [bgView addSubview:userImageView];
    //    [bgView addSubview:pwdImageView];
    //    [bgView addSubview:line1];
    //[self.view addSubview:line2];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
        [self.view addSubview:line3];
        [self.view addSubview:line4];
    }
}

//270   100 380  225
-(void)createButtons
{
    UIButton *landBtn=[self createButtonFrame:CGRectMake(30, 380 *RATIO, self.view.frame.size.width-60, 50*RATIO) backImageName:nil title:@"登   录" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:17] target:self action:@selector(landClick)];
//    landBtn.backgroundColor=[UIColor colorWithRed:115/255.0f green:140/255.0f blue:255/255.0f alpha:1];
    landBtn.backgroundColor = COLOR_ORANGE_DEFOUT;
    landBtn.layer.cornerRadius=5.0f;
    
    UIButton *newUserBtn=[self createButtonFrame:CGRectMake(30, 440 *RATIO, 70, 30) backImageName:nil title:@"快速注册" titleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] target:self action:@selector(registration:)];
    
    UIButton *forgotPwdBtn=[self createButtonFrame:CGRectMake(self.view.frame.size.width-90, 440 *RATIO, 60, 30) backImageName:nil title:@"找回密码" titleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] target:self action:@selector(fogetPwd:)];
//    forgotPwdBtn.centerX = SCREEN_WIDTH/2;
    
      #define Start_X 60.0f           // 第一个按钮的X坐标
      #define Start_Y 440.0f           // 第一个按钮的Y坐标
      #define Width_Space 50.0f        // 2个按钮之间的横间距
      #define Height_Space 20.0f      // 竖间距
      #define Button_Height 50.0f    // 高
      #define Button_Width 50.0f      // 宽

    float margin = 0.0f;
    margin = (WINDOW_WIDTH - 150) /4;
    
    float y = 510.0;
    //微信
    weixinBtn=[[UIButton alloc]initWithFrame:CGRectMake(margin*2+50, y * RATIO, 50, 50)];
    //weixinBtn.tag = UMSocialSnsTypeWechatSession;
    weixinBtn.layer.cornerRadius=25;
    weixinBtn=[self createButtonFrame:weixinBtn.frame backImageName:@"weixinLmg-" title:nil titleColor:nil font:nil target:self action:@selector(onClickWX:)];
    
    //qq
    QQBtn=[[UIButton alloc]initWithFrame:CGRectMake(margin, y *RATIO, 50, 50)];
    QQBtn.layer.cornerRadius=25;
    QQBtn=[self createButtonFrame:QQBtn.frame backImageName:@"ic_landing_qq" title:nil titleColor:nil font:nil target:self action:@selector(onClickQQ:)];
    
    //新浪微博  faceBook
    xinlangBtn=[[UIButton alloc]initWithFrame:CGRectMake(margin*3+100, y *RATIO, 50, 50)];
    xinlangBtn.layer.cornerRadius=25;
    xinlangBtn=[self createButtonFrame:xinlangBtn.frame backImageName:@"facebook" title:nil titleColor:nil font:nil target:self action:@selector(onClickSina:)];
    
        //没有安装QQ则重新布局
        margin = (WINDOW_WIDTH -100)/3;
        weixinBtn.frame = CGRectMake(margin, y * RATIO, 50, 50);
        xinlangBtn.frame = CGRectMake(margin*2+50, y * RATIO, 50, 50);
//    }
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
        [self.view addSubview:weixinBtn];
        [self.view addSubview:xinlangBtn];
    }
    
    [self.view addSubview:landBtn];
    [self.view addSubview:newUserBtn];
    [self.view addSubview:forgotPwdBtn];

}
-(void)onClickSina:(UIButton *)button{
    
}

- (void)onClickQQ:(UIButton *)button
{
    [OpenShare QQAuth:@"get_user_info" Success:^(NSDictionary *message) {
        [SVProgressHUD show];
        NSLog(@"QQ登陆成功:%@",message);
        NSString *acc_token = message[@"access_token"];
        _accessToken = acc_token;
        NSString *openId = message[@"openid"];
        NSString *url = [NSString stringWithFormat:@"https://graph.qq.com/user/get_user_info?access_token=%@&oauth_consumer_key=%@_ID&openid=%@",acc_token,QQAPPID,openId];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer =[AFHTTPResponseSerializer serializer];
        [manager GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                NSDictionary *temDic = @{@"openid":message[@"openid"] ? message[@"openid"] :@"",@"nikename":dic[@"nikename"]?dic[@"nikename"]:@"",@"headimgurl":dic[@"figureurl_qq_1"]?dic[@"figureurl_qq_1"]:@""};
                [self thirdLogin:temDic];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"获取个人信息失败:%@",error);
        }];
        
    } Fail:^(NSDictionary *message, NSError *error) {
        NSLog(@"QQ登录失败%@",message);
    }];

}

- (void)onClickWX:(UIButton *)button
{
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


//- (void)onClickSina:(UIButton *)button
//{
//    [OpenShare WeiboAuth:@"all" redirectURI:@"http://openshare.gfzj.us/" Success:^(NSDictionary *message) {
//        NSLog(@"微博登录成功:\n%@",message);
//    } Fail:^(NSDictionary *message, NSError *error) {
//        NSLog(@"微博登录失败:\n%@\n%@",message,error);
//    }];
//}

                     
-(UITextField *)createTextFielfFrame:(CGRect)frame font:(UIFont *)font placeholder:(NSString *)placeholder
{
    UITextField *textField=[[UITextField alloc]initWithFrame:frame];
    
    textField.font=font;
    
    textField.textColor=[UIColor blackColor];
    
    textField.borderStyle=UITextBorderStyleNone;
    
    textField.placeholder=placeholder;
    
    return textField;
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

-(UIButton *)createButtonFrame:(CGRect)frame backImageName:(NSString *)imageName title:(NSString *)title titleColor:(UIColor *)color font:(UIFont *)font target:(id)target action:(SEL)action
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=frame;
    if (imageName)
    {
        [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    } 
    
    if (font)
    {
        btn.titleLabel.font=font;
    }
    
    if (title)
    {
        [btn setTitle:title forState:UIControlStateNormal];
    }
    if (color)
    {
        [btn setTitleColor:color forState:UIControlStateNormal];
    }
    if (target&&action)
    {
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return btn;
}

//登录
-(void)landClick
{
    if ([user.text isEqualToString:@""])
    {
        [SVProgressHUD showInfoWithStatus:@"亲,请输入用户名"];
        return;
    }
    else if (user.text.length !=11)
    {
        [SVProgressHUD showInfoWithStatus:@"您输入的手机号码格式不正确"];
        return;
    }
    else if ([pwd.text isEqualToString:@""])
    {
        [SVProgressHUD showInfoWithStatus:@"亲,请输入密码"];
        return;
    }
    else if (pwd.text.length <6)
    {
        [SVProgressHUD showInfoWithStatus:@"亲,密码长度至少六位"];
        return;
    }
    [self login];
}

//注册
-(void)zhuce
{
    [self.navigationController pushViewController:[[MMZCHMViewController alloc]init] animated:YES];
}

-(void)registration:(UIButton *)button
{
   [self ifAllowLocation];
//   [self.navigationController pushViewController:[[MMZCHMViewController alloc]init] animated:YES];
}

-(void)fogetPwd:(UIButton *)button
{
   [self.navigationController pushViewController:[[forgetPassWardViewController alloc]init] animated:YES];
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
        [self.navigationController pushViewController:[[MMZCHMViewController alloc]init] animated:YES];
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

#pragma mark - 工具
//手机号格式化
-(NSString*)getHiddenStringWithPhoneNumber:(NSString*)number middle:(NSInteger)countHiiden{
    // if (number.length>6) {
    
    if (number.length<countHiiden) {
        return number;
    }
    NSInteger count=countHiiden;
    NSInteger leftCount=number.length/2-count/2;
    NSString *xings=@"";
    for (int i=0; i<count; i++) {
        xings=[NSString stringWithFormat:@"%@%@",xings,@"*"];
    }
    
    NSString *chuLi=[number stringByReplacingCharactersInRange:NSMakeRange(leftCount, count) withString:xings];
    // chuLi=[chuLi stringByReplacingCharactersInRange:NSMakeRange(number.length-count, count-leftCount) withString:xings];
    
    return chuLi;
}

//手机号格式化后还原
-(NSString*)getHiddenStringWithPhoneNumber1:(NSString*)number middle:(NSInteger)countHiiden{
    // if (number.length>6) {
    if (number.length<countHiiden) {
        return number;
    }
    for (int i=0; i<1; i++) {
        //xings=[NSString stringWithFormat:@"%@",[CheckTools getUser]];
    }
    
    NSString *chuLi=[number stringByReplacingCharactersInRange:NSMakeRange(0, 0) withString:@""];
    // chuLi=[chuLi stringByReplacingCharactersInRange:NSMakeRange(number.length-count, count-leftCount) withString:xings];
    
    return chuLi;
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
    [SVProgressHUD show];
    [RequestManager thirdLoginWithOpenId:dic[@"openid"] accessToken:_accessToken? _accessToken:@""nickName:dic[@"nickname"]? dic[@"nickname"]:@"" sex:dic[@"sex"] ? dic[@"sex"] : @"" headImageUrl:dic[@"headimgurl"] unionId:dic[@"unionid"]? dic[@"unionid"]:@"" success:^(id result) {
        //保存头像地址
        NSString *str = [NSString stringWithFormat:@"%@",dic[@"headimgurl"]];
        //            [PXAlertView showAlertWithTitle:nil message:str];
        
        [[NSUserDefaults standardUserDefaults] setValue:str forKey:User_HEAD_URL];
         [[NSUserDefaults standardUserDefaults] synchronize];

        NSNumber *errNumber = [result objectForKey:@"errCode"];
        NSInteger errcode = [errNumber integerValue];
        NSString *message =[result valueForKey:@"message"];
        NSString *mobile = nil;
        if ([result objectForKey:@"data"]) {
            NSDictionary *dataDic = [result objectForKey:@"data"][0];
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
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
