//
//  DanBaoViewController.m
//  iwant
//
//  Created by 公司 on 2016/11/28.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "DanBaoViewController.h"
#import "CouponViewController.h"
#import "UserLogListViewController.h"
#import "Wallet.h"
#import "AlipayRequestConfig.h"
#import "WXPay.h"
#import "WXApi.h"
#import "WXPayManager.h"
#import "PayView.h"
#import "UserPayView.h" //用户支付
#import "YMHeaderView.h"
#import "EcoinWebViewController.h"
#import "CarNumModel.h"
#import "CarNumCell.h"
#import "TouBaoRuleVC.h"
#import "InforWebViewController.h"

@interface DanBaoViewController (){
    
    NSString * _warrant;   //是否担保交易
    NSString *  _whether;   //是否投保
    
    NSString * _url;//投保照片url

    int _feilv ;
    PayView *_payView;
    UserPayView * _userPayView; //用户支付界面
   NSString * _category;    //1 常规货物类、2 蔬菜、3 水果、4。牲畜及禽鱼
   NSString * _insurance;   //承险类别  1 基本险  2综合险
    
    UIView * _bigView;//大的背景
}
@property (weak, nonatomic) IBOutlet UISwitch *switchOne; //是否担保交易
@property (weak, nonatomic) IBOutlet UISwitch *switchTwo; //是否投保
@property (weak, nonatomic) IBOutlet UIButton *goToPayBtn; //zhifu
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailViewHeightConatraint; //解释的view高度

@property (weak, nonatomic) IBOutlet UIButton *NoPay; //暂不支付
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toubaoViewHeightContraint;
@property (weak, nonatomic) IBOutlet UITextField *cargoCostTextField;   //货物价值
@property (weak, nonatomic) IBOutlet UILabel *labelOne;
@property (weak, nonatomic) IBOutlet UILabel *labelTwo;
@property (weak, nonatomic) IBOutlet UILabel *labelThree;
@property (weak, nonatomic) IBOutlet UIButton *goodsTypeOne;
@property (weak, nonatomic) IBOutlet UIButton *goodsTypeTwo;

@property (weak, nonatomic) IBOutlet UIButton *goodsTypeFour;
@property (weak, nonatomic) IBOutlet UIButton *baoxianTypeOne;
@property (weak, nonatomic) IBOutlet UILabel *baoxianTypeOneLabel;

@property (weak, nonatomic) IBOutlet UIButton *baoxianTypeTwo;
@property (weak, nonatomic) IBOutlet UILabel *baoxianTypeTwoLabel;

@property (weak, nonatomic) IBOutlet UIButton *ifAgreeBtn; //阅读并同意
@property (weak, nonatomic) IBOutlet UIButton *xieYiBtn;  //投保协议

@property(nonatomic,strong)UIButton * catoryBtn;  //货物种类

@end

@implementation DanBaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (SCREEN_WIDTH == 320) {
        self.leftConstraint.constant = 22 ;
        self.rightConstraint.constant = 22;
        self.detailViewHeightConatraint.constant = 268;
    }
    if (self.isZhiFu) {
        self.switchOne.hidden = NO;
    }
    [self.labelOne setAttributedText:[self creatLabelText:@"*货物价值："]];
    [self.labelTwo setAttributedText:[self creatLabelText:@"*请勾选投保物品种类"]];
    [self.labelThree setAttributedText:[self creatLabelText:@"*请选择承保类型"]];

    self.toubaoViewHeightContraint.constant = 0;
    self.toubaoView.hidden = YES;
    
    [SVProgressHUD show];
    NSString * urlStr =[NSString stringWithFormat:@"%@logistics/task/quotationInfo?recId=%@",BaseUrl,self.recId];
    [ExpressRequest sendWithParameters:nil MethodStr:urlStr reqType:k_GET success:^(id object) {
        [SVProgressHUD dismiss];
        NSDictionary  * dict =[object objectForKey:@"data"][0];
        self.model = [[Logist alloc]initWithJsonDict:dict];
        self.baojiaModel = [[Baojia alloc]initWithJsonDict:dict];
        if ([self.model.carType isEqualToString:@"cold"]) {
            self.switchTwo.hidden = YES;
        }
    } failed:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];

    _whether =@"0";
    _warrant = @"1";
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 60)];
    label.textColor = [UIColor blackColor];
    label.text = @"确认交易";
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
    
    self.view.backgroundColor = BACKGROUND_COLOR;
    self.switchOne.onTintColor = COLOR_MainColor;
    self.switchTwo.onTintColor = COLOR_MainColor;
    //去支付按钮
    [self.goToPayBtn setBackgroundColor:COLOR_MainColor];
    [self.goToPayBtn sizeToFit];
    self.goToPayBtn.layer.cornerRadius = 6.0;
    self.goToPayBtn.clipsToBounds = YES;
    [self.goToPayBtn addTarget:self action:@selector(gotoPay:) forControlEvents:UIControlEventTouchUpInside];
    //暂不支付
    [self.NoPay setBackgroundColor:COLOR_PurpleColor];
    [self.NoPay sizeToFit];
    self.NoPay.layer.cornerRadius = 6.0;
    self.NoPay.clipsToBounds = YES;
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notice) name:WECHAT_BACK_WL object:nil];
    
    UIBarButtonItem *rightBarButtonItem =[[UIBarButtonItem alloc]initWithTitle:@"声明" style:UIBarButtonItemStylePlain target:self action:@selector(shengmingBtn)];
    rightBarButtonItem.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

