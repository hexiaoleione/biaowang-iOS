//
//  OrderViewController.m
//  iwant
//
//  Created by dongba on 16/8/30.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "OrderViewController.h"
#import "CompanyOrderView.h"
#import "MainHeader.h"
#import "UITextView+placeholder.h"
#import "PayView.h"
#import "HuoWuInfoView.h" //货物信息
#import "GoodsInfoView.h"  //货物信息
#import "newView.h"
#import "LCFAlert.h"  //确认支付10元
#import "LCFChargeAlert.h" // 去充值按钮
#import "LCFPayView.h" 
#import "RechargeViewController.h"
#import "HuoChangAdressVC.h"
#import "AddHuoChangAddressVC.h"
#import "HuoChangModel.h"

#import "AlipayRequestConfig.h"
#import "WechatPayHeader.h"
#import "WXPayManager.h"

@interface OrderViewController (){
    UIScrollView *_scrollView;
    //留言
    UITextView *_commentTextField;
    
    newView * _newBaojiaView;//新的报价View
    GoodsInfoView *_topView; //货物信息
    
    //货场地址
    UITextView * _huochangAdressTextField;
    
    NSString *_payType;// 后台为了区分支付来源加的类型
    LCFPayView * _lcfPayView;
    LCFChargeAlert * _lcfChargeAlert;
    LCFAlert * _lcfAlert;
}

@property (nonatomic,strong)NSString * takeCargoMoney;//取货费
@property (nonatomic,strong)NSString * sendCargoMoney;//送货费


@property (nonatomic,strong) NSDictionary * dic;//预报价成功
@property (nonatomic,strong) id object;


@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self setCostomeTitle:@"镖王报价"];
    [self configSubViews];
    

}

- (void)initData{

    _payType = @"2";
}

