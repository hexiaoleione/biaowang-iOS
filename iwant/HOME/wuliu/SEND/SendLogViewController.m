//
//  SendLogViewController.m
//  iwant
//
//  Created by dongba on 16/8/24.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "SendLogViewController.h"
#import "SendLogView.h"
#import "SendLogToInfoView.h"
#import "TopBarView.h"
#import "LDPickViewController.h"
#import "MHDatePicker.h"
#import "CityViewController.h"
#import "Logist.h"
#import "MainHeader.h"
#import "UserLogListViewController.h"
#import "PayView.h"
#import "WechatPayHeader.h"
#import "WXPayManager.h"

#import "AlipayRequestConfig.h"
#import "WLUserPay.h" //支付

@interface SendLogViewController (){
    UIScrollView *_scrollView;
    TopBarView *_topView;
    SendLogView *_sendInfoView;
    SendLogToInfoView *_sendLogToView;
    Logist *_model;
    NSString *_lat;
    NSString *_lon;
    NSString *_cityCodeFrom;
    NSString *_townCodeFrom;
    NSString *_cityCodeTo;
    NSString *_latitudeTo;//收件地纬度
    NSString *_longitudeTo;//收件地经度
    PayView *_payView;
    NSMutableString *_billCode;
    WLUserPay * _userPayView;
}
@property (strong, nonatomic) MHDatePicker *selectTimePicker;

@end

@implementation SendLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCostomeTitle:@"发布"];
    [self configSubViews];
    [self setModel];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notice) name:WECHAT_BACK_WL object:nil];
    
}


- (void)setModel{
    _model = [[Logist alloc]init];
}

