//
//  MMZCHMViewController.m
//  MMR
//
//  Created by qianfeng on 15/6/30.
//  Copyright © 2015年 MaskMan. All rights reserved.
//

#import "MMZCHMViewController.h"
#import "settingPassWardViewController.h"
#import "MMZCViewController.h"
#import "MainHeader.h"
#import "RoleExplainVC.h"


@interface MMZCHMViewController ()<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    UIView *bgView;
    UITextField *phone;
    UITextField *otherPhone;
    UITextField *code;
    UINavigationBar *customNavigationBar;
    UIButton *yzButton;
    
    BMKLocationService * _locService;
    BMKGeoCodeSearch *  _geocodesearch;//地理检索
    BMKReverseGeoCodeOption *_reverseGeocodeSearchOption;//反地理检索
    NSString *  _citycode;
}
//验证码
@property(nonatomic, copy) NSString *oUserPhoneNum;
@property(assign, nonatomic) NSInteger timeCount;
@property(strong, nonatomic) NSTimer *timer;
@property(copy, nonatomic) NSString *smsId;
@end

@implementation MMZCHMViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initLocation];
}
-(void)initLocation{
    _locService = [[BMKLocationService alloc]init];
    _locService.distanceFilter = 100.0f;
    _locService.delegate = self;
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    _geocodesearch.delegate = self;
    [_locService startUserLocationService];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _locService.delegate = nil;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    
    if (_type == 1) {
        self.title = @"手机号验证";
    }
    else if (_type == 2){
        self.title = @"绑定手机号";
    }
    else{
         self.title= @"注册1/2";
    }
   
    self.navigationController.navigationBarHidden = NO;
   self.navigationController.navigationBar.barTintColor = COLOR_MainColor;
   self.view.backgroundColor=[UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(clickaddBtn)];
    [addBtn setImage:[UIImage imageNamed:@"nav_back"]];
    addBtn.tintColor=[UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:addBtn];
    
    [self createTextFields];
}

-(void)clickaddBtn
{
    [self.navigationController popViewControllerAnimated:YES];
    //[self.navigationController pushViewController:[[MMZCViewController alloc]init] animated:YES];
}

