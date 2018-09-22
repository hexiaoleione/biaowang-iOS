//
//  FaBiaoViewController.m
//  iwant
//
//  Created by 公司 on 2017/2/4.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "FaBiaoViewController.h"
#import "MainHeader.h"
#import "WeChectLoginViewController.h"
#import "MMZCViewController.h"
#import "ActivityNewVC.h"
#import "AdvertisementView.h"
#import "SCouponVC.h"
#import "AdDetailViewController.h"
#import "LeadingPage.h"
#import "InforWebViewController.h"
#import "MyUserCenterVC.h"
#import "SendLimitTimeExpViewController.h"
#import "OneKeyViewController.h"
#import "SendLogViewController.h"
#import "FaXianShiVC.h"
#import "FaShunFengVC.h"
#import "FaKuaiDiVC.h"
#import "FaWuLiuVC.h"
#import "MyMessageViewController.h"
#import "LocationViewController.h"
#import "AdView.h"
#import "LogInRewardVC.h"


@interface FaBiaoViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>{
    BMKLocationService * _locService;
    BMKGeoCodeSearch *  _geocodesearch;//地理检索
    BMKReverseGeoCodeOption *_reverseGeocodeSearchOption;//反地理检索
    CLLocationCoordinate2D _pt;
    
    BOOL _isGoTOLogin;
    UIButton *_skipbtn; //广告页跳过按钮
    NSInteger timeCount;
    NSTimer *_timer;
    NSTimer *_upLoadTimer;

    UIBarButtonItem *rightBarButtonItem;
}
@property (strong, nonatomic)   NSNumber *adImageId;
/*广告页*/
@property (strong, nonatomic)  UIImageView *adImageView;



@end

@implementation FaBiaoViewController
-(void)viewWillAppear:(BOOL)animated{
//    [self creatControllersUI];
    self.tabBarController.tabBar.hidden = NO;
    [self loadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self addAdverment];
    [self creatNavgationItem];
    [self initMap];
    [LeadingPage addLeadingPage];
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(islogin) name:ISLOGIN object:nil];
    /*
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isPost) name:ISPOST object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkModule) name:COURIER_SUCCESS object:nil];
   */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(driverPush) name:DRIVER_AUTH object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoVC:) name:GOTOVC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setTimer) name:ENTER_BACKGROUND object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setTimer) name:ENTER_FOREGROUND object:nil];

    //接收审核快递员成功的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(courierSuccessed) name:COURIER_SUCCESS object:nil];
     
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isJustLaunch"]) {
        [self addadsView];
    }
    [self creatControllersUI];

}
#pragma mark -------创建控制器 （限时镖  顺风镖  快递  物流）
-(void)creatControllersUI{
    FaXianShiVC * xianshiVC = [[FaXianShiVC alloc]init];
    FaShunFengVC * shunfengVc =[[FaShunFengVC alloc]init];
   // FaKuaiDiVC * kuaidiVc = [[FaKuaiDiVC alloc]init];
    FaWuLiuVC * wuliuVC =[[FaWuLiuVC alloc]init];
    
    self.kuaidiyuanArr = @[@[@"sfNoSelected",@"xsNoSelected",@"wlNoSelected"],
                           @[@"sfSelected",@"xsSelected",@"wlSelected"],
                           @[shunfengVc,xianshiVC,wuliuVC]];
    //隐藏快递  @"kdNoSelected" ,@"kdSelected"
    self.userArr = @[@[@"sfNoSelected",@"xsNoSelected",@"wlNoSelected"],
                     @[@"sfSelected",@"xsSelected",@"wlSelected"],
                     @[shunfengVc,xianshiVC,wuliuVC]];
    
    self.wuliuArr = @[@[@"sfNoSelected",@"xsNoSelected"],
                      @[@"sfSelected",@"xsSelected"],
                      @[shunfengVc,xianshiVC]];
    
    self.kuaidiAndWuliuArr = @[@[@"sfNoSelected",@"xsNoSelected"],
                              @[@"sfSelected",@"xsSelected"],
                              @[shunfengVc,xianshiVC]];
    
    
    if([UserManager getDefaultUser].userType == 2){
        if([[UserManager getDefaultUser].wlid intValue] != 0){
            [self showTitle:3];
        }else{
            [self showTitle:1];
        }
    }else{
        if([[UserManager getDefaultUser].wlid intValue] != 0){
            [self showTitle:2];
        }else{
            [self showTitle:0];
        }
  }

}
//广告
- (void)addadsView{
    _adImageId = [[NSUserDefaults standardUserDefaults] valueForKey:@"advertiseId"];
    if (![[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@.png",_adImageId]]) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isJustLaunch"];
    self.adImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoAdDetail)];
    self.adImageView.clipsToBounds = YES;
    [self.adImageView addGestureRecognizer:tap];
    self.adImageView.userInteractionEnabled = YES;
    self.adImageView.image = [UIImage imageWithData:[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@.png",_adImageId]]];
    _skipbtn = [[UIButton alloc]initWithFrame:CGRectMake(WINDOW_WIDTH - 100, 60, 80, 30)];
    _skipbtn.titleLabel.font = FONT(15, YES);
    _skipbtn.backgroundColor = COLOR_(150, 150, 150, 0.5);
    _skipbtn.layer.cornerRadius = 5;
    [_skipbtn addTarget:self action:@selector(clearAd:) forControlEvents:UIControlEventTouchUpInside];
    _skipbtn.titleLabel.font = FONT(15, YES);
    [_skipbtn setTitle:@"3秒跳过" forState:0];
    [self.adImageView addSubview:_skipbtn];
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.adImageView];
    timeCount = 3;
    _timer =[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reduceTime:) userInfo:nil repeats:YES];
    
}

