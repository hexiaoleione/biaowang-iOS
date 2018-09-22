//
//  OperationViewController.m
//  iwant
//
//  Created by pro on 16/4/27.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "OperationViewController.h"
#import "MainHeader.h"
#import "MywindViewController.h"
#import "CustomAlert.h"
#import "TXTradePasswordView.h"
#import "LPPopup.h"
#import "LXAlertView.h"
#import "ShunFengBiaoShi.h"
#import "YMHeaderView.h"
//#import "BNCoreServices.h"
#import "HuowuWeiguiView.h"
#import "TouSuView.h"
#import "DaiShouKuanAlert.h"

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height

#define ROTIO  WINDOW_HEIGHT/736.0

//按比例获取高度
#define  WGiveHeight(HEIGHT) HEIGHT * [UIScreen mainScreen].bounds.size.height/568.0

//按比例获取宽度
#define  WGiveWidth(WIDTH) WIDTH * [UIScreen mainScreen].bounds.size.width/320.0

#define BG_COLOR            [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0]

#define TableViewBG_COLOR            [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0]

//BNNaviUIManagerDelegate，BNNaviRoutePlanDelegate
@interface OperationViewController ()<TXTradePasswordViewDelegate,YMHeaderViewDelegate,BMKLocationServiceDelegate>

{
    BMKLocationService * _locService;
    CLLocationCoordinate2D _pt;

    CGFloat _currentScale;

    UIView *_view;

    UITableView *_tableview;
    
    UILabel *_SendTime;
    UILabel *_Person;
    UILabel *_Phone;
    UILabel *_SendAddress;
    
    UILabel *_PersonTo;
    UILabel *_PhoneTo;
    UILabel *_AddressTo;
    
    UILabel *_matName;
    UILabel *_matprice;
    
    UILabel *_matvolume;//体积
    UILabel *_carLengthL;//车长要求
    UILabel *_remark; //备注
    
    
    UIImageView *_matImage;
    
    UIView * matView;
    
    
    UILabel *_textLabel;
    UIButton *_SureButton; //确认取货
    UIButton *_FinisheBtn;
    
    UIButton * _shouKuanBtn;//我已收款
    DaiShouKuanAlert * _shouKuanAlert;
    
    UIButton * _jiuWeiBtn;//我已就位
    UIButton * _weiGuiBtn;//货物违规
    UIButton * _touSuBtn;//投诉按钮
    
    HuowuWeiguiView * _huowuWeiguiView;
    NSString * _illegalUrl; //货物违规照片路径
    
    TouSuView * _touSuView;
    NSString * _accusationUrl; //投诉上传照片的路径
    
    
    UIButton *_btn;
    UIView *mainView;
    TXTradePasswordView *txView;
    BOOL isCLick;
    UIVisualEffectView *visualEffectView;
    UILabel *_limitTimeLabel;
    UILabel * _replaceMoneyLabel;
    
}
@property (strong, nonatomic) CustomAlert *alert;
@property (strong, nonatomic) NSString *pd;
@property (weak, nonatomic) UIViewController *superViewController;

@end

@implementation OperationViewController

float margin = 20;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //开启定位服务，获取当前的经纬度
    [self locService];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavgationBar];
    [self CreatTableview];
    
    [self CteatUI];
    isCLick = YES;
    [self chargeBtnIfEnable];
}

-(void)locService{
    _locService = [[BMKLocationService alloc]init];
    _locService.distanceFilter = 100;
    _locService.delegate = self;
    [_locService startUserLocationService];
}
#pragma mark ----locationService  delegate

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
    NSLog(@"----didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    _pt = userLocation.location.coordinate;
    if (userLocation.location.coordinate.latitude == 0) {
        [_locService stopUserLocationService];
        [_locService startUserLocationService];
        return;
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


- (void)chargeBtnIfEnable{
    if ([_model.status integerValue] > 2) {
        _SureButton.selected = YES;
        _SureButton.userInteractionEnabled = NO;
    }

    if ([_model.status integerValue] != 3) {
        _FinisheBtn.userInteractionEnabled = NO;
        _FinisheBtn.selected = YES;
        [_FinisheBtn setImage:[UIImage imageNamed:@"wancheng_gray"] forState:UIControlStateSelected];
    }
    if ([_model.status integerValue] > 4 ) {
        [_FinisheBtn setImage:[UIImage imageNamed:@"wancheng_no"] forState:UIControlStateSelected];
    }
    if (_model.readyTime.length > 0 ) {
        _jiuWeiBtn.selected = YES;
    }
    if ([_model.status intValue] != 2  ) {
        _jiuWeiBtn.hidden = YES;
        _weiGuiBtn.hidden = YES;
    }
    if ([_model.status intValue] == 4 || [_model.status intValue] == 8) {
        if ([_model.ifAgree isEqualToString:@"1"]) {
            _touSuBtn.hidden = YES;
            _FinisheBtn.hidden = YES;
            _shouKuanBtn.hidden = YES;
        }else{
            _touSuBtn.hidden = NO;
            _FinisheBtn.hidden = YES;
            _shouKuanBtn.hidden = YES;
        }
    }
    
    if ([_model.status intValue] == 9) {
        _FinisheBtn.hidden = YES;
    }
    
//    if ([_model.status intValue] == 3) {
//        if (_model.ifTackReplace) {
//            _shouKuanBtn.hidden = YES;
//            _FinisheBtn = [self CreatBtnWithimage:@"wancheng_yes" SelectImage:@"wancheng_gray" Highlightedimage:@"chenggong_moren" X:_shouKuanBtn.x Y:_shouKuanBtn.y W:ScreenW-WGiveWidth(100) H:WGiveHeight(35) tag:5];
//        }
//    }
}
-(void)CreatTableview
{
    _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    _tableview.backgroundColor = TableViewBG_COLOR;
    
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableview];
}

- (void)initMainView{
    // 临时修改尺寸
    if (mainView == nil) {
        mainView = [[UIView alloc]initWithFrame:CGRectMake(margin, -300, WINDOW_WIDTH - 2 * margin, 200)];
        mainView.backgroundColor = [UIColor whiteColor];
        mainView.layer.cornerRadius = 6.0f;
        mainView.clipsToBounds = YES;
        [self setMohu];
        [self.view addSubview:visualEffectView];
        [self.view addSubview:mainView];
    }
    
    UILabel *topLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, mainView.width, 50)];
    topLabel.backgroundColor = [UIColor orangeColor];
    topLabel.text = @"请输入交易密码";
    topLabel.textAlignment = NSTextAlignmentCenter;
    topLabel.textColor = [UIColor whiteColor];
    topLabel.userInteractionEnabled = YES;
    [mainView addSubview:topLabel];
    
    //手势
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGes:)];
    panGes.minimumNumberOfTouches = 1;
    panGes.maximumNumberOfTouches = 1;
    [mainView addGestureRecognizer:panGes];
    
    
    //❎号
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(mainView.width - 30, 10, 30, 30)];
    cancelBtn.backgroundColor = [UIColor clearColor];
    [cancelBtn setTitle:@"X" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:cancelBtn];
    //空格
    txView = [[TXTradePasswordView alloc]initWithFrame:CGRectMake(0,60, mainView.width, 50) WithTitle:@""];
    txView.TXTradePasswordDelegate = self;
    if (mainView.width != 375){
        txView = [[TXTradePasswordView alloc]initWithFrame:CGRectMake(-15,60, mainView.width, 50) WithTitle:@""];
        txView.TXTradePasswordDelegate = self;
    }
    [mainView addSubview:txView];
    //取消按钮
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 120, mainView.width/2 - 1, 40)];
    leftBtn.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1.0];
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    leftBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [leftBtn addTarget:self action:@selector(renwuChange) forControlEvents:UIControlEventTouchUpInside];
    //确认按钮
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(mainView.width/2, 120, mainView.width/2 + 1, 40)];
//    rightBtn.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1.0];
    rightBtn.backgroundColor = [UIColor orangeColor];

    [rightBtn setTitle:@"确认" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    rightBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [rightBtn addTarget:self action:@selector(renwuFinish) forControlEvents:UIControlEventTouchUpInside];
    
    [mainView addSubview:leftBtn];
    [mainView addSubview:rightBtn];
    
    
    UILabel *bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 165, 315, 30)];
    bottomLabel.backgroundColor = [UIColor clearColor];
    bottomLabel.text = @"提示:交易密码请联系收件人";
    bottomLabel.font = [UIFont systemFontOfSize:11];