- (void)configSubViews{
    
    _scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    _scrollView.backgroundColor = BACKGROUND_COLOR;
    _scrollView.contentSize = CGSizeMake(WINDOW_WIDTH, 760.);
    [self.view addSubview:_scrollView];

    _topView = [[[NSBundle mainBundle] loadNibNamed:@"TopBarView" owner:nil options:nil] lastObject];
    [_topView sizeToFit];
    _topView.top = 9;
    _topView.left = 10;
    [_topView layoutIfNeeded];
    _topView.contentView.layer.cornerRadius = 5.;
    _topView.contentView.layer.masksToBounds = YES;
    _topView.width = WINDOW_WIDTH -20 ;
    [_scrollView addSubview:_topView];
    
    
    __weak SendLogViewController *weakSelf = self;
    _sendInfoView = [[[NSBundle mainBundle] loadNibNamed:@"SendLogInfoView" owner:nil options:nil] lastObject];
    _sendInfoView.block = ^(int tag){
        [weakSelf btnClick:tag];
    };
    [_sendInfoView sizeToFit];
    _sendInfoView.top = _topView.bottom + 9;
    _sendInfoView.left = 0;
    _sendInfoView.width = WINDOW_WIDTH ;
    [_scrollView addSubview:_sendInfoView];
    
    _sendLogToView = [[[NSBundle mainBundle]loadNibNamed:@"SendLogPersonInfo" owner:nil options:nil] lastObject];
    [_sendLogToView sizeToFit];
    _sendLogToView.top = _sendInfoView.bottom + 12;
    _sendLogToView.left = 0;
    _sendLogToView.width = WINDOW_WIDTH ;
    [_scrollView addSubview:_sendLogToView];

    UIButton *btn = [UIButton new];
    [btn setBackgroundColor:COLOR_ORANGE_DEFOUT];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"发布货源" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(sendInfo) forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    btn.width = btn.width *1.5;
    btn.layer.cornerRadius = btn.height *0.5;
    btn.centerX = _scrollView.centerX;
    btn.top = _sendLogToView.bottom+22;
    [_scrollView addSubview:btn];
    
    _payView = [[[NSBundle mainBundle] loadNibNamed:@"PayView" owner:nil options:nil] lastObject];
    _payView.width = WINDOW_WIDTH;
    
    _userPayView =[[[NSBundle mainBundle] loadNibNamed:@"WLUserPay" owner:nil options:nil] lastObject];
    
}
//发布货源
#pragma mark -发布货源
- (void)sendInfo{
    if (![self checkPrem]) {
        return;
    }

    [SVProgressHUD show];

    //发货地的位置
    NSString * fromAddress = [NSString stringWithFormat:@"%@%@",_sendInfoView.fromArea.text,_sendInfoView.fromDetailAdress.text
                              ];
    //送货地的位置
    NSString * toAddress = [NSString stringWithFormat:@"%@%@",_sendInfoView.toArea.text,_sendInfoView.toDetailAdress.text];
    
    NSDictionary *dic = @{k_USER_ID:[UserManager getDefaultUser].userId,
                          @"cargoName":_sendInfoView.matName.text,
                          @"startPlace":fromAddress,
                          @"entPlace":toAddress,
                          @"takeCargo":_model.takeCargo ? @"1":@"0",
                          @"sendCargo":_model.sendCargo ? @"1":@"0",
                          @"cargoWeight":[NSString stringWithFormat:@"%@%@",_sendInfoView.matWeight.text,_sendInfoView.danwei.currentTitle],
                          @"cargoVolume":_sendInfoView.tiJi.text,
                          @"takeTime":_sendInfoView.StarTime.text,
                          @"arriveTime":_sendInfoView.ReceiveTime.text,
                          @"takeName":_sendLogToView.name.text,
                          @"takeMobile":_sendLogToView.phone.text,
                          @"remark":_sendLogToView.other.text,
                          @"latitude":_lat?_lat:@"",
                          @"longitude":_lon?_lon:@"",
                          @"startPlaceCityCode":_cityCodeFrom,
                          @"startPlaceTownCode":_townCodeFrom,
                          @"entPlaceCityCode":_cityCodeTo,
                          @"latitudeTo":_latitudeTo,
                          @"longitudeTo":_longitudeTo
                          };
    [ExpressRequest sendWithParameters:dic MethodStr:@"logistics/task/publishNew" reqType:k_POST success:^(id object) {
        [SVProgressHUD dismiss];
//        原支付界面
//        [self showPayViewWithObj:object];
        [self showUserPayViewWithObj:object];

        
    } failed:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
}



- (BOOL)checkPrem{
    if (_sendInfoView.matName.text.length == 0) {

        [SVProgressHUD showErrorWithStatus:@"请填写货物名称"];
        return NO;
    }
    if (_sendInfoView.fromArea.text.length == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"请选择起始地点"];
        return NO;
    }
    if (_sendInfoView.toArea.text.length == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"请选择到达地点"];

        return NO;
    }
    
    if (_sendInfoView.matWeight.text.length == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"请填写货物重量"];

        return NO;
    }
    if (_sendInfoView.tiJi.text.length == 0) {
        
         [SVProgressHUD showErrorWithStatus:@"请填写货物体积"];
        
        return NO;
    }
    if (_sendInfoView.StarTime.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择取货时间"];
        
        return NO;
    }
    if (_sendInfoView.ReceiveTime.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择送达时间"];
        
        return NO;
    }
    if (_sendLogToView.name.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请填写收件人姓名"];

        
        return NO;
    }
    if (_sendLogToView.phone.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请填写收件人手机号"];

        return NO;
    }
      return YES;
}


