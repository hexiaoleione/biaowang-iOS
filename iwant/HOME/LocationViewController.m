//
//  LocationViewController.m
//  iwant
//
//  Created by 公司 on 2017/3/14.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "LocationViewController.h"
#import "MainHeader.h"
#import "CitysViewController.h"
#import "AddressMapView.h"

#import "iflyMSC/iflyMSC.h"
#import "IATConfig.h"
#import "ISRDataHelper.h"

@class IFlyDataUploader;
@class IFlySpeechRecognizer;
@class IFlyPcmRecorder;
/**
 语音听写demo
 使用该功能仅仅需要四步
 1.创建识别对象；
 2.设置识别参数；
 3.有选择的实现识别回调；
 4.启动识别
 */


@interface LocationViewController ()
 <BMKMapViewDelegate,
 BMKGeoCodeSearchDelegate,
 BMKLocationServiceDelegate,
 BMKPoiSearchDelegate,
 UITextFieldDelegate,
 UITableViewDelegate,
 UITableViewDataSource,
IFlySpeechRecognizerDelegate,IFlyRecognizerViewDelegate,UIActionSheetDelegate>

{
 BMKMapView *_mapView;
 BMKGeoCodeSearch* _geocodesearch;//地理检索
 BMKReverseGeoCodeOption *_reverseGeocodeSearchOption;//反地理检索
 UILabel * label;
 BMKLocationService* _locService;
 UIButton * _sureAddressBtn;
    
 BMKPoiSearch* _poiSearch;//检索
 BMKPoiResult *_searchResult;
 UITextField * _searchTextField;
    
 UITableView * _tableView;
 UIButton * _cityBtn;

 BMKCitySearchOption * _option;
 NSString * _cityStr;
    
 AddressMapView * _addressView;
    
    NSString *_address;
    
    NSString * _name;
    NSString * _la;
    NSString * _lo;
    NSString * _cityCode;
    NSString * _cityName;
    NSString * _townCode;
    NSString * _townName;

    BOOL _isCellSelected;
}

@property (nonatomic, assign) CLLocationCoordinate2D centerCoordinate;  //地图的中心经纬度


@property (nonatomic, strong) NSString *pcmFilePath;//音频文件路径
@property (nonatomic, strong) IFlySpeechRecognizer *iFlySpeechRecognizer;//不带界面的识别对象
@property (nonatomic, strong) IFlyRecognizerView *iflyRecognizerView;//带界面的识别对象
@property (nonatomic, strong) IFlyDataUploader *uploader;//数据上传对象

@property (nonatomic, strong) NSString * result;
@property (nonatomic, assign) BOOL isCanceled;

@property (nonatomic,strong) IFlyPcmRecorder *pcmRecorder;//录音器，用于音频流识别的数据传入
@property (nonatomic,assign) BOOL isStreamRec;//是否是音频流识别
@property (nonatomic,assign) BOOL isBeginOfSpeech;//是否返回BeginOfSpeech回调


@end


@implementation LocationViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self; //此处记得不用的时候需要置nil，否则会影响内存的释放
    _poiSearch.delegate = self;
    
    [self initRecognizer];//初始化识别对象

    self.navigationController.navigationBarHidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChange) name:UITextFieldTextDidChangeNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
    _locService.delegate = nil;
    _poiSearch.delegate  = nil;
    self.navigationController.navigationBarHidden = NO;
    
    NSLog(@"%s",__func__);
    
    if ([IATConfig sharedInstance].haveView == NO) {//无界面
        [_iFlySpeechRecognizer cancel]; //取消识别
        [_iFlySpeechRecognizer setDelegate:nil];
        [_iFlySpeechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
        
        [_pcmRecorder stop];
        _pcmRecorder.delegate = nil;
    }
    else
    {
        [_iflyRecognizerView cancel]; //取消识别
        [_iflyRecognizerView setDelegate:nil];
        [_iflyRecognizerView setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
    }
    
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initMap];
    [self showUser];
    [self initSearchUI];
    _cityStr = [[NSUserDefaults standardUserDefaults] valueForKey:USER_CITY];
    
     //避免同时产生多个按钮事件
    [self setExclusiveTouchForButtons:self.view];
}