//    bottomLabel.textAlignment = NSTextAlignmentCenter;
    bottomLabel.textColor = [UIColor blackColor];
    [mainView addSubview:bottomLabel];
     NSMutableAttributedString * str = [[NSMutableAttributedString alloc]initWithString:bottomLabel.text attributes:@{NSKernAttributeName:@(0.)}];
    NSRange orangeRange = NSMakeRange([[str string] rangeOfString:@"提示："].location,[[str string] rangeOfString:@"提示："].length);
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:orangeRange];
    [bottomLabel setAttributedText:str];
}


-(void)CteatUI
{
    //寄件人信息
    UILabel *headLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0, ScreenW, WGiveHeight(30))];
    headLabel.backgroundColor = BG_COLOR;
    headLabel.text = @"温馨提示：为了您的人身安全请勿押运违禁物品";
    headLabel.textAlignment = NSTextAlignmentCenter;
    headLabel.textColor = [UIColor grayColor];
    headLabel.font = [UIFont systemFontOfSize:13];
    [_tableview addSubview:headLabel];
    
    
    UIView *TopView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(headLabel.frame)+WGiveWidth(10), ScreenW, WGiveHeight(120))];
    TopView.backgroundColor = [UIColor whiteColor];
    [_tableview addSubview:TopView];
    
    _SendTime = [self CreatViewLabelWithtext:[NSString stringWithFormat:@"发件时间:%@",self.model.publishTime] textfont:FONT(14,NO) textcolor:[UIColor darkGrayColor] X:WGiveWidth(10) Y:WGiveHeight(40) W:ScreenW H:WGiveHeight(25)];
    _Person = [self CreatViewLabelWithtext:[NSString stringWithFormat:@"发件人:%@",self.model.personName] textfont:FONT(14,NO) textcolor:[UIColor darkGrayColor] X:WGiveWidth(10) Y:CGRectGetMaxY(_SendTime.frame) W:ScreenW H:WGiveHeight(25)];
    //电话
    [self CreatBtnWithimage:@"dianhua" SelectImage:@"" Highlightedimage:@"" X:ScreenW-WGiveWidth(50) Y:CGRectGetMaxY(_SendTime.frame) W:WGiveWidth(30) H:WGiveHeight(30) tag:1];
    
    _Phone = [self CreatViewLabelWithtext:[NSString stringWithFormat:@"电话:%@",self.model.mobile] textfont:FONT(14,NO) textcolor:[UIColor darkGrayColor] X:WGiveWidth(10) Y:CGRectGetMaxY(_Person.frame) W:ScreenW H:WGiveHeight(25)];
    _SendAddress =[self CreatViewLabelWithtext:[NSString stringWithFormat:@"发货地址:%@",self.model.address]  textfont:FONT(14,NO) textcolor:[UIColor darkGrayColor] X:WGiveWidth(10) Y:CGRectGetMaxY(_Phone.frame) W:ScreenW- WGiveWidth(10)*2 H:WGiveHeight(40)];
    _SendAddress.numberOfLines = 2;
    
    
    UIView *ReciveView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(TopView.frame)+WGiveHeight(10), ScreenW, WGiveHeight(120))];
    ReciveView.backgroundColor = [UIColor whiteColor];
    [_tableview addSubview:ReciveView];
    
    UILabel * receiveLabel = [self CreatViewLabelWithtext:[NSString stringWithFormat:@"到达时间:%@",self.model.finishTime] textfont:FONT(14,NO) textcolor:[UIColor darkGrayColor] X:WGiveWidth(10) Y:CGRectGetMaxY(TopView.frame)+WGiveHeight(10) W:ScreenW H:WGiveHeight(25)];
    
    
    _PersonTo = [self CreatViewLabelWithtext:[NSString stringWithFormat:@"收件人:%@",self.model.personNameTo] textfont:FONT(14,NO) textcolor:[UIColor darkGrayColor] X:WGiveWidth(10) Y:CGRectGetMaxY(receiveLabel.frame) W:ScreenW H:WGiveHeight(25)];
    if ([self.model.finishTime isEqualToString:@""]) {
        receiveLabel.height = 0;
        ReciveView.height = WGiveHeight(95);
        _PersonTo.y = CGRectGetMaxY(TopView.frame)+WGiveHeight(10);
    }