- (void)configSubViews{
    self.view.backgroundColor = [UIColor whiteColor];
    _scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    _scrollView.contentSize = CGSizeMake(WINDOW_WIDTH, 850);
    _scrollView.backgroundColor = BACKGROUND_COLOR;
    [self.view addSubview:_scrollView];
    
    _topView = [[[NSBundle mainBundle] loadNibNamed:@"GoodsInfoView" owner:nil options:nil] lastObject];
    [_topView setViewsWithModel:_model];
    _topView.top = 10;
    _topView.left = 8;
    _topView.width = WINDOW_WIDTH-16;
    //此处是要隐藏收件人和发件人信息
    _topView.receiveName.hidden = YES;
    _topView.sendName.hidden = YES;
    _topView.heightContraint.constant =0;
    _topView.heightReceiveContraint.constant = 0;
    _topView.distanceConstraint.constant = 0;
    _topView.distanceReceiveContraint.constant = 0;
    _topView.height -= 48;
    
    [_scrollView addSubview:_topView];
    _topView.layer.cornerRadius = 5;
    _topView.clipsToBounds = YES;
    
    
    UILabel *liuyanLabel = [UILabel new];
    liuyanLabel.font = [UIFont systemFontOfSize:14];
    liuyanLabel.text = @"留言：";
    [liuyanLabel sizeToFit];
    liuyanLabel.top =_topView.bottom + 15;
    liuyanLabel.left = 10;
    liuyanLabel.height = 20;
    [_scrollView addSubview:liuyanLabel];
    
    
    _commentTextField = [[UITextView alloc]init];
    _commentTextField.font = [UIFont fontWithName:@"Arial" size:14.0];//设置字体名字和字体
    _commentTextField.text = _model.luMessage;
    if (_model.luMessage.length == 0) {
        _commentTextField.placeholder = @"请输入您的预计运输时间~";
    }else{
    _commentTextField.placeholder = @"";
    }
    
    _commentTextField.layer.borderColor = [[UIColor colorWithRed:215.0 / 255.0 green:215.0 / 255.0 blue:215.0 / 255.0 alpha:1] CGColor];
    
    _commentTextField.layer.borderWidth = 0.6f;
    _commentTextField.layer.cornerRadius = 6.0f;
    _commentTextField.top = liuyanLabel.bottom +10;
    _commentTextField.left = 10;
    _commentTextField.width = WINDOW_WIDTH - 20;
    _commentTextField.height = 60;
    [_scrollView addSubview:_commentTextField];
    
    UILabel * huochangAdress = [UILabel new];
    huochangAdress.font = [UIFont systemFontOfSize:14];
    huochangAdress.text = @"请选择货场地址:";
    [huochangAdress sizeToFit];
    huochangAdress.top = _commentTextField.bottom +15;
    huochangAdress.left = 10;
    huochangAdress.height = 20;
    [_scrollView addSubview:huochangAdress];
    
    
    
    _huochangAdressTextField = [[UITextView alloc]init];
    _huochangAdressTextField.font = [UIFont fontWithName:@"Arial" size:14.0];
    _huochangAdressTextField.layer.borderColor =  [[UIColor colorWithRed:215.0 / 255.0 green:215.0 / 255.0 blue:215.0 / 255.0 alpha:1] CGColor];
    _huochangAdressTextField.layer.borderWidth = 0.6f;
    _huochangAdressTextField.layer.cornerRadius = 6.0f;
    _huochangAdressTextField.top = huochangAdress.bottom+10;
    _huochangAdressTextField.left = 10;
    _huochangAdressTextField.width = SCREEN_WIDTH - 20;
    _huochangAdressTextField.height = 60;
    _huochangAdressTextField.userInteractionEnabled =NO;
    [_scrollView addSubview:_huochangAdressTextField];
    
    _huochangAdressTextField.text = _model.yardAddress;
    if (_model.yardAddress.length == 0 || _model.yardAddress ==nil||[_model.yardAddress isEqual:@""]) {
     [ExpressRequest sendWithParameters:nil MethodStr:[NSString stringWithFormat:@"%@%@?userId=%@",BaseUrl,API_WL_HUOCHANG_DEFAULT,[UserManager getDefaultUser].userId ] reqType:k_GET success:^(id object) {
         NSDictionary * dict = [object objectForKey:@"data"][0];
         if ([dict valueForKey:@"locationAddress"]) {
              _huochangAdressTextField.text = [NSString stringWithFormat:@"%@%@",[dict valueForKey:@"locationAddress"],[dict valueForKey:@"address"]];
         }else{
             _huochangAdressTextField.height = 0;
         }
     } failed:^(NSString *error) {
         [SVProgressHUD showErrorWithStatus:error];
     }];
    }else{
      _huochangAdressTextField.placeholder = @"";
    }
    
    UIButton * addBtn =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    addBtn.frame = CGRectMake(huochangAdress.right + 16, _commentTextField.bottom +15,20 , 20);
    [addBtn setBackgroundImage:[UIImage imageNamed:@"addSelect"] forState:UIControlStateNormal];
    [_scrollView addSubview:addBtn];
    [addBtn addTarget:self action:@selector(addAdress) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *baojiaLabel = [UILabel new];
    baojiaLabel.font = [UIFont systemFontOfSize:14];
    baojiaLabel.text = @"报价：";
    [_scrollView addSubview:baojiaLabel];

    [baojiaLabel sizeToFit];
    [baojiaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_huochangAdressTextField.mas_bottom).offset(15);
        make.left.equalTo(_scrollView).offset(10);
        make.height.mas_equalTo(20);
    }];

    _newBaojiaView = [[[NSBundle mainBundle] loadNibNamed:@"newView" owner:nil options:nil] lastObject];
    [_scrollView addSubview:_newBaojiaView];
    [_newBaojiaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(baojiaLabel.mas_bottom).offset(0);
        make.left.equalTo(_scrollView).offset(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(246);
    }];


    _newBaojiaView.quhuoFree.text = _model.takeCargoMoney;
    _newBaojiaView.songhuoFree.text = _model.sendCargoMoney;
    _newBaojiaView.costLabel.text = _model.cargoTotal;
    _newBaojiaView.totalFree.text = _model.transferMoney;
    
    //根据是否需要上门取货和送货上门显示 
    [_newBaojiaView hiddenGet:self.model.takeCargo hiddenSend:self.model.sendCargo];

    //根据ifQuotion来判断 是否已经报过价了
    if (_model.ifQuotion) {
        [_newBaojiaView.baoJiaBtn setTitle:@"修改报价" forState:UIControlStateNormal];
    }else{
        [_newBaojiaView.baoJiaBtn setTitle:@"提交报价" forState:UIControlStateNormal];
    }
    [_newBaojiaView.baoJiaBtn addTarget:self action:@selector(publish) forControlEvents:UIControlEventTouchUpInside];

}