-(void)createTextFields
{
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(30, 75, self.view.frame.size.width-90, 30)];
    label.text= _type == 1 ? @"" :@"请输入您的手机号码";
    label.textColor=[UIColor grayColor];
    label.textAlignment=NSTextAlignmentLeft;
    label.font=[UIFont systemFontOfSize:13];
    
    [self.view addSubview:label];

   
        CGRect frame=[UIScreen mainScreen].bounds;
        bgView=[[UIView alloc]initWithFrame:CGRectMake(10, 110-64, frame.size.width-20, 100)];
        bgView.layer.cornerRadius=3.0;
        bgView.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:bgView];
        
        phone=[self createTextFielfFrame:CGRectMake(100, 10, 200, 30) font:[UIFont systemFontOfSize:14] placeholder:@"11位手机号"];
        phone.clearButtonMode = UITextFieldViewModeWhileEditing;
        phone.keyboardType=UIKeyboardTypeNumberPad;
    
    
        code=[self createTextFielfFrame:CGRectMake(100, 60, 90, 30) font:[UIFont systemFontOfSize:14]  placeholder:@"4位数字" ];
        code.clearButtonMode = UITextFieldViewModeWhileEditing;
        //code.text=@"mojun1992225";
        //密文样式
        code.secureTextEntry=YES;
        code.keyboardType=UIKeyboardTypeNumberPad;
        
        
    UILabel *phonelabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 12, 50, 25)];
    phonelabel.text=@"手机号";
    phonelabel.textColor=[UIColor blackColor];
    phonelabel.textAlignment=NSTextAlignmentLeft;
    phonelabel.font=[UIFont systemFontOfSize:14];
    
    UILabel *codelabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 62, 50, 25)];
    codelabel.text=@"验证码";
    codelabel.textColor=[UIColor blackColor];
    codelabel.textAlignment=NSTextAlignmentLeft;
    codelabel.font=[UIFont systemFontOfSize:14];
    
    
    yzButton=[[UIButton alloc]initWithFrame:CGRectMake(bgView.frame.size.width-100-20, 62, 110, 30)];
    //yzButton.layer.cornerRadius=3.0f;
    //yzButton.backgroundColor=[UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
    [yzButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [yzButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    yzButton.titleLabel.font=[UIFont systemFontOfSize:13];
    [yzButton addTarget:self action:@selector(getValidCode:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:yzButton];
    
    UIImageView *line1=[self createImageViewFrame:CGRectMake(20, 50, bgView.frame.size.width-40, 1) imageName:nil color:[UIColor colorWithRed:180/255.0f green:180/255.0f blue:180/255.0f alpha:.3]];
    
    UIButton *landBtn=[self createButtonFrame:CGRectMake(10, bgView.frame.size.height+bgView.frame.origin.y+30,self.view.frame.size.width-20, 37) backImageName:nil title:@"下一步" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:17] target:self action:@selector(next)];
    landBtn.backgroundColor=COLOR_MainColor;
    landBtn.layer.cornerRadius=5.0f;

        
    [bgView addSubview:phone];
    [bgView addSubview:code];
        
    [bgView addSubview:phonelabel];
    [bgView addSubview:codelabel];
    [bgView addSubview:line1];
    [self.view addSubview:landBtn];
    
    
    //推荐人手机号
    UILabel *otherlabel=[[UILabel alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(bgView.frame)+10, self.view.frame.size.width-90, 30)];
    otherlabel.text= _type == 1 ? @"" :@"请输入推荐人的手机号码(可不填)";
    otherlabel.textColor=[UIColor grayColor];
    otherlabel.textAlignment=NSTextAlignmentLeft;
    otherlabel.font=[UIFont systemFontOfSize:13];
    
    [self.view addSubview:otherlabel];
    
    UIView *bgView2=[[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(otherlabel.frame)+10, frame.size.width-20, 50)];
    bgView2.layer.cornerRadius=3.0;
    bgView2.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bgView2];
    
    UILabel *otherPhonelabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 12, 100, 25)];
    otherPhonelabel.text=@"推荐人手机号";
    otherPhonelabel.textColor=[UIColor blackColor];
    otherPhonelabel.textAlignment=NSTextAlignmentLeft;
    otherPhonelabel.font=[UIFont systemFontOfSize:14];
    [bgView2 addSubview:otherPhonelabel];
    
    otherPhone=[self createTextFielfFrame:CGRectMake(120, 10, 200, 30) font:[UIFont systemFontOfSize:14] placeholder:@"11位手机号(可不填)"];
    otherPhone.clearButtonMode = UITextFieldViewModeWhileEditing;
    otherPhone.keyboardType=UIKeyboardTypeNumberPad;
    [bgView2 addSubview:otherPhone];
    
    landBtn.top = CGRectGetMaxY(bgView2.frame)+ 35;

 //如果为登录时验证手机号
    if (_type == 1) {
        phone.text= _phoneNumber;
        phone.userInteractionEnabled = NO;
        [landBtn setTitle:@"确认" forState:0];
        landBtn.top = bgView.frame.size.height+bgView.frame.origin.y+30;
        bgView2.hidden = YES;
    }
}

