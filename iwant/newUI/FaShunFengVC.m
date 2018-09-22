//
//  FaShunFengVC.m
//  iwant
//
//  Created by 公司 on 2017/2/11.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "FaShunFengVC.h"
#import "FaBiaoPersonView.h"
#import "MainHeader.h"
#import "AddressViewController.h"
#import "TopBarView.h"
#import "FaBiaoGoodsInfoView.h"
#import "EcoinWebViewController.h"
#import "ShunFeng.h"
#import "MHDatePicker.h"
#import "PayView.h"
#import  "CouponViewController.h"
#import "CouponTableViewCell.h"
#import "Wallet.h"
#import "WXApi.h"
#import "AlipayHeader.h"
#import "WXPayManager.h"
#import "RechargeViewController.h"
#import "LocationViewController.h"

#import "PublishWindOne.h"
#import "PublishWindTwo.h"
#import "PublishWindThree.h"
#import "PublishSFOne.h"
#import "PublishSFTwo.h"

@interface FaShunFengVC ()<UITableViewDelegate,UITableViewDataSource>{
    
    UIScrollView * _scrollerView;
    FaBiaoPersonView * _sendInfoView;
    FaBiaoPersonView * _reciveInfoView;
    FaBiaoGoodsInfoView * _goodsInfoView;
    
    PublishSFOne * _publishOne;
    PublishSFTwo * _publishTwo;
    PublishWindThree * _publishThree;
    
    NSString * _time;
    NSString *_ifInsure;  //是否投保
    NSString *_insuerCost;  //投保金额
    NSString *_filePath;
    NSString *_transferMoney;//需要支付（没扣除现金券之前）的总费用
    NSString * _premium;  //保额

    
    NSString *_ifReplaceMoney;//是否代收货款
    
    NSString * _length;
    NSString * _carTypeStr;
    
    NSString * _carLength;
    NSString * _matVolume;
    //现金券
    NSString *_couponId;
    int _payType;//1-余额 2-微信 3-支付宝
    PayView *_payView;
    
    ShunFeng * _shunfengModel;
    NSString * _recId;
    
}

@property (nonatomic,strong) ShunFeng * model;
@property (strong, nonatomic) MHDatePicker *selectTimePicker;
@property (strong, nonatomic)  UITableView *couponTableView;
@property (strong, nonatomic)  NSMutableArray *couponArray;

@end

@implementation FaShunFengVC

//现金券列表
-(UITableView *)couponTableView{
    if (!_couponTableView) {
        
        _couponTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH - 90,WINDOW_WIDTH == 320 ? 70 : 96 ) style:UITableViewStylePlain];
        
        _couponTableView.delegate = self;
        _couponTableView.dataSource = self;
        _couponTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _couponTableView.backgroundColor = [UIColor whiteColor];
    }
    return _couponTableView;
}

-(NSMutableArray *)couponArray{
    if (!_couponArray) {
        _couponArray = [NSMutableArray array];
    }
    return _couponArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _length = @"10";
    _ifInsure = @"N";
    _ifReplaceMoney = @"0";
    _carLength = @"1";
    _matVolume = @"";
    
    [self initUI];
    _model = [[ShunFeng alloc]init];
    [self firstFill];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goHome) name:WECHAT_BACK_SF object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(islogin) name:ISLOGIN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(islogout) name:ISLOGOUT object:nil];

}

-(void)initUI{
    __weak FaShunFengVC * weakSelf = self;
    //允许改变层级
    self.view.autoresizesSubviews = YES;
    _scrollerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (SCREEN_WIDTH == 320) {
        _scrollerView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+100);
    }

    _publishOne = [[[NSBundle mainBundle] loadNibNamed:@"PublishSFOne" owner:nil options:nil] lastObject];
    _publishOne.frame = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _publishOne.BlockOne = ^(int tag){
        [weakSelf sendBtnClick:tag];
    };
    _publishOne.BlockCarLength = ^(NSString * carLength){
        _carLength = carLength;
    };
    _publishOne.BlockMatVolume = ^(NSString * matVolume){
        _matVolume = matVolume;
    };
    
    _publishTwo = [[[NSBundle mainBundle] loadNibNamed:@"PublishSFTwo" owner:nil options:nil] lastObject];
    _publishTwo.frame = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _publishTwo.BlockTwo = ^(int tag){
        [weakSelf receiveBtnClick:tag];
    };
    
    [_scrollerView addSubview:_publishTwo];
    [self.view addSubview:_scrollerView];
    [self.view addSubview:_publishOne];
}

