//
//  LCFPayViewConstroller.m
//  iwant
//
//  Created by 公司 on 2017/10/12.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "LCFPayViewConstroller.h"
#import "CouponViewController.h"
#import "Wallet.h"
#import "RechargeViewController.h"
#import "WXApi.h"
#import "AlipayHeader.h"
#import "WXPayManager.h"
@interface LCFPayViewConstroller (){
    
    int _payType;  //支付方式  1余额  2微信   3支付宝
    NSString *_couponId; //现金券使用
    NSString * _distance; //距离
    NSString * _transferMoney;  //最后需要支付的钱
    
     UITextField * _otherPhonetextField; //代付人手机号
}
@property (strong, nonatomic)  NSMutableArray *couponArray;  //现金券的数组

@end

@implementation LCFPayViewConstroller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCostomeTitle:@"付款"];
    _payType = 0;
    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    
    self.yueBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 75, 75)];
//    self.yueBtn.centerX = SCREEN_WIDTH/8;
    [self.yueBtn addTarget:self action:@selector(payBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.yueBtn setImage:[UIImage imageNamed:@"Pay_1"] forState:UIControlStateNormal];
    [self.yueBtn setImage:[UIImage imageNamed:@"Pay_10"] forState:UIControlStateSelected];
    self.yueBtn.tag = 1;
    
    self.weChatBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 75, 75)];
//    self.weChatBtn.centerX = SCREEN_WIDTH*3/8;
    [self.weChatBtn addTarget:self action:@selector(payBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.weChatBtn setImage:[UIImage imageNamed:@"Pay_2"] forState:UIControlStateNormal];
    [self.weChatBtn setImage:[UIImage imageNamed:@"Pay_20"] forState:UIControlStateSelected];
    self.weChatBtn.tag = 2;
    
    self.AliBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 75, 75)];
//    self.AliBtn.centerX = SCREEN_WIDTH*5/8;
    [self.AliBtn addTarget:self action:@selector(payBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.AliBtn setImage:[UIImage imageNamed:@"Pay_3"] forState:UIControlStateNormal];
    [self.AliBtn setImage:[UIImage imageNamed:@"Pay_30"] forState:UIControlStateSelected];
    self.AliBtn.tag = 3;
    
    self.otherPayBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 75, 75)];
//    self.otherPayBtn.centerX = SCREEN_WIDTH*7/8;
   
    [self.otherPayBtn addTarget:self action:@selector(payBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.otherPayBtn setImage:[UIImage imageNamed:@"Pay_4"] forState:UIControlStateNormal];
    [self.otherPayBtn setImage:[UIImage imageNamed:@"Pay_40"] forState:UIControlStateSelected];
    self.otherPayBtn.tag = 4;

    /**
    重新布局UI   去掉支付宝支付方式
    */
    self.yueBtn.centerX =SCREEN_WIDTH/4;
    self.weChatBtn.centerX = SCREEN_WIDTH/2;
    self.otherPayBtn.centerX =SCREEN_WIDTH*3/4;
    
    [self.btnBgView addSubview:self.yueBtn];
    if ([self.sendType isEqualToString:@"1"]) {
        if ((![self.model.carType isEqualToString:@"else"])&&(![self.model.carType isEqualToString:@"sanlun"])) {
           
            self.weChatBtn.centerX = SCREEN_WIDTH/3;
            self.otherPayBtn.centerX = SCREEN_WIDTH*2/3;
            self.yueBtn.hidden = YES;
        }
    }
    [self.btnBgView addSubview:self.weChatBtn];
//    [self.btnBgView addSubview:self.AliBtn];
    [self.btnBgView addSubview:self.otherPayBtn];
    
    //保存找人代付的userId 区分是否找人代付款过
    if (self.model.replaceUserId.length !=0) {
        self.otherPayBtn.hidden = YES;
//        self.yueBtn.centerX = SCREEN_WIDTH/4;
//        self.weChatBtn.centerX = SCREEN_WIDTH/2;
//        self.AliBtn.centerX = SCREEN_WIDTH*3/4;
        self.yueBtn.centerX = SCREEN_WIDTH/3;
        self.weChatBtn.centerX =SCREEN_WIDTH*2/3;
    }
    [self creatUI];
}