- (void)getValidCode:(UIButton *)sender
{
    if ([phone.text isEqualToString:@""])
    {
        return;
    }
    else if (phone.text.length !=11)
    {
        return;
    }
    if (!sender.userInteractionEnabled) {
        return;
    }
    if ([otherPhone.text isEqualToString:phone.text]) {
        [SVProgressHUD showErrorWithStatus:@"推荐人不能是自己"];
        return;
    }
    if (_type == 1) {
        NSLog(@"登陆的时候获取验证码");
        [SVProgressHUD show];
        [RequestManager loginauthMobile:phone.text success:^(NSString *reslut) {
            NSLog(@"%@",reslut);
            [SVProgressHUD dismiss];
        } Failed:^(NSString *error) {
            [yzButton setTitle:@"重新获取验证码" forState:UIControlStateNormal];
            if (_timer) {
                [_timer invalidate];
            }
            [SVProgressHUD showErrorWithStatus:error];
        }];
    }
    else if (_type == 2){
        [SVProgressHUD show];
        [RequestManager loginauthMobile:phone.text success:^(NSString *reslut) {
            NSLog(@"%@",reslut);
            [SVProgressHUD dismiss];
        } Failed:^(NSString *error) {
            [yzButton setTitle:@"重新获取验证码" forState:UIControlStateNormal];
            if (_timer) {
                [_timer invalidate];
            }
            [SVProgressHUD showErrorWithStatus:error];
        }];
    }
    else{
        [SVProgressHUD show];
        [RequestManager getSmsCodeWithMobile:phone.text Success:^(id object) {
//            _oUserPhoneNum = [NSString stringWithFormat:@"%@",object[0]];
            [SVProgressHUD dismiss];
        } Failed:^(NSString *error) {
            [yzButton setTitle:@"重新获取验证码" forState:UIControlStateNormal];
            if (_timer) {
                [_timer invalidate];
            }
            [SVProgressHUD showErrorWithStatus:error];
        }];
    }
    
        //__weak MMZCHMViewController *weakSelf = self;
    sender.userInteractionEnabled = NO;
    self.timeCount = 180;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reduceTime:) userInfo:sender repeats:YES];
    
  }