//导航
//    [self CreatBtnWithimage:@"map_letter"SelectImage:@"" Highlightedimage:@"" X:ScreenW-WGiveWidth(100) Y:CGRectGetMaxY(TopView.frame)+WGiveHeight(10) W:WGiveWidth(30) H:WGiveHeight(30) tag:3];
    
    //电话
    [self CreatBtnWithimage:@"dianhua"SelectImage:@"" Highlightedimage:@"" X:ScreenW-WGiveWidth(50) Y:CGRectGetMaxY(_PersonTo.frame) W:WGiveWidth(30) H:WGiveHeight(30) tag:2];
    
    _PhoneTo = [self CreatViewLabelWithtext:[NSString stringWithFormat:@"电话:%@",self.model.mobileTo] textfont:FONT(14,NO) textcolor:[UIColor darkGrayColor] X:WGiveWidth(10) Y:CGRectGetMaxY(_PersonTo.frame) W:ScreenW H:WGiveHeight(25)];
    _AddressTo = [self CreatViewLabelWithtext:[NSString stringWithFormat:@"收货地址:%@",self.model.addressTo] textfont:FONT(14,NO) textcolor:[UIColor darkGrayColor] X:WGiveWidth(10) Y:CGRectGetMaxY(_PhoneTo.frame) W:ScreenW - WGiveWidth(10)*2  H:WGiveHeight(40)];
    _AddressTo.numberOfLines = 2;
    
//    [self CreatBtnWithimage:@"map_letter"SelectImage:@"" Highlightedimage:@"" X:ScreenW-WGiveWidth(50) Y:CGRectGetMaxY(_PhoneTo.frame) W:WGiveWidth(30) H:WGiveHeight(30) tag:3];
    matView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(ReciveView.frame)+WGiveHeight(10),  ScreenW, WGiveHeight(60))];
    matView.backgroundColor = [UIColor whiteColor];
    [_tableview addSubview:matView];

    _matName = [self CreatViewLabelWithtext:[NSString stringWithFormat:@"物品名称：%@",self.model.matName] textfont:FONT(14,NO) textcolor:[UIColor darkGrayColor] X:WGiveWidth(10) Y:CGRectGetMaxY(ReciveView.frame)+WGiveWidth(10) W:(ScreenW - WGiveWidth(20))/3+WGiveWidth(10) H:WGiveHeight(25)];
    
    _matprice = [self CreatViewLabelWithtext:[NSString stringWithFormat:@"运费：%0.2lf元",[self.model.transferMoney doubleValue]] textfont:FONT(14,NO) textcolor:[UIColor darkGrayColor] X:_matName.right  Y:CGRectGetMaxY(ReciveView.frame)+ WGiveWidth(10) W:(ScreenW - WGiveWidth(20))/3 H:WGiveHeight(25)];
    
    
   [self CreatViewLabelWithtext:[NSString stringWithFormat:@"重量：%@kg",self.model.matWeight] textfont:FONT(14,NO) textcolor:[UIColor darkGrayColor] X:_matprice.right Y:CGRectGetMaxY(ReciveView.frame)+WGiveWidth(10) W:(ScreenW - WGiveWidth(20))/3 H:WGiveHeight(25)];
    
