//
//  FaXianShiVC.m
//  iwant
//
//  Created by 公司 on 2017/2/9.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "FaXianShiVC.h"
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
#import "ActionSheetStringPicker.h" //重量选择呢器
#import "LocationViewController.h"
#import "PublishWindOne.h"
#import "PublishWindTwo.h"


@interface FaXianShiVC ()<UITableViewDelegate,UITableViewDataSource>{

    UIScrollView * _scrollerView;
    FaBiaoPersonView * _sendInfoView;
    FaBiaoPersonView * _reciveInfoView;
    FaBiaoGoodsInfoView * _goodsInfoView;
    
    PublishWindOne * _publishOne;
    PublishWindTwo * _publishTwo;
    
    NSString * _time;
    NSString * _ifNeedHuoChe;
    NSString *_ifInsure;  //  是否投保
    NSString *_insuerCost;  //投保金额
    NSString *_filePath;
    NSString *_transferMoney;//需要支付（没扣除现金券之前）的总费用
    NSString * _premium;  //保额
    //使用货车时  length 传135   不使用货车  length 传 10
    NSString * _length;
    
    NSString * _carTypeStr;
    //是否代收货款
    NSString *_ifReplaceMoney;
    
    //现金券
    NSString *_couponId;
    int _payType;//1-余额 2-微信 3-支付宝
    PayView *_payView;

    ShunFeng * _model;
    
    NSString * _weightStr; //重量字符串
    NSString * _recId; //所发单的ID
}

@property (nonatomic,strong) ShunFeng * expModel;
@property (strong, nonatomic) MHDatePicker *selectTimePicker;
@property (strong, nonatomic)  UITableView *couponTableView;
@property (strong, nonatomic)  NSMutableArray *couponArray;

@end

@implementation FaXianShiVC
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
    _carTypeStr = @"else";

    [self initUI];
    _expModel = [[ShunFeng alloc]init];
    [self firstFill];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goHome) name:WECHAT_BACK_SF object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(islogin) name:ISLOGIN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(islogout) name:ISLOGOUT object:nil];


}

-(void)initUI{
    __weak FaXianShiVC * weakSelf = self;
    //允许改变层级
    self.view.autoresizesSubviews = YES;
    _scrollerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (SCREEN_WIDTH == 320) {
        _scrollerView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+100);
    }
    
    _publishOne = [[[NSBundle mainBundle] loadNibNamed:@"PublishWindOne" owner:nil options:nil] lastObject];
    _publishOne.topNoticeLabel.text = @"限时镖：时效要求强，重量轻、体积小、路程短的货物";
    _publishOne.frame = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _publishOne.BlockOne = ^(int tag){
        [weakSelf sendBtnClick:tag];
    };
    
    _publishTwo = [[[NSBundle mainBundle] loadNibNamed:@"PublishWindTwo" owner:nil options:nil] lastObject];
    _publishTwo.topNoticeLabel.text = @"限时镖：时效要求强，重量轻、体积小、路程短的货物";
    _publishTwo.frame = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _publishTwo.BlockTwo = ^(int tag){
        [weakSelf receiveBtnClick:tag];
    };
    
    [_scrollerView addSubview:_publishTwo];
    [self.view addSubview:_scrollerView];
    [self.view addSubview:_publishOne];
}