-(void)shengmingBtn{
    EcoinWebViewController *vc = [[EcoinWebViewController alloc]init];
    vc.web_type = WEB_insureWL;
    [self.navigationController pushViewController:vc animated:YES];
}

-(NSMutableAttributedString *)creatLabelText:(NSString *)text{
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc]initWithString:text attributes:@{NSKernAttributeName:@(0.)}];
    //设置某写字体的颜色
    //NSForegroundColorAttributeName 设置字体颜色
    NSRange blueRange = NSMakeRange([[str string] rangeOfString:@"*"].location, [[str string] rangeOfString:@"*"].length);
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:blueRange];
    return str;
}

//是否担保交易
- (IBAction)switchDanBao:(UISwitch *)sender {
    if (sender.on) {
        _warrant = @"1";
        self.NoPay.hidden = NO;
        self.switchTwo.hidden = NO;
        if (SCREEN_WIDTH == 320) {
            self.rightConstraint.constant = 22;
        }else{
            self.rightConstraint.constant = 44;
        }
        [self.goToPayBtn setTitle:@"去支付" forState:UIControlStateNormal];
    }else{
        _warrant = @"0";
        self.NoPay.hidden = YES;
        self.switchTwo.hidden=NO;
        self.rightConstraint.constant = (SCREEN_WIDTH-self.NoPay.width)/2;
        [self.goToPayBtn setTitle:@"确认" forState:UIControlStateNormal];
    }
    
    if ([self.model.carType isEqualToString:@"cold"]) {
        self.switchTwo.hidden = YES;
    }
}

//判断是否投保的问题
- (IBAction)switchTouBao:(UISwitch *)sender {
    if (sender.on) {
        _whether = @"1";
        //后台请求接口物流的投保费率问题 用这个来控制实名是否可以参与投保的问题
        NSString * strUrl = [NSString stringWithFormat:@"%@%@?userId=%@",BaseUrl,API_WL_TOUBAO_FEILU,[UserManager getDefaultUser].userId];
        [ExpressRequest sendWithParameters:nil MethodStr:strUrl reqType:k_GET success:^(id object) {
            NSDictionary * dict = [object objectForKey:@"data"][0];
             _feilv = [[dict objectForKey:@"value"] intValue];
            self.toubaoViewHeightContraint.constant = 140;
            self.toubaoView.hidden = NO;
            self.xieYiBtn.hidden = NO;
            self.ifAgreeBtn.hidden = NO;
         } failed:^(NSString *error) {
            [SVProgressHUD showErrorWithStatus:error];
             sender.on = NO;
        }];

    }else{
        self.toubaoViewHeightContraint.constant = 0;
        self.toubaoView.hidden = YES;
        self.xieYiBtn.hidden = YES;
        self.ifAgreeBtn.hidden = YES;

        _whether = @"0";
    }
}