- (void)btnClick:(int)tag{
    NSLog(@"点击了%d",tag);
    switch (tag) {
        case 0:{//是否上门取货
            
            _model.takeCargo = _sendInfoView.pickSwitch.on ? YES : NO;
            
            if (_sendInfoView.pickSwitch.on) {
                _sendInfoView.sendtimeLabel.text =@"上门取货时间:";
            }else{
            
               _sendInfoView.sendtimeLabel.text = @"送到货场时间:";
            }
            
            
        }
            break;
        case 1:{//是否送货上门
            _model.sendCargo = _sendInfoView.arriveSwitch.on ? YES : NO;
            
            if (_sendInfoView.arriveSwitch.on) {
                _sendInfoView.arriveTimeLabel.text=@"要求到达时间:";
            }else{
                _sendInfoView.arriveTimeLabel.text=@"要求到达时间:";

            }
            
        }
            break;
        case 2:{//单位名称
            LDPickViewController *pickVC= [[LDPickViewController alloc] init];
            pickVC.view.frame = CGRectMake(0, WINDOW_HEIGHT - 254, WINDOW_WIDTH, 190);
            pickVC.dataArray = @[@[@"吨",@"公斤"]];
            [self addChildViewController:pickVC];
            [self.view addSubview:pickVC.view];
            
            pickVC.block = ^(NSString *str){
                [_sendInfoView.danwei setTitle:str forState:UIControlStateNormal];
            };
        }
            
        break;
        case 3:{//出发时间
            [self PickTimebtn:_sendInfoView.StarTime];
            
        }
            break;
        case 4:{//到达时间
            [self PickEndTimebtn:_sendInfoView.ReceiveTime];
            
        }
            break;
        case 5:{//起始地
//            if (_sendInfoView.pickSwitch.on) {
//                AddressViewController *adress = [AddressViewController new];
//                adress.isSelectCity = YES;
//                adress.passBlock = ^(NSString *address,NSString *name,NSString *la,NSString *lon,NSString *cityCode,NSString *cityName,NSString * townCode){
//                    _sendInfoView.fromArea.text= [NSString stringWithFormat:@"%@%@",address,name];
//                    _model.startPlace = [NSString stringWithFormat:@"%@%@",address,name];
//                    //                _addressField.text = name;
//                                    _lat = la;
//                                    _lon = lon;
//                                    _cityCodeFrom = cityCode;
//                                    _townCodeFrom = townCode;
//                    
//                };
//                
//                
//                [self.navigationController pushViewController:adress animated:YES];
//                
                
//            }else{
//                CityViewController *cityVC =[[CityViewController alloc]init];
//                cityVC.returnTextBlock = ^(NSString *address,NSString *citycode,NSString *towncode,NSString *cityname,NSString *townname){
//                    _sendInfoView.fromArea.text= [NSString stringWithFormat:@"%@",address];
//                    _model.cityCodeFrom = citycode;
//                    _model.startPlace = _sendInfoView.fromArea.text;
//                    _cityCodeFrom = citycode;
//                };
//                [self.navigationController pushViewController:cityVC animated:YES];
//            }
  
        }
            break;
        case 6:{//目的地
            
//            if (_sendInfoView.arriveSwitch.on) {
            
//                AddressViewController *adress = [AddressViewController new];
//                adress.isSelectCity = YES;
//                adress.ifReceive = YES;
//                adress.passBlock = ^(NSString *address,NSString *name,NSString *la,NSString *lon,NSString *cityCode,NSString *cityName,NSString * townCode){
//                    _sendInfoView.toArea.text= [NSString stringWithFormat:@"%@%@",address,name];
//                    _model.entPlace = _sendInfoView.toArea.text;
//                    _latitudeTo = la;
//                    _longitudeTo = lon;
//                    _cityCodeTo = cityCode;
//                };
//                [self.navigationController pushViewController:adress animated:YES];
//            }else{
//                
//                CityViewController *cityVC =[[CityViewController alloc]init];
//                cityVC.returnTextBlock = ^(NSString *address,NSString *citycode,NSString *towncode,NSString *cityname,NSString *townname){
//                    _sendInfoView.toArea.text= [NSString stringWithFormat:@"%@",address];
//                    _model.cityCodeTo = citycode;
//                    _cityCodeTo =citycode;
//                    _model.entPlace = _sendInfoView.toArea.text;
//                };
//                [self.navigationController pushViewController:cityVC animated:YES];
//            }
        }
            break;
            
        default:
            break;
    }
}

-(void)PickTimebtn:(UITextField *)textField
{
    
    _selectTimePicker = [[MHDatePicker alloc] init];
    __weak typeof(self) weakSelf = self;
    [_selectTimePicker didFinishSelectedDate:^(NSDate *selectedDate) {
        //    NSString *string = [NSString stringWithFormat:@"%@",[NSDate dateWithTimeInterval:3600*8 sinceDate:selectedDate]];
        textField.text = [weakSelf dateStringWithDate:selectedDate DateFormat:@"yyyy-MM-dd HH:mm"];
//        _time = [[NSString alloc]init];
//        _time = [weakSelf dateStringWithDate:selectedDate DateFormat:@"yyyy-MM-dd HH:mm"];
        
    }];
}