-(void)gotoAdDetail{
    [self.adImageView removeFromSuperview];
    NSString * adUrl = [[NSUserDefaults standardUserDefaults] valueForKey:[NSString stringWithFormat:@"%@.html",_adImageId]];
    NSString * adName = [[NSUserDefaults standardUserDefaults] valueForKey:[NSString stringWithFormat:@"image_%@",_adImageId]];
    InforWebViewController *web = [[InforWebViewController alloc]init];
    web.info_type  = INFO_AD_WEB;
    web.adUrl = adUrl;
    web.adName = adName;
    [self.navigationController pushViewController:web animated:YES];
}

- (void)clearAd:(UIButton *)sender {
    [_timer invalidate];
    _timer = nil;
    [UIView animateWithDuration:0.3f animations:^{
        self.adImageView.transform = CGAffineTransformMakeScale(0.5f, 0.5f);
        self.adImageView.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self.adImageView removeFromSuperview];
        [self addAdverment];
        
    }];
}
- (void)reduceTime:(NSTimer *)codeTimer {
    timeCount--;
    NSString *str = [NSString stringWithFormat:@"%d秒跳过", (int)timeCount];
    [_skipbtn setTitle:str forState:0];
    if (timeCount == 0 ) {
        [_timer invalidate];
        _timer = nil;
        [self removeAdImageView];
    }
}

- (void)removeAdImageView
{
    [UIView animateWithDuration:0.3f animations:^{
        self.adImageView.transform = CGAffineTransformMakeScale(0.5f, 0.5f);
        self.adImageView.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self.adImageView removeFromSuperview];
        [self addAdverment];
    }];
}

#pragma mark ------推荐引导广告页面
-(void)addAdverment{
    //判断登陆次数
    if (![self checkIfLogin]) {
        
    }else{
        NSString *URLStr = [NSString stringWithFormat:@"%@users/loginCount?userId=%@",BaseUrl,[UserManager getDefaultUser].userId];
        [ExpressRequest sendWithParameters:nil MethodStr:URLStr reqType:k_GET success:^(id object) {
            NSDictionary * dict = [object objectForKey:@"data"][0];
            int jumpPage = [[dict objectForKey:@"jumpPage"] intValue];
            if (jumpPage ==1 ) {
                NSLog(@"jump");
                LogInRewardVC * vc = [[LogInRewardVC alloc]init];
                vc.isFirstJump = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
//               不跳转界面的时候直接加载广告页
                UINib *nib = [UINib nibWithNibName:@"View" bundle:nil];
                AdView *adView = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
                __weak typeof(AdView *)badView = adView;
                badView.Block = ^{
                    ActivityNewVC * sc = [[ActivityNewVC alloc]init];
                    [self.navigationController pushViewController:sc animated:YES];
                };
                adView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                [[UIApplication sharedApplication].keyWindow addSubview:adView];
            }
            
        } failed:^(NSString *error) {
//            [SVProgressHUD showErrorWithStatus:error];
            UINib *nib = [UINib nibWithNibName:@"View" bundle:nil];
            AdView *adView = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
            __weak typeof(AdView *)badView = adView;
            badView.Block = ^{
                ActivityNewVC * sc = [[ActivityNewVC alloc]init];
                [self.navigationController pushViewController:sc animated:YES];
            };
            adView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            [[UIApplication sharedApplication].keyWindow addSubview:adView];
        }];
     }
}