#pragma mark ------ 选择货场地址
-(void)addAdress{
    HuoChangAdressVC * addressVc =[[HuoChangAdressVC alloc]init];
    addressVc.block = ^(HuoChangModel * model){
        _huochangAdressTextField.height = 60;
        _huochangAdressTextField.text = [NSString stringWithFormat:@"%@%@",model.locationAddress,model.address];
    };
    
    [self.navigationController pushViewController:addressVc animated:YES];
}

- (void)publish{
    if(_huochangAdressTextField.text.length == 0){
        [SVProgressHUD showErrorWithStatus:@"请选择货场地址"];
        return;
    }
   
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message: [NSString stringWithFormat:@"参与报价，用户选择后，对接成功将收取平台使用费。您确定要报价吗？"] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"报价" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (self.model.takeCargo) {
            self.takeCargoMoney = _newBaojiaView.quhuoFree.text;
        }else{
            self.takeCargoMoney = @"0";
        }
        if (self.model.sendCargo) {
            self.sendCargoMoney = _newBaojiaView.songhuoFree.text;
        }else{
            self.sendCargoMoney = @"0";
        }


        //根据ifQuotion来判断 是否已经报过价了
        if (_model.ifQuotion) {
            [self editBaojia];
        }else{
            [self firstBaojia];
        }

    }];
    
    [alert addAction:cancelAction];
    [alert addAction:sureAction];
    [self presentViewController:alert animated:NO completion:nil];
}

