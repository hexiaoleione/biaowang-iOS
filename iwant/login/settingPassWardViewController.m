//
//  settingPassWardViewController.m
//  chuanke
//
//  Created by mj on 15/11/30.
//  Copyright © 2015年 jinzelu. All rights reserved.
//

#import "settingPassWardViewController.h"
#import "settinhHeaderViewController.h"
#import "MainHeader.h"
#import "UserNameViewController.h"
#import "InforWebViewController.h"
#import "RoleExplainVC.h"

@interface settingPassWardViewController ()<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    UIView *bgView;
    UITextField *passward;
    
    BMKLocationService * _locService;
    BMKGeoCodeSearch *  _geocodesearch;//地理检索
    BMKReverseGeoCodeOption *_reverseGeocodeSearchOption;//反地理检索
    NSString *  _citycode;
}

@end

@implementation settingPassWardViewController

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


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    self.title=@"注册2/2";
    self.view.backgroundColor=[UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(clickaddBtn)];
    [addBtn setImage:[UIImage imageNamed:@"nav_back"]];
    addBtn.tintColor=[UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:addBtn];
    
    [self createTextFields];
}

-(void)createTextFields
{
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(30, 16, self.view.frame.size.width-90, 30)];
    label.text=@"请设置密码";
    label.textColor=[UIColor grayColor];
    label.textAlignment=NSTextAlignmentLeft;
    label.font=[UIFont systemFontOfSize:13];
    [self.view addSubview:label];
    
    CGRect frame=[UIScreen mainScreen].bounds;
    bgView=[[UIView alloc]initWithFrame:CGRectMake(10, 53, frame.size.width-20, 50)];
    bgView.layer.cornerRadius=3.0;
    bgView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bgView];
    
    passward=[self createTextFielfFrame:CGRectMake(100, 10, 200, 30) font:[UIFont systemFontOfSize:14] placeholder:@"6-20位字母或数字"];
    passward.clearButtonMode = UITextFieldViewModeWhileEditing;
    passward.secureTextEntry=YES;
   
    UILabel *phonelabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 12, 50, 25)];
    phonelabel.text=@"密码";
    phonelabel.textColor=[UIColor blackColor];
    phonelabel.textAlignment=NSTextAlignmentLeft;
    phonelabel.font=[UIFont systemFontOfSize:14];
    
    
    UIButton *landBtn=[self createButtonFrame:CGRectMake(10, bgView.frame.size.height+bgView.frame.origin.y+30,self.view.frame.size.width-20, 37) backImageName:nil title:@"下一步" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:17] target:self action:@selector(landClick)];
    landBtn.backgroundColor=COLOR_MainColor;
    landBtn.layer.cornerRadius=5.0f;
    
    [bgView addSubview:passward];
    
    [bgView addSubview:phonelabel];
    [self.view addSubview:landBtn];
    
    UILabel *noticeLabel = [UILabel new];
    noticeLabel.text = @"点击上面\"下一步\"按钮注册账号，即表示你同意";
    noticeLabel.textColor  = [UIColor lightGrayColor];
    noticeLabel.font = [UIFont systemFontOfSize:14];
    [noticeLabel sizeToFit];
    noticeLabel.textAlignment = NSTextAlignmentCenter;
    noticeLabel.centerX = self.view.centerX;
    noticeLabel.top = landBtn.bottom +20;
    [self.view addSubview:noticeLabel];
    
    UIButton *tiaoKuanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [tiaoKuanBtn sizeToFit];
    tiaoKuanBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [tiaoKuanBtn setTitle:@"《法律声明及条款》" forState:UIControlStateNormal];
    [tiaoKuanBtn addTarget:self action:@selector(gotoTiaokuan) forControlEvents:UIControlEventTouchUpInside];
    [tiaoKuanBtn setTitleColor:[UIColor colorWithRed:27/255.0 green:113/255.0 blue:217/255.0 alpha:1] forState:UIControlStateNormal];
    tiaoKuanBtn.size = CGSizeMake(200, 20);
    tiaoKuanBtn.top = noticeLabel.bottom;
    tiaoKuanBtn.centerX = self.view.centerX;
    [self.view addSubview:tiaoKuanBtn];
    
}

-(void)landClick
{
    if([passward.text isEqualToString:@""] && [passward.text isValidPassWord])
    {
        [SVProgressHUD showInfoWithStatus:@"您还未设置密码"];
        return;
    }
    else if (passward.text.length <6)
    {
        [SVProgressHUD showInfoWithStatus:@"亲,密码长度至少六位"];
        return;
    }
    NSString *phone = [[NSUserDefaults standardUserDefaults] valueForKey:REGIST_PHONE];
    [SVProgressHUD showWithStatus:@""];
    
    [RequestManager registWithMobile:phone
                            passWord:[NSString stringWithFormat:@"%@",passward.text]
                            deviceId:nil
                     recommendMobile:_otherPhone ?_otherPhone:@""
                             smsCode:self.code
                             cityCode:_citycode
                             success:^(NSString *reslut)
     {
         [SVProgressHUD showSuccessWithStatus:reslut];
         [[NSUserDefaults standardUserDefaults] setValue:passward.text forKey:REGIST_PASSWORD];
          [[NSUserDefaults standardUserDefaults] synchronize];
         //让用户跳转角色认证的界面
         [[NSNotificationCenter defaultCenter] postNotificationName:ISLOGIN object:nil];
         RoleExplainVC * headVC = [[RoleExplainVC alloc]init];
         headVC.isRegist = YES;
         [self.navigationController pushViewController:headVC animated:YES];
     }
          failed:^(NSString *error)
     {
         [SVProgressHUD showErrorWithStatus:error];
     }];
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

-(void)clickaddBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)gotoTiaokuan{
    InforWebViewController *infoVC = [[InforWebViewController alloc]init];
    infoVC.info_type = INFO_LAW;
    [self.navigationController pushViewController:infoVC animated:YES];
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