-(void)PickEndTimebtn:(UITextField *)textField
{
    
    _selectTimePicker = [[MHDatePicker alloc] init];
    _selectTimePicker.datePickerMode=UIDatePickerModeDate;
    __weak typeof(self) weakSelf = self;
    [_selectTimePicker didFinishSelectedDate:^(NSDate *selectedDate) {
        textField.text = [weakSelf dateStringWithDate:selectedDate DateFormat:@"yyyy-MM-dd"];
    }];
}


- (NSString *)dateStringWithDate:(NSDate *)date DateFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    NSString *str = [dateFormatter stringFromDate:date];
    return str ? str : @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showUserPayViewWithObj:(id)obj{
    NSDictionary *dataDic = [obj valueForKey:@"data"][0];
    NSString *trueMoney = [NSString stringWithFormat:@"%d",[[dataDic valueForKey:@"evaluationScore"] intValue] ];
    NSString *publishMoney = [NSString stringWithFormat:@"%@",trueMoney];
    NSString *specialMoney = [[dataDic valueForKey:@"evaluationStatus"] stringValue] ;
    NSString *discount = [NSString stringWithFormat:@"优惠减免：使用余额支付优惠%d元",[publishMoney intValue] - [specialMoney intValue]];
    __weak SendLogViewController * weakSelf = self;
    [_userPayView  setLogistModel:[NSArray arrayWithObjects:specialMoney,publishMoney,discount, nil]];
    __weak WLUserPay * weakPayView = _userPayView;
    _userPayView.block = ^(NSInteger tag){
        switch (tag) {
            case 0:
            {
                //开关
            }
            break;
            case 1:{
            //余额支付
                [weakPayView setLogistModel:[NSArray arrayWithObjects:specialMoney,publishMoney,discount, nil]];
            }
                break;
            case 2:{
            //微信
                [weakPayView setLogistModel:[NSArray arrayWithObjects:publishMoney,publishMoney,@"",nil]];
            }
                break;
            case 3:{
            //支付宝
                [weakPayView setLogistModel:[NSArray arrayWithObjects:publishMoney, publishMoney,@"",nil]];
            }
                break;
            case 4:{
                
                for (UIButton *btn in weakPayView.payBtn) {
                    if (btn.selected) {
                        [weakSelf payWithTag:btn.tag obj:dataDic];
                    }
                    
                }
            }
                break;
            default:
                break;
        }
    };
    
    [_userPayView show];

}

- (void)showPayViewWithObj:(id)obj{
    NSDictionary *dataDic = [obj valueForKey:@"data"][0];
    NSString *trueMoney = [NSString stringWithFormat:@"%.2f",[[dataDic valueForKey:@"evaluationScore"] doubleValue] ];
    NSString *publishMoney = [NSString stringWithFormat:@"%@元",trueMoney];
    NSString *specialMoney = [dataDic valueForKey:@"evaluationStatus"];
    NSString *discount = [NSString stringWithFormat:@"余额支付优惠%0.2f元",[publishMoney doubleValue] - [specialMoney doubleValue]];
    __weak SendLogViewController *weakSelf = self;
    [_payView setLogistModel:[NSArray arrayWithObjects:@"平台使用费",publishMoney,discount,specialMoney, nil ]];
    __weak PayView *weakPayView = _payView;
    _payView.block = ^(NSInteger tag){
        switch (tag) {
            case 0:
            {
                //开关
            }
                break;
            case 1:
            {
                //余额
                [weakPayView setLogistModel:[NSArray arrayWithObjects:@"平台使用费",publishMoney,discount,specialMoney, nil ]];
            }
                break;
            case 2:
            {
                //微信
                [weakPayView setLogistModel:[NSArray arrayWithObjects:@"平台使用费",publishMoney,@"无",trueMoney, nil ]];
            }
                break;
            case 3:
            {
                //支付宝
                [weakPayView setLogistModel:[NSArray arrayWithObjects:@"平台使用费",publishMoney,@"无",trueMoney, nil ]];
            }
                break;
            case 4:
            {
                for (UIButton *btn in weakPayView.payBtns) {
                    if (btn.selected) {
                        [weakSelf payWithTag:btn.tag obj:dataDic];
                    }
                    
                }
            }
                break;
                
            default:
                break;
        }
    };
    [_payView show];
}