#pragma mark -----设置导航
-(void)creatNavgationItem{
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"gerenImg"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                           style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(userCenter)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"giftImage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(activity)];
//    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 40, 40)];//初始化图片视图控件
    imageView.contentMode = UIViewContentModeScaleAspectFit;//设置内容样式,通过保持长宽比缩放内容适应视图的大小,任何剩余的区域的视图的界限是透明的。
    UIImage *image = [UIImage imageNamed:@"biaowangLogo"];//初始化图像视图
    [imageView setImage:image];
    self.navigationItem.titleView = imageView;//设置导航栏的titleView为imageView
    
  }
#pragma mark -- 消息条数
-(void)loadData
{
    //获取未读消息数
    NSString *Url = [NSString stringWithFormat:@"%@%@?%@=%@",BaseUrl,API_GET_UNREAD_MSG,k_USER_ID,[UserManager getDefaultUser].userId];
    [ExpressRequest sendWithParameters:nil
                             MethodStr:Url
                               reqType:k_GET
                               success:^(id object) {
                                   
                                   int errCode = [[NSString stringWithFormat:@"%@",[object valueForKey:@"errCode"]] intValue];
                                   if (errCode) {
                                       [self setNavi:1];
                                   }else{
                                       [self setNavi:0];
                                   }
                               }
                                failed:^(NSString *error) {
                                    [self setNavi:0];
                                }];
}

#pragma mark -- 我的消息
- (void)MyMessage:(id)sender {
    
    MyMessageViewController *VC = [[MyMessageViewController alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
    [sender clearBadge];
}


- (void)setNavi:(int)tag{
    
    UIButton *msgButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,33, 23)];
    [msgButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"info_%d",tag]] forState:UIControlStateNormal];
    [msgButton addTarget:self action:@selector(MyMessage:) forControlEvents:UIControlEventTouchUpInside];
    
     UIBarButtonItem *settingBtnItem = [[UIBarButtonItem alloc] initWithCustomView:msgButton];
    NSArray *rightButtons=@[rightBarButtonItem,settingBtnItem];
    self.navigationItem.rightBarButtonItems= rightButtons;
}

- (void)jpush:(id)tag{
    UIBarButtonItem *btn = (UIBarButtonItem *)self.navigationItem.rightBarButtonItem;
    btn.badgeCenterOffset = CGPointMake(-8, 3);
    [btn showBadgeWithStyle:WBadgeStyleNew value:1 animationType:WBadgeAnimTypeScale];
}


-(void)userCenter{
    if (![self checkIfLogin]) {
        return;
    }
    MyUserCenterVC *  userVc = [[MyUserCenterVC alloc]init];
    [self.navigationController pushViewController:userVc animated:YES];
}
-(void)activity{
    if (![self checkIfLogin]) {
        return;
    }
    //    跳转活动页面
    ActivityNewVC * activityVC = [[ActivityNewVC alloc]init];
    [self.navigationController pushViewController:activityVC animated:YES];

}