#pragma mark ------  //确认非担保交易了
-(void)makeSure{
    //再次确认非担保交易了？？？
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确认要非担保交易吗" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"点错了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *suerAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //对接非担保交易了
        NSString * transforMoney ;
        if ([_whether boolValue]) {
            transforMoney =[NSString stringWithFormat:@"%.2f",[self.money doubleValue]+[self.model.insureCost doubleValue]];
        }else{
            transforMoney = [NSString stringWithFormat:@"%.2f",[self.money doubleValue]];
        }
        NSString *str = [NSString stringWithFormat:@"%@logistics/task/pay/balance?userId=%@&WLBId=%@&whether=%@&warrant=%@&transferMoney=%@",BaseUrl,self.model.userToId,self.model.recId,_whether,_warrant,transforMoney];
        [ExpressRequest sendWithParameters:nil MethodStr:str reqType:k_GET success:^(id object) {
            [SVProgressHUD showSuccessWithStatus:[object objectForKey:@"message"]];
            [self notice];
        } failed:^(NSString *error) {
            [SVProgressHUD showErrorWithStatus:error];
        }];
    }];
    [alert addAction:cancelAction];
    [alert addAction:suerAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark -----勾选投保物品种类
- (IBAction)selectedGoodsType:(UIButton *)sender{
    if (self.catoryBtn == sender) {
        return;
    }
    self.catoryBtn.selected = NO;
    self.catoryBtn = sender;
    self.catoryBtn.selected = YES;
    self.baoxianTypeOne.selected = YES;
    self.baoxianTypeTwo.selected = NO;
    _insurance = @"1";
    self.baoxianTypeTwo.hidden = NO;
    if (sender.tag != 1) {
        self.baoxianTypeTwo.hidden = YES;
    }
    /*
    switch (sender.tag) {
        case 1:
            [self.goodsTypeOne setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
            [self.goodsTypeTwo setImage:[UIImage imageNamed:@"noSelected"] forState:UIControlStateNormal];
            [self.goodsTypeFour setImage:[UIImage imageNamed:@"noSelected"] forState:UIControlStateNormal];
            self.baoxianTypeOneLabel.text = @"综合险";
            _category = @"1";
            _insurance = @"2";
            break;
        case 2:
            [self.goodsTypeOne setImage:[UIImage imageNamed:@"noSelected"] forState:UIControlStateNormal];
            [self.goodsTypeTwo setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
            [self.goodsTypeFour setImage:[UIImage imageNamed:@"noSelected"] forState:UIControlStateNormal];
            self.baoxianTypeTwo.hidden=YES;
            self.baoxianTypeTwoLabel.hidden = YES;
            self.baoxianTypeOneLabel.text = @"基本险";
            _category = @"2";
            _insurance = @"1";
            break;
        case 3:
            [self.goodsTypeOne setImage:[UIImage imageNamed:@"noSelected"] forState:UIControlStateNormal];
            [self.goodsTypeTwo setImage:[UIImage imageNamed:@"noSelected"] forState:UIControlStateNormal];
            [self.goodsTypeFour setImage:[UIImage imageNamed:@"noSelected"] forState:UIControlStateNormal];
            self.baoxianTypeTwo.hidden=YES;
            self.baoxianTypeTwoLabel.hidden = YES;
            self.baoxianTypeOneLabel.text = @"综合险";
            _category = @"3";
            _insurance = @"2";
            break;
        case 4:
            [self.goodsTypeOne setImage:[UIImage imageNamed:@"noSelected"] forState:UIControlStateNormal];
            [self.goodsTypeTwo setImage:[UIImage imageNamed:@"noSelected"] forState:UIControlStateNormal];
            [self.goodsTypeFour setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
            self.baoxianTypeTwo.hidden=YES;
            self.baoxianTypeTwoLabel.hidden = YES;
            self.baoxianTypeOneLabel.text = @"综合险";
            _category = @"4";
            _insurance = @"2";
            break;
        default:
            break;
    }
    */
}

#pragma mark ------选择承险类型
- (IBAction)selectedBaoxianType:(UIButton *)sender {
    sender.selected = !sender.selected;
    if(sender.selected){
        if (sender.tag == 11) {
            _insurance = @"1";
            self.baoxianTypeTwo.selected = NO;
        }else{
            _insurance = @"2";
            self.baoxianTypeOne.selected = NO;
        }
    }else{
        _insurance = @"";
    }
    /*
    switch (sender.tag) {
        case 11:
            [self.baoxianTypeOne setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
            [self.baoxianTypeTwo setImage:[UIImage imageNamed:@"noSelected"] forState:UIControlStateNormal];
            break;
        case 12:
            [self.baoxianTypeTwo setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
            [self.baoxianTypeOne setImage:[UIImage imageNamed:@"noSelected"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
     */
}

//去投保
-(void)gotoPay:(UIButton *)sender{
    if (self.switchOne.on) {
      //是否投保
    if (self.switchTwo.on) {
        if (_cargoCostTextField.text.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请填写货物价值"];
            return;
        }
        if (!self.catoryBtn) {
            [SVProgressHUD showErrorWithStatus:@"请勾选投保物品种类"];
            return;
        }
        if (_insurance.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请选择承保类型"];
            return;
        }
        if (!self.ifAgreeBtn.selected) {
            [SVProgressHUD showErrorWithStatus:@"请先阅读并同意《投保协议》"];
            return;
        }
        //对接填写货物价值   新加保险类别
        [SVProgressHUD show];
        NSDictionary * dic =@{@"userId":[UserManager getDefaultUser].userId,
                              @"recId":self.recId,
                              @"cargoCost":_cargoCostTextField.text,
                              @"category":[NSString stringWithInteger:self.catoryBtn.tag],
                              @"insurance":_insurance};
        [ExpressRequest sendWithParameters:dic MethodStr:[NSString stringWithFormat:@"%@",API_WL_AddInsurance] reqType:k_POST success:^(id object) {
            [SVProgressHUD dismiss];
            NSString * urlStr =[NSString stringWithFormat:@"%@logistics/task/quotationInfo?recId=%@",BaseUrl,self.recId];
            [ExpressRequest sendWithParameters:nil MethodStr:urlStr reqType:k_GET success:^(id object) {
                NSDictionary  * dict =[object objectForKey:@"data"][0];
                self.model = [[Logist alloc]initWithJsonDict:dict];
                self.baojiaModel = [[Baojia alloc]initWithJsonDict:dict];
                [self showUserPay];
                
            } failed:^(NSString *error) {
                [SVProgressHUD showErrorWithStatus:error];
            }];

        } failed:^(NSString *error) {
            [SVProgressHUD showErrorWithStatus:error];

        }];
       }else{
       NSString * urlStr =[NSString stringWithFormat:@"%@logistics/task/quotationInfo?recId=%@",BaseUrl,self.recId];
        [ExpressRequest sendWithParameters:nil MethodStr:urlStr reqType:k_GET success:^(id object) {
            NSDictionary  * dict =[object objectForKey:@"data"][0];
            self.model = [[Logist alloc]initWithJsonDict:dict];
            self.baojiaModel = [[Baojia alloc]initWithJsonDict:dict];
            if ([_model.status intValue] == 7|| [_model.status intValue] == 8) {
                [self showUserPay];
            }else{
                [SVProgressHUD showErrorWithStatus:@"该单已经支付成功"];
            }
        } failed:^(NSString *error) {
            [SVProgressHUD showErrorWithStatus:error];
        }];
    }
    
    }else{
        if (self.switchTwo.on) {
         [self showToubao];
        }else{
        [SVProgressHUD show];
        NSString * urlStr =[NSString stringWithFormat:@"%@logistics/task/quotationInfo?recId=%@",BaseUrl,self.recId];
        [ExpressRequest sendWithParameters:nil MethodStr:urlStr reqType:k_GET success:^(id object) {
            [SVProgressHUD dismiss];
            NSDictionary  * dict =[object objectForKey:@"data"][0];
            self.model = [[Logist alloc]initWithJsonDict:dict];
            self.baojiaModel = [[Baojia alloc]initWithJsonDict:dict];
            [self makeSure];
        } failed:^(NSString *error) {
            [SVProgressHUD showErrorWithStatus:error];
        }];
        }
    }
}

#pragma mark ----我已阅读并同意《投保协议》
- (IBAction)ifAgreeBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
}
- (IBAction)toubaoXieyi:(UIButton *)sender {
    InforWebViewController * vc = [[InforWebViewController alloc]init];
    vc.info_type = WEB_WL_insure;
    [self.navigationController pushViewController:vc animated:YES];
}