-(void)firstFill{
    _publishTwo.sendNameTextField.text = [UserManager getDefaultUser].userName;
    _publishTwo.sendPhoneTextField.text = [UserManager getDefaultUser].mobile;
    _publishOne.startTextField.text = [[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCASTR];
    _expModel.fromLongitude = [[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCATION_LON] ;
    _expModel.fromLatitude = [[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCATION_LAT];
    _expModel.cityCode = [[NSUserDefaults standardUserDefaults] valueForKey:USER_CITY_CODE];
    _expModel.townCode = [[NSUserDefaults standardUserDefaults] valueForKey:USER_TOWN_CODE];
}

-(void)sendBtnClick:(int) tag{
//    __weak FaXianShiVC * weakSelf = self;
    switch (tag) {
        case 1:
        {
            LocationViewController *addVC = [[LocationViewController alloc]init];
            addVC.passBlock = ^(NSString *address,NSString *name,NSString *la,NSString *lon,NSString *cityCode,NSString *cityName,NSString *townCode,NSString *townName){
                _publishOne.startTextField.text = [NSString stringWithFormat:@"%@%@",address,name];
                _expModel.address = [NSString stringWithFormat:@"%@%@",address,name];
                _expModel.fromLatitude = la;
                _expModel.fromLongitude = lon;
                _expModel.cityCode = cityCode;
                _expModel.townCode = townCode;
            };
            [self.navigationController pushViewController:addVC animated:YES];
        }
            break;
        case 2:
        {
            LocationViewController *addVC = [[LocationViewController alloc]init];
            addVC.passBlock = ^(NSString *address,NSString *name,NSString *la,NSString *lon,NSString *cityCode,NSString *cityName,NSString *townCode,NSString *townName){
                _publishOne.endTextField.text = [NSString stringWithFormat:@"%@%@",address,name];
                _expModel.address = [NSString stringWithFormat:@"%@%@",address,name];
                _expModel.toLatitude = la;
                _expModel.toLongitude = lon;
                _expModel.cityCodeTo = cityCode;
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
            if(_publishOne.weightTextField.text.length == 0){
                [SVProgressHUD showErrorWithStatus:@"请填写货物重量"];
                return;
            }
            if (_publishOne.timeTextField.text.length == 0) {
                [SVProgressHUD showErrorWithStatus:@"请选择限定到达时间"];
                return;
            }
            [self.view bringSubviewToFront:_scrollerView];

        }
            break;
        case 4:
        {
            _selectTimePicker = [[MHDatePicker alloc] init];
            __weak typeof(self) weakSelf = self;
            [_selectTimePicker didFinishSelectedDate:^(NSDate *selectedDate) {
                _publishOne.timeTextField.text = [weakSelf dateStringWithDate:selectedDate DateFormat:@"MM月dd日 HH:mm"];
                _time = [[NSString alloc]init];
                _time = [weakSelf dateStringWithDate:selectedDate DateFormat:@"yyyy-MM-dd HH:mm"];
            }];
        }
            break;
        case 5:{
            //选择重量的
            _publishOne.WeightBlock = ^(NSString * weightStr,NSString * weight){
                _publishOne.weightTextField.text = weightStr;
                _weightStr = weight;
            };
        }
            break;

            default:
            break;
    }
}


-(void)receiveBtnClick:(int)tag{
//    __weak FaXianShiVC * weakSelf = self;
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
            [self sendExp];
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

- (void)headerView:(YMHeaderView *)headerView didSelectWithImage:(UIImage *)image{
    [SVProgressHUD show];
    [RequestManager uploadmatNameWithUserId:[NSString stringWithFormat:@"%@_GOODS",[UserManager getDefaultUser].userId]
                                   fileName:@"id_matName.png"
                                       file:image
                                    Success:^(NSDictionary *result) {
                                        _filePath = [([result objectForKey:@"data"][0]) valueForKey:@"filePath"];
                                        _expModel.matImageUrl = _filePath;
                                        [SVProgressHUD showSuccessWithStatus:@"上传成功"];
                                    } Failed:^(NSString *error) {
                                        [SVProgressHUD showErrorWithStatus:error];
                                    }];
}
- (void)sendExp{
    if (![self checkPream]) {
        NSString *cityCode = [[NSUserDefaults standardUserDefaults] valueForKey:USER_CITY_CODE];
        if (!cityCode || [cityCode isEqualToString:@""]) {
            [SVProgressHUD showErrorWithStatus:@"定位失败,请重新定位"];
            return;
        }
        return;
    }
    
    //    拼接地址
    NSString * sendAddress = [_publishOne.startTextField.text stringByAppendingString:_publishOne.startDetailTextField.text];
    NSString * receiveAdress =  [NSString stringWithFormat:@"%@%@",_publishOne.endTextField.text,_publishOne.endDetailTextField.text];
    
    [SVProgressHUD show];
    [RequestManager SendtailLimitMissionWithUserId:[UserManager getDefaultUser].userId
                                          latitude:[[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCATION_LAT]
                                         longitude:[[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCATION_LON]
                                        personName:_publishTwo.sendNameTextField.text
                                            mobile:_publishTwo.sendPhoneTextField.text
                                           address:sendAddress
                                          cityCode:_expModel.cityCode
                                          townCode:_expModel.townCode
                                          deviceId:nil
                                      fromLatitude:_expModel.fromLatitude ? _expModel.fromLatitude : @""
                                     fromLongitude:_expModel.fromLongitude ? _expModel.fromLongitude :@""
                                      personNameTo:_publishTwo.receiveNameTextField.text
                                          mobileTo:_publishTwo.receivePhoneTextField.text
                                         addressTo:receiveAdress
                                        cityCodeTo:_expModel.cityCodeTo ? _expModel.cityCodeTo:@""
                                        toLatitude:_expModel.toLatitude ? _expModel.toLatitude:@""
                                       toLongitude:_expModel.toLongitude ?_expModel.toLongitude:@""
                                           matName:_publishTwo.goodsNameTextField.text
                                       matImageUrl:_expModel.matImageUrl ?_expModel.matImageUrl:@""
                                         matRemark:_publishTwo.remarkTextField.text?_publishTwo.remarkTextField.text:@""
                                         matWeight:_weightStr
                                            length:_length
                                             width:@""
                                             height:@""
                                         limitTime:_time
                                           whether:_ifInsure
                                           premium: _publishTwo.toubaoBtn.selected  ? _publishTwo.goodsValueTextField.text : @""
                                      ifReplaceMoney:_ifReplaceMoney
                                      replaceMoney:_publishTwo.replaceMoneyTextField.text
                                           carType:_carTypeStr
                                           success:^(NSMutableArray *result) {
                                               [SVProgressHUD dismiss];
                                               double temp = [result[0][@"transferMoney"] doubleValue];
                                               _transferMoney = [NSString stringWithFormat:@"%0.2f",temp];
                                               double temp2 = [result[0][@"insureCost"] doubleValue];
                                               _insuerCost = [NSString stringWithFormat:@"%0.2f",temp2];
                                               _premium = result[0][@"premium"];
                                               _model = [[ShunFeng alloc]initWithJsonDict:result[0]];
                                               _expModel.billCode = result[0][@"billCode"];
                                               _recId = result[0][@"recId"];
                                               [self CreatPopView:_transferMoney];

                                           } Failed:^(NSString *error) {
                                               [SVProgressHUD showErrorWithStatus:error];
                                               NSLog(@"顺风任务发布失败");
                                           }];
}

-(void)CreatPopView:(NSString *)money
{
    _couponId = @"";
    _payType = 0;
    
    NSString *yunfei = [NSString stringWithFormat:@"%0.2f",([_transferMoney doubleValue] - [_insuerCost doubleValue])];
    
    _payView = [[[NSBundle mainBundle] loadNibNamed:@"PayView" owner:nil options:nil] lastObject];
    NSString * distance =[NSString stringWithFormat:@"%0.2f", [_model.distance floatValue]/1000];
    [_payView setModel:[NSArray arrayWithObjects:@"限时镖",[NSString stringWithFormat:@"%@ 元",yunfei],[NSString stringWithFormat:@"%@元(保额：%@元)",_insuerCost,_premium],[NSString stringWithFormat:@"%@",_transferMoney],distance,nil]];
    __weak PayView *weakPayView = _payView;
    _payView.width = WINDOW_WIDTH;
    _payView.tag = 0;
    if (_model.ifReplaceMoney) {
        _payView.daishouHuokuanL.hidden = NO;
        _payView.replaceMoneyLabel.hidden = NO;
        _payView.replaceMoneyLabel.text =[NSString stringWithFormat:@"%@元", _model.replaceMoney];
    }else{
        _payView.daishouHuokuanL.hidden = YES;
        _payView.replaceMoneyLabel.hidden = YES;
    }
    
    if ([_model.whether isEqualToString:@"N"]) {
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
                    [weakPayView setModel:[NSArray arrayWithObjects:@"限时镖",[NSString stringWithFormat:@"%@元",yunfei],[NSString stringWithFormat:@"%@元(保额：%@元)",_insuerCost,_premium],[NSString stringWithFormat:@"%@",_transferMoney],distance,nil]];
                    _couponArray = nil;
                    [self.couponTableView reloadData];
                    weakPayView.weixinBtn.enabled = YES;
                    weakPayView.alipayBtn.enabled = YES;
                    weakPayView.yueBtn.selected = NO;
                }else{
                    weakPayView.hidden = YES;
                    weakPayView.btn.hidden = YES;
                    weakPayView.overlayView.hidden = YES;
                    CouponViewController *couVC = [[CouponViewController alloc]init];
                    couVC.isPay = YES;
                    couVC.needMoney = _transferMoney;
                    couVC.billcode = _expModel.billCode;
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
                        weakPayView.hidden = NO;
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
            
            [RequestManager getWXPreWithBillCode:_expModel.billCode
                                         matName:@"" matType:@"" insuranceFee:@""insureMoney:@""needPayMoney:_transferMoney shipMoney:@"" weight:@""
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
                                             wxManager.billCode = _expModel.billCode;
                                             
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
            [AlipayRequestConfig alipayWithPartner:kPartnerID seller:kSellerAccount tradeNO:_expModel.billCode productName:@"镖王" productDescription: @"快递费" amount:_transferMoney notifyURL:kNotifyURL itBPay:@"30m" standbyCallback:^(NSDictionary *resultDic)
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
                    [RequestManager payByyueBillCode:_expModel.billCode
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
    [RequestManager getPayResultWithBillCode:_expModel.billCode success:^(NSDictionary *result) {
        NSLog(@"%@",result);
        [self goHome];
        
    } Failed:^(NSString *error) {
        [PXAlertView showAlertWithTitle:error];
    }];
}

#pragma mark ---- 支付成功后的操作返回的首界面
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
            [SVProgressHUD showInfoWithStatus:error];
        }
    }];

}

-(void)removeAllInfo{
    _publishTwo.sendNameTextField.text = [UserManager getDefaultUser].userName;
    _publishTwo.sendPhoneTextField.text = [UserManager getDefaultUser].mobile;
    _publishOne.startTextField.text = [[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCASTR];
    _expModel.fromLongitude = [[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCATION_LON] ;
    _expModel.fromLatitude = [[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCATION_LAT];
    _expModel.cityCode = [[NSUserDefaults standardUserDefaults] valueForKey:USER_CITY_CODE];
    _expModel.townCode = [[NSUserDefaults standardUserDefaults] valueForKey:USER_TOWN_CODE];
    _publishOne.startDetailTextField.text =@"";
    _publishTwo.receiveNameTextField.text = @"";
    _publishTwo.receivePhoneTextField.text =@"";
    _publishOne.endTextField.text =@"";
    _publishOne.endDetailTextField.text =@"";
    _publishOne.timeTextField.text = @"";
    _publishTwo.goodsNameTextField.text = @"";
    _publishOne.weightTextField.text = @"";
    [_publishTwo.toubaoBtn setImage:[UIImage imageNamed:@"toubaokuangLmg"] forState:UIControlStateNormal];
    _publishTwo.goodsNameTextField.text =@"";
    _publishTwo.toubaoImg.hidden = YES;
    [_publishTwo.replaceMoneyBtn setImage:[UIImage imageNamed:@"toubaokuangLmg"] forState:UIControlStateNormal];
    _publishTwo.replaceMoneyTextField.text =@"";
    _publishTwo.replaceMoneyImg.hidden = YES;
    _publishTwo.remarkTextField.text = @"";
    
    _publishTwo.replaceMoneyTextField.userInteractionEnabled = NO;
    _publishTwo.goodsValueTextField.userInteractionEnabled = NO;
    _publishOne.kgDanwei.hidden = NO;

    _length = @"10";
    _expModel.matImageUrl =@"";
    _ifInsure = @"N";
    _ifReplaceMoney = @"0";
    _carTypeStr = @"else";
}

- (BOOL)checkPream{
    if (_publishTwo.sendNameTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的发件人姓名"];
        return NO;
    }
    if (_publishTwo.sendPhoneTextField.text.length != 11) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的发件人手机号"];
        return NO;
    }
    if (_publishTwo.receiveNameTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的收件人姓名"];
        return NO;
    }
    if (_publishTwo.receivePhoneTextField.text.length != 11) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的收件人手机号"];
        return NO;
    }
    if (_publishTwo.goodsNameTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入物品名称"];
        return NO;
    }
    if ( [_ifInsure isEqualToString:@"Y"]&&[_publishTwo.goodsValueTextField.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入货物价值"];
        return NO;
    }
    if ( _ifInsure.length == 0 ||_ifInsure == nil) {
        _ifInsure = @"N";
    }
    if (![_ifInsure isEqualToString:@"Y"]) {
        _publishTwo.goodsValueTextField.text = @"";
    }
    //是否代收款
    if ([_ifReplaceMoney isEqualToString:@"1"] && [_publishTwo.replaceMoneyTextField.text isEqualToString:@""] &&[_publishTwo.replaceMoneyTextField.text intValue] == 0 ) {
        [SVProgressHUD showErrorWithStatus:@"请输入收款金额"];
        return NO;
    }
    if (![_ifReplaceMoney isEqualToString:@"1"]) {
        _publishTwo.replaceMoneyTextField.text = @"";
    }

    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(void)islogin{
    _publishTwo.sendNameTextField.text = [UserManager getDefaultUser].userName;
    _publishTwo.sendPhoneTextField.text = [UserManager getDefaultUser].mobile;
    _publishOne.startTextField.text = [[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCASTR];
    _expModel.fromLongitude = [[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCATION_LON] ;
    _expModel.fromLatitude = [[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCATION_LAT];
    _expModel.cityCode = [[NSUserDefaults standardUserDefaults] valueForKey:USER_CITY_CODE];
    _expModel.townCode = [[NSUserDefaults standardUserDefaults] valueForKey:USER_TOWN_CODE];
}

-(void)islogout{
    [self removeAllInfo];
    _publishTwo.sendNameTextField.text = @"";
    _publishTwo.sendPhoneTextField.text =@"";
}


@end