- (void)reduceTime:(NSTimer *)codeTimer {
    self.timeCount--;
    if (self.timeCount == 0) {
        [yzButton setTitle:@"重新获取验证码" forState:UIControlStateNormal];
        [yzButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        UIButton *info = codeTimer.userInfo;
        info.enabled = YES;
        yzButton.userInteractionEnabled = YES;
        [self.timer invalidate];
    } else {
        NSString *str = [NSString stringWithFormat:@"%lu秒后重新获取", self.timeCount];
        [yzButton setTitle:str forState:UIControlStateNormal];
        yzButton.userInteractionEnabled = NO;
        
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [phone resignFirstResponder];
    
}

-(UITextField *)createTextFielfFrame:(CGRect)frame font:(UIFont *)font placeholder:(NSString *)placeholder
{
    UITextField *textField=[[UITextField alloc]initWithFrame:frame];
    
    textField.font=font;
    
    textField.textColor=[UIColor grayColor];
    
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

//验证码
-(void)next
{
    
    if ([phone.text isEqualToString:@""])
    {
        [SVProgressHUD showInfoWithStatus:@"亲,请输入注册手机号码"];
        return;
    }
    else if (phone.text.length !=11)
    {
        [SVProgressHUD showInfoWithStatus:@"您输入的手机号码格式不正确"];
        return;
    }
    else if ([code.text isEqualToString:@""])
    {
        [SVProgressHUD showInfoWithStatus:@"亲,请输入验证码"];
        return;
    }
    
    if (_type == 1) {
        //多设备登陆验证
        [SVProgressHUD show];
        if (_isThird) {
            //第三方
            [RequestManager thirdCheckWithOpenId:_dic[@"openid"]?_dic[@"openid"]:@""
                                     accessToken:_acctoken ? _acctoken :@"" nickName:_dic[@"nickname"] ?_dic[@"nickname"]:@""
                                             sex:_dic[@"sex"]?_dic[@"sex"]:@""
                                    headImageUrl:_dic[@"headimgurl"] ? _dic[@"headimgurl"]:@""
                                         unionId:_dic[@"unionid"]? _dic[@"unionid"] :@""
                                          mobile:phone.text ? phone.text :@""
                                            code:code.text ?code.text:@""
                                 recommendMobile:otherPhone.text ? otherPhone.text : @""
                                        cityCode:_citycode
                                         success:^(id  result) {
            NSNumber *errNumber = [result objectForKey:@"errCode"];
            NSInteger errcode = [errNumber integerValue];
            NSString *message =[result valueForKey:@"message"];
            if (errcode != 0) {
                 [SVProgressHUD showErrorWithStatus:message];
                return ;
            }else{
                [SVProgressHUD showSuccessWithStatus:message];
                self.navigationController.navigationBarHidden = NO;
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:ISLOGIN object:nil];
            }
                                         } Failed:^(NSString *error) {
            [SVProgressHUD showErrorWithStatus:error];
            
        }];
        }else{
            //多设备手机号登陆
            [RequestManager checkloginauthMobile:phone.text code:code.text deviceId:nil success:^(NSString *reslut) {
                self.navigationController.navigationBarHidden = NO;
                [SVProgressHUD showSuccessWithStatus:@"登陆成功"];
                [self.navigationController dismissViewControllerAnimated:YES completion:nil ];
                [[NSNotificationCenter defaultCenter] postNotificationName:ISLOGIN object:nil];
            } Failed:^(NSString *error) {
                [SVProgressHUD showErrorWithStatus:error];
            }];
        }
        
        
    }else if (_type == 2){
        //第三方登陆绑定手机号
        [SVProgressHUD show];
        [RequestManager thirdCheckWithOpenId:_dic[@"openid"] ? _dic[@"openid"] : @""
                                 accessToken:_acctoken ? _acctoken:@"" nickName:_dic[@"nickname"] ? _dic[@"nickname"]:@""
                                         sex:_dic[@"sex"]? _dic[@"sex"] :@""
                                headImageUrl:_dic[@"headimgurl"] ?_dic[@"headimgurl"]:@""
                                     unionId:_dic[@"unionid"]? _dic[@"unionid"] :@""
                                      mobile:phone.text
                                        code:code.text
                             recommendMobile:otherPhone.text ? otherPhone.text : @""
                                    cityCode:_citycode
                                     success:^(id result) {
                                         NSNumber *errNumber = [result objectForKey:@"errCode"];
                                         NSInteger errcode = [errNumber integerValue];
                                         NSString *message =[result valueForKey:@"message"];
                                         if (errcode != 0) {
                                             [SVProgressHUD showErrorWithStatus:message];
                                             return ;
                                         }else{
                                             [SVProgressHUD showSuccessWithStatus:message];
                                             self.navigationController.navigationBarHidden = NO;
                                             [[UINavigationBar appearance] setBarTintColor:COLOR_ORANGE_DEFOUT];

//                                             [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                                             //微信登录需要跳转认证页面
                                             [[NSNotificationCenter defaultCenter] postNotificationName:ISLOGIN object:nil];
                                             RoleExplainVC * headVC = [[RoleExplainVC alloc]init];
                                             headVC.isRegist = YES;
                                             [self.navigationController pushViewController:headVC animated:YES];

                                         }
                                     } Failed:^(NSString *error) {
                                         [SVProgressHUD showErrorWithStatus:error];

                                     }];
    }
    else{
        //正常注册
        NSString * urlStr = [NSString stringWithFormat:@"%@sms/compare?mobile=%@&code=%@",BaseUrl,phone.text,code.text];
        [ExpressRequest sendWithParameters:nil MethodStr:urlStr reqType:k_GET success:^(id object) {
            [[NSUserDefaults standardUserDefaults] setValue:phone.text forKey:REGIST_PHONE];
            [[NSUserDefaults standardUserDefaults] synchronize];
            settingPassWardViewController *vc =  [[settingPassWardViewController alloc]init];
            vc.otherPhone = otherPhone.text;
            vc.code = code.text;
            [self.navigationController pushViewController:vc animated:YES];
        } failed:^(NSString *error) {
            [SVProgressHUD showErrorWithStatus:error];
        }];
        /*
        if ([code.text isEqualToString: _oUserPhoneNum]) {
            
            [[NSUserDefaults standardUserDefaults] setValue:phone.text forKey:REGIST_PHONE];
             [[NSUserDefaults standardUserDefaults] synchronize];
            settingPassWardViewController *vc =  [[settingPassWardViewController alloc]init];
            vc.otherPhone = otherPhone.text;
            vc.code = _oUserPhoneNum;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:@"验证码不正确，请重新填写!"];
        }
         */
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ------定位传反编码 传cityCode
#pragma mark- MapView delegate 定位
/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)willStartLocatingUser
{
    NSLog(@"start locate");
}

///**
// *用户方向更新后，会调用此函数
// *@param userLocation 新的用户位置
// */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //    NSLog(@"%f,%f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    //这个是为了解决有时候会定位到非洲（0，0），如果是00再让他定位一次
    if (userLocation.location.coordinate.latitude == 0) {
        [_locService stopUserLocationService];
        [_locService startUserLocationService];
        return;
    }
    //    发起反地理编码
    float lat =  userLocation.location.coordinate.latitude ;
    float lon =   userLocation.location.coordinate.longitude;
    
    _reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    _reverseGeocodeSearchOption.reverseGeoPoint = CLLocationCoordinate2DMake(lat, lon);
    BOOL flag = [_geocodesearch reverseGeoCode:_reverseGeocodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"发送geo搜索失败");
    }
}

/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)didStopLocatingUser
{
    NSLog(@"stop locate");
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error:%@",error);
    //    [SVProgressHUD showErrorWithStatus:@"请您检测当前网络或是否开启定位服务"];
}

