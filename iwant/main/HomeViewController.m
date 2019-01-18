//
//  HomeViewController.m
//  iwant
//
//  Created by 公司 on 2017/2/4.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "HomeViewController.h"
#import "MainHeader.h"
#import "WeChectLoginViewController.h"
#import "MMZCViewController.h"
#import "LeadingPage.h"
#import "InforWebViewController.h"
#import "LogInRewardVC.h"
#import "AdView.h"
#import "ActivityNewVC.h"
#import "MyMessageViewController.h"

#import "MapViewController.h"
#import "JieViewController.h"
#import "FaViewConstroller.h"
#import "FaOtherViewConstroller.h"
#import "SelectTypeView.h"
//#import "XLIDScanViewController.h"
@interface HomeViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,UIAlertViewDelegate>{
    
    BMKLocationService * _locService;
    BMKUserLocation * _userLocation; //定位的经纬度
    BMKGeoCodeSearch *  _geocodesearch;//地理检索
    BMKReverseGeoCodeOption *_reverseGeocodeSearchOption;//反地理检索
    CLLocationCoordinate2D _pt;

    BMKPoiSearch* _poiSearch;//检索
    BMKPoiResult *_searchResult;
    
    MapViewController * _MapVC;
    JieViewController * _JieVC;
    
    UIButton * leftBtnFa;
    UIButton * rightBtnJie;
    
    NSTimer *_timer;
    NSTimer *_upLoadTimer;
    
    BOOL _isGoTOLogin;
    UIButton *_skipbtn; //广告页跳过按钮
    NSInteger timeCount;
    
    UIBarButtonItem *rightBarButtonItem;
}

@property (strong, nonatomic)   NSNumber *adImageId;
/*广告页*/
@property (strong, nonatomic)  UIImageView *adImageView;

@end

@implementation HomeViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [LeadingPage addLeadingPage];
    [self loadData];
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [DwHelp updateUser];
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"home_btn_left"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(leftBtnClick)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"giftImage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                          style:UIBarButtonItemStylePlain
                                                         target:self
                                                         action:@selector(rightBtnClick)];
    [self ShowNavgationView];
    [self ifAllowLocation];
    [self initLocation];
    [self addSubChildVC];
    [self initBottomBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(islogin) name:ISLOGIN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setTimer) name:ENTER_BACKGROUND object:nil];

    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isJustLaunch"]) {
        [self addadsView];
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

            }
        } failed:^(NSString *error) {

        }];
     }
}

-(void)addSubChildVC{
    _MapVC = [[MapViewController alloc]init];
    [self addChildViewController:_MapVC];
    [self.view addSubview:_MapVC.view];
    _MapVC.view.left = 0;
    _MapVC.view.top = 0;
    
    _JieVC = [[JieViewController alloc]init];
    [self addChildViewController:_JieVC];
    [self.view addSubview:_JieVC.view];
    _JieVC.view.left = SCREEN_WIDTH;
    _JieVC.view.top = 0;
}


-(void)initLocation{
    _locService = [[BMKLocationService alloc]init];
    _locService.distanceFilter = 100.0f;
    _locService.delegate = self;
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    _geocodesearch.delegate = self;
    [_locService startUserLocationService];
}

#pragma mark ----- 底部我要发货  我要接单两个按钮
-(void)initBottomBtn{
    if (Device_Is_iPhoneX) {
      leftBtnFa = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-88-34-80, SCREEN_WIDTH/2, 80)];
    }else{
      leftBtnFa = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-64-80*RATIO_HEIGHT, SCREEN_WIDTH/2, 80*RATIO_HEIGHT)];
    }
    leftBtnFa.selected = YES;
    leftBtnFa.tag = 0;
    [leftBtnFa setImage:[UIImage imageNamed:@"FaBtnImg_selectedNone"] forState:UIControlStateNormal];
    [leftBtnFa setImage:[UIImage imageNamed:@"FaBtnImg_selected"] forState:UIControlStateSelected];
    [leftBtnFa addTarget:self action:@selector(faBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (Device_Is_iPhoneX) {
        rightBtnJie = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT-88-34-80, SCREEN_WIDTH/2, 80)];
    }else{
        rightBtnJie = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT-64-80*RATIO_HEIGHT, SCREEN_WIDTH/2, 80*RATIO_HEIGHT)];
    }
    rightBtnJie.tag = 1;
    [rightBtnJie setImage:[UIImage imageNamed:@"JieBtnImg_selectedNone"] forState:UIControlStateNormal];
    [rightBtnJie setImage:[UIImage imageNamed:@"JieBtnImg_selected"] forState:UIControlStateSelected];
    [rightBtnJie addTarget:self action:@selector(faBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:leftBtnFa];
    [self.view addSubview:rightBtnJie];
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
//    NSLog(@"%f,%f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    _pt = userLocation.location.coordinate;
    //这个是为了解决有时候会定位到非洲（0，0），如果是00再让他定位一次
    if (userLocation.location.coordinate.latitude == 0) {
        [_locService stopUserLocationService];
        [_locService startUserLocationService];
        return;
    }
    if (!_upLoadTimer) {
        [self uploadLocation];
        _upLoadTimer = [NSTimer scheduledTimerWithTimeInterval:60*10 target:self selector:@selector(uploadLocation) userInfo:nil repeats:YES];
    }
    
    [[NSUserDefaults standardUserDefaults]setDouble:userLocation.location.coordinate.latitude forKey:USER_LOCATION_LAT];
    [[NSUserDefaults standardUserDefaults]setDouble:userLocation.location.coordinate.longitude forKey:USER_LOCATION_LON];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
//    发起反地理编码
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
//    [SVProgressHUD showErrorWithStatus:@"请您检测当前网络或是否开启定位服务"];
    [self ifAllowLocation];
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
    
    NSString *citycode =[self getCityCode:result.addressDetail.city];
    
    [[NSUserDefaults standardUserDefaults] setValue:result.addressDetail.city forKey:USER_CITY];
    [[NSUserDefaults standardUserDefaults] setValue:citycode forKey:USER_CITY_CODE];
    
    NSString * townCode = [self getTownCodeWithTownName:result.addressDetail.district];
    [[NSUserDefaults standardUserDefaults] setValue:townCode forKey:USER_TOWN_CODE];
    [[NSUserDefaults standardUserDefaults] setValue:result.addressDetail.district forKey:USER_TOWN_NAME];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"------cityName:%@----cityCode:%@------townName:%@------townCode:%@----",result.addressDetail.city,citycode,result.addressDetail.district,townCode);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:USER_LOC_CHANGED object:nil];
    return;
}