/*
    if ([_model.length isEqualToString:@"0"] ||_model.wide.length == 0 ||_model.high.length == 0) {
        matView.height -= WGiveHeight(25);
        _matvolume = [self CreatViewLabelWithtext:@"" textfont:FONT(14,NO) textcolor:[UIColor darkGrayColor] X:WGiveWidth(20) Y:CGRectGetMaxY(_matprice.frame) W:ScreenW H:WGiveHeight(0)];
    }else{
    _matvolume = [self CreatViewLabelWithtext:[NSString stringWithFormat:@"尺寸：长：%@cm 宽：%@cm 高：%@cm",self.model.length,self.model.wide,self.model.high] textfont:FONT(14,NO) textcolor:[UIColor darkGrayColor] X:WGiveWidth(20) Y:CGRectGetMaxY(_matprice.frame) W:ScreenW H:WGiveHeight(25)];
    }
 */
    if (self.model.limitTime.length ==0 || [self.model.limitTime isEqualToString:@""]) {
        
        NSString *_carLength ;
        if ([_model.carLength intValue] == 1|| [_model.carLength isEqualToString:@""]) {
            _carLength = @"车长要求：无";
        }else if ([_model.carLength intValue] == 2){
            _carLength = [NSString stringWithFormat:@"车长要求：1.8米"];
        }else if([_model.carLength intValue] == 3){
            _carLength = [NSString stringWithFormat:@"车长要求：2.7米"];
        }else if([_model.carLength intValue] == 4){
            _carLength = [NSString stringWithFormat:@"车长要求：4.2米"];
        }
        matView.height += WGiveHeight(25);
        UILabel * carLengthLabel =[self CreatViewLabelWithtext:_carLength textfont:FONT(14, NO) textcolor:[UIColor darkGrayColor] X:WGiveWidth(10) Y:CGRectGetMaxY(_matprice.frame) W:WGiveWidth(100) H:WGiveHeight(25)];
        
        NSString * _matVolume;
        if (_model.matVolume.length == 0) {
            _matVolume = @"体积：1立方米以下";
        }else if([_model.matVolume intValue] == 0){
            _matVolume = [NSString stringWithFormat:@"体积：1立方米以下"];
        }else{
            _matVolume = [NSString stringWithFormat:@"体积：%@",_model.matVolume];
        }
        [self CreatViewLabelWithtext:_matVolume textfont:FONT(14,NO) textcolor:[UIColor darkGrayColor] X:carLengthLabel.right+5 Y:CGRectGetMaxY(_matprice.frame) W:WINDOW_WIDTH-WGiveWidth(60)  H:WGiveHeight(25)];
        
        if (_model.matRemark && _model.matRemark.length > 0) {
            _remark = [self CreatViewLabelWithtext:@"备注:" textfont:FONT(14,NO) textcolor:[UIColor darkGrayColor] X:WGiveWidth(10) Y:CGRectGetMaxY(carLengthLabel.frame) W:WGiveWidth(40) H:WGiveHeight(25)];
             matView.height += WGiveHeight(25);
            [self CreatViewLabelWithtext:[NSString stringWithFormat:@"%@",_model.matRemark] textfont:FONT(14,NO) textcolor:[UIColor darkGrayColor] X:_remark.right +5 Y:CGRectGetMaxY(carLengthLabel.frame) W:WINDOW_WIDTH - WGiveWidth(60) H:WGiveHeight(25)];
        }else{
            _remark = [self CreatViewLabelWithtext:@"备注:" textfont:FONT(14,NO) textcolor:[UIColor darkGrayColor] X:WGiveWidth(10) Y:CGRectGetMaxY(carLengthLabel.frame) W:WGiveWidth(35) H:WGiveHeight(0)];
//            matView.height -= WGiveHeight(25);
            [self CreatViewLabelWithtext:[NSString stringWithFormat:@"%@",_model.matRemark] textfont:FONT(14,NO) textcolor:[UIColor blackColor] X:_remark.right +5 Y:CGRectGetMaxY(carLengthLabel.frame) W:WINDOW_WIDTH - WGiveWidth(60) H:WGiveHeight(0)];
        }
        
        matView.height -= WGiveHeight(25);
        if (![_model.limitTime isEqualToString:@""]) {
            _limitTimeLabel = [self CreatViewLabelWithtext:[NSString stringWithFormat:@"用户期望到达时间：%@",_model.limitTime] textfont:FONT(14,NO) textcolor:[UIColor orangeColor] X:WGiveWidth(10) Y:CGRectGetMaxY(_remark.frame) W:ScreenW H:WGiveHeight(25)];
            matView.height += WGiveHeight(25);
        }else{
            _limitTimeLabel = [self CreatViewLabelWithtext:[NSString stringWithFormat:@"用户期望到达时间：%@",_model.limitTime] textfont:FONT(14,NO) textcolor:[UIColor orangeColor] X:WGiveWidth(10) Y:CGRectGetMaxY(_remark.frame) W:ScreenW H:0];
        }
   }else{

       if (_model.matRemark && _model.matRemark.length > 0) {
           _remark = [self CreatViewLabelWithtext:@"备注:" textfont:FONT(14,NO) textcolor:[UIColor darkGrayColor] X:WGiveWidth(10) Y:CGRectGetMaxY(_matName.frame) W:WGiveWidth(40) H:WGiveHeight(25)];
           matView.height += WGiveHeight(25);
           [self CreatViewLabelWithtext:[NSString stringWithFormat:@"%@",_model.matRemark] textfont:FONT(14,NO) textcolor:[UIColor darkGrayColor] X:_remark.right +5 Y:CGRectGetMaxY(_matName.frame) W:WINDOW_WIDTH - WGiveWidth(60) H:WGiveHeight(25)];
       }else{
           _remark = [self CreatViewLabelWithtext:@"备注:" textfont:FONT(14,NO) textcolor:[UIColor darkGrayColor] X:WGiveWidth(10) Y:CGRectGetMaxY(_matName.frame) W:WGiveWidth(35) H:WGiveHeight(0)];
           //            matView.height -= WGiveHeight(25);
           [self CreatViewLabelWithtext:[NSString stringWithFormat:@"%@",_model.matRemark] textfont:FONT(14,NO) textcolor:[UIColor blackColor] X:_remark.right +5 Y:CGRectGetMaxY(_matName.frame) W:WINDOW_WIDTH - WGiveWidth(60) H:WGiveHeight(0)];
       }

       
    matView.height -= WGiveHeight(25);
    if (![_model.limitTime isEqualToString:@""]) {
       _limitTimeLabel = [self CreatViewLabelWithtext:[NSString stringWithFormat:@"用户期望到达时间：%@",_model.limitTime] textfont:FONT(14,NO) textcolor:[UIColor orangeColor] X:WGiveWidth(10) Y:CGRectGetMaxY(_remark.frame) W:ScreenW H:WGiveHeight(25)];
        matView.height += WGiveHeight(25);
    }else{
    _limitTimeLabel = [self CreatViewLabelWithtext:[NSString stringWithFormat:@"用户期望到达时间：%@",_model.limitTime] textfont:FONT(14,NO) textcolor:[UIColor orangeColor] X:WGiveWidth(10) Y:CGRectGetMaxY(_remark.frame) W:ScreenW H:0];
    }
 }
    if (_model.ifReplaceMoney && _model.replaceMoney.length >0 && ![_model.replaceMoney isEqualToString:@""]) {
        _replaceMoneyLabel = [self CreatViewLabelWithtext:[NSString stringWithFormat:@"代收款:%@元",_model.replaceMoney] textfont:FONT(14, NO) textcolor:[UIColor orangeColor] X:WGiveWidth(10) Y:CGRectGetMaxY(_limitTimeLabel.frame) W:ScreenW H:WGiveHeight(25)];
        matView.height += WGiveHeight(25);
    }
    
    //投诉按钮
    _touSuBtn = [self CreatBtnWithimage:@"tousu" SelectImage:@"tousu" Highlightedimage:@"" X:ScreenW-WGiveWidth(50) Y:CGRectGetMaxY(matView.frame)+WGiveHeight(10) W:WGiveHeight(35) H:WGiveHeight(35) tag:8];
    _touSuBtn.hidden = YES;
    
    //确认取货
    if ([_model.status intValue] < 3) {
        _SureButton = [self CreatBtnWithimage:@"quhuo_yes" SelectImage:@"quhuo_no" Highlightedimage:@"" X:WGiveWidth(50) Y:CGRectGetMaxY(matView.frame)+WGiveHeight(60) W:ScreenW-WGiveWidth(100) H:WGiveHeight(35) tag:4];
    }else {
        if (_model.ifReplaceMoney && !_model.ifTackReplace) {
            //代收款的订单
            _shouKuanBtn = [self CreatBtnWithimage:@"yishoukuanImg" SelectImage:@"yishoukuanImg" Highlightedimage:@"" X:ScreenW/2-(ScreenW-WGiveWidth(100))/4 Y:CGRectGetMaxY(matView.frame)+WGiveHeight(60) W:(ScreenW-WGiveWidth(100))/2 H:WGiveHeight(35) tag:11];
        }else if(_model.ifTackReplace){
            //完成订单
        _FinisheBtn = [self CreatBtnWithimage:@"wancheng_yes" SelectImage:@"wancheng_gray" Highlightedimage:@"chenggong_moren" X:WGiveWidth(50) Y:CGRectGetMaxY(matView.frame)+WGiveHeight(60) W:ScreenW-WGiveWidth(100) H:WGiveHeight(35) tag:5];
        }else{
            //完成订单
            _FinisheBtn = [self CreatBtnWithimage:@"wancheng_yes" SelectImage:@"wancheng_gray" Highlightedimage:@"chenggong_moren" X:WGiveWidth(50) Y:CGRectGetMaxY(matView.frame)+WGiveHeight(60) W:ScreenW-WGiveWidth(100) H:WGiveHeight(35) tag:5];
        }
    }
    //完成订单