//投保
-(void)showToubao{

    if (self.switchTwo.on) {
        if (_cargoCostTextField.text.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请填写货物价值"];
            return;
        }
        if (_category.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请勾选投保物品种类"];
            return;
        }
        if (_insurance.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请选择承保类型"];
            return;
        }
        //对接填写货物价值   新加保险类别
        [SVProgressHUD show];
        NSDictionary * dic =@{@"userId":[UserManager getDefaultUser].userId,
                              @"recId":self.recId,
                              @"cargoCost":_cargoCostTextField.text,
                              @"category":_category,
                              @"insurance":_insurance};
        [ExpressRequest sendWithParameters:dic MethodStr:[NSString stringWithFormat:@"%@",API_WL_AddInsurance] reqType:k_POST success:^(id object) {
            [SVProgressHUD dismiss];
            NSString * urlStr =[NSString stringWithFormat:@"%@logistics/task/quotationInfo?recId=%@",BaseUrl,self.recId];
            [ExpressRequest sendWithParameters:nil MethodStr:urlStr reqType:k_GET success:^(id object) {
                NSDictionary  * dict =[object objectForKey:@"data"][0];
                self.model = [[Logist alloc]initWithJsonDict:dict];
                self.baojiaModel = [[Baojia alloc]initWithJsonDict:dict];
                [self feiDanBaoTouBao];
                
            } failed:^(NSString *error) {
                [SVProgressHUD showErrorWithStatus:error];
            }];
            
            
        } failed:^(NSString *error) {
            [SVProgressHUD showErrorWithStatus:error];
            
        }];
    }else{
        NSString * urlStr =[NSString stringWithFormat:@"%@logistics/task/quotationInfo?recId=%@",BaseUrl,self.recId];
        [ExpressRequest sendWithParameters:nil MethodStr:urlStr reqType:k_GET success:^(id object) {
            NSDictionary  * dict =[object objectForKey:@"data"][0];
            self.model = [[Logist alloc]initWithJsonDict:dict];
            self.baojiaModel = [[Baojia alloc]initWithJsonDict:dict];
            if ([_model.status intValue] == 7|| [_model.status intValue] == 8) {
                [self showUserPay];
            }else{
                [SVProgressHUD showErrorWithStatus:@"该单已经支付成功"];
            }
        } failed:^(NSString *error) {
            [SVProgressHUD showErrorWithStatus:error];
        }];
    }
}