#pragma mark- 城市名城市code相互转换
//根据城市名找province
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

-(void)dealloc{
    if (_poiSearch != nil) {
        _poiSearch = nil;
    }
}

- (void)setTimer{
    if (_pt.latitude == 0) {
//      [SVProgressHUD showErrorWithStatus:@"定位失败，请检查定位设置或手机网络"];
        [_locService stopUserLocationService];
        [_locService startUserLocationService];
        return;
    }
    [self uploadLocation];
    if (!_upLoadTimer) {
        _upLoadTimer =[NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(uploadLocation) userInfo:nil repeats:YES];
    }
}

//上传经纬度
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

#pragma mark ---- 点击事件
-(void)leftBtnClick{
    if (![self checkIfLogin]) {
        return;
    }
    MMDrawerController * drawerVC = (MMDrawerController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [drawerVC toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
//消息中心的按钮
-(void)rightBtnClick{
    if (![self checkIfLogin]) {
        return;
    }
    MyMessageViewController * vc =[[MyMessageViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
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
- (void)setNavi:(int)tag{
    if (tag == 0) {
        rightBarButtonItem.image =[[UIImage imageNamed:@"message0"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    }else{
        rightBarButtonItem.image =[[UIImage imageNamed:@"message1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}


-(void)faBtnClick:(UIButton *)sender{
    if (![self checkIfLogin]) {
        return;
    }
    sender.selected = YES;
    [UIView animateWithDuration:0.3 animations:^{
       _MapVC.view.left = - WINDOW_WIDTH * sender.tag;
       _JieVC.view.left = WINDOW_WIDTH *(labs(sender.tag - 1));
       
    }];
    if (sender.tag ==0) {
       if (rightBtnJie.selected == YES) {

       }else{
           if(_MapVC.startLabel.text.length == 0 ||_MapVC.model.fromLongitude.length == 0){
               [SVProgressHUD showErrorWithStatus:@"请先选择正确的起始地"];
               return;
           }
           
           UINib *nib = [UINib nibWithNibName:@"SelectTypeView" bundle:nil];
           SelectTypeView *adView = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
           __weak typeof(SelectTypeView *)badView = adView;
           badView.Block = ^(NSInteger tag) {
               if (tag == 0) {
                   FaViewConstroller * faVC =[[FaViewConstroller alloc]init];
                   faVC.model = [_MapVC.model copy];
                   faVC.cityName = _MapVC.cityName; 
                   faVC.wlModel = _MapVC.wlModel;
                   [self.navigationController pushViewController:faVC animated:YES];
                   [badView removeFromSuperview];
               }else{
                   FaOtherViewConstroller * faVC =[[FaOtherViewConstroller alloc]init];
                   faVC.model = [_MapVC.model copy];
                   faVC.wlModel = _MapVC.wlModel;
                   [self.navigationController pushViewController:faVC animated:YES];
                   [badView removeFromSuperview];
               }
           };
           adView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
           [[UIApplication sharedApplication].keyWindow addSubview:adView];
      }
        rightBtnJie.selected = NO;
    }else{
        leftBtnFa.selected = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- 判断是否登录
- (BOOL)checkIfLogin{
    if (![UserManager getDefaultUser]) {
        [self goToLogin];
        return NO;
    }
    return YES;
}
- (void)goToLogin{

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

#pragma mark ----通知  登录
//登陆之后的操作
- (void)islogin{
    [self setJPushAlias];
}

//极光设置alias
-(void)setJPushAlias{
    NSString *tag=@"";
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

#pragma mark ---- 判断是否开启定位
-(void)ifAllowLocation{
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请打开[定位服务]来允许[镖王]确定您的位置，否则将影响您继续使用软件" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置" , nil];
        alertView.delegate = self;
        alertView.tag = 1;
        [alertView show];
    }else{
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

@end