#pragma mark- 反地理编码
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    
    NSString *locaStr = [NSString stringWithFormat:@"%@%@%@%@%@",result.addressDetail.province,result.addressDetail.city,result.addressDetail.district,result.addressDetail.streetName,result.addressDetail.streetNumber];
    NSRange range =[result.addressDetail.province rangeOfString:@"市"];
    if (range.length > 0) {
        locaStr = [NSString stringWithFormat:@"%@%@%@%@",result.addressDetail.city,result.addressDetail.district,result.addressDetail.streetName,result.addressDetail.streetNumber];
    }
    NSLog(@"保存的反地理编码的地址%@",locaStr);
    if (![result.addressDetail.province length] || ![result.addressDetail.city length]|| ![result.addressDetail.district length]) {
        NSLog(@"没有找到省市区");
        return;
    }
    _citycode =[self getCityCode:result.addressDetail.city];
    NSLog(@"------cityName:%@----cityCode:%@------",result.addressDetail.city,_citycode);
    return;
}
#pragma mark- 城市名城市code相互转换
//根据城市名找citycode
-(NSString *)getCityCode:(NSString *)city{
    //    获取txt文件路径
    NSString *txtPath = [[NSBundle mainBundle]  pathForResource:@"wr_city" ofType:@"txt"];
    //    将txt到string对象中，编码类型为NSUTF8StringEncoding
    NSString *string = [[NSString  alloc] initWithContentsOfFile:txtPath encoding:NSUTF8StringEncoding error:nil];
    NSArray *contentsArray = [string componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    for (NSString *strcode in contentsArray) {
        NSArray *lines = [strcode componentsSeparatedByString:@"	"];
        if (lines.count <2) {
            continue;
        }
        NSRange range = [strcode rangeOfString:city];//判断字符串是否包含
        if (range.length >0)//包含
        {
            NSString *provcode = [lines objectAtIndex:0];
            provcode =  [provcode  stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            return provcode;
        }
        else//不包含
        {
            continue;
        }
    }
    return nil;
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