//    _FinisheBtn = [self CreatBtnWithimage:@"wancheng_yes" SelectImage:@"wancheng_gray" Highlightedimage:@"chenggong_moren" X:WGiveWidth(50) Y:CGRectGetMaxY(_SureButton.frame)+WGiveHeight(30) W:ScreenW-WGiveWidth(100) H:WGiveHeight(35) tag:5];
    
    //我已就位
    _jiuWeiBtn = [self CreatBtnWithimage:@"jiuwei" SelectImage:@"jiuweiGray" Highlightedimage:@"" X:WGiveWidth(50) Y:CGRectGetMaxY(_SureButton.frame)+WGiveHeight(10) W:(ScreenW-WGiveWidth(100)-WGiveWidth(10))/2 H:WGiveHeight(35) tag:6];
    //货物违规
    _weiGuiBtn =[self CreatBtnWithimage:@"weigui" SelectImage:@"weigui" Highlightedimage:@"" X:CGRectGetMaxX(_jiuWeiBtn.frame)+WGiveWidth(10) Y:CGRectGetMaxY(_SureButton.frame)+WGiveHeight(10) W:_jiuWeiBtn.width H:WGiveHeight(35) tag:7];
}

- (void)dismiss{
    [UIView animateWithDuration:0.5 animations:^{
        _view.alpha = 0;
    } completion:^(BOOL finished) {
        [_view removeFromSuperview];
    }];
    
}
-(UILabel *)CreatViewLabelWithtext:(NSString *)text textfont:(UIFont *)font textcolor:(UIColor *)textcolor X:(CGFloat)x Y:(CGFloat)y W:(CGFloat)w H:(CGFloat)h
{
    
    UILabel *Label = [[UILabel alloc]initWithFrame:CGRectMake(x, y, w, h)];
    Label.text = text;
    Label.textColor=textcolor;
    Label.font = font;
    [_tableview addSubview:Label];
    
    return Label;
    
}
-(UIButton *)CreatBtnWithimage:(NSString *)image  SelectImage:(NSString *)selectimage  Highlightedimage:(NSString *)Highlightedimage X:(CGFloat)x Y:(CGFloat)y W:(CGFloat)w H:(CGFloat)h tag:(int)tag
{
    // btn
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(x, y, w, h)];
    btn.tag = tag;
    [btn setTitleColor:COLOR_ORANGE_DEFOUT forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [btn addTarget:self action:@selector(Clicktag:) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:selectimage] forState:UIControlStateSelected];
    [btn setImage:[UIImage imageNamed:Highlightedimage] forState:UIControlStateHighlighted];
    [_tableview addSubview:btn];
    return btn;
}
- (void)handlePanGes:(UIPanGestureRecognizer*)recognizer{
    
    CGPoint translation = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointZero inView:self.view];
}
#pragma mark  delegate
-(void)TXTradePasswordView:(TXTradePasswordView *)view WithPasswordString:(NSString *)Password{
    
    [self showTipView:[NSString stringWithFormat:@"密码为 : %@",Password]];
    self.pd = Password;
    
}


#pragma mark - show tip
- (void)showTipView:(NSString *)tip{
    
    LPPopup *popup = [LPPopup popupWithText:tip];
    popup.popupColor = [UIColor blackColor];
    popup.textColor = [UIColor whiteColor];
    
    [popup showInView:self.view
        centerAtPoint:self.view.center
             duration:kLPPopupDefaultWaitDuration
           completion:nil];
}
-(void)btnClick
{
    
    [self HideView];
    
    
}
 // 点击背景改变状态
-(void)clickCover

{
   
  
    
}