-(void)yuyinClick{
    NSLog(@"语音搜索");
    if ([IATConfig sharedInstance].haveView == NO) {//无界面
        
        [_searchTextField setText:@""];
        [_searchTextField resignFirstResponder];
        self.isCanceled = NO;
        self.isStreamRec = NO;
        
        if(_iFlySpeechRecognizer == nil)
        {
            [self initRecognizer];
        }
        
        [_iFlySpeechRecognizer cancel];
        
        //设置音频来源为麦克风
        [_iFlySpeechRecognizer setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
        
        //设置听写结果格式为json
        [_iFlySpeechRecognizer setParameter:@"json" forKey:[IFlySpeechConstant RESULT_TYPE]];
        
        //保存录音文件，保存在sdk工作路径中，如未设置工作路径，则默认保存在library/cache下
        [_iFlySpeechRecognizer setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
        
        [_iFlySpeechRecognizer setDelegate:self];
        
        BOOL ret = [_iFlySpeechRecognizer startListening];
        
        if (ret) {
         ///不带界面的
        }else{
//            [_popUpView showText: @"启动识别服务失败，请稍后重试"];//可能是上次请求未结束，暂不支持多路并发
        }
    }else {
        
        if(_iflyRecognizerView == nil)
        {
            [self initRecognizer ];
        }
        
        [_searchTextField setText:@""];
        [_searchTextField resignFirstResponder];
        
        //设置音频来源为麦克风
        [_iflyRecognizerView setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
        
        //设置听写结果格式为json
        [_iflyRecognizerView setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];
        
        //保存录音文件，保存在sdk工作路径中，如未设置工作路径，则默认保存在library/cache下
        [_iflyRecognizerView setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
        
        BOOL ret = [_iflyRecognizerView start];
        if (ret) {
       //带界面的识别对象
        }
    }
}

#pragma mark - IFlySpeechRecognizerDelegate

/**
 音量回调函数
 volume 0－30
 ****/
- (void) onVolumeChanged: (int)volume
{
    if (self.isCanceled) {
//        [_popUpView removeFromSuperview];
        return;
    }
//    NSString * vol = [NSString stringWithFormat:@"音量：%d",volume];
//    [_popUpView showText: vol];
}



/**
 开始识别回调
 ****/
- (void) onBeginOfSpeech
{
    NSLog(@"onBeginOfSpeech");
    
    if (self.isStreamRec == NO)
    {
        self.isBeginOfSpeech = YES;
//        [_popUpView showText: @"正在录音"];
    }
}

/**
 停止录音回调
 ****/
- (void) onEndOfSpeech
{
    NSLog(@"onEndOfSpeech");
    
    [_pcmRecorder stop];
//    [_popUpView showText: @"停止录音"];
}
/**
 听写结束回调（注：无论听写是否正确都会回调）
 error.errorCode =
 0     听写正确
 other 听写出错
 ****/
- (void) onError:(IFlySpeechError *) error
{
//    NSLog(@"%s",__func__);
//    if ([IATConfig sharedInstance].haveView == NO ) {
//
//        //        if (self.isStreamRec) {
//        //            //当音频流识别服务和录音器已打开但未写入音频数据时stop，只会调用onError不会调用onEndOfSpeech，导致录音器未关闭
//        //            [_pcmRecorder stop];
//        //            self.isStreamRec = NO;
//        //            NSLog(@"error录音停止");
//        //        }
//
//        NSString *text  ;
//
//        if (self.isCanceled) {
//            text = @"识别取消";
//
//        } else if (error.errorCode == 0 ) {
//            if (_result.length == 0) {
//                text = @"无识别结果";
//            }else {
//                text = @"识别成功";
//                //清空识别结果
//                _result = nil;
//            }
//        }else {
//            text = [NSString stringWithFormat:@"发生错误：%d %@", error.errorCode,error.errorDesc];
//            NSLog(@"%@",text);
//        }
////        [_popUpView showText: text];
//
//    }else {
////        [_popUpView showText:@"识别结束"];
//        NSLog(@"errorCode:%d",[error errorCode]);
//    }
}

/**
 无界面，听写结果回调
 results：听写结果
 isLast：表示最后一次
 ****/
- (void) onResults:(NSArray *) results isLast:(BOOL)isLast
{
    
    NSMutableString *resultString = [[NSMutableString alloc] init];
    NSDictionary *dic = results[0];
    for (NSString *key in dic) {
        [resultString appendFormat:@"%@",key];
    }
    _result =[NSString stringWithFormat:@"%@%@", _searchTextField.text,resultString];
    NSString * resultFromJson =  [ISRDataHelper stringFromJson:resultString];
    _searchTextField.text = [NSString stringWithFormat:@"%@%@", _searchTextField.text,resultFromJson];
    
    if (isLast){
        NSLog(@"听写结果(json)：%@测试",  self.result);
    }
    NSLog(@"_result=%@",_result);
    NSLog(@"resultFromJson=%@",resultFromJson);
    NSLog(@"isLast=%d,_textView.text=%@",isLast,_searchTextField.text);
    [self textFieldChange];
}



/**
 有界面，听写结果回调
 resultArray：听写结果
 isLast：表示最后一次
 ****/
- (void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast
{
    NSMutableString *result = [[NSMutableString alloc] init];
    NSDictionary *dic = [resultArray objectAtIndex:0];
    
    for (NSString *key in dic) {
        [result appendFormat:@"%@",key];
    }
    _searchTextField.text = [NSString stringWithFormat:@"%@%@",_searchTextField.text,result];
    [self textFieldChange];
}


/**
 听写取消回调
 ****/
- (void) onCancel
{
    NSLog(@"识别取消");
}

-(void) showPopup
{
//    [_popUpView showText: @"正在上传..."];
}


#pragma mark ----- 听写功能 语音录入

/**
 设置识别参数
 ****/
-(void)initRecognizer
{
    NSLog(@"%s",__func__);
    
    if ([IATConfig sharedInstance].haveView == NO) {//无界面
        
        //单例模式，无UI的实例
        if (_iFlySpeechRecognizer == nil) {
            _iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];
            
            [_iFlySpeechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
            
            //设置听写模式
            [_iFlySpeechRecognizer setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
        }
        _iFlySpeechRecognizer.delegate = self;
        
        if (_iFlySpeechRecognizer != nil) {
            IATConfig *instance = [IATConfig sharedInstance];
            
            //设置最长录音时间
            [_iFlySpeechRecognizer setParameter:instance.speechTimeout forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
            //设置后端点
            [_iFlySpeechRecognizer setParameter:instance.vadEos forKey:[IFlySpeechConstant VAD_EOS]];
            //设置前端点
            [_iFlySpeechRecognizer setParameter:instance.vadBos forKey:[IFlySpeechConstant VAD_BOS]];
            //网络等待时间
            [_iFlySpeechRecognizer setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
            
            //设置采样率，推荐使用16K
            [_iFlySpeechRecognizer setParameter:instance.sampleRate forKey:[IFlySpeechConstant SAMPLE_RATE]];
            
            //设置语言
            [_iFlySpeechRecognizer setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
            //设置方言
            [_iFlySpeechRecognizer setParameter:instance.accent forKey:[IFlySpeechConstant ACCENT]];
            
            //设置是否返回标点符号
            [_iFlySpeechRecognizer setParameter:instance.dot forKey:[IFlySpeechConstant ASR_PTT]];
            
        }
        
        //初始化录音器
        if (_pcmRecorder == nil)
        {
            _pcmRecorder = [IFlyPcmRecorder sharedInstance];
        }
        
        _pcmRecorder.delegate = self;
        
        [_pcmRecorder setSample:[IATConfig sharedInstance].sampleRate];
        
        [_pcmRecorder setSaveAudioPath:nil];    //不保存录音文件
        
    }else  {//有界面
        
        //单例模式，UI的实例
        if (_iflyRecognizerView == nil) {
            //UI显示剧中
            _iflyRecognizerView= [[IFlyRecognizerView alloc] initWithCenter:self.view.center];
            
            [_iflyRecognizerView setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
            
            //设置听写模式
            [_iflyRecognizerView setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
            
        }
        _iflyRecognizerView.delegate = self;
        
        if (_iflyRecognizerView != nil) {
            IATConfig *instance = [IATConfig sharedInstance];
            //设置最长录音时间
            [_iflyRecognizerView setParameter:instance.speechTimeout forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
            //设置后端点
            [_iflyRecognizerView setParameter:instance.vadEos forKey:[IFlySpeechConstant VAD_EOS]];
            //设置前端点
            [_iflyRecognizerView setParameter:instance.vadBos forKey:[IFlySpeechConstant VAD_BOS]];
            //网络等待时间
            [_iflyRecognizerView setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
            
            //设置采样率，推荐使用16K
            [_iflyRecognizerView setParameter:instance.sampleRate forKey:[IFlySpeechConstant SAMPLE_RATE]];
            if ([instance.language isEqualToString:[IATConfig chinese]]) {
                //设置语言
                [_iflyRecognizerView setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
                //设置方言
                [_iflyRecognizerView setParameter:instance.accent forKey:[IFlySpeechConstant ACCENT]];
            }else if ([instance.language isEqualToString:[IATConfig english]]) {
                //设置语言
                [_iflyRecognizerView setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
            }
            //设置是否返回标点符号
            [_iflyRecognizerView setParameter:instance.dot forKey:[IFlySpeechConstant ASR_PTT]];
            
        }
    }
}


/**
 设置UIButton的ExclusiveTouch属性
 ****/
-(void)setExclusiveTouchForButtons:(UIView *)myView
{
    for (UIView * button in [myView subviews]) {
        if([button isKindOfClass:[UIButton class]])
        {
            [((UIButton *)button) setExclusiveTouch:YES];
        }
        else if ([button isKindOfClass:[UIView class]])
        {
            [self setExclusiveTouchForButtons:button];
        }
    }
}


-(void)initSearchUI{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(10, 35, SCREEN_WIDTH-20, 44)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.borderWidth = 0.5;
    view.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [self.view addSubview:view];
    
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(39, 2, 1, 40)];
    line1.backgroundColor = BACKGROUND_COLOR;
    [view addSubview:line1];
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [backBtn setImage:[[UIImage imageNamed:@"backImg"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(0, 2, 40, 40);
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:backBtn];
    
    _searchTextField= [[UITextField alloc]initWithFrame:CGRectMake(40, 0, view.width-40-55, view.height)];
    _searchTextField.placeholder = @"请输入搜索地址";
    _searchTextField.delegate = self;
    _searchTextField.returnKeyType = UIReturnKeySearch;

    [view addSubview:_searchTextField];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH-10, 200)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.hidden = YES;
    [self.view addSubview:_tableView];
    
#pragma mark ---  语音搜索
    _cityBtn = [[UIButton alloc]initWithFrame:CGRectMake(_searchTextField.right,0,view.width-_searchTextField.right, 44)];
//    [_cityBtn setTitle:@"语音搜索" forState:UIControlStateNormal];
    [_cityBtn setImage:[UIImage imageNamed:@"vidioImg"] forState:UIControlStateNormal];
    [_cityBtn addTarget:self action:@selector(showCityList) forControlEvents:UIControlEventTouchUpInside];
    [_cityBtn setTitleColor:[UIColor lightGrayColor] forState:0];
    _cityBtn.titleLabel.font = FONT(15, NO);
    [view addSubview:_cityBtn];
}

#pragma mark -- 初始化地图，定位服务，地理编码服务，地图设置
-(void)initMap{
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _mapView.mapType=BMKMapTypeStandard;
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    
    BMKLocationViewDisplayParam* param = [[BMKLocationViewDisplayParam alloc] init];
    param.locationViewOffsetY = 100;//偏移量
    param.locationViewOffsetX = 100;
    param.isAccuracyCircleShow =YES;//设置是否显示定位的那个精度圈
    param.isRotateAngleValid = YES;
    [_mapView updateLocationViewWithParam:param];

    [self.view addSubview: _mapView];
    _mapView.zoomLevel = 16;

    _locService = [[BMKLocationService alloc]init];
    _locService.distanceFilter = 100.0f;
    _locService.delegate = self;
    [_locService startUserLocationService];
    
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    _geocodesearch.delegate = self;
    _reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    _poiSearch = [[BMKPoiSearch alloc]init];
    
    UIImageView * imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"BigPin"]];
    imgView.center =_mapView.center;
    [self.view addSubview:imgView];
    
    _addressView = [[[NSBundle mainBundle] loadNibNamed:@"AddressMapView" owner:nil options:nil] lastObject];
    _addressView.layer.cornerRadius = 5;
    
    //    但是赋值之后你没有让她重新更新
    _addressView.centerX = self.view.centerX;
    _addressView.centerY = _mapView.centerY-30;
    [self.view addSubview:_addressView];
    
    [self addlocatBtn];
    
    _sureAddressBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49)];
    [_sureAddressBtn setImage:[UIImage imageNamed:@"Home_locationImg"] forState:UIControlStateNormal];
    [self.view addSubview:_sureAddressBtn];
    [_sureAddressBtn addTarget:self action:@selector(sureAddress) forControlEvents:UIControlEventTouchUpInside];
}
//定位按钮
- (void)addlocatBtn {
    CGRect frame = CGRectMake(0, 0, WINDOW_WIDTH/414 *36, WINDOW_WIDTH/414 *36);
    UIButton *btn = [[UIButton alloc]initWithFrame:frame];
    [btn setImage:[UIImage imageNamed:@"locat"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(showUser) forControlEvents:UIControlEventTouchUpInside];
    btn.center = CGPointMake(WINDOW_WIDTH - 46, WINDOW_HEIGHT - 100);
    btn.layer.cornerRadius = 5;
    //阴影颜色
    btn.layer.shadowColor = [UIColor blackColor].CGColor;
    //阴影横向和纵向的偏移值
    btn.layer.shadowOffset = CGSizeMake(5.0, 5.0);
    //阴影透明度
    btn.layer.shadowOpacity = 0.45;
    //  阴影半径大小
    //  btn.layer.shadowRadius = 5.0;
    [self.view addSubview:btn];
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
//- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
//{
//    //设置地图中心为用户经纬度
//    [_mapView updateLocationData:userLocation];
//    _mapView.centerCoordinate = userLocation.location.coordinate;
//    
//    [_locService stopUserLocationService];
//    NSLog(@"%f,%f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
//
//}

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
    _reverseGeocodeSearchOption.reverseGeoPoint = CLLocationCoordinate2DMake(_centerCoordinate.latitude, _centerCoordinate.longitude);
    BOOL flag = [_geocodesearch reverseGeoCode:_reverseGeocodeSearchOption];
    
    _isCellSelected = NO;
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"发送geo搜索失败");
    }
    
}

#pragma mark -- 设置当前地图中心点的位置
-(void)showUser{
    float lat =  [[NSUserDefaults standardUserDefaults] doubleForKey:USER_LOCATION_LAT];
    float lon =   [[NSUserDefaults standardUserDefaults]doubleForKey:USER_LOCATION_LON];
    
    NSLog(@"%f %f",lat,lon);
    [_locService startUserLocationService];
    //    [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(lat, lon)];
    _mapView.centerCoordinate = CLLocationCoordinate2DMake(lat, lon);
    [_locService stopUserLocationService];
    
    //反地理编码
    _reverseGeocodeSearchOption.reverseGeoPoint = CLLocationCoordinate2DMake(lat,lon);
    BOOL flag = [_geocodesearch reverseGeoCode:_reverseGeocodeSearchOption];
    _isCellSelected = NO;
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

//获取屏幕中心点的坐标
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
//    MKCoordinateRegion region;
//     self.centerCoordinate = mapView.region.center;
//    region.center= self.centerCoordinate;
    
    self.centerCoordinate = [_mapView convertPoint:_mapView.center toCoordinateFromView:_mapView];
    if (self.centerCoordinate.latitude ==0 ) {
        return;
    }
    NSLog(@"中心坐标经纬度regionDidChangeAnimated %f,%f",_centerCoordinate.latitude, _centerCoordinate.longitude);
    //反地理编码
    _reverseGeocodeSearchOption.reverseGeoPoint = CLLocationCoordinate2DMake(_centerCoordinate.latitude, _centerCoordinate.longitude);
    BOOL flag = [_geocodesearch reverseGeoCode:_reverseGeocodeSearchOption];
    _isCellSelected = NO;
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"发送geo搜索失败");
    }
}

#pragma mark- 反地理编码
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
   
    NSString *locaStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",result.addressDetail.province,result.addressDetail.city,result.addressDetail.district,result.addressDetail.streetName,result.addressDetail.streetNumber,result.businessCircle,result.sematicDescription];
    NSRange range =[result.addressDetail.province rangeOfString:@"市"];
    if (range.length > 0) {
        locaStr = [NSString stringWithFormat:@"%@%@%@%@%@",result.addressDetail.province,result.addressDetail.city,result.addressDetail.district,result.addressDetail.streetName,result.addressDetail.streetNumber];
    }
    
      NSLog(@"保存的反地理编码的地址%@",locaStr);
      [self getSizeByString:locaStr AndFontSize:14];
    
    if (![result.addressDetail.province length] || ![result.addressDetail.city length]|| ![result.addressDetail.district length]) {
        NSLog(@"没有找到省市区");
        return;
    }
 
    NSString * townCode = [self getTownCodeWithTownName:result.addressDetail.district];
    
    if (_isCellSelected) {
        _townCode = townCode;
        _townName = result.addressDetail.district;
        return;
    }

   //获取周边用户信息
    if (error==BMK_SEARCH_NO_ERROR) {
        
        BMKPoiInfo *poiInfo = result.poiList[0];
        _addressView.addressL.text = poiInfo.address;
        _addressView.detailL.text = poiInfo.name;
       CGSize size1 = [self getSizeByString:poiInfo.address AndFontSize:12];

       CGSize size2 = [self getSizeByString:poiInfo.name AndFontSize:14];
    
       _addressView.size = CGSizeMake(MAX(size1.width, size2.width)+16, size1.height+size2.height+5);
       _addressView.centerX = self.view.centerX;
       _addressView.centerY = _mapView.centerY-60;
        
        if (_passBlock) {
            NSString *cityCode = [self getCityCode:result.addressDetail.city];
            if (cityCode == nil) {
                HHAlertView *alert = [[HHAlertView alloc] initWithTitle:@"" detailText:@"百度地图检索地址数据有误，请选择城市后再输入地址关键词进行搜索，请勿单独输入省名搜索" cancelButtonTitle:@"确定" otherButtonTitles:nil];
                alert.mode = HHAlertViewModeWarning;
                [alert show];
                return;
            }
            NSString *address = nil;
            NSRange range = [poiInfo.address rangeOfString:result.addressDetail.city];//判断字符串是否包含
            NSRange rangeP = [poiInfo.address rangeOfString:@"省"];
            if (range.length >0 || rangeP.length > 0)//包含
            {
                address = [NSString stringWithFormat:@"%@",poiInfo.address];
            }else{
                address = [NSString stringWithFormat:@"%@",poiInfo.address];
            }
            
            _address = address;
            _name= [NSString stringWithFormat:@"%@",poiInfo.name];
            _la = [NSString stringWithFormat:@"%f",poiInfo.pt.latitude];
            _lo = [NSString stringWithFormat:@"%f",poiInfo.pt.longitude];

            
            _cityCode = cityCode;
            _cityName = result.addressDetail.city;
            _townCode = townCode;
            _townName = result.addressDetail.district;
            //这个是把值回传回去 一般都是判断一下block是不是空的
//           _passBlock(_address,_name,_la,_lo,_cityCode,_cityName,_townCode);
        }
    }else{
        
        NSLog(@"BMKSearchErrorCode: %u",error);
    }

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
-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)sureAddress{
    
    if (_passBlock) {
        _passBlock(_address,_name,_la,_lo,_cityCode,_cityName,_townCode,_townName);
    }
    [self.navigationController popViewControllerAnimated:YES];
}


//实现PoiSearchDeleage处理回调结果
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResultList errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        _searchResult = poiResultList;
        _tableView.hidden = NO;
        [_tableView reloadData];
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
        NSLog(@"起始点有歧义");
    } else {
        NSLog(@"抱歉，未找到结果");
    }
}
#pragma mark- textFieldDelegate

- (void)textFieldChange{
    NSLog(@"字改变了:%@",_searchTextField.text);
    //poi发起检索
    if ([_searchTextField.text isEqualToString:@""]) {
        _searchResult = nil;
        _tableView.hidden = YES;
        [_tableView reloadData];
        return;
    }
    _option = [[BMKCitySearchOption alloc]init];
    _option.pageIndex = 0;
    _option.pageCapacity = 20;
    _option.keyword = _searchTextField.text;
    _option.city = _cityStr;
    BOOL flag =  [_poiSearch poiSearchInCity:_option];
    if(flag)
    {
        NSLog(@"周边检索发送成功");
    }
    else
    {
        NSLog(@"周边检索发送失败");
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 城市列表   //语音搜索
- (void)showCityList{
    
    [self yuyinClick];
    /*
    CitysViewController *vc = [[CitysViewController alloc]init];
    vc.block = ^(NSString *cityName){
        
        [_cityBtn setTitle:cityName forState:0];
        _cityStr = cityName;
        NSLog(@"__________%@",cityName);
    };
    [self presentViewController:vc animated:YES completion:nil];
     */
}


#pragma mark-  TableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _searchResult.poiInfoList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ID"];
        
    }
    BMKPoiInfo *info = _searchResult.poiInfoList[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",info.name];
    NSRange range = [info.address rangeOfString:info.city];//判断字符串是否包含
    if (range.length >0)//包含
    {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",info.address];
    }else{
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@",info.city,info.address];
    }
    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    BMKPoiInfo *info = _searchResult.poiInfoList[indexPath.row];
    _mapView.centerCoordinate = info.pt;
    _tableView.hidden = YES;
    _searchTextField.text = @"";
    
    if (_passBlock) {
        NSString *cityCode = [self getCityCode: info.city];
        if (cityCode == nil) {
            HHAlertView *alert = [[HHAlertView alloc] initWithTitle:@"" detailText:@"百度地图检索地址数据有误，请选择城市后再输入地址关键词进行搜索，请勿单独输入省名搜索" cancelButtonTitle:@"确定" otherButtonTitles:nil];
            alert.mode = HHAlertViewModeWarning;
            [alert show];
            return;
        }
        NSString *address = nil;
        NSRange range = [info.address rangeOfString:info.city];//判断字符串是否包含
        NSRange rangeP = [info.address rangeOfString:@"省"];
        if (range.length >0 || rangeP.length > 0)//包含
        {
            address = [NSString stringWithFormat:@"%@",info.address];
        }else{
            address = [NSString stringWithFormat:@"%@%@",info.city,info.address];
        }
        
        _addressView.detailL.text = info.name;
        _addressView.addressL.text = address;
        CGSize size1 = [self getSizeByString:address AndFontSize:12];
        CGSize size2 = [self getSizeByString:info.name AndFontSize:14];
        
        _addressView.size = CGSizeMake(MAX(size1.width, size2.width)+16, size1.height+size2.height+5);
        _addressView.centerX = self.view.centerX;
        _addressView.centerY = _mapView.centerY-60;
        
        _isCellSelected = YES;
        //反地理编码
        _reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
        _reverseGeocodeSearchOption.reverseGeoPoint = CLLocationCoordinate2DMake(info.pt.latitude, info.pt.longitude);
        BOOL flag = [_geocodesearch reverseGeoCode:_reverseGeocodeSearchOption];
        if(flag)
        {
            NSLog(@"反geo检索发送成功");
        }
        else
        {
            NSLog(@"发送geo搜索失败");
        }
        
        _address = address;
        _name= [NSString stringWithFormat:@"%@",info.name];
        _la = [NSString stringWithFormat:@"%f",info.pt.latitude];
        _lo = [NSString stringWithFormat:@"%f",info.pt.longitude];
        _cityCode = cityCode;
        _cityName = info.city;
    }

}

//根据字符串的字号 和长度  确定size
-(CGSize)getSizeByString:(NSString *)string AndFontSize:(CGFloat)font{
    CGSize size = [string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 60) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size;
    size.width += 5;
    size.height +=5;
    return size;
}

@end