- (void)firstBaojia{
    //    发布报价
    [SVProgressHUD show];
    
    NSDictionary *dic = @{@"userId":[UserManager getDefaultUser].userId,
                          @"transferMoney":_newBaojiaView.totalFree.text,
                          @"luMessage":_commentTextField.text,
                          @"WLBId":_model.recId,
                          @"takeCargoMoney":self.takeCargoMoney,
                          @"sendCargoMoney":self.sendCargoMoney,
                          @"cargoTotal":_newBaojiaView.costLabel.text,
                          @"yardAddress":_huochangAdressTextField.text
                          };
    [ExpressRequest sendWithParameters:dic
                             MethodStr:@"quotation/publish"
                               reqType:k_POST
                               success:^(id object) {
                                   [SVProgressHUD dismiss];
                                   [self notice];
    /*
                                   self.object = object;
                                   self.dic = [object objectForKey:@"data"][0];
                                   NSString * payMoneyMin = [[self.dic objectForKey:@"playMoneyMin"] stringValue];
                                   NSString * payMoneyMax = [[self.dic objectForKey:@"playMoneyMax"] stringValue];
  
            //判断用户钱包的金额 === 0  三方支付或者充值     大于0小于payMoneyMin  充值     >payMoneyMin 余额支付
                if ([[UserManager getDefaultUser].balance doubleValue] <= 0.0) {
                    
                    _lcfPayView = [[NSBundle mainBundle] loadNibNamed:@"LCFPayView" owner:nil options:nil].firstObject;
                    _lcfPayView.frame = [UIApplication sharedApplication].windows.lastObject.bounds;
                    _lcfPayView.needPayMoney.text = [NSString stringWithFormat:@"%@元",payMoneyMax];
                    _lcfPayView.noteLabelOne.text = [NSString stringWithFormat:@"1.参与报价，收取平台使用费，用户取消或对接不成功平台使用费将会退回到您的钱包。"];
                    _lcfPayView.noteLabelTwo.text = [NSString stringWithFormat:@"2.使用余额支付收取平台使用付费%@元。",payMoneyMin];
                    _lcfPayView.noteLabelThree.text = [NSString stringWithFormat:@"3.使用第三方支付收取%@元。",payMoneyMax];
                    [[UIApplication sharedApplication].windows.lastObject addSubview:_lcfPayView];
                    [_lcfPayView.rightBtn addTarget:self action:@selector(toCharge) forControlEvents:UIControlEventTouchUpInside];
                    [_lcfPayView.weChatBtn addTarget:self action:@selector(wxPay) forControlEvents:UIControlEventTouchUpInside];
                    [_lcfPayView.zhiFuBaoBtn addTarget:self action:@selector(zhifubaoPay) forControlEvents:UIControlEventTouchUpInside];
                    
                 }
                 //大于0  小于payMoneyMin
                if ([[UserManager getDefaultUser].balance doubleValue]>0.0 && [[UserManager getDefaultUser].balance doubleValue] < [payMoneyMin doubleValue]) {
                    
                    _lcfChargeAlert = [[NSBundle mainBundle] loadNibNamed:@"LCFChargeAlert" owner:nil options:nil].firstObject;
                    _lcfChargeAlert.frame = [UIApplication sharedApplication].windows.lastObject.bounds;
                    _lcfChargeAlert.noteLabel.text = [NSString stringWithFormat:@"参与报价，将收取平台使用费%@元，用户取消或对接不成功平台使用费将会退回到您的钱包。",payMoneyMin];
                    [[UIApplication sharedApplication].windows.lastObject addSubview:_lcfChargeAlert];
                    [_lcfChargeAlert.chargeBtn addTarget:self action:@selector(toChargeTwo) forControlEvents:UIControlEventTouchUpInside];

                }

                //大于payMoneyMin 就直接余额支付了
                if ([[UserManager getDefaultUser].balance doubleValue] >= [payMoneyMin doubleValue]) {
                    _lcfAlert = [[NSBundle mainBundle] loadNibNamed:@"LCFAlert" owner:nil options:nil].firstObject;
                    _lcfAlert.frame = [UIApplication sharedApplication].windows.lastObject.bounds;
                    _lcfAlert.needPayMoney.text =[NSString stringWithFormat:@"%@元",payMoneyMin];
                     _lcfAlert.noteLabel.text = [NSString stringWithFormat:@"参与报价，将收取平台使用费%@元，用户取消或对接不成功平台使用费将会退回到您的钱包。",payMoneyMin];
                    [_lcfAlert.rightBtn addTarget:self action:@selector(btnCancle) forControlEvents:UIControlEventTouchUpInside];
                    [[UIApplication sharedApplication].windows.lastObject addSubview:_lcfAlert];
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payYue) name:@"LCFAlertNotification" object:nil];
                    
                }
     */
                                   
        } failed:^(NSString *error) {
         [SVProgressHUD showErrorWithStatus:error];
    }];
}