-(void)creatUI{
    self.payNameLabel.text = self.payName;
    _distance =[NSString stringWithFormat:@"%0.2f",[self.model.distance floatValue]/1000];
    _transferMoney = [NSString stringWithFormat:@"%0.2f",[self.model.transferMoney floatValue]];
    self.transformoneyLable.text =[NSString stringWithFormat:@"%0.2f元",([self.model.transferMoney doubleValue] - [self.model.insureCost doubleValue])];
    self.insureLabel.text = [NSString stringWithFormat:@"%0.2f元(保额：%0.2f元)",[self.model.insureCost doubleValue] ,[self.model.premium doubleValue]];
    self.needPayMoneyLabel.text = [NSString stringWithFormat:@"共计：%0.2f元(%0.2fkm)",[self.model.transferMoney doubleValue],[self.model.distance floatValue]/1000];
    if ([_model.whether isEqualToString:@"N"]) {
        self.baoXianLabel.text = @"";
        self.insureLabel.text = @"";
        self.baoxianConstraint.constant = -1.0;
        self.viewHeightConstraint.constant = 205;
    }else{
        self.baoXianLabel.text = @"保险费用";
        self.insureLabel.text = [NSString stringWithFormat:@"%0.2f元(保额：%0.2f元)",[self.model.insureCost doubleValue] ,[self.model.premium doubleValue]];
        self.baoxianConstraint.constant = 45;
        self.viewHeightConstraint.constant = 250;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//是否用现金券
- (IBAction)switchBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        CouponViewController *couVC = [[CouponViewController alloc]init];
        couVC.isPay = YES;
        couVC.needMoney = self.model.transferMoney;
        couVC.billcode = self.model.billCode;
        couVC.shunfengBlock = ^(NSString *couponName,NSMutableArray *_selectArray) {
            //选取了现金券
            if (![couponName isEqualToString:@""] && ![couponName isEqualToString:@"&"]) {
                 _couponId = [NSString stringWithFormat:@"%@",couponName];
                self.couponArray = _selectArray;
                [self reloadDataWithCoupon:self.couponArray];
            }else{
                sender.selected = NO;
                self.couponArray = nil;
                _couponId = @"";
                [self reloadDataWithCoupon:_selectArray];
                self.couponLabel.text=@"";
            }
        };
     [self.navigationController pushViewController:couVC animated:YES];
    }else{
        sender.selected = NO;
        [self reloadDataWithCoupon:nil];
        self.couponArray = nil;
        _couponId = @"";
        self.couponLabel.text = @"";
        self.needPayMoneyLabel.text = [NSString stringWithFormat:@"共计：%0.2f元(%@km)",[self.model.transferMoney floatValue],_distance];
    }
}

#pragma mark --- 更新使用现金券界面
- (void)reloadDataWithCoupon:(NSMutableArray *)couponArray{
    self.weChatBtn.enabled = YES;
    self.AliBtn.enabled = YES;
    self.otherPayBtn.enabled = YES;
    float couponMoney;
    Wallet *model = couponArray.lastObject;
    couponMoney = [model.money floatValue];
    float _needPayMoney;
    _needPayMoney = [self.model.transferMoney floatValue]- couponMoney;
    self.couponLabel.text = [NSString stringWithFormat:@"%@元%@",model.money,model.couponName];
    self.needPayMoneyLabel.text = [NSString stringWithFormat:@"共计：%0.2f元(%@km)",_needPayMoney,_distance];
    _transferMoney = [NSString stringWithFormat:@"%0.2f",_needPayMoney];
    if (_needPayMoney <= 0) {
        self.needPayMoneyLabel.text = [NSString stringWithFormat:@"共计：0 元(%@km)",self.model.distance];
        self.yueBtn.selected = YES;
        self.weChatBtn.selected = NO;
        self.AliBtn.selected = NO;
        self.otherPayBtn.selected = NO;
        self.weChatBtn.enabled = NO;
        self.AliBtn.enabled = NO;
        self.otherPayBtn.enabled = NO;
    }
}