- (void)renwuChange
{
    NSLog(@"点击了_________密码请联系收件人");
    [self HideView];
   
    
}
//核对密码后 押镖完成
- (void)renwuFinish
{
    NSLog(@"点击了_________任务完成_____密码是：%@",self.pd);
    if (_pt.latitude == 0 || _pt.longitude == 0) {
        [SVProgressHUD showErrorWithStatus:@"定位失败，请检查定位设置或手机网络"];
        return ;
    }
    [SVProgressHUD show];
    [RequestManager ChecktransactionpasswordWithrecId:self.model.recId Withlat:[NSString stringWithFormat:@"%f",_pt.latitude] withLon:[NSString stringWithFormat:@"%f",_pt.longitude] dealPassword:self.pd success:^(id result) {
        [SVProgressHUD dismiss];
        NSString *msg = [NSString stringWithFormat:@"%@",result[@"message"]];
        [SVProgressHUD showSuccessWithStatus:msg];
        _SureButton.selected = YES;
        _FinisheBtn.selected = YES;
        [self HideView];
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH object:nil];

    }
            Failed:^(NSString *error) {
                                                 
                                                 [SVProgressHUD showErrorWithStatus:error];
                                                 
                                             }];
}
-(void)HideView
{
    [UIView animateWithDuration:0.3f animations:^{
        [mainView setFrame:CGRectMake(30, -300, 315, 200)];
    }];
    [txView.TF resignFirstResponder];
    isCLick = YES;
    mainView = nil;
    [visualEffectView removeFromSuperview];
}