#pragma mark ------非担保交易  并且投保
-(void)feiDanBaoTouBao{
    //非担保交易  投保
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确认非担保交易并支付相应保险费吗？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"点错了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *suerAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //对接非担保交易了
        NSString * transforMoney ;
        if ([_whether boolValue]) {
            transforMoney =[NSString stringWithFormat:@"%.2f",[self.money doubleValue]+[self.model.insureCost doubleValue]];
        }else{
            transforMoney = [NSString stringWithFormat:@"%.2f",[self.money doubleValue]];
        }
        NSString *str = [NSString stringWithFormat:@"%@logistics/task/pay/balance?userId=%@&WLBId=%@&whether=%@&warrant=%@&transferMoney=%@",BaseUrl,self.model.userToId,self.model.recId,_whether,_warrant,transforMoney];
        [ExpressRequest sendWithParameters:nil MethodStr:str reqType:k_GET success:^(id object) {
            [SVProgressHUD showSuccessWithStatus:[object objectForKey:@"message"]];
            [self notice];
        } failed:^(NSString *error) {
            [SVProgressHUD showErrorWithStatus:error];
        }];
        
    }];
    [alert addAction:cancelAction];
    [alert addAction:suerAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)showUserPay{
    _userPayView  = [[NSBundle mainBundle] loadNibNamed:@"UserPayView" owner:nil options:nil].firstObject;
    _userPayView.frame = [UIApplication sharedApplication].windows.lastObject.bounds;
    [[[UIApplication sharedApplication] keyWindow] addSubview:_userPayView];

    //保险费
    if ([_whether boolValue]){
    _userPayView.baoxianFree.text =[NSString stringWithFormat:@"%.2f",[self.model.insureCost doubleValue]];
    }else{
    _userPayView.baoxianFree.text = @"0";
    }
    _userPayView.yunFree.text = self.baojiaModel.cargoTotal;
    _userPayView.quhuoFree.text = self.baojiaModel.takeCargoMoney;
    _userPayView.songhuoFree.text = self.baojiaModel.sendCargoMoney;
    _userPayView.totolFree.text = [NSString stringWithFormat:@"%.2f",[self.baojiaModel.transferMoney doubleValue] +[_userPayView.baoxianFree.text doubleValue]];
    
//    [_userPayView.yuePayBtn addTarget:self action:@selector(yuePay) forControlEvents:UIControlEventTouchUpInside];
    [_userPayView.weChatPay addTarget:self action:@selector(weChatPay) forControlEvents:UIControlEventTouchUpInside];
    [_userPayView.AliPay addTarget:self action:@selector(AliPay) forControlEvents:UIControlEventTouchUpInside];
    
}