-(void)payBtnClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        switch (sender.tag) {
            case 1:{
                _payType = 1;
                self.weChatBtn.selected = NO;
                self.AliBtn.selected = NO;
                self.otherPayBtn.selected = NO;
            }
                break;
            case 2:{
                _payType = 2;
                self.yueBtn.selected = NO;
                self.AliBtn.selected = NO;
                self.otherPayBtn.selected = NO;
            }
                break;
            case 3:{
                _payType = 3;
                self.yueBtn.selected = NO;
                self.weChatBtn.selected = NO;
                self.otherPayBtn.selected = NO;
            }
                break;
            case 4:{
                _payType = 0;
                self.yueBtn.selected = NO;
                self.weChatBtn.selected = NO;
                self.AliBtn.selected = NO;
                self.otherPayBtn.selected = NO;
                [self findOtherPay];
            }
                break;
            default:
                break;
        }
    }else{
        _payType = 0;
    }
}

#pragma mark ------ 付款方式  找人代付
-(void)findOtherPay{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"请输入代付人手机号" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (_otherPhonetextField.text.length != 11) {
            [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
            return;
        }
        NSString * urlStr = [NSString stringWithFormat:@"%@downwind/task/replace?recId=%@&mobile=%@",BaseUrl,self.model.recId,_otherPhonetextField.text];
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

//确认支付
- (IBAction)paySureBtnClick:(UIButton *)sender {
    if (_payType == 0) {
        [SVProgressHUD showErrorWithStatus:@"请先选择一种付款方式"];
        return;
    }
    //余额支付  三方支付均可使用现金券
   [ExpressRequest sendWithParameters:nil MethodStr:[NSString stringWithFormat:@"%@downwind/task/coupon?recId=%@&userCouponId=%@",BaseUrl,self.model.recId,_couponId ? _couponId : @""]reqType:k_GET success:^(id object) {
      switch (_payType) {
        case 1:{
            NSLog(@"余额");
            [SVProgressHUD show];
            [RequestManager payByyueBillCode:self.model.billCode
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
            break;
        case 2:{
            NSLog(@"wx");
            [SVProgressHUD show];
            [RequestManager getWXPreWithBillCode:self.model.billCode
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
                                             wxManager.billCode = self.model.billCode;
                                         } Failed:^(NSString *error) {
                                             [SVProgressHUD showErrorWithStatus:error];
                                         }];
        }
            break;
        case 3:{
            NSLog(@"alpay");
            [AlipayRequestConfig alipayWithPartner:kPartnerID seller:kSellerAccount tradeNO:self.model.billCode productName:@"镖王" productDescription:self.payName amount:_transferMoney notifyURL:kNotifyURL itBPay:@"30m" standbyCallback:^(NSDictionary *resultDic)
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
        default:
            break;
      }
   } failed:^(NSString *error) {
     [SVProgressHUD showWithStatus:error];
  }];
}

- (void)checkResult{
    [RequestManager getPayResultWithBillCode:self.model.billCode success:^(NSDictionary *result) {
        NSLog(@"%@",result);
        [self goHome];
    } Failed:^(NSString *error) {
        [PXAlertView showAlertWithTitle:error];
    }];
}

#pragma mark ---- 支付成功后的操作返回的首界面
- (void)goHome{
    _payType = 0;
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:PUBLISH_SUCCESS object:nil];
    
    //给推送 附近的镖师正忙
    [ExpressRequest sendWithParameters:nil MethodStr:[NSString stringWithFormat:@"%@downwind/task/afterPublish?recId=%@",BaseUrl,self.model.recId] reqType:k_GET success:^(id object) {
        
    } failed:^(NSString *error) {
        int errCode = [[[NSUserDefaults standardUserDefaults] objectForKey:@"errCode"] intValue];
        if (errCode == -2){
            [SVProgressHUD showInfoWithStatus:error];
        }
    }];
    
}
@end