- (void)Clicktag:(id)sender{
    
    UIButton *btn = (UIButton*)sender;
    switch (btn.tag) {
        case 0:
        {
            NSLog(@"导航至发件人，去取镖");
            [self startNavi:0];
        }
            break;
        case 1:
        {
            
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",_model.mobile];
            NSLog(@"str======%@",str);
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            NSLog(@"点击了给发件人打电话");
        }
            break;
        case 2:
        {
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",_model.mobileTo];
            NSLog(@"str======%@",str);
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            NSLog(@"点击了给收件人打电话");
            
        }
            break;
        case 3:
        {
            NSLog(@"导航去收件人,押镖");
            [self startNavi:1];
        }
            break;
            
        case 4:
        {
            NSLog(@"确定取货");
            //            _SureButton.enabled = NO;

            LXAlertView *alert=[[LXAlertView alloc]initWithTitle:@"温馨提示" message:@"1.根据公安部规定，禁止押运易燃易爆，一切与毒品有关物品。\r2.请认真检查货物是否完整，是否符合安全规定。\r3.请确认货主身份信息，是否与平台信息一致。" cancelBtnTitle:@"" otherBtnTitle:@"收货成功" clickIndexBlock:^(UIButton *btn) {
                for (UIView *view in alert.subviews){
                    if ([view isKindOfClass:[UILabel class]]) {
                        UILabel *label = (UILabel *)view;
                        label.textAlignment = NSTextAlignmentLeft;
                    }
                }
                if (btn.tag == 0) {
                    btn.selected = !btn.selected;
                    if (btn.selected) {
                        [btn setBackgroundImage:[UIImage imageNamed:@"yiyanshou_bar"] forState:UIControlStateNormal];
                    }else{
                        [btn setBackgroundImage:[UIImage imageNamed:@"n0yanshou_bar"] forState:UIControlStateNormal];
                    }
                }else{
                    //勾选了验货
                    if (btn.selected) {
                        _SureButton.selected = YES;
                        _FinisheBtn.highlighted = YES;
                        
                        NSLog(@" 取货");
                        if (_pt.latitude == 0 || _pt.longitude == 0) {
                            [SVProgressHUD showErrorWithStatus:@"定位失败，请检查定位设置或手机网络"];
                            return ;
                        }
                        
                        [RequestManager sendDriverPickpasswordWithrecId:self.model.recId Withlat:[NSString stringWithFormat:@"%f",_pt.latitude] withLon:[NSString stringWithFormat:@"%f",_pt.longitude]withCarNum:@""  success:^(NSMutableArray *result) {
                            
                            [SVProgressHUD showSuccessWithStatus:@"取件成功，密码已发给收件人"];
                            [self.navigationController popViewControllerAnimated:YES];
                            [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH object:nil];
                            _SureButton.userInteractionEnabled = NO;
                            _SureButton.selected = YES;
                            _FinisheBtn.userInteractionEnabled = YES;
                            _FinisheBtn.selected = NO;
                            _jiuWeiBtn.hidden = YES;
                            _weiGuiBtn.hidden = YES;
                            
                        }
                         Failed:^(NSString *error) {
                             [SVProgressHUD showErrorWithStatus:error];
                        }];
                    }else{
                        //未勾选验货
                        NSLog(@"未勾选验货");
                    }
                }
            }];
            [alert.cancelBtn setBackgroundImage:[UIImage imageNamed:@"n0yanshou_bar"] forState:0];
            alert.animationStyle=LXASAnimationLeftShake;
            [alert showLXAlertView];
        }
            break;
            
        case 5:
        {
            NSLog(@"押镖完成");
//            _FinisheBtn.selected = YES;
//            _SureButton.selected = YES;
            if (isCLick) {
                [self initMainView];
                [UIView animateWithDuration:0.3f animations:^{
                    [mainView setFrame:CGRectMake(margin, 50, WINDOW_WIDTH - 2*margin, 200)];
                }];
                [txView.TF becomeFirstResponder];
                isCLick = NO;
            } else {
                [UIView animateWithDuration:0.3f animations:^{
                    [mainView setFrame:CGRectMake(margin, -300, WINDOW_WIDTH - 2*margin, 200)];
                }];
                [txView.TF resignFirstResponder];
                isCLick = YES;
                mainView = nil;
                [visualEffectView removeFromSuperview];
            }
            
        }
            break;
        case 6:
        {
            NSLog(@"我已就位啦~~");
            /*
             downwind/task/onReady
             请求 GET
             参数 Integer recId（顺风单号）,Double readyLatitude就位地纬度,Double readyLongitude就位地经度
             
             */
            float lat =  _pt.latitude;
            float lon =  _pt.longitude;
            NSString * urlStr = [NSString stringWithFormat:@"%@%@?recId=%@&readyLatitude=%f&readyLongitude=%f",BaseUrl,API_DOWNWIND_TASK_ONREADY,_model.recId,lat,lon];
           [ ExpressRequest sendWithParameters:nil MethodStr:urlStr reqType:k_GET success:^(id object) {
               
               _jiuWeiBtn.selected = YES;
               _jiuWeiBtn.userInteractionEnabled = NO;
           } failed:^(NSString *error) {
                [SVProgressHUD showErrorWithStatus:error];
            }];
        }
            break;
        case 7:
        {
            NSLog(@"货物违规~~~");
            __weak OperationViewController * weakSelf = self;
            _huowuWeiguiView =[[NSBundle mainBundle] loadNibNamed:@"HuowuWeiguiView" owner:nil options:nil].firstObject;
            _huowuWeiguiView.frame = [UIApplication sharedApplication].windows.lastObject.bounds;
            [[[UIApplication sharedApplication] keyWindow] addSubview:_huowuWeiguiView];
            _huowuWeiguiView.huowuImg.delagate = self;
            _huowuWeiguiView.huowuImg.layer.cornerRadius =0.0;
            _huowuWeiguiView.huowuImg.image = [UIImage imageNamed:@"zhaopianKuang"];
            _huowuWeiguiView.block =^(NSInteger tag){
                [weakSelf sendBtnClick:tag];
            };
        }
            break;
        case 8:
        {
            NSLog(@"镖师投诉用户");
            __weak OperationViewController * weakSelf = self;
            _touSuView  = [[NSBundle mainBundle] loadNibNamed:@"TouSuView" owner:nil options:nil].firstObject;
            _touSuView.frame = [UIApplication sharedApplication].windows.lastObject.bounds;
            [[[UIApplication sharedApplication] keyWindow] addSubview:_touSuView];
            _touSuView.tousuImg.delagate = self;
            _touSuView.tousuImg.layer.cornerRadius = 0.0;
            _touSuView.tousuImg.image = [UIImage imageNamed:@"zhaopianKuang"];
            _touSuView.block =^(NSInteger tag){
                [weakSelf sendBtnClick:tag];
            };

        }
            break;
        case 11:{
        //我已收款  driver/tackReplayMoney
            _shouKuanAlert = [[[NSBundle mainBundle] loadNibNamed:@"DaiShouKuanAlert" owner:self options:nil] lastObject];
            _shouKuanAlert.noticeLabel.text = @"确认收款后，平台将会把冻结的相应金额支付给发件人。";
            _shouKuanAlert.leftDistanceConstraint.constant = 44.0;
            _shouKuanAlert.topDistanceConstraint.constant = 40.0;
            [_shouKuanAlert.sureBtn setTitle:@"确认" forState:UIControlStateNormal];
            [_shouKuanAlert.sureBtn addTarget:self action:@selector(wiyiShoukuan) forControlEvents:UIControlEventTouchUpInside];
            [_shouKuanAlert show];

        }
            break;
    }
}
#pragma mark ------我已收款
-(void)wiyiShoukuan{
    [SVProgressHUD show];
    NSString * urlStr = [NSString stringWithFormat:@"%@%@?recId=%@",BaseUrl,API_DRIVER_TAKEReplayMoney,_model.recId];
    [ExpressRequest sendWithParameters:nil MethodStr:urlStr reqType:k_GET success:^(id object) {
        _model.ifTackReplace = YES;
//        [self chargeBtnIfEnable ];
        _shouKuanBtn.hidden = YES;
    _FinisheBtn = [self CreatBtnWithimage:@"wancheng_yes" SelectImage:@"wancheng_gray" Highlightedimage:@"chenggong_moren" X:WGiveWidth(50) Y:CGRectGetMaxY(matView.frame)+WGiveHeight(60) W:ScreenW-WGiveWidth(100) H:WGiveHeight(35) tag:5];
        [SVProgressHUD dismiss];
        [_shouKuanAlert dismiss];
    } failed:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _huowuWeiguiView.hidden = YES;
    _touSuView.hidden = YES;
}

-(void)headerView:(YMHeaderView *)headerView didSelectWithImage:(UIImage *)image{

    switch (headerView.tag) {
        case 0:{
            _huowuWeiguiView.hidden = NO;
            [SVProgressHUD showWithStatus:@"正在上传"];
            NSDictionary *dic = @{k_USER_ID:[UserManager getDefaultUser].userId,k_FILE_NAME:@"huowuweigui.png"};
            NSDictionary *fileDic = @{@"data":image,@"fileName":@"huowuweigui.png"};
            
            NSString *api =@"file/illegal";
            [ExpressRequest sendWithParameters:dic MethodStr:api
                                       fileDic:fileDic
                                       success:^(id object) {
                                           [SVProgressHUD showSuccessWithStatus:@"上传成功"];
                                           _illegalUrl = [([object objectForKey:@"data"][0]) valueForKey:@"filePath"];
                                       } failed:^(NSString *error) {
                                           [SVProgressHUD showErrorWithStatus:error];
                                       }];
        }
            break;
        case 1:{
            _touSuView.hidden = NO;
            [SVProgressHUD showWithStatus:@"正在上传"];
            NSDictionary *dic = @{k_USER_ID:[UserManager getDefaultUser].userId,k_FILE_NAME:@"tousu.png"};
            NSDictionary *fileDic = @{@"data":image,@"fileName":@"tousu.png"};
            NSString *api =@"file/accusation";
            [ExpressRequest sendWithParameters:dic MethodStr:api
                                       fileDic:fileDic
                                       success:^(id object) {
                                           [SVProgressHUD showSuccessWithStatus:@"上传成功"];
                                           _accusationUrl = [([object objectForKey:@"data"][0]) valueForKey:@"filePath"];
                                       } failed:^(NSString *error) {
                                           [SVProgressHUD showErrorWithStatus:error];
                                       }];
        }
            break;
            default:
            break;
    }
   }

-(void)sendBtnClick:(NSInteger)tag{
    switch (tag) {
        case 0:{
            /*
             货物违规按钮
             路径driver/removeDow
             请求 GET
             参数 Integer recId（顺风单号）,String illegalImageUrl（上传图片的路径，若镖师不上传就传NUll）
             */
            
            NSString * urlStr = [NSString stringWithFormat:@"%@%@?recId=%@&illegalImageUrl=%@",BaseUrl,API_DOWNWIND_DRIVER_REMOVEDOW,_model.recId,_illegalUrl?_illegalUrl:@""];
            [ExpressRequest sendWithParameters:nil MethodStr:urlStr reqType:k_GET success:^(id object) {
                [self.navigationController popViewControllerAnimated:YES];
                [_huowuWeiguiView removeFromSuperview];
            } failed:^(NSString *error) {
                [SVProgressHUD showErrorWithStatus:error];
            }];
        }
            break;
        case 2:{
            /*
             用户投诉
             路径 feedback/accusation
             请求 POST
             参数 private Integer userId;//用户ID -- 投诉人
             private Integer toUserId;//被投诉人  Id   从订单中获得
             private Integer type;//投诉类型  1 顺风 - 用户投诉镖师  2 顺风 - 镖师投诉用户 3 快递 - 用户投诉快递员  4 快递 - 快递员投诉用户 5 物流 用户投诉公司6  物流 - 公司 投诉 用户
             private String details;//详情描述 -- 投诉内容
             private Integer toRecId;// 被投诉单子的主键
             private String imageUrl;//上传图片url
             */
           
            NSDictionary * dic =@{@"userId":[UserManager getDefaultUser].userId,
                                  @"toUserId":_model.userId,
                                  @"details":_touSuView.tousuTextView.text,
                                  @"toRecId":_model.recId,
                                  @"imageUrl":_accusationUrl?_accusationUrl:@"",
                                  @"type":@"2"
                                  };
            [ExpressRequest sendWithParameters:dic MethodStr:API_DOWNWIND_FEEDBACK_ACCUSATION reqType:k_POST success:^(id object) {
                [_touSuView removeFromSuperview];
                [self.navigationController popViewControllerAnimated:YES];
            } failed:^(NSString *error) {
                [SVProgressHUD showErrorWithStatus:error];
            }];
        
        }
            break;
        default:
            break;
    }


}

- (void)configNavgationBar {
    self.view.backgroundColor =[UIColor whiteColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 60)];
    label.textColor = [UIColor whiteColor];
    label.text = @"镖件详情";
    label.textAlignment = 1;
    self.navigationItem.titleView = label;
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(backToMenuView)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    if ([_model.status integerValue] == 2) {
       
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消订单" style:UIBarButtonItemStylePlain target:self action:@selector(Cancel)];
        rightBarButtonItem.tintColor =[UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;

    }
}
- (void)backToMenuView{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)Cancel
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定取消吗？" message:@"取消订单将罚款10元补偿给用户。" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        [RequestManager refundReimburseWithrecId:self.model.recId success:^(NSMutableArray *result) {
            [SVProgressHUD showSuccessWithStatus:@"取消成功"];
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH object:nil];
            
        } Failed:^(NSString *error) {
            [SVProgressHUD showErrorWithStatus:error];
        }];

    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        NSLog(@"点击了取消按钮");
        
    }]];
}

