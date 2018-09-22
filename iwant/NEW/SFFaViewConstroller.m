//
//  SFFaViewConstroller.m
//  iwant
//
//  Created by 公司 on 2017/6/2.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "SFFaViewConstroller.h"
#import "MainHeader.h"
#import "EcoinWebViewController.h"
#import "PayView.h"
#import "CouponViewController.h"
#import "Wallet.h"
#import "CouponTableViewCell.h"
#import "WXApi.h"
#import "AlipayHeader.h"
#import "WXPayManager.h"
#import "RechargeViewController.h"
#import "KeyChain.h"
#import "LCFPayViewConstroller.h"
#import "ActionSheetStringPicker.h"

@interface SFFaViewConstroller ()<UITableViewDelegate,UITableViewDataSource>{
    NSString *_transferMoney;//需要支付（没扣除现金券之前）的总费用
    NSString * _premium;  //保额
    NSString *_insuerCost;  //投保金额
    //现金券
    NSString *_couponId;
    int _payType;//1-余额 2-微信 3-支付宝
    PayView *_payView;
    
    ShunFeng * _model;
    NSString * _recId; //所发单的ID
    
    NSString * _ifReplaceMoney;//是否代收款
    NSString *_whether;  //  是否投保
    NSString * _category; //货物类型
    NSString * _insurance;   //承险类别  1 基本险  2综合险
    
    UITextField * _otherPhonetextField; //代付人手机号
    
    NSString * _needPayMoney;
    
}
@property(nonatomic,strong)UIButton * catoryBtn;  //物品种类
@property (strong, nonatomic)  UITableView *couponTableView;
@property (strong, nonatomic)  NSMutableArray *couponArray;

//物品种类 生活用品、文件、美食、蛋糕、鲜花、数码产品、其他
@property (nonatomic,strong) NSArray *cargoNameArray;

@end