-(void)firstFill{
    _publishOne.startTextField.text = [[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCASTR];
    _publishTwo.sendNameTextField.text = [UserManager getDefaultUser].userName;
    _publishTwo.sendPhoneTextField.text = [UserManager getDefaultUser].mobile;
    _model.fromLongitude = [[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCATION_LON] ;
    _model.fromLatitude = [[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCATION_LAT];
    _model.cityCode = [[NSUserDefaults standardUserDefaults] valueForKey:USER_CITY_CODE];
    _model.townCode = [[NSUserDefaults standardUserDefaults] valueForKey:USER_TOWN_CODE];
}

-(void)sendBtnClick:(int) tag{
//    __weak FaShunFengVC * weakSelf = self;
    switch (tag) {
        case 1:
        {
            LocationViewController *addVC = [[LocationViewController alloc]init];
            addVC.passBlock = ^(NSString *address,NSString *name,NSString *la,NSString *lon,NSString *cityCode,NSString *cityName,NSString *townCode,NSString *townName){
                _publishOne.startTextField.text = [NSString stringWithFormat:@"%@%@",address,name];
                _model.address = [NSString stringWithFormat:@"%@%@",address,name];
                _model.fromLatitude = la;
                _model.fromLongitude = lon;
                _model.cityCode = cityCode;
                _model.townCode = townCode;
            };
            [self.navigationController pushViewController:addVC animated:YES];
        }
            break;
        case 2:
        {
            LocationViewController *addVC = [[LocationViewController alloc]init];
            addVC.passBlock = ^(NSString *address,NSString *name,NSString *la,NSString *lon,NSString *cityCode,NSString *cityName,NSString *townCode,NSString *townName){
                _publishOne.endTextField.text= [NSString stringWithFormat:@"%@%@",address,name];
                _model.addressTo = [NSString stringWithFormat:@"%@%@",address,name];
                _model.toLatitude = la;
                _model.toLongitude = lon;
                _model.cityCodeTo = cityCode;
            };
            [self.navigationController pushViewController:addVC animated:YES];
        }
            break;
        case 3:
        {
            if (_publishOne.startTextField.text.length == 0) {
                [SVProgressHUD showErrorWithStatus:@"请选择发件人地址"];
                return;
            }
            if (_publishOne.endTextField.text.length == 0) {
                [SVProgressHUD showErrorWithStatus:@"请选择收件人地址"];
                return;
            }
            if (_publishOne.goodsNameTextField.text.length == 0) {
                [SVProgressHUD showErrorWithStatus:@"请填写物品名称"];
                return;
            }
            if(_publishOne.weightTextField.text.length == 0){
                [SVProgressHUD showErrorWithStatus:@"请填写货物重量"];
                return;
            }
            [self.view bringSubviewToFront:_scrollerView];
        }
            break;
        }
}
-(void)receiveBtnClick:(int)tag{
    __weak FaShunFengVC * weakSelf = self;
    switch (tag) {
        case 1:
        {
            [Contacts judgeAddressBookPowerWithUIViewController:self contactsBlock:^(NSString *name, NSString *phoneNumber) {
                _publishTwo.sendNameTextField.text = name;
                _publishTwo.sendPhoneTextField.text = phoneNumber;

            }];
        }
            break;
        case 2:
        {
            [Contacts judgeAddressBookPowerWithUIViewController:self contactsBlock:^(NSString *name, NSString *phoneNumber) {
                _publishTwo.receiveNameTextField.text = name;
                _publishTwo.receivePhoneTextField.text = phoneNumber;
                
            }];
        }
            break;
        case 3:
        {
            [self.view bringSubviewToFront:_publishOne];
        }
            break;
        case 4:
        {
            [self sureSend];
        }
            break;
        case 5:
        {
            EcoinWebViewController *vc = [[EcoinWebViewController alloc]init];
            vc.web_type = WEB_insureSF;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 6:
        {
            if (_publishTwo.toubaoBtn.selected) {
                _ifInsure = @"Y";
            }else{
                _ifInsure = @"N";
            }
        }
            break;
        case 7:
        {
            //是否代收货款
            if (_publishTwo.replaceMoneyBtn.selected) {
                _ifReplaceMoney = @"1";
            }else{
                _ifReplaceMoney = @"0";
            }
        }
            break;
        case 8:{
            _selectTimePicker = [[MHDatePicker alloc] init];
            _selectTimePicker.minSelectDate  = [[NSDate date] dateByAddingTimeInterval:5*60];
            _selectTimePicker.selectDate = [[NSDate date] dateByAddingTimeInterval:5*60];
            __weak typeof(self) weakSelf = self;
            [_selectTimePicker didFinishSelectedDate:^(NSDate *selectedDate) {
                _publishTwo.useTimeTextfield.text = [weakSelf dateStringWithDate:selectedDate DateFormat:@"MM月dd日 HH:mm"];
                
                _time = [[NSString alloc]init];
                _time = [weakSelf dateStringWithDate:selectedDate DateFormat:@"MM-dd HH:mm"];
            }];        
        }
            break;
        default:
            break;
    }
}

- (NSString *)dateStringWithDate:(NSDate *)date DateFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    NSString *str = [dateFormatter stringFromDate:date];
    return str ? str : @"";
}

-(void)carTypeBtnClick:(int)tag{
    switch (tag) {
        case 0:
            _carTypeStr =@"smallMinibus";
            break;
        case 1:
            _carTypeStr =@"middleMinibus";
            break;
        case 2:
            _carTypeStr =@"smallTruck";
            break;
        case 3:
            _carTypeStr =@"middleTruck";
            break;
        default:
            break;
    }
    [UIView animateWithDuration:0.35 animations:^{
        _publishThree.y = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        [_publishThree removeFromSuperview];
        [self sureSend];
    }];
}

-(void)sureSend{
    if (![self checkParem]) {
    return;
    }
    [SVProgressHUD show];
    NSString * address =  [_publishOne.startTextField.text stringByAppendingString:_publishOne.startDetailTextField.text];
    NSString * addressTo = [NSString stringWithFormat:@"%@%@",_publishOne.endTextField.text,_publishOne.endDetailTextField.text];
    
   [RequestManager SendtailWindMissionWithUserId:[UserManager getDefaultUser].userId
                                     latitude:[[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCATION_LAT]
                                    longitude:[[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCATION_LON]
                                   personName:_publishTwo.sendNameTextField.text
                                       mobile:_publishTwo.sendPhoneTextField.text
                                      address:address
                                        cityCode:_model.cityCode ? _model.cityCode :@""
                                        townCode:_model.townCode ?_model.townCode :@""
                                     deviceId:nil
                                 fromLatitude:_model.fromLatitude ? _model.fromLatitude : @""
                                fromLongitude:_model.fromLongitude ? _model.fromLongitude :@""
                                 personNameTo:_publishTwo.receiveNameTextField.text
                                     mobileTo:_publishTwo.receivePhoneTextField.text
                                    addressTo:addressTo
                                   cityCodeTo:_model.cityCodeTo ? _model.cityCodeTo:@""
                                   toLatitude:_model.toLatitude ? _model.toLatitude:@""
                                  toLongitude:_model.toLongitude ?_model.toLongitude:@""
                                      matName:_publishOne.goodsNameTextField.text
                                  matImageUrl:_model.matImageUrl ?_model.matImageUrl:@""
                                    matRemark:_publishTwo.remarkTextField.text
                                    matWeight:_publishOne.weightTextField.text
                                       length:_length
                                        width:@""
                                       height:@""
                                      whether:_ifInsure
                                      premium:_publishTwo.toubaoBtn.selected ? _publishTwo.goodsValueTextField.text : @""
                               ifReplaceMoney:_ifReplaceMoney
                                 replaceMoney:_publishTwo.replaceMoneyTextField.text
                                    matVolume:_matVolume
                                    carLength:_carLength
                                    useTime:_time
                                      success:^(NSMutableArray *result) {
                                          [SVProgressHUD dismiss];
                                          double temp = [result[0][@"transferMoney"] doubleValue];
                                          _transferMoney = [NSString stringWithFormat:@"%0.2f",temp];
                                          double temp2 = [result[0][@"insureCost"] doubleValue];
                                          _insuerCost = [NSString stringWithFormat:@"%0.2f",temp2];
                                          _premium = result[0][@"premium"];
                                          _shunfengModel = [[ShunFeng alloc]initWithJsonDict:result[0]];
                                          _model.billCode = result[0][@"billCode"];
                                          [self CreatPopView:_transferMoney];
                                          _recId = result[0][@"recId"];
                                        } Failed:^(NSString *error) {
                                          [SVProgressHUD showErrorWithStatus:error];
                                          NSLog(@"顺风任务发布失败");
                                      }];
}

- (BOOL)checkParem{
    NSString *alert = nil;
    
    if ( _publishTwo.sendPhoneTextField.text.length != 11) {
        alert = @"请输入正确的发件人手机号";
    }
    
    if ( [_publishTwo.sendNameTextField.text isEqualToString:@""]) {
        alert = @"请输入发件人姓名";
    }
    
    if ( [_publishTwo.receivePhoneTextField.text isEqualToString:@""]) {
        alert = @"请输入收件人手机号";
    }
    
    if (_publishTwo.receivePhoneTextField.text.length != 11) {
        alert = @"请输入正确的收件人手机号";
    }
    if ( [_publishTwo.receivePhoneTextField.text isEqualToString:@""]) {
        alert = @"请输入收件人姓名";
    }
    
    if ( [_ifInsure isEqualToString:@"Y"]&&[_publishTwo.goodsValueTextField.text isEqualToString:@""]) {
        alert = @"请输入货物价值";
    }
    if (alert) {
        [SVProgressHUD showErrorWithStatus:alert];
        return NO;
    }
    
    _model.latitude = [[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCATION_LAT];
    _model.longitude = [[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCATION_LON];
    _model.personName = _publishTwo.sendNameTextField.text;
    _model.mobile = _publishTwo.sendPhoneTextField.text;
    _model.matName = _publishOne.goodsNameTextField.text;
    _model.personNameTo = _publishTwo.receiveNameTextField.text;
    _model.mobileTo = _publishTwo.receiveNameTextField.text;
    return YES;
}
-(void)CreatPopView:(NSString *)money
{
    NSString *yunfei = [NSString stringWithFormat:@"%0.2f",([_transferMoney doubleValue] - [_insuerCost doubleValue])];
    _couponId = @"";
    _payType = 0;
    _payView = [[[NSBundle mainBundle] loadNibNamed:@"PayView" owner:nil options:nil] lastObject];
    NSString * distance =[NSString stringWithFormat:@"%0.2f", [_shunfengModel.distance floatValue]/1000];

    [_payView setModel:[NSArray arrayWithObjects:@"顺风镖",[NSString stringWithFormat:@"%@元",yunfei],[NSString stringWithFormat:@"%@元(保额：%@元)",_insuerCost,_premium],[NSString stringWithFormat:@"%@",_transferMoney],distance,nil]];
    __weak PayView *weakPayView = _payView;
    weakPayView.tag = 0;
    _payView.width = WINDOW_WIDTH;
    if (_shunfengModel.ifReplaceMoney) {
        _payView.daishouHuokuanL.hidden = NO;
        _payView.replaceMoneyLabel.hidden = NO;
        _payView.replaceMoneyLabel.text =[NSString stringWithFormat:@"%@元", _shunfengModel.replaceMoney];
    }else{
        _payView.daishouHuokuanL.hidden = YES;
        _payView.replaceMoneyLabel.hidden = YES;
    }
    if ([_shunfengModel.whether isEqualToString:@"N"]) {
        _payView.insureLable.hidden = YES;
        _payView.insuerMoney.hidden = YES;
        _payView.topDiatanceConstraint.constant =0;
    }else{
        _payView.insureLable.hidden = NO;
        _payView.insuerMoney.hidden = NO;
        _payView.topDiatanceConstraint.constant =15;
    }

    _payView.block = ^(NSInteger tag){
        
        switch (tag) {
            case 0:
            {
                if (!weakPayView.couponSwitch.isOn) {
                    _couponId = @"";
                    [weakPayView setModel:[NSArray arrayWithObjects:@"顺风镖",[NSString stringWithFormat:@"%@元",yunfei],[NSString stringWithFormat:@"%@元(保额：%@元)",_insuerCost,_premium],[NSString stringWithFormat:@"%@",_transferMoney],distance,nil]];
                    _couponArray = nil;
                    [self.couponTableView reloadData];
                    weakPayView.weixinBtn.enabled = YES;
                    weakPayView.alipayBtn.enabled = YES;
                    weakPayView.yueBtn.selected = NO;
                    
                }else{
                    weakPayView.hidden = YES;
                    weakPayView.overlayView.hidden = YES;
                    weakPayView.btn.hidden = YES;
                    CouponViewController *couVC = [[CouponViewController alloc]init];
                    couVC.isPay = YES;
                    couVC.needMoney = _transferMoney;
                    couVC.billcode = _model.billCode;
                    couVC.shunfengBlock = ^(NSString *couponName,NSMutableArray *_selectArray){
                        //选取了快递券
                        if (![couponName isEqualToString:@""] && ![couponName isEqualToString:@"&"]) {
                            weakPayView.couponSwitch.on = YES;
                            [weakPayView.table addSubview:self.couponTableView];
                            _couponArray = _selectArray;
                            [self.couponTableView reloadData];
                            _couponId = [NSString stringWithFormat:@"%@",couponName];
                            _payType = 1;
                            weakPayView.weixinBtn.enabled = NO;
                            weakPayView.alipayBtn.enabled = NO;
                            weakPayView.weixinBtn.selected = NO;
                            weakPayView.alipayBtn.selected = NO;
                            weakPayView.yueBtn.selected = YES;
                        }else{
                            //进到快递券界面 ，为选取快递券
                            weakPayView.couponSwitch.on = NO;
                            _couponArray = nil;
                            [self.couponTableView reloadData];
                            _couponId = @"";
                            weakPayView.weixinBtn.enabled = YES;
                            weakPayView.alipayBtn.enabled = YES;
                        }
                        
                        weakPayView.hidden = NO;
                        weakPayView.btn.hidden = NO;
                        weakPayView.overlayView.hidden = NO;
                        [weakPayView reloadDataWithCoupon:_selectArray];
                    };
                    
                    [self.navigationController pushViewController:couVC animated:YES];
                }
                
            }
                break;
            case 1:
            {
                _payType = 1;
            }
                break;
            case 2:
            {
                _payType = 2;
            }
                break;
            case 3:
            {
                _payType = 3;
            }
                break;
            case 4:
            {
                [self tapBtn:_payType];
            }
                break;
            default:
                break;
        }
    };
    [_payView show];
    
}
- (void)tapBtn:(int)tag{
    
    if (tag == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择支付方式"];
        return;
    }
    switch (tag) {
        case 2:
        {
            if (_couponId && _couponId.length > 0) {
                [SVProgressHUD showErrorWithStatus:@"现金券仅限余额支付使用!"];
                return;
            }
            
            NSLog(@"微信支付");
            [SVProgressHUD show];
            
            [RequestManager getWXPreWithBillCode:_model.billCode
                                         matName:@""
                                         matType:@""
                                    insuranceFee:@""
                                     insureMoney:@""
                                    needPayMoney:_transferMoney
                                       shipMoney:@""
                                          weight:@""
                                         success:^(NSDictionary *object) {
                                             NSLog(@"%@",object);
                                             
                                             PayReq* req = [[PayReq alloc] init];
                                             req.partnerId           = [object valueForKey:@"partnerId"];
                                             req.prepayId            = [object valueForKey:@"prepayid"];
                                             req.nonceStr            = [object valueForKey:@"nonceStr"];
                                             req.timeStamp           = [[object valueForKey:@"timestamp"] intValue];
                                             req.package             = [object valueForKey:@"package_"];
                                             req.sign                = [object valueForKey:@"sign"];
                                             [WXApi sendReq:req];
                                             WXPayManager *wxManager = [WXPayManager shareManager];
                                             wxManager.billCode = _model.billCode;
                                             
                                         } Failed:^(NSString *error) {
                                             [SVProgressHUD showErrorWithStatus:error];
                                         }];
           }
            break;
        case 3:
        {
            if (_couponId && _couponId.length > 0) {
                [SVProgressHUD showErrorWithStatus:@"现金券仅限余额支付使用!"];
                return;
            }
            NSLog(@"支付宝支付");
            [AlipayRequestConfig alipayWithPartner:kPartnerID seller:kSellerAccount tradeNO:_model.billCode productName:@"镖王" productDescription: @"快递费" amount:_transferMoney notifyURL:kNotifyURL itBPay:@"30m" standbyCallback:^(NSDictionary *resultDic)
             {
                 if ([[resultDic objectForKey:@"resultStatus"] integerValue]==9000) {
                     [SVProgressHUD showSuccessWithStatus:@"支付成功"];
                     [self checkResult];
                 }
                 else {
                     [SVProgressHUD showErrorWithStatus:[resultDic objectForKey:@"memo"] ];
                 }
             }];
        }
            
            break;
        case 1:
            
        {
            NSLog(@"余额支付");
            HHAlertView *alert = [[HHAlertView alloc]initWithTitle:nil detailText:@"确认使用余额支付？" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"]];
            alert.mode = HHAlertViewModeWarning;
            [alert showWithBlock:^(NSInteger index) {
                if (index != 0) {
                    [SVProgressHUD show];
                    [RequestManager payByyueBillCode:_model.billCode
                                             matName:@""
                                             matType:@""
                                        insuranceFee:@""
                                         insureMoney:@""
                                        needPayMoney:_transferMoney
                                           shipMoney:@""
                                        userCouponId:_couponId ? _couponId : @""
                                              weight:@""
                                              userId:[UserManager getDefaultUser].userId
                                             success:^(id object) {
                                                 [SVProgressHUD showSuccessWithStatus:@"支付成功"];
                                                 [self goHome];
                                             } Failed:^(NSString *error) {
                                                 //
                                                int errCode = [[[NSUserDefaults standardUserDefaults] objectForKey:@"errCode"] intValue];
                                                 if (errCode == -2)
                                                 {
                                                     [SVProgressHUD dismiss];
                                                     HHAlertView *alert = [[HHAlertView alloc]initWithTitle:nil detailText:error cancelButtonTitle:@"更换支付方式" otherButtonTitles:@[@"去充值"]];
                                                     alert.mode = HHAlertViewModeWarning;
                                                     [alert showWithBlock:^(NSInteger index) {
                                                         if(index != 0){
                                                             [self.navigationController pushViewController:[[RechargeViewController alloc]init] animated:YES];
                                                         }
                                                         
                                                     }];
                                                 }else{
                                                     [SVProgressHUD showErrorWithStatus:error];
                                                 }
                                             }];
                }
            }];
            
        }
            break;
    }
}

- (void)checkResult{
    [RequestManager getPayResultWithBillCode:_model.billCode success:^(NSDictionary *result) {
        NSLog(@"%@",result);
        [self goHome];
        
    } Failed:^(NSString *error) {
        [PXAlertView showAlertWithTitle:error];
    }];
}

- (void)goHome{
    _payType = 0;
    [_payView dismiss];
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self removeAllInfo];
    [self.view bringSubviewToFront:_publishOne];
    //给推送 附近的镖师正忙
    [ExpressRequest sendWithParameters:nil MethodStr:[NSString stringWithFormat:@"%@downwind/task/afterPublish?recId=%@",BaseUrl,_recId] reqType:k_GET success:^(id object) {
        
    } failed:^(NSString *error) {
        int errCode = [[[NSUserDefaults standardUserDefaults] objectForKey:@"errCode"] intValue];
        if (errCode == -2){
            NSLog(@"@@@@@@@@@@@@@@@@@@@@@@");
          [SVProgressHUD showInfoWithStatus:error];
        }
    }];
}
-(void)removeAllInfo{
    
    _publishTwo.sendNameTextField.text = [UserManager getDefaultUser].userName;
    _publishTwo.sendPhoneTextField.text = [UserManager getDefaultUser].mobile;
    _publishOne.startTextField.text = [[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCASTR];
    _model.fromLongitude = [[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCATION_LON] ;
    _model.fromLatitude = [[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCATION_LAT];
    _model.cityCode = [[NSUserDefaults standardUserDefaults] valueForKey:USER_CITY_CODE];
    _model.townCode = [[NSUserDefaults standardUserDefaults] valueForKey:USER_TOWN_CODE];
    _publishOne.startDetailTextField.text =@"";
    _publishTwo.receiveNameTextField.text = @"";
    _publishTwo.receivePhoneTextField.text =@"";
    _publishOne.endTextField.text =@"";
    _publishOne.endDetailTextField.text =@"";
    _publishOne.goodsNameTextField.text = @"";
    _publishOne.weightTextField.text = @"";
    [_publishTwo.toubaoBtn setImage:[UIImage imageNamed:@"toubaokuangLmg"] forState:UIControlStateNormal];
    _publishOne.goodsNameTextField.text =@"";
    _publishTwo.toubaoImg.hidden = YES;
    [_publishTwo.replaceMoneyBtn setImage:[UIImage imageNamed:@"toubaokuangLmg"] forState:UIControlStateNormal];
    _publishTwo.replaceMoneyTextField.text =@"";
    _publishTwo.replaceMoneyImg.hidden = YES;
    
    _publishTwo.replaceMoneyTextField.userInteractionEnabled = NO;
    _publishTwo.goodsValueTextField.userInteractionEnabled = NO;
    
    _publishOne.carLengthTextField.text = @"";
    _publishOne.goodsSqureTextField.text = @"";
    _publishTwo.useTimeTextfield.text  = @"";
    
    _length = @"10";
    _model.matImageUrl =@"";
    _ifInsure = @"N";
    _ifReplaceMoney = @"0";
    _carLength = @"1";
    _matVolume = @"";
}
//登录之后的操作
-(void)islogin{
    
    _publishTwo.sendNameTextField.text = [UserManager getDefaultUser].userName;
    _publishTwo.sendPhoneTextField.text = [UserManager getDefaultUser].mobile;
    _publishOne.startTextField.text = [[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCASTR];
    _model.fromLongitude = [[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCATION_LON] ;
    _model.fromLatitude = [[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCATION_LAT];
    _model.cityCode = [[NSUserDefaults standardUserDefaults] valueForKey:USER_CITY_CODE];
    _model.townCode = [[NSUserDefaults standardUserDefaults] valueForKey:USER_TOWN_CODE];
}
-(void)islogout{
    [self removeAllInfo];
    _publishTwo.sendNameTextField.text = @"";
    _publishTwo.sendPhoneTextField.text =@"";
}
#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _couponArray.count;
}

- (CGFloat)cellHeightForIndexPath:(NSIndexPath *)indexPath cellContentViewWidth:(CGFloat)width tableView:(UITableView *)tableView{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CouponTableViewCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    Wallet *model = _couponArray[indexPath.row];
    [cell configModel:model];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