- (void)setMohu{
    if (visualEffectView != nil) {
        return;
    }
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    visualEffectView.frame = self.view.bounds;
    visualEffectView.alpha = 0.6;
}

//发起导航
- (void)startNavi:(int)tag
{
//    //节点数组
//    NSMutableArray *nodesArray = [[NSMutableArray alloc]    initWithCapacity:2];
//    
//    //起点
//    BNRoutePlanNode *startNode = [[BNRoutePlanNode alloc] init];
//    startNode.pos = [[BNPosition alloc] init];
//    //    startNode.pos.x = 113.936392;
//    //    startNode.pos.y = 22.547058;
//    //    startNode.pos.eType = BNCoordinate_BaiduMapSDK;
//    startNode.pos.x = [[[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCATION_LON] doubleValue];
//    startNode.pos.y = [[[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCATION_LAT] doubleValue];
//    startNode.pos.eType = BNCoordinate_BaiduMapSDK;
//    [nodesArray addObject:startNode];
//    
//    //终点
//    BNRoutePlanNode *endNode = [[BNRoutePlanNode alloc] init];
//    endNode.pos = [[BNPosition alloc] init];
//    //    endNode.pos.x = 114.077075;
//    //    endNode.pos.y = 22.543634;
//    //    endNode.pos.eType = BNCoordinate_BaiduMapSDK;
//    endNode.pos.x = [_model.fromLongitude doubleValue];
//    endNode.pos.y = [_model.fromLatitude doubleValue];
//    if (tag != 0) {
//        endNode.pos.x = [_model.toLongitude doubleValue];
//        endNode.pos.y = [_model.toLatitude doubleValue];
//    }
//    endNode.pos.eType = BNCoordinate_BaiduMapSDK;
//    [nodesArray addObject:endNode];
//    //发起路径规划
//    [BNCoreServices_RoutePlan startNaviRoutePlan:BNRoutePlanMode_Recommend naviNodes:nodesArray time:nil delegete:self userInfo:nil];
}


/**
 *  算路成功回调
 *
 *  @param userInfo 发起算路时用户传入的参数
 */
- (void)routePlanDidFinished:(NSDictionary*)userInfo{
    NSLog(@"算路成功");
    
    //路径规划成功，开始导航
//    [BNCoreServices_UI showNaviUI: BN_NaviTypeReal delegete:self isNeedLandscape:YES];
}


/**
 *  算路失败回调
 *
 *  @param error    错误对象，可从error.code查看原因
 *  @param userInfo 发起算路时用户传入的参数
 */
- (void)routePlanDidFailedWithError:(NSError *)error andUserInfo:(NSDictionary*)userInfo{
    
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