- (void)payWithTag:(NSInteger )tag obj:(NSDictionary *)obj{
    [SVProgressHUD show];
    NSMutableString *billCode = [obj valueForKey:@"billCode"];
    NSString *str = [NSString stringWithFormat:@"%@logistics/task/balancePay?userId=%@&billCode=%@&counterFee=%@&type=%@",BaseUrl,[UserManager getDefaultUser].userId,[obj valueForKey:@"billCode"],[obj valueForKey:@"evaluationStatus"],@"1"];
    
    switch (tag) {
        case 1:
            //余额支付
        {
            [ExpressRequest sendWithParameters:nil MethodStr:str reqType:k_GET success:^(id object) {
                [SVProgressHUD showSuccessWithStatus:[object objectForKey:@"message"]];
                [self notice];
            } failed:^(NSString *error) {
                [SVProgressHUD showErrorWithStatus:error];
            }];
        }
            
            break;
        case 2:
            //微信支付
        {
//            		GET		String billCode，String price
            NSLog(@"微信支付");
            [SVProgressHUD show];
            NSString *URLStr = [NSString stringWithFormat:@"%@logistics/task/pay/wechat/pre?billCode=%@&price=%@&type=%@",BaseUrl,billCode,obj[@"evaluationScore"],@"1"];
            [ExpressRequest sendWithParameters:nil MethodStr:URLStr
                                       reqType:k_GET
                                       success:^(id object) {
                                           NSDictionary *preDic = [object objectForKey:ARG_DATA][0];
                                           [SVProgressHUD dismiss];
                                           PayReq* req = [[PayReq alloc] init];
                                           req.partnerId           = [preDic valueForKey:@"partnerId"];
                                           req.prepayId            = [preDic valueForKey:@"prepayid"];
                                           req.nonceStr            = [preDic valueForKey:@"nonceStr"];
                                           req.timeStamp           = [[preDic valueForKey:@"timestamp"] intValue];
                                           req.package             = [preDic valueForKey:@"package_"];
                                           req.sign                = [preDic valueForKey:@"sign"];
                                           [WXApi sendReq:req];
                                           WXPayManager *wxManager = [WXPayManager shareManager];
                                           NSString *newBillCode = [NSString stringWithFormat:@"%@A",billCode];
                                           wxManager.billCode = newBillCode;
                                       }
                                        failed:^(NSString *error) {
                                            [SVProgressHUD showErrorWithStatus:error];
                                        }];
        }
           break;
        case 3:
            //支付宝支付
        {

            float value = [obj[@"evaluationScore"] doubleValue];
            NSString *amount = [NSString stringWithFormat:@"%.2f",value];
            NSString *newBillCode = [NSString stringWithFormat:@"%@A",billCode];
            [AlipayRequestConfig alipayWithPartner:kPartnerID seller:kSellerAccount tradeNO:newBillCode productName:@"镖王" productDescription:@"平台使用费" amount:amount notifyURL:kNotifyURL itBPay:@"30m" standbyCallback:^(NSDictionary *resultDic) {
                [SVProgressHUD dismiss];
                if ([[resultDic objectForKey:@"resultStatus"] integerValue]==9000) {
                    NSLog(@"支付宝充值成功");
                    [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"恭喜您支付成功%@元！",amount]];
                    [self checkResultWithBillCode:newBillCode];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else {
                    NSLog(@"%@",resultDic);
                    [SVProgressHUD showErrorWithStatus:[resultDic objectForKey:@"memo"] ];
                }
            }];
            
         }
            break;
        default:
            break;
    }
}

- (void)checkResultWithBillCode:(NSString *)billCode{
    [RequestManager getPayResultWithBillCode:billCode success:^(NSDictionary *result) {
        NSLog(@"%@",result);
        [self notice];
    } Failed:^(NSString *error) {
        [PXAlertView showAlertWithTitle:error];
    }];
}

- (void)notice{
//    [_payView dismiss];
    [_userPayView dismiss];
    NSDictionary *dic = @{CLASS_NAME:@"UserLogListViewController"};
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:GOTOVC object:dic];
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