//暂不支付
- (IBAction)noPayClick:(UIButton *)sender {
    //暂不支付
    NSArray * arr = self.navigationController.viewControllers;
    UIViewController * vc;
    if (_isZhiFu) {
       vc =arr[arr.count -4];
    }else{
       vc =arr[arr.count -3];
    }
     [self.navigationController popToViewController:vc animated:YES];
}

#pragma mark ------ 余额支付
-(void)yuePay{
    NSLog(@"余额pay");
    [SVProgressHUD show];
    NSString * transforMoney = _userPayView.totolFree.text;
    NSString *str = [NSString stringWithFormat:@"%@logistics/task/pay/balance?userId=%@&WLBId=%@&whether=%@&warrant=%@&transferMoney=%@",BaseUrl,self.model.userToId,self.model.recId,_whether,_warrant,transforMoney];
    [ExpressRequest sendWithParameters:nil MethodStr:str reqType:k_GET success:^(id object) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showSuccessWithStatus:[object objectForKey:@"message"]];
        [self notice];
    } failed:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];

}
#pragma mark ------ 微信支付
-(void)weChatPay{
    NSLog(@"微信pay");
    [SVProgressHUD show];
    NSString * type;
    if ([_whether boolValue]) {
        type = @"3";
    }else{
        type = @"4";
    }
    NSString * transforMoney = _userPayView.totolFree.text;
    NSString *URLStr = [NSString stringWithFormat:@"%@logistics/task/pay/wechat/pre?billCode=%@&price=%@&type=%@",BaseUrl,self.model.billCode,transforMoney,type];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goBackRefresh) name:WECHAT_BACK_WL object:nil];
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
                                   wxManager.billCode = [NSString stringWithFormat:@"%@C",_model.billCode];
                                   [_userPayView removeFromSuperview];
                               }
                                failed:^(NSString *error) {
                                    [SVProgressHUD showErrorWithStatus:error];
                                }];
    
}
#pragma mark ----- 支付宝支付
-(void)AliPay{
    NSLog(@"支付宝");
    NSString * transforMoney = _userPayView.totolFree.text;
    NSString *amount = [NSString stringWithFormat:@"%.2f",[transforMoney doubleValue]];
    NSString *newBillCode = [NSString stringWithFormat:@"%@C",self.model.billCode];
    [AlipayRequestConfig alipayWithPartner:kPartnerID seller:kSellerAccount tradeNO:newBillCode productName:@"镖王" productDescription:@"平台使用费" amount:amount notifyURL:kNotifyURL itBPay:@"30m" standbyCallback:^(NSDictionary *resultDic) {
        [_userPayView removeFromSuperview];
        if ([[resultDic objectForKey:@"resultStatus"] integerValue]==9000) {
            NSLog(@"支付宝支付成功");
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
- (void)checkResultWithBillCode:(NSString *)billCode{
    [RequestManager getPayResultWithBillCode:billCode success:^(NSDictionary *result) {
        NSLog(@"%@",result);
        [self notice];
    } Failed:^(NSString *error) {
        [PXAlertView showAlertWithTitle:error];
    }];
}

- (void)notice{
    [_userPayView removeFromSuperview];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)goBackRefresh{
    /*
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[UserLogListViewController class]]) {
            [self.navigationController popToViewController:temp animated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_WULIU object:nil];
        }
    }
     */
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
