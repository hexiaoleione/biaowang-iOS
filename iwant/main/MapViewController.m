//
//  MapViewController.m
//  iwant
//
//  Created by 公司 on 2017/6/1.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "MapViewController.h"
#import "LocationViewController.h"
#import "SDCycleScrollView.h"
#import "ActivityNewVC.h"
#import "MMZCViewController.h"
#import "WeChectLoginViewController.h"
#import "MyJieViewController.h"
#import "MyFaViewController.h"
#import "PersonalWealthVC.h"
#import "TouBaoVC.h"
#import "BaoXianViewController.h"
@interface MapViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKPoiSearchDelegate,SDCycleScrollViewDelegate>{
    
    BMKMapView *_mapView;
    BMKLocationService * _locService;
    BMKUserLocation * _userLocation; //定位的经纬度
    BMKGeoCodeSearch *  _geocodesearch;//地理检索
    BMKReverseGeoCodeOption *_reverseGeocodeSearchOption;//反地理检索
    CLLocationCoordinate2D _pt;
    
    BMKPoiSearch* _poiSearch;//检索
    BMKPoiResult *_searchResult;
    
    SDCycleScrollView * _cycleScrollView; //轮播图
    NSMutableArray * _imagesURLStrings;
    
    UIView * addressView; //发件地址选择
    
    
    UIButton * _myJieBtn; //我的接单
    UIButton * _myFaBtn;  //我的发单
    UIButton * _moneyBtn;  //我的余额
    UIButton * _insureBtn; //一键投保
}
@property (nonatomic, assign) CLLocationCoordinate2D centerCoordinate;  //地图的中心经纬度

@end

@implementation MapViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self;
    _poiSearch.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addAdvertisement];
    [self initMap];
    [self addressView];
    _cityName =  [[NSUserDefaults standardUserDefaults] valueForKey:USER_CITY];
    self.model = [[ShunFeng alloc]init];
    self.wlModel = [[WLModel alloc]init];
    _startLabel.text = [[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCASTR];
    _model.address = [NSString stringWithFormat:@"%@",_startLabel.text];
    _model.fromLongitude = [[[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCATION_LON] stringValue];
    _model.fromLatitude = [[[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCATION_LAT] stringValue];
    _model.cityCode = [[NSUserDefaults standardUserDefaults] valueForKey:USER_CITY_CODE];
    _model.townCode = [[NSUserDefaults standardUserDefaults] valueForKey:USER_TOWN_CODE];
    
    _wlModel.startPlace = _model.address;
    _wlModel.latitude = _model.fromLatitude;
    _wlModel.longitude = _model.fromLongitude;
    _wlModel.startPlaceCityCode =_model.cityCode;
    _wlModel.startPlaceTownCode = _model.townCode;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(publishSuccess) name:PUBLISH_SUCCESS object:nil];

}
-(void)addAdvertisement{
    _cycleScrollView = [[SDCycleScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120*RATIO_HEIGHT)];
    [ExpressRequest sendWithParameters:nil MethodStr:[NSString stringWithFormat:@"%@activity/getAdvertNew",BaseUrl] reqType:k_GET success:^(id object) {
        NSArray * arr = [object objectForKey:@"data"];
        _imagesURLStrings = [[NSMutableArray alloc]init];
        
        for (NSDictionary * dict in arr) {
            [_imagesURLStrings addObject:[dict valueForKey:@"pointName"]];
        }
        _cycleScrollView.pageControlBottomOffset = - 10;
        _cycleScrollView.delegate = self;
        _cycleScrollView.imageURLStringsGroup = (NSArray *)_imagesURLStrings ;
        [self.view addSubview:_cycleScrollView];
    } failed:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
}
#pragma mark --- 轮播页面的点击事件
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    if (![self checkIfLogin]) {
        return;
    }
    ActivityNewVC * sc = [[ActivityNewVC alloc]init];
    [self.navigationController pushViewController:sc animated:YES];
}

-(void)addressView{
    UIImageView * imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HomeCenter_Pic"]];
    imgView.center =_mapView.center;
    imgView.userInteractionEnabled = YES;
    [self.view addSubview:imgView];
    
    UILabel * noticeL = [[UILabel alloc]init];
    noticeL.text = @"发货地址";
    noticeL.font = FONT(12, NO);
    _startLabel = [[UILabel alloc]init];
    _startLabel.textAlignment = NSTextAlignmentCenter;
    _startLabel.font = FONT(12, NO);
    
    UIButton * dingweiBtn = [[UIButton alloc]init];
    [dingweiBtn setTitle:@"定位" forState:UIControlStateNormal];
    [dingweiBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    dingweiBtn.titleLabel.font = FONT(15, NO);
    [dingweiBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    dingweiBtn.userInteractionEnabled = YES;
    
    [imgView addSubview:noticeL];
    [imgView addSubview:_startLabel];
    [imgView addSubview:dingweiBtn];

    [noticeL  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imgView);
        make.top.equalTo(imgView).offset(5);
    }];
    [_startLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgView).offset(5);
        make.right.equalTo(imgView).offset(-5);
        make.top.equalTo(noticeL.mas_bottom).offset(5);
    }];

    [dingweiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgView).offset(0);
        make.right.equalTo(imgView).offset(-5);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(35);
    }];
}