- (BOOL)checkIfLogin{
    if (![UserManager getDefaultUser]) {
        [self goToLogin];
        return NO;
    }
    return YES;
}
#pragma mark -- 进入登陆界面
- (void)goToLogin{
    _isGoTOLogin = YES;
    //如果用户装了微信就只能微信登陆，如果没装微信，就进入账号登陆
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
        WeChectLoginViewController *vc = [[WeChectLoginViewController alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
        
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
    }else{
        MMZCViewController *vc = [[MMZCViewController alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
        
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
    }
}
#pragma mark -- 初始化地图，定位服务，地理编码服务，地图设置
- (void)initMap{
    _locService = [[BMKLocationService alloc]init];
    _locService.distanceFilter = 100.0f;
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    
    BMKLocationViewDisplayParam *displayParam = [[BMKLocationViewDisplayParam alloc]init];
    displayParam.isRotateAngleValid = true;//跟随态旋转角度是否生效
    displayParam.isAccuracyCircleShow = false;//精度圈是否显示
    //    displayParam.locationViewImgName= @"icon";//定位图标名称
    displayParam.locationViewOffsetX = 0;//定位偏移量(经度)
    displayParam.locationViewOffsetY = 0;//定位偏移量（纬度）
    _locService.delegate = self;
    _geocodesearch.delegate = self;
    [_locService startUserLocationService];
}

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
//    [_mapView updateLocationData:userLocation];
    //     NSLog(@"heading is %@",userLocation.heading);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    _pt = userLocation.location.coordinate;
    //    [PXAlertView showAlertWithTitle:[NSString stringWithFormat:@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude]];
//    [_mapView setCenterCoordinate:userLocation.location.coordinate];
    if (userLocation.location.coordinate.latitude == 0) {
        [_locService stopUserLocationService];
        [_locService startUserLocationService];
        return;
    }
    if (!_upLoadTimer) {
        [self uploadLocation];
        _upLoadTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(uploadLocation) userInfo:nil repeats:YES];
    }
    
    
    [[NSUserDefaults standardUserDefaults]setDouble:userLocation.location.coordinate.latitude forKey:USER_LOCATION_LAT];
    [[NSUserDefaults standardUserDefaults]setDouble:userLocation.location.coordinate.longitude forKey:USER_LOCATION_LON];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //发起反地理编码
    float lat =  [[NSUserDefaults standardUserDefaults] doubleForKey:USER_LOCATION_LAT];
    float lon =   [[NSUserDefaults standardUserDefaults]doubleForKey:USER_LOCATION_LON];
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
    [[NSUserDefaults standardUserDefaults] setValue:result.addressDetail.city forKey:USER_CITY];
    [[NSUserDefaults standardUserDefaults] setValue:locaStr forKey:USER_LOCASTR];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (![result.addressDetail.province length] || ![result.addressDetail.city length]|| ![result.addressDetail.district length]) {
        NSLog(@"没有找到省市区");
        return;
    }
    
    NSString *provinceCode = [self getProvinceData:result.addressDetail.province];
    NSString *citycode = [self getCityData:result.addressDetail.city withcode:provinceCode];
    [[NSUserDefaults standardUserDefaults] setValue:citycode forKey:USER_CITY_CODE];
    
    NSString * townCode = [self getTownCodeWithTownName:result.addressDetail.district];
    [[NSUserDefaults standardUserDefaults] setValue:townCode forKey:USER_TOWN_CODE];
    [[NSUserDefaults standardUserDefaults] setValue:townCode forKey:USER_TOWN_NAME];
    
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"__________%@~~~~~~~~~~~",result.addressDetail.district);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:USER_LOC_CHANGED object:nil];
    return;
}