@implementation SFFaViewConstroller

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}
-(void)layOut{
    self.topConstraint.constant = 18*RATIO_HEIGHT;
    self.faViewHeightConstraint.constant = 40*RATIO_HEIGHT;
    self.shouViewHeightConstraint.constant = 40*RATIO_HEIGHT;
    self.cargoTypeViewConstraint.constant = 120* RATIO_HEIGHT;
    if (SCREEN_WIDTH == 320) {
        self.cargoTypeHeightConstraint1.constant = 20;
        self.cargoTypeHeightConstraint2.constant = 20;
        self.cargoTypeHeightConstraint4.constant = 20;
    }
    
    self.detailViewHeight.constant = 160*RATIO_HEIGHT;
    self.nameTextfieldHeightConstraint.constant = 40*RATIO_HEIGHT;
    self.daishouHeightConstraint.constant = 40*RATIO_HEIGHT;
    self.remarkHeightConstraint.constant = 45*RATIO_HEIGHT;
    self.noticeTopConstraint.constant = 50*RATIO_HEIGHT;
    self.fabuBtnTopConstraint.constant = 44*RATIO_HEIGHT;
    self.lineTopConstraint.constant = 8 * RATIO_HEIGHT;
    
    self.topNoticeL.font = FONT(15, NO);
    self.sendNameTextField.font = FONT(17, NO);
    self.receiveNameTextField.font = FONT(17, NO);
    self.sendPhoneTextField.font = FONT(17, NO);
    self.receivePhoneTextField.font = FONT(17, NO);
    self.nameL.font = FONT(17, NO);
    self.mateNameTextField.font = FONT(17, NO);
    self.noticeL.font = FONT(18, NO);
    
    self.mateValue.font = FONT(14, NO);
    self.mateType.font = FONT(14, NO);
    self.toubaoBtn.titleLabel.font = FONT(16, NO);
    self.replaceMoneyBtn.titleLabel.font = FONT(16, NO);
    self.replaceMoneyTextField.font = FONT(14, NO);
    self.remarkTextView.font = FONT(14, NO);
    self.placeholderLabel.font = FONT(14, NO);
    self.remarkL.font = FONT(16, NO);
    
    [self.matTypeBtn.titleLabel setFont:FONT(16, NO)];
    
    self.mateTypeView.hidden = YES;
    self.mateValue.userInteractionEnabled = NO;
    self.replaceMoneyTextField.userInteractionEnabled = NO;
    self.replaceMoneyTextField.keyboardType =UIKeyboardTypeDecimalPad;
    
    [self.mateValue  addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark ----lazyLoad
//现金券列表
-(UITableView *)couponTableView{
    if (!_couponTableView) {
        
        _couponTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH - 90,WINDOW_WIDTH == 320 ? 40 : 60 ) style:UITableViewStylePlain];
        
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
    // Do any additional setup after loading the view from its nib.
    _whether = @"N";
    _ifReplaceMoney = @"0";
    _category = @"";
    [self layOut];
    [self ShowNavgationView];
    self.sendNameTextField.text = [UserManager getDefaultUser].userName;
    self.sendPhoneTextField.text = [UserManager getDefaultUser].mobile;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goHome) name:WECHAT_BACK_SF object:nil];
    if ([UserManager getDefaultUser].shopType == 1) {
        [self getChapmanData];
    }
    _cargoNameArray = @[@"生活用品",@"文件",@"美食",@"蛋糕",@"鲜花",@"数码产品",@"其他"];
    self.mateNameTextField.text = _cargoNameArray[0];
    //如果是再来一单了
    if (_publishAgain) {
        _whether = self.sfModel.whether;
        _ifReplaceMoney = self.sfModel.ifReplaceMoney?@"1":@"0";
        _category = self.sfModel.category;
        self.sendNameTextField.text = self.sfModel.personName;
        self.sendPhoneTextField.text = self.sfModel.mobile;
        self.receiveNameTextField.text = self.sfModel.personNameTo;
        self.receivePhoneTextField.text = self.sfModel.mobileTo;
        self.mateNameTextField.text = self.sfModel.matName;
        if (self.sfModel.matRemark.length != 0) {
            _placeholderLabel.hidden = YES;
        }
        self.remarkTextView.text = self.sfModel.matRemark;
        if ([self.sfModel.whether isEqualToString:@"Y"]) {
            _toubaoBtn.selected = YES;
            self.mateValue.text = self.sfModel.premium;
            if ([self.sfModel.premium floatValue] >5000) {
                self.matTypeBtn.hidden = NO;
                self.mateType.hidden = NO;
                switch ([self.sfModel.category intValue]) {
                        //1 常规货物、2 蔬菜水果、3 冷藏冷冻货、4 易碎品
                    case 1:
                        self.mateType.text =@"常规货物";
                        break;
                    case 2:
                        self.mateType.text =@"蔬菜";
                        break;
                    case 3:
                        self.mateType.text =@"水果";
                        break;
                    case 4:
                        self.mateType.text =@"牲畜及禽鱼";
                        break;
                    default:
                        break;
                }
            }
        }
        if (self.sfModel.ifReplaceMoney && self.sfModel.replaceMoney.length!=0) {
            _replaceMoneyBtn.selected = YES;
            self.replaceMoneyTextField.text = self.sfModel.replaceMoney;
        }
    }
}
#pragma mark ---- 商户默认信息啊
-(void)getChapmanData{
    NSString * urlStr = [NSString stringWithFormat:@"%@check/getChapman?userId=%@",BaseUrl,[UserManager getDefaultUser].userId];
    [SVProgressHUD show];
    [ExpressRequest sendWithParameters:nil MethodStr:urlStr reqType:k_GET success:^(id object) {
        [SVProgressHUD dismiss];
        NSArray * arr = [object valueForKey:@"data"][0];
        self.sendNameTextField.text=[arr valueForKey:@"shopName"];
    } failed:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
}

- (IBAction)btnClick:(UIButton *)sender {
    //0 发件人 1收件人 2 投保 3投保说明 4 物品类型 5代收款 6 发布啦
    switch (sender.tag) {
        case 0:{
            [Contacts judgeAddressBookPowerWithUIViewController:self contactsBlock:^(NSString *name, NSString *phoneNumber) {
                self.sendNameTextField.text = name;
                self.sendPhoneTextField.text = phoneNumber;
            }];
        }
            break;
        case 1:{
            [Contacts judgeAddressBookPowerWithUIViewController:self contactsBlock:^(NSString *name, NSString *phoneNumber) {
                self.receiveNameTextField.text = name;
                self.receivePhoneTextField.text = phoneNumber;
            }];
        }
            break;
        case 2:{
            sender.selected = !sender.selected;
            if (sender.selected) {
                //后台请求接口顺风的投保费率问题
                NSString * strUrl = [NSString stringWithFormat:@"%@%@",BaseUrl,API_SF_TOUBAO_FEILU];
                [ExpressRequest sendWithParameters:nil MethodStr:strUrl reqType:k_GET success:^(id object) {
                    NSString * message = [object objectForKey:@"message"];
                    HHAlertView *alert = [[HHAlertView alloc]initWithTitle:@"温馨提示" detailText:message cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                    [alert show];
                    _mateValue.userInteractionEnabled = YES;
                    _whether = @"Y";
                } failed:^(NSString *error) {
                    [SVProgressHUD showErrorWithStatus:error];
                }];
            }else{
                _whether = @"N";
                _mateValue.userInteractionEnabled = NO;
                _mateValue.text = @"";
                self.mateTypeView.hidden = YES;
                self.matTypeBtn.hidden = YES;
                self.mateType.hidden = YES;
                self.mateType.text = @"";
                self.lineTopConstraint.constant = 8;
                self.insureLabel.hidden = YES;
                self.jiBenBtn.hidden = YES;
                self.zongHeBtn.hidden = YES;
                self.detailViewHeight.constant = 160*RATIO_HEIGHT;
            }
        }
            break;
        case 3:{
            EcoinWebViewController *vc = [[EcoinWebViewController alloc]init];
            vc.web_type = WEB_insureSF;
            vc.insureUrl = self.insureUrl;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4:{
            sender.selected = !sender.selected;
            if (sender.selected) {
                self.mateTypeView.hidden = NO;
            }else{
                self.mateTypeView.hidden = YES;
            }
        }
            break;
        case 5:{
            sender.selected = !sender.selected;
            if (sender.selected) {
                HHAlertView *alert = [[HHAlertView alloc]initWithTitle:@"温馨提示" detailText:@"选择代收货款后，货款将由镖师代您收取，镖师收款完成后，货款将自动转入您的钱包。" cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                [alert show];
                _ifReplaceMoney =@"1";
                self.replaceMoneyTextField.userInteractionEnabled = YES;
            }else{
                self.replaceMoneyTextField.userInteractionEnabled = NO;
                self.replaceMoneyTextField.text = @"";
                _ifReplaceMoney =@"0";
            }
        }
            break;
        case 6:{
    //发布
            [self publishSure];
        }
            break;
        default:
            break;
    }
}

#pragma mark---物品名称变为物品种类
- (IBAction)cargoNameSelected:(UIButton *)sender {
    [ActionSheetStringPicker showPickerWithTitle:@"物品种类" rows:_cargoNameArray initialSelection:0 target:self successAction:@selector(cargoNameWasSelected:element:sender:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
}
-(void)cargoNameWasSelected:(NSNumber *)selectedIndex element:(id)element sender: (UIButton*) btn {
    self.mateNameTextField.text = [NSString stringWithFormat:@"%@",_cargoNameArray[[selectedIndex intValue]]];
}
- (void)actionPickerCancelled:(id)sender {
}

-(void)textFieldDidChange :(UITextField *)theTextField{
    NSString *num = theTextField.text;
    if ([num floatValue] > 5000) {
        self.matTypeBtn.hidden = NO;
        self.mateType.hidden = NO;
        self.lineTopConstraint.constant = 58;
        self.insureLabel.hidden = NO;
        self.jiBenBtn.hidden = NO;
        self.zongHeBtn.hidden = NO;
        self.detailViewHeight.constant = 210*RATIO_HEIGHT;
    }else{
        self.matTypeBtn.hidden = YES;
        self.mateType.hidden = YES;
        self.mateType.text = @"";
        self.lineTopConstraint.constant = 8;
        self.insureLabel.hidden = YES;
        self.jiBenBtn.hidden = YES;
        self.zongHeBtn.hidden = YES;
        self.detailViewHeight.constant = 160*RATIO_HEIGHT;
    }
}
//选择货物类型 //1 常规货物类、2 蔬菜、3 水果、4 牲畜及禽鱼
- (IBAction)matTypeBtnClick:(UIButton *)sender {
    _category = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    self.mateType.text = sender.titleLabel.text;
    self.mateTypeView.hidden = YES;
    
    if (self.catoryBtn == sender) {
        return;
    }
    self.catoryBtn = sender;
    self.jiBenBtn.selected = YES;
    self.zongHeBtn.selected = NO;
    _insurance = @"1";
    self.zongHeBtn.hidden = NO;
    if (sender.tag != 1) {
        self.zongHeBtn.hidden = YES;
    }
}
#pragma mark ---承保类型
- (IBAction)insureTypeBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if(sender.selected){
        if (sender.tag == 1) {
            _insurance = @"1";
            self.zongHeBtn.selected = NO;
        }else{
            _insurance = @"2";
            self.jiBenBtn.selected = NO;
        }
    }else{
        _insurance = @"";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---确认发布
-(void)publishSure{
    if (![self checkParem]) {
        return;
    }
    [SVProgressHUD show];
    if (!ARG_SAVED_IDFV) {
        NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [KeyChain save:ARG_IDFV data:idfv];
    }
    NSDictionary *parametersDict;
    if (_temp.length !=0) {
        parametersDict = @{@"userId":[UserManager getDefaultUser].userId,
                                         @"latitude":[[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCATION_LAT],
                                         @"longitude":[[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCATION_LON],
                                         @"personName":self.sendNameTextField.text,
                                         @"mobile":self.sendPhoneTextField.text,
                                         @"address":self.sfModel.address,
                                         @"cityCode":self.sfModel.cityCode,
                                         @"townCode":self.sfModel.townCode,
                                         @"publshDeviceId":ARG_SAVED_IDFV,
                                         @"fromLatitude":self.sfModel.fromLatitude ? self.sfModel.fromLatitude : @"",
                                         @"fromLongitude":self.sfModel.fromLongitude ? self.sfModel.fromLongitude :@"",
                                         @"personNameTo":self.receiveNameTextField.text,
                                         @"mobileTo":self.receivePhoneTextField.text,
                                         @"addressTo":self.sfModel.addressTo,
                                         @"cityCodeTo":self.sfModel.cityCodeTo ? self.sfModel.cityCodeTo:@"",
                                         @"toLatitude":self.sfModel.toLatitude ? self.sfModel.toLatitude:@"",
                                         @"toLongitude":self.sfModel.toLongitude ?self.sfModel.toLongitude:@"",
                                         @"matName":self.mateNameTextField.text,
                                         @"matRemark":self.remarkTextView.text?self.remarkTextView.text:@"",
                                         @"matWeight":self.sfModel.matWeight,
                                         @"carType":self.sfModel.carType,
                                         @"matVolume":self.sfModel.matVolume,
                                         @"cargoSize":self.sfModel.cargoSize,
                                         @"whether":_whether,
                                         @"premium":self.mateValue.text,
                                         @"ifReplaceMoney":_ifReplaceMoney,
                                         @"replaceMoney":self.replaceMoneyTextField.text,
                                         @"useTime":self.sfModel.useTime,
                                         @"category":self.catoryBtn ?[NSString stringWithInteger:self.catoryBtn.tag]:@"",
                                         @"insurance":_insurance?_insurance:@"",
                                         @"weatherId":_weatherId ?_weatherId :@"",
                                         @"temp":_temp
                                         };
    }else{
        parametersDict = @{@"userId":[UserManager getDefaultUser].userId,
                                     @"latitude":[[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCATION_LAT],
                                     @"longitude":[[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCATION_LON],
                                     @"personName":self.sendNameTextField.text,
                                     @"mobile":self.sendPhoneTextField.text,
                                     @"address":self.sfModel.address,
                                     @"cityCode":self.sfModel.cityCode,
                                     @"townCode":self.sfModel.townCode,
                                     @"publshDeviceId":ARG_SAVED_IDFV,
                                     @"fromLatitude":self.sfModel.fromLatitude ? self.sfModel.fromLatitude : @"",
                                     @"fromLongitude":self.sfModel.fromLongitude ? self.sfModel.fromLongitude :@"",
                                     @"personNameTo":self.receiveNameTextField.text,
                                     @"mobileTo":self.receivePhoneTextField.text,
                                     @"addressTo":self.sfModel.addressTo,
                                     @"cityCodeTo":self.sfModel.cityCodeTo ? self.sfModel.cityCodeTo:@"",
                                     @"toLatitude":self.sfModel.toLatitude ? self.sfModel.toLatitude:@"",
                                     @"toLongitude":self.sfModel.toLongitude ?self.sfModel.toLongitude:@"",
                                     @"matName":self.mateNameTextField.text,
                                     @"matRemark":self.remarkTextView.text?self.remarkTextView.text:@"",
                                     @"matWeight":self.sfModel.matWeight,
                                     @"carType":self.sfModel.carType,
                                     @"matVolume":self.sfModel.matVolume,
                                     @"cargoSize":self.sfModel.cargoSize,
                                     @"whether":_whether,
                                     @"premium":self.mateValue.text,
                                     @"ifReplaceMoney":_ifReplaceMoney,
                                     @"replaceMoney":self.replaceMoneyTextField.text,
                                     @"useTime":self.sfModel.useTime,
                                     @"category":self.catoryBtn ?[NSString stringWithInteger:self.catoryBtn.tag]:@"",
                                     @"insurance":_insurance?_insurance:@"",
                                     @"weatherId":_weatherId ?_weatherId :@"",
                                     };
    }
    [ExpressRequest sendWithParameters:parametersDict MethodStr:API_PUBLISH_SF_TASK reqType:k_POST success:^(id object) {
        [SVProgressHUD dismiss];
        NSMutableArray * result =[object valueForKey:@"data"];
        double temp = [result[0][@"transferMoney"] doubleValue];
        _transferMoney = [NSString stringWithFormat:@"%0.2f",temp];
        double temp2 = [result[0][@"insureCost"] doubleValue];
        _insuerCost = [NSString stringWithFormat:@"%0.2f",temp2];
        _premium = result[0][@"premium"];
        _model = [[ShunFeng alloc]initWithJsonDict:result[0]];
        _sfModel.billCode = result[0][@"billCode"];
        _recId = result[0][@"recId"];
//        [self CreatPopView:_transferMoney];
        LCFPayViewConstroller * payVC = [[LCFPayViewConstroller alloc]init];
        payVC.model =_model;
        payVC.payName = @"顺路送";
        if ([self.sendType isEqualToString:@"1"]) {
            payVC.sendType = @"1";
        }
        [self.navigationController pushViewController:payVC animated:YES];

    } failed:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
}
//判断填写信息是否完成
-(BOOL)checkParem{
    if (self.sendNameTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请填写发件人姓名"];
        return NO;
    }
    if (self.receiveNameTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请填写收件人姓名"];
        return NO;
    }
    if (self.receivePhoneTextField.text.length != 11) {
        [SVProgressHUD showErrorWithStatus:@"请填写正确的收件人电话"];
        return NO;
    }
    if (self.sendPhoneTextField.text.length != 11) {
        [SVProgressHUD showErrorWithStatus:@"请填写正确的发件人电话"];
        return NO;
    }
    if (self.mateNameTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请填写真实的物品名称"];
        return NO;
    }
    if ([_whether isEqualToString:@"Y"]&& self.mateValue.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请填写物品价值"];
        return NO;
    }
    if ([_whether isEqualToString:@"Y"]&& [self.mateValue.text intValue] >5000 && !self.catoryBtn) {
        [SVProgressHUD showErrorWithStatus:@"请选择货物类型"];
        return NO;
    }
    if ([_whether isEqualToString:@"Y"]&& [self.mateValue.text intValue] >5000 && _insurance.length ==0) {
        [SVProgressHUD showErrorWithStatus:@"请选择承保类型"];
        return NO;
    }
    if ([_ifReplaceMoney isEqualToString:@"1"] && self.replaceMoneyTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请填写代收款金额"];
        return NO;
    }
    return YES;
}

-(void)CreatPopView:(NSString *)money
{
    _couponId = @"";
    _payType = 0;
    
    NSString *yunfei = [NSString stringWithFormat:@"%0.2f",([_transferMoney doubleValue] - [_insuerCost doubleValue])];
    
    _payView = [[[NSBundle mainBundle] loadNibNamed:@"PayView" owner:nil options:nil] lastObject];
    NSString * distance =[NSString stringWithFormat:@"%0.2f", [_model.distance floatValue]/1000];
    [_payView setModel:[NSArray arrayWithObjects:@"顺路送",[NSString stringWithFormat:@"%@ 元",yunfei],[NSString stringWithFormat:@"%@元(保额：%@元)",_insuerCost,_premium],[NSString stringWithFormat:@"%@",_transferMoney],distance,nil]];
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
                    [weakPayView setModel:[NSArray arrayWithObjects:@"顺路送",[NSString stringWithFormat:@"%@元",yunfei],[NSString stringWithFormat:@"%@元(保额：%@元)",_insuerCost,_premium],[NSString stringWithFormat:@"%@",_transferMoney],distance,nil]];
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
                    couVC.billcode = _sfModel.billCode;
                    couVC.shunfengBlock = ^(NSString *couponName,NSMutableArray *_selectArray){
                        //选取了现金券
                        if (![couponName isEqualToString:@""] && ![couponName isEqualToString:@"&"]) {
                            weakPayView.couponSwitch.on = YES;
                            [weakPayView.table addSubview:self.couponTableView];
                            _couponArray = _selectArray;
                            [self.couponTableView reloadData];
                            _couponId = [NSString stringWithFormat:@"%@",couponName];
                            _payType = 1;
                            weakPayView.weixinBtn.enabled = YES;
                            weakPayView.alipayBtn.enabled = YES;
                            weakPayView.weixinBtn.selected = NO;
                            weakPayView.alipayBtn.selected = NO;
                            weakPayView.yueBtn.selected = YES;
                        }else{
                            //进到现金券界面 ，为选取快递券
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
            case 5:{
                [self findOtherPay];
            }
                break;
            case 666:{
                //这时候需要支付的金额是0
                weakPayView.weixinBtn.enabled = NO;
                weakPayView.alipayBtn.enabled = NO;
                weakPayView.weixinBtn.selected = NO;
                weakPayView.alipayBtn.selected = NO;
                weakPayView.yueBtn.selected = YES;
            }
                break;
            default:
                break;
        }
    };
    _payView.needPayBlock = ^(double needPayMoney) {
        if (!weakPayView.couponSwitch.isOn) {
           //未选择现金券不需要操作
        }else{
            //三方支付 选择了现金券的时候
            _needPayMoney = [NSString stringWithFormat:@"%.2f",needPayMoney];
        }
    };
    [_payView show];
}
#pragma mark ------ 付款方式  找人代付
-(void)findOtherPay{
    [_payView dismiss];
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"请输入代付人手机号" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (_otherPhonetextField.text.length != 11) {
            [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
            return;
        }
        NSString * urlStr = [NSString stringWithFormat:@"%@downwind/task/replace?recId=%@&mobile=%@",BaseUrl,_recId,_otherPhonetextField.text];
        [ExpressRequest sendWithParameters:nil MethodStr:urlStr reqType:k_GET success:^(id object) {
            NSString * message = [object valueForKey:@"message"];
            [SVProgressHUD showSuccessWithStatus:message];
            [self.navigationController popToRootViewControllerAnimated:YES];
        } failed:^(NSString *error) {
            [SVProgressHUD showErrorWithStatus:error];
        }];
    }];
    
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入代付人手机号";
        _otherPhonetextField = textField;
        textField.keyboardType = UIKeyboardTypePhonePad;
    }];
    [alertVC addAction:cancle];
    [alertVC addAction:sure];
    [[Utils getCurrentVC] presentViewController:alertVC animated:YES completion:nil];
}
#pragma mark ------ 付款方式   自己支付
- (void)tapBtn:(int)tag{
    if (tag == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择支付方式"];
        return;
    }
    //余额支付  三方支付均可使用现金券
    [ExpressRequest sendWithParameters:nil MethodStr:[NSString stringWithFormat:@"%@downwind/task/coupon?recId=%@&userCouponId=%@",BaseUrl,_recId,_couponId ? _couponId : @""]reqType:k_GET success:^(id object) {
        switch (tag) {
            case 1:
            {
                NSLog(@"余额支付");
                HHAlertView *alert = [[HHAlertView alloc]initWithTitle:nil detailText:@"确认使用余额支付？" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"]];
                alert.mode = HHAlertViewModeWarning;
                [alert showWithBlock:^(NSInteger index) {
                    if (index != 0) {
                        [SVProgressHUD show];
                        [RequestManager payByyueBillCode:_sfModel.billCode
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
                                                                 [_payView dismiss];
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
            case 2:
            {
                NSLog(@"微信支付");
                [SVProgressHUD show];
                
                [RequestManager getWXPreWithBillCode:_sfModel.billCode
                                             matName:@"" matType:@"" insuranceFee:@""insureMoney:@""needPayMoney:_transferMoney shipMoney:@"" weight:@""
                                             success:^(NSDictionary *object) {
                                                 NSLog(@"%@",object);
                                                 [SVProgressHUD dismiss];
                                                 PayReq* req = [[PayReq alloc] init];
                                                 req.partnerId           = [object valueForKey:@"partnerId"];
                                                 req.prepayId            = [object valueForKey:@"prepayid"];
                                                 req.nonceStr            = [object valueForKey:@"nonceStr"];
                                                 req.timeStamp           = [[object valueForKey:@"timestamp"] intValue];
                                                 req.package             = [object valueForKey:@"package_"];
                                                 req.sign                = [object valueForKey:@"sign"];
                                                 [WXApi sendReq:req];
                                                 WXPayManager *wxManager = [WXPayManager shareManager];
                                                 wxManager.billCode = _sfModel.billCode;
                                             } Failed:^(NSString *error) {
                                                 [SVProgressHUD showErrorWithStatus:error];
                                             }];
            }
                break;
            case 3:
            {
                NSString * moneyAliPay ;
                if (!_payView.couponSwitch.isOn) {
                    //未选择现金券不需要操作
                    moneyAliPay = _transferMoney;
                }else{
                    //三方支付 选择了现金券的时候
                    moneyAliPay = _needPayMoney;
                }
                
                NSLog(@"支付宝支付");
                [AlipayRequestConfig alipayWithPartner:kPartnerID seller:kSellerAccount tradeNO:_sfModel.billCode productName:@"镖王" productDescription: @"顺路送" amount:moneyAliPay notifyURL:kNotifyURL itBPay:@"30m" standbyCallback:^(NSDictionary *resultDic)
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
        }
        
    } failed:^(NSString *error) {
        [SVProgressHUD showWithStatus:error];
    }];
}

- (void)checkResult{
    [RequestManager getPayResultWithBillCode:_sfModel.billCode success:^(NSDictionary *result) {
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
    [[NSNotificationCenter defaultCenter] postNotificationName:PUBLISH_SUCCESS object:nil];

    //给推送 附近的镖师正忙
    [ExpressRequest sendWithParameters:nil MethodStr:[NSString stringWithFormat:@"%@downwind/task/afterPublish?recId=%@",BaseUrl,_recId] reqType:k_GET success:^(id object) {
        
    } failed:^(NSString *error) {
        int errCode = [[[NSUserDefaults standardUserDefaults] objectForKey:@"errCode"] intValue];
        if (errCode == -2){
            [SVProgressHUD showInfoWithStatus:error];
        }
    }];
    
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

#pragma mark ---textView delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text

{
    if (![text isEqualToString:@""]){
        _placeholderLabel.hidden = YES;
    }
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1)
    {
        _placeholderLabel.hidden = NO;
    }
    return YES;
}
/*
 (1) _placeholderLabel 是加在UITextView后面的UITextView，_placeholderLabel要保证和真正的输入框的设置一样，字体设置成浅灰色，然后[_placeholderLabel setEditable:NO];真正的输入框要设置背景色透明，保证能看到底部的_placeholderLabel。
 (2) [text isEqualToString:@""] 表示输入的是退格键
 (3) range.location == 0 && range.length == 1 表示输入的是第一个字符
*/

@end