#pragma mark ---跳转我要发单
-(void)btnClick{
   LocationViewController * vc = [[LocationViewController alloc]init];
    vc.passBlock = ^(NSString *address, NSString *name, NSString *lat, NSString *lon, NSString *cityCode, NSString *cityName, NSString *townCode, NSString *townName) {
        _startLabel.text = [NSString stringWithFormat:@"%@%@",address,name];
        _model.address = [NSString stringWithFormat:@"%@",_startLabel.text];
        _model.fromLatitude = lat;
        _model.fromLongitude = lon;
        _model.cityCode = cityCode;
        _model.townCode = townCode;
        _wlModel.latitude = lat;
        _wlModel.longitude = lon;
        _wlModel.startPlaceCityCode = cityCode;
        _wlModel.startPlaceTownCode = townCode;
        _cityName = cityName;
    };
    [self.navigationController pushViewController:vc animated:NO];
}

-(void)initMap{
    if(Device_Is_iPhoneX){
        _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, _cycleScrollView.bottom, SCREEN_WIDTH, SCREEN_HEIGHT-88-34-80-_cycleScrollView.height)];
    }else{
        _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, _cycleScrollView.bottom, SCREEN_WIDTH, SCREEN_HEIGHT-64-80*RATIO_HEIGHT-_cycleScrollView.height)];
    }
    _mapView.mapType=BMKMapTypeStandard;
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    
    BMKLocationViewDisplayParam* param = [[BMKLocationViewDisplayParam alloc] init];
    //设置了偏移量  所以xy 就是100  100 了  相对于中心点
    //    param.locationViewOffsetY = 100;//偏移量
    //    param.locationViewOffsetX = 100;
    param.isAccuracyCircleShow =NO;//设置是否显示定位的那个精度圈
    param.isRotateAngleValid = YES;
    [_mapView updateLocationViewWithParam:param];
    
    [self.view addSubview: _mapView];
    _mapView.zoomLevel = 14;
    
    _locService = [[BMKLocationService alloc]init];
    _locService.distanceFilter = 100.0f;
    _locService.delegate = self;
    [_locService startUserLocationService];
    
    [self addlocatBtn];
}