#pragma mark- 城市名城市code相互转换
//根据城市名找citycode
-(NSString *)getProvinceData:(NSString *)province{
    //    获取txt文件路径
    NSString *txtPath = [[NSBundle mainBundle]  pathForResource:@"wr_province" ofType:@"txt"];
    //    将txt到string对象中，编码类型为NSUTF8StringEncoding
    NSString *string = [[NSString  alloc] initWithContentsOfFile:txtPath encoding:NSUTF8StringEncoding error:nil];
    NSArray *contentsArray = [string componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    for (NSString *strcode in contentsArray) {
        
        NSArray *lines = [strcode componentsSeparatedByString:@"	"];
        if (lines.count <2) {
            continue;
        }
        NSRange range = [strcode rangeOfString:province];//判断字符串是否包含
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
//根据citycode找城市
-(NSString *)getCityData:(NSString *)cityname withcode:(NSString *)code{
    if (!code) {
        return 0;
    }
    NSString *txtPath = [[NSBundle mainBundle]  pathForResource:@"wr_city" ofType:@"txt"];
    //    将txt到string对象中，编码类型为NSUTF8StringEncoding
    NSString *string = [[NSString  alloc] initWithContentsOfFile:txtPath encoding:NSUTF8StringEncoding error:nil];
    NSArray *contentsArray = [string componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    for (NSString *strcode in contentsArray) {
        NSRange range = [strcode rangeOfString:code];//判断字符串是否包含
        NSArray *lines = [strcode componentsSeparatedByString:@"	"];
        if (lines.count <4) {
            continue;
        }
        //if (range.location ==NSNotFound)//不包含
        if (range.length >0)//包含
        {
            NSString *citycode = [lines objectAtIndex:0];
            citycode =  [citycode  stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            return citycode;
        }
        else//不包含
        {
            continue;
        }
        
    }
    return nil;
}

//根据县区找townCode
-(NSString *)getTownCodeWithTownName:(NSString *)townName{
    NSString *txtPath = [[NSBundle mainBundle]  pathForResource:@"wr_town" ofType:@"txt"];
    NSString *string = [[NSString  alloc] initWithContentsOfFile:txtPath encoding:NSUTF8StringEncoding error:nil];
    NSArray *contentsArray = [string componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];//以行分割字符串
    
    for (NSString *strCode in contentsArray) {
        NSRange range = [strCode rangeOfString:townName];//判断字符串是否包含区的名字
        NSArray *lines = [strCode componentsSeparatedByString:@"	"];//以空格分隔每一行的字符串
        if (range.length >0)//包含区县名字
        {
            NSString *townCode = [lines objectAtIndex:0];
            townCode =  [townCode  stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            return townCode;
        }
        
    }
    
    return nil;
}

#pragma mark ---- 各个通知的方法

//登陆之后的操作
- (void)islogin{
    if([UserManager getDefaultUser].userType == 2){
        if([[UserManager getDefaultUser].wlid intValue] != 0){
            [self showTitle:3];
        }else{
            [self showTitle:1];
        }
    }else{
        if([[UserManager getDefaultUser].wlid intValue] != 0){
            [self showTitle:2];
        }else{
            [self showTitle:0];
        }
    }
    [self setJPushAlias];
}

//极光设置alias
-(void)setJPushAlias{
    
    NSString *tag;
    switch ([UserManager getDefaultUser].userType) {
        case 1:{
            tag = @"user";
        }
            
            break;
        case 2:{
            tag = @"courier";
        }
            
            break;
        case 3:{
            tag = @"driver";
        }
            
            break;
            
        default:
            break;
    }
    [JPUSHService setTags:[NSSet setWithArray:@[tag]] alias:[UserManager getDefaultUser].userId fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags , iAlias);
    }];
}

- (void)gotoVC:(NSNotification *)notice{
    
    Class OneVC = NSClassFromString(notice.object[CLASS_NAME]);
    UIViewController *vc = [OneVC new];
    if (notice.object[METHOD_NAME]) {
        SEL action = NSSelectorFromString(notice.object[METHOD_NAME]);
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if ([notice.object[OTHER] intValue] == 1) {
            btn.tag = 1;
        }
        if ([notice.object[OTHER] intValue] == 2) {
            btn.tag = 2;
        }
        [vc performSelector:action withObject:btn afterDelay:1.];
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setTimer{
    if (_pt.latitude == 0) {
        [SVProgressHUD showErrorWithStatus:@"定位失败，请检查定位设置或手机网络"];
        return;
    }
    [self uploadLocation];
    if (!_upLoadTimer) {
        _upLoadTimer =[NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(uploadLocation) userInfo:nil repeats:YES];
    }
}

- (void)uploadLocation{
    if ([UserManager getDefaultUser].userId) {
        NSDictionary *dic = @{k_USER_ID:[UserManager getDefaultUser].userId,
                              k_USER_TYPE:[NSNumber numberWithInt:[UserManager getDefaultUser].userType],
                              USER_LOCATION_LAT:[NSString stringWithFormat:@"%f",_pt.latitude],
                              USER_LOCATION_LON:[NSString stringWithFormat:@"%f",_pt.longitude]};
        [ExpressRequest sendWithParameters:dic MethodStr:API_LOCAT_UPLOAD reqType:k_POST success:^(id object) {
            NSLog(@"map上传位置成功");
        } failed:^(NSString *error) {
            NSLog(@"map上传位置失败:%@",error);
        }];
    }
}

-(void)courierSuccessed{
// 快递员审核通过
        if([[UserManager getDefaultUser].wlid intValue] != 0){
            [self showTitle:3];
            NSLog(@"快递员审核11");
        }else{
            [self showTitle:1];
            NSLog(@"快递员审核");
        }
}
//镖师 或者大货司机 物流公司认证走的通知
-(void)driverPush{
    if([UserManager getDefaultUser].userType == 2){
        if([[UserManager getDefaultUser].wlid intValue] != 0){
            [self showTitle:3];
        }else{
            [self showTitle:1];
        }
    }else{
        if([[UserManager getDefaultUser].wlid intValue] != 0){
            [self showTitle:2];
        }else{
            [self showTitle:0];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