#pragma mark ------- 支付平台使用费
/*
//等于0
-(void)toCharge{
    RechargeViewController * rechargeVC =[[RechargeViewController alloc]init];
    rechargeVC.model = [[Logist alloc]init];
    rechargeVC.model = _model;
    
    [self.navigationController pushViewController:rechargeVC animated:YES];
    [_lcfPayView removeFromSuperview];
}

//不够10元   前去充值的情况
-(void)toChargeTwo{
    RechargeViewController * rechargeVC =[[RechargeViewController alloc]init];
    rechargeVC.model = [[Logist alloc]init];
    rechargeVC.model = _model;
    
    [self.navigationController pushViewController:rechargeVC animated:YES];
    [_lcfChargeAlert removeFromSuperview];
    
}

//余额支付的情况
-(void)payYue{

    Logist *model = [[Logist alloc] initWithJsonDict:self.dic];
    // 物流公司报价余额支付
    [SVProgressHUD show];
    
    NSString * str = [NSString stringWithFormat:@"%@quotation/balancePay?userId=%@&billCode=%@&counterFee=%@&type=%@&transferMoney=%@&takeCargoMoney=%@&sendCargoMoney=%@&cargoTotal=%@",BaseUrl,[UserManager getDefaultUser].userId ,self.model.billCode ,model.playMoneyMin,_payType,_newBaojiaView.totalFree.text,_newBaojiaView.quhuoFree.text,_newBaojiaView.songhuoFree.text,_newBaojiaView.costLabel.text];
    [ExpressRequest sendWithParameters:nil MethodStr:str reqType:k_GET success:^(id object) {
        [SVProgressHUD showSuccessWithStatus:[object valueForKey:@"message"]];
        [self notice];
    } failed:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];

}

-(void)btnCancle{

    [self.navigationController popViewControllerAnimated:YES];
}

//微信支付
-(void)wxPay{
    NSLog(@"物流公司报价微信支付平台使用费");
    Logist *model = [[Logist alloc] initWithJsonDict:self.dic];
    [SVProgressHUD show];
     NSString *newBillCode = [NSString stringWithFormat:@"%@B%@",self.model.billCode,[UserManager getDefaultUser].userId];
    NSString *URLStr = [NSString stringWithFormat:@"%@logistics/task/pay/wechat/pre?billCode=%@&price=%@&type=%@",BaseUrl,newBillCode,model.playMoneyMax,_payType];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notice) name:WECHAT_BACK_WL object:nil];
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
                                   wxManager.billCode = newBillCode;
                                   [_lcfPayView removeFromSuperview];

                               }
                                failed:^(NSString *error) {
                                    [SVProgressHUD showErrorWithStatus:error];
                                }];
}

-(void)zhifubaoPay{
    Logist *model = [[Logist alloc] initWithJsonDict:self.dic];
    NSLog(@"物流公司报价支付宝支付");
    NSString *newBillCode = [NSString stringWithFormat:@"%@B%@",self.model.billCode,[UserManager getDefaultUser].userId];
    [AlipayRequestConfig alipayWithPartner:kPartnerID seller:kSellerAccount tradeNO:newBillCode productName:@"镖王" productDescription:@"平台使用费" amount:model.playMoneyMax notifyURL:kNotifyURL itBPay:@"30m" standbyCallback:^(NSDictionary *resultDic) {
        
        if ([[resultDic objectForKey:@"resultStatus"] integerValue]==9000) {
            NSLog(@"支付宝充值成功");
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"恭喜您支付成功%@元！",model.playMoneyMax]];
            [self checkResultWithBillCode:newBillCode];
        }
        else {
            NSLog(@"%@",resultDic);
            [SVProgressHUD showErrorWithStatus:[resultDic objectForKey:@"memo"] ];
        }
    }];

    [_lcfPayView removeFromSuperview];
}

*/

- (void)editBaojia{
    //    修改报价
    [SVProgressHUD show];
    NSDictionary *dic = @{@"userId":[UserManager getDefaultUser].userId,
                          @"transferMoney":_newBaojiaView.totalFree.text,
                          @"luMessage":_commentTextField.text,
                          @"WLBId":_model.recId,
                          @"takeCargoMoney":self.takeCargoMoney,
                          @"sendCargoMoney":self.sendCargoMoney,
                          @"cargoTotal":_newBaojiaView.costLabel.text,
                          @"yardAddress":_huochangAdressTextField.text
                          };

    [ExpressRequest sendWithParameters:dic
                             MethodStr:@"quotation/update"
                               reqType:k_POST
                               success:^(id object) {
                                   [SVProgressHUD showSuccessWithStatus:[object valueForKey:@"message"]];
                                   NSLog(@"%@",object);
                                   if (_block) {
                                       _block(nil);
                                   }
                                   [self.navigationController popViewControllerAnimated:YES];
                               } failed:^(NSString *error) {
                                   [SVProgressHUD showErrorWithStatus:error];
                               }];
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
    if (_block) {
        _block(nil);
    }
    [_newBaojiaView.baoJiaBtn setTitle:@"修改报价" forState:UIControlStateNormal];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