#pragma mark ----悬浮按钮以及定位按钮
//定位按钮
- (void)addlocatBtn {
    CGRect frame = CGRectMake(0, 0, WINDOW_WIDTH/414 *36, WINDOW_WIDTH/414 *36);
    UIButton *btn = [[UIButton alloc]initWithFrame:frame];
    [btn setImage:[UIImage imageNamed:@"locat"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(showUser) forControlEvents:UIControlEventTouchUpInside];
    btn.center = CGPointMake(46,_mapView.bottom -  WINDOW_WIDTH/414 *46);
    btn.layer.cornerRadius = 5;
    //阴影颜色
    btn.layer.shadowColor = [UIColor blackColor].CGColor;
    //阴影横向和纵向的偏移值
    btn.layer.shadowOffset = CGSizeMake(5.0, 5.0);
    //阴影透明度
    btn.layer.shadowOpacity = 0.45;
    //  阴影半径大小
    [self.view addSubview:btn];
    
    _myJieBtn = [[UIButton alloc]initWithFrame:CGRectMake(150*RATIO_WIDTH, _cycleScrollView.bottom + 20*RATIO_HEIGHT,42*RATIO_WIDTH, 36*RATIO_HEIGHT)];
    [_myJieBtn setBackgroundImage: [UIImage imageNamed:@"myJieBtn"] forState:UIControlStateNormal];
    _myJieBtn.tag = 0;
    [_myJieBtn addTarget:self action:@selector(jieAndFaBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    _myFaBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, _myJieBtn.top,42*RATIO_WIDTH, 36* RATIO_HEIGHT)];
    _myFaBtn.left = _myJieBtn.right+12*RATIO_HEIGHT;
    [_myFaBtn setBackgroundImage:[UIImage imageNamed:@"myFaBtn"] forState:UIControlStateNormal];
    _myFaBtn.tag = 1;
    [_myFaBtn addTarget:self action:@selector(jieAndFaBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _moneyBtn =[[UIButton alloc]initWithFrame:CGRectMake(0,_myJieBtn.top,42*RATIO_WIDTH, 36* RATIO_HEIGHT)];
    _moneyBtn.left = _myFaBtn.right+12*RATIO_HEIGHT;
    [_moneyBtn setBackgroundImage: [UIImage imageNamed:@"moneyBtn"] forState:UIControlStateNormal];
    _moneyBtn.tag = 2;
    [_moneyBtn addTarget:self action:@selector(jieAndFaBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _insureBtn =[[UIButton alloc]initWithFrame:CGRectMake(0, _myJieBtn.top,42*RATIO_WIDTH, 36* RATIO_HEIGHT)];
    _insureBtn.left = _moneyBtn.right+12*RATIO_HEIGHT;
    [_insureBtn setBackgroundImage: [UIImage imageNamed:@"insureBtn"] forState:UIControlStateNormal];
    _insureBtn.tag = 3;
    [_insureBtn addTarget:self action:@selector(jieAndFaBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_myJieBtn];
    [self.view addSubview:_myFaBtn];
    [self.view addSubview:_moneyBtn];
    [self.view addSubview:_insureBtn];
}

#pragma mark --- 悬浮按钮的点击事件
-(void)jieAndFaBtnClick:(UIButton *)sender{
    if (![self checkIfLogin]) {
        return;
    }
    switch (sender.tag) {
        case 0:{
            //我的接单
            MyJieViewController  * vc =[[MyJieViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:{
            //我的发单
            MyFaViewController * vc =[[MyFaViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:{
            //个人财产
            PersonalWealthVC * personalWealthVC = [[PersonalWealthVC alloc]init];
            [self.navigationController  pushViewController:personalWealthVC animated:YES];
        }
            break;
        case 3:{
           //一键投保
            BaoXianViewController * vc = [[BaoXianViewController alloc]init];
            [self.navigationController  pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- 设置当前地图中心点的位置
-(void)showUser{
     float   lat = _locService.userLocation.location.coordinate.latitude;
     float   lon = _locService.userLocation.location.coordinate.longitude;
    NSLog(@"%f %f",lat,lon);
    if (lat == 0) {
        [_locService stopUserLocationService];
        [_locService startUserLocationService];
        return;
    }
    _mapView.centerCoordinate = CLLocationCoordinate2DMake(lat, lon);
    
    _startLabel.text = [[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCASTR];
    _model.address = [NSString stringWithFormat:@"%@",_startLabel.text];
    _model.fromLongitude = [[[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCATION_LON] stringValue];
    _model.fromLatitude = [[[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCATION_LAT] stringValue];
    _model.cityCode = [[NSUserDefaults standardUserDefaults] valueForKey:USER_CITY_CODE];
    _model.townCode = [[NSUserDefaults standardUserDefaults] valueForKey:USER_TOWN_CODE];
    
    _wlModel.startPlace = _model.address;
    _wlModel.latitude = _model.fromLatitude;
    _wlModel.longitude = _model.fromLongitude;
    _wlModel.startPlaceCityCode =_model.cityCode;
    _wlModel.startPlaceTownCode = _model.townCode;
}

//获取屏幕中心点的坐标
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    self.centerCoordinate = [_mapView convertPoint:_mapView.center toCoordinateFromView:_mapView];
    if (self.centerCoordinate.latitude ==0 ) {
        return;
    }
    NSLog(@"中心坐标经纬度regionDidChangeAnimated %f,%f",_centerCoordinate.latitude, _centerCoordinate.longitude);
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
    [_mapView setCenterCoordinate:userLocation.location.coordinate];
    [_mapView updateLocationData:userLocation];
    //    咋有一直定位 不造 顶一回就停了  有时候就这样那个
    BMKCoordinateRegion region ;//表示范围的结构体
    region.center = _mapView.centerCoordinate;//中心点
    region.span.latitudeDelta = 0.004;//经度范围（设置为0.1表示显示范围为0.2的纬度范围）
    region.span.longitudeDelta = 0.004;//纬度范围
    [_mapView setRegion:region animated:YES];
    
    
    float lat = userLocation.location.coordinate.latitude;
    float lon = userLocation.location.coordinate.longitude;
    
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

-(void)dealloc{
    if (_poiSearch != nil) {
        _poiSearch = nil;
    }
    
    if (_mapView) {
        _mapView = nil;
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
    _locService.delegate = nil;
    _poiSearch.delegate  = nil;
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark- 反地理编码
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSString *locaStr = [NSString stringWithFormat:@"%@%@%@%@%@",result.addressDetail.province,result.addressDetail.city,result.addressDetail.district,result.addressDetail.streetName,result.addressDetail.streetNumber];
    NSRange range =[result.addressDetail.province rangeOfString:@"市"];
    if (range.length > 0) {
        locaStr = [NSString stringWithFormat:@"%@%@%@%@",result.addressDetail.city,result.addressDetail.district,result.addressDetail.streetName,result.addressDetail.streetNumber];
    }
    NSLog(@"mapView保存的反地理编码的地址%@",locaStr);
    _startLabel.text = locaStr;
//    [[NSUserDefaults standardUserDefaults] setValue:result.addressDetail.city forKey:USER_CITY];
//    [[NSUserDefaults standardUserDefaults] setValue:locaStr forKey:USER_LOCASTR];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    if (![result.addressDetail.province length] || ![result.addressDetail.city length]|| ![result.addressDetail.district length]) {
//        NSLog(@"没有找到省市区");
//        return;
//    }
//    NSString *citycode =[self getCityCode:result.addressDetail.city];
//    [[NSUserDefaults standardUserDefaults] setValue:citycode forKey:USER_CITY_CODE];
//    
//    NSString * townCode = [self getTownCodeWithTownName:result.addressDetail.district];
//    [[NSUserDefaults standardUserDefaults] setValue:townCode forKey:USER_TOWN_CODE];
//    [[NSUserDefaults standardUserDefaults] setValue:result.addressDetail.district forKey:USER_TOWN_NAME];
//    
//    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"-----%@~~~~~~~~~~~",result.addressDetail.district);
    
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

//-(void)textFieldDidChange :(UITextField *)theTextField{
//    NSLog( @"text changed: %@", theTextField.text);
//    _model.address = [NSString stringWithFormat:@"%@%@",_startLabel.text,theTextField.text];
//}

-(void)publishSuccess{
    _startLabel.text = [[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCASTR];
    _startLabel.text = [[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCASTR];
    _model.address = [NSString stringWithFormat:@"%@",_startLabel.text];
    _model.fromLongitude = [[[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCATION_LON] stringValue];
    _model.fromLatitude = [[[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCATION_LAT] stringValue];
    _model.cityCode = [[NSUserDefaults standardUserDefaults] valueForKey:USER_CITY_CODE];
    _model.townCode = [[NSUserDefaults standardUserDefaults] valueForKey:USER_TOWN_CODE];
    
    _wlModel.startPlace = _model.address;
    _wlModel.latitude = _model.fromLatitude;
    _wlModel.longitude = _model.fromLongitude;
    _wlModel.startPlaceCityCode =_model.cityCode;
    _wlModel.startPlaceTownCode = _model.townCode;
    NSLog(@"发布成功，需要改变位置啊");
}


@end
