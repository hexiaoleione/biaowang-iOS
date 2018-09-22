//
//  jiaoFeiDetailViewController.m
//  iwant
//
//  Created by 公司 on 2017/6/20.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "jiaoFeiDetailViewController.h"
#import "WeiJiaoFeiPay.h"
#import "WechatPayHeader.h"
#import "WXPayManager.h"
#import "AlipayHeader.h"

@interface jiaoFeiDetailViewController (){
    WeiJiaoFeiPay * _jiaofeiPay;
    NSInteger _payType;
}
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *limitTimeL;
@property (weak, nonatomic) IBOutlet UILabel *guiGeL;
@property (weak, nonatomic) IBOutlet UILabel *weightL;
@property (weak, nonatomic) IBOutlet UILabel *sizeL;
@property (weak, nonatomic) IBOutlet UILabel *takeCargoL;
@property (weak, nonatomic) IBOutlet UILabel *sendCargoL;
@property (weak, nonatomic) IBOutlet UILabel *sendNameL;
@property (weak, nonatomic) IBOutlet UILabel *sendPhoneL;
@property (weak, nonatomic) IBOutlet UILabel *start;
@property (weak, nonatomic) IBOutlet UILabel *startL;
@property (weak, nonatomic) IBOutlet UILabel *arriveNameL;
@property (weak, nonatomic) IBOutlet UILabel *arrivePhoneL;
@property (weak, nonatomic) IBOutlet UILabel *end;
@property (weak, nonatomic) IBOutlet UILabel *endL;

@property (weak, nonatomic) IBOutlet UILabel *noticeL;
@property (weak, nonatomic) IBOutlet UILabel *companyNameL;
@property (weak, nonatomic) IBOutlet UILabel *huochangL;

@property (weak, nonatomic) IBOutlet UILabel *baijia;
@property (weak, nonatomic) IBOutlet UILabel *quL;
@property (weak, nonatomic) IBOutlet UILabel *quqFree;
@property (weak, nonatomic) IBOutlet UILabel *quDanwei;

@property (weak, nonatomic) IBOutlet UILabel *songL;
@property (weak, nonatomic) IBOutlet UILabel *songFree;
@property (weak, nonatomic) IBOutlet UILabel *songDanwei;

@property (weak, nonatomic) IBOutlet UILabel *yunfeiL;
@property (weak, nonatomic) IBOutlet UILabel *yunfeiFree;
@property (weak, nonatomic) IBOutlet UILabel *yunfeiYuan;

@property (weak, nonatomic) IBOutlet UILabel *hejiL;
@property (weak, nonatomic) IBOutlet UILabel *totolFree;
@property (weak, nonatomic) IBOutlet UILabel *hejiDanwei;
@property (weak, nonatomic) IBOutlet UIButton *jiaoFieBtn;
@property (weak, nonatomic) IBOutlet UILabel *messageL;

//冷链车的特殊需求
@property (weak, nonatomic) IBOutlet UILabel *specialNeedL;

@end

@implementation jiaoFeiDetailViewController
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    
    self.nameL.font = FONT(14, NO);
    self.limitTimeL.font = FONT(14, NO);
    self.guiGeL.font = FONT(14, NO);
    self.sizeL.font = FONT(14, NO);
    self.takeCargoL.font = FONT(14, NO);
    self.sendCargoL.font = FONT(14, NO);
    self.sendNameL.font = FONT(14, NO);
    self.sendPhoneL.font = FONT(14, NO);
    self.arriveNameL.font = FONT(14, NO);
    self.arrivePhoneL.font = FONT(14, NO);
    self.start.font = FONT(14, NO);
    self.end.font = FONT(14, NO);
    self.startL.font = FONT(14, NO);
    self.endL.font = FONT(14, NO);
    self.noticeL.font = FONT(17, NO);
    self.companyNameL.font = FONT(14, NO);
    self.huochangL.font = FONT(14, NO);
    self.baijia.font = FONT(14, NO);
    self.quL.font = FONT(14, NO);
    self.quqFree.font = FONT(14, NO);
    self.quDanwei.font = FONT(14, NO);
    self.songL.font = FONT(14, NO);
    self.songFree.font = FONT(14, NO);
    self.songDanwei.font = FONT(14, NO);
    self.yunfeiL.font = FONT(14, NO);
    self.yunfeiFree.font = FONT(14, NO);
    self.yunfeiYuan.font = FONT(14, NO);
    self.hejiL.font = FONT(14, NO);
    self.hejiDanwei.font = FONT(14, NO);
    self.totolFree.font = FONT(14, NO);
    self.messageL.font = FONT(14, NO);
    self.weightL.font = FONT(14, NO);
    self.specialNeedL.font = FONT(14, NO);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCostomeTitle:@"货物信息"];
    //判断是否是代缴费的详情
    if (_ifJustLook) {
        self.jiaoFieBtn.hidden = YES;
    }
    NSString * urlStr =[NSString stringWithFormat:@"%@logistics/task/quotationInfo?recId=%@",BaseUrl,self.recId];
    [ExpressRequest sendWithParameters:nil MethodStr:urlStr reqType:k_GET success:^(id object) {
        [SVProgressHUD dismiss];
        NSDictionary  * dict =[object objectForKey:@"data"][0];
        self.model = [[Logist alloc]initWithJsonDict:dict];
        self.baojiaModel = [[Baojia alloc]initWithJsonDict:dict];
        [self configSubViews];
    } failed:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
}

-(void)configSubViews{
    self.nameL.text = [NSString stringWithFormat:@"物品名称：%@",self.model.cargoName];
    self.limitTimeL.text = [NSString stringWithFormat:@"要求到达时间：%@",self.model.arriveTime];
    self.guiGeL.text = [NSString stringWithFormat:@"总体积：%@",self.model.cargoVolume];
    if ([self.model.carType isEqualToString:@"cold"]) {
        self.specialNeedL.hidden = NO;
        self.specialNeedL.text = [NSString stringWithFormat:@"需求：%@",self.model.carName];
    }

    self.weightL.text = [NSString stringWithFormat:@"总重量：%@",self.model.cargoWeight];
    self.sizeL.text = [NSString stringWithFormat:@"件数：%@件",self.model.cargoSize];
    
    //温度要求问题
    if ([self.model.carType isEqualToString:@"cold"]) {
        self.takeCargoL.text = [NSString stringWithFormat:@"温度要求：%@",self.model.tem];
        self.sendCargoL.hidden = YES;
    }else{
       self.takeCargoL.text = self.model.takeCargo ?@"物流公司上门取货":@"发件人送到货场";
       self.sendCargoL.text = self.model.sendCargo ?@"物流公司送货上门":@"收件人自提";
    }
    
    self.startL.text = self.model.startPlace;
    self.endL.text = self.model.entPlace;
    self.sendNameL.text = [NSString stringWithFormat:@"发件人：%@",self.model.sendName];
    self.sendPhoneL.text = [NSString stringWithFormat:@"电话：%@",self.model.sendMobile];
    self.arriveNameL.text = [NSString stringWithFormat:@"收件人：%@",self.model.takeName];
    self.arrivePhoneL.text = [NSString stringWithFormat:@"电话：%@",self.model.takeMobile];
    self.companyNameL.text = [NSString stringWithFormat:@"名称：%@",self.baojiaModel.companyName];
    if (self.model.takeCargo) {
        self.huochangL.text = @"";
    }else{
        self.huochangL.text = [NSString stringWithFormat:@"货场地址：%@",self.baojiaModel.yardAddress];
    }
    //温度要求问题
    if ([self.model.carType isEqualToString:@"cold"]) {
       self.quL.text = @"运费";
       self.quqFree.text =[NSString stringWithFormat:@"%@",_baojiaModel.cargoTotal];
       self.songL.text = @"合计";
       self.songFree.text = [NSString stringWithFormat:@"%@",_baojiaModel.transferMoney];
        self.yunfeiL.hidden = YES;
        self.yunfeiFree.hidden = YES;
        self.yunfeiYuan.hidden = YES;
        self.hejiL.hidden = YES;
        self.hejiDanwei.hidden = YES;
        self.totolFree.hidden = YES;
    }else{
        
    self.quqFree.text = [NSString stringWithFormat:@"%@",_baojiaModel.takeCargoMoney];
    self.songFree.text = [NSString stringWithFormat:@"%@",_baojiaModel.sendCargoMoney];
    self.yunfeiFree.text = [NSString stringWithFormat:@"%@",_baojiaModel.cargoTotal];
    self.totolFree.text =[NSString stringWithFormat:@"%@",_baojiaModel.transferMoney];
    }
    self.messageL.text = [NSString stringWithFormat:@"留言：%@",_baojiaModel.luMessage];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
 [self.navigationController.navigationBar setBarTintColor:COLOR_MainColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)jiaofeiBtnClick:(UIButton *)sender {
    //立即缴费按钮
    __weak jiaoFeiDetailViewController * weakSelf = self;
    _jiaofeiPay =[[[NSBundle mainBundle] loadNibNamed:@"WeiJiaoFeiPay" owner:self options:nil] lastObject];
    _jiaofeiPay.moneyLabel.text = [NSString stringWithFormat:@"%@元",_model.playMoneyMin];
    [_jiaofeiPay show];
    _jiaofeiPay.block = ^(NSInteger tag){
        [weakSelf payBtnWithTag:tag];
    };
}

#pragma mark -----  分单支付
-(void)payBtnWithTag:(NSInteger)tag{
    __weak jiaoFeiDetailViewController * weakSelf = self;
    switch (tag) {
        case 0:{
            _payType = 1;
            _jiaofeiPay.moneyLabel.text = [NSString stringWithFormat:@"%@元",_model.playMoneyMin];
        }
            break;
        case 1:{
            _payType = 2;
            _jiaofeiPay.moneyLabel.text = [NSString stringWithFormat:@"%@元",_model.playMoneyMax];
        }
            break;
        case 2:{
            _payType = 3;
            _jiaofeiPay.moneyLabel.text = [NSString stringWithFormat:@"%@元",_model.playMoneyMax];
        }
            break;
        case 3:{
            [weakSelf paySure];
        }
            break;
        default:
            break;
    }
}

//确定我要付款了
-(void)paySure{
    switch (_payType) {
        case 0:{
            [SVProgressHUD showErrorWithStatus:@"请先选择支付方式"];
        }
            break;
        case 1:
            NSLog(@"余额");
            _payType = 0;
            [self payYue];
            break;
        case 2:
            _payType = 0;
            [self wxPay];
            NSLog(@"微信");
            break;
        case 3:
            _payType = 0;
            [self zhifubaoPay];
            NSLog(@"支付宝");
            break;
        default:
            break;
    }
}

//余额支付的情况
-(void)payYue{
    
    // 物流公司报价余额支付
    [SVProgressHUD show];
    NSString * str = [NSString stringWithFormat:@"%@quotation/balancePay?userId=%@&billCode=%@&counterFee=%@",BaseUrl,[UserManager getDefaultUser].userId ,_model.billCode,_model.playMoneyMin];
    [ExpressRequest sendWithParameters:nil MethodStr:str reqType:k_GET success:^(id object) {
        [SVProgressHUD showSuccessWithStatus:[object valueForKey:@"message"]];
        [_jiaofeiPay removeFromSuperview];
        [self notice];
    } failed:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
}

//微信支付
-(void)wxPay{
    NSLog(@"物流公司报价微信支付平台使用费");
    [SVProgressHUD show];
    NSString *newBillCode = [NSString stringWithFormat:@"%@B%@",_model.billCode,[UserManager getDefaultUser].userId];
    NSString *URLStr = [NSString stringWithFormat:@"%@logistics/task/pay/wechat/pre?billCode=%@&price=%@&type=2",BaseUrl,newBillCode,_model.playMoneyMax];
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
                                   [_jiaofeiPay removeFromSuperview];
                                   
                               }
                                failed:^(NSString *error) {
                                    [SVProgressHUD showErrorWithStatus:error];
                                }];
}

-(void)zhifubaoPay{
    NSLog(@"物流公司报价支付宝支付");
    NSString *newBillCode = [NSString stringWithFormat:@"%@B%@",_model.billCode,[UserManager getDefaultUser].userId];
    [AlipayRequestConfig alipayWithPartner:kPartnerID seller:kSellerAccount tradeNO:newBillCode productName:@"镖王" productDescription:@"平台使用费" amount:_model.playMoneyMax notifyURL:kNotifyURL itBPay:@"30m" standbyCallback:^(NSDictionary *resultDic) {
        
        if ([[resultDic objectForKey:@"resultStatus"] integerValue]==9000) {
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"恭喜您支付成功%@元！",_model.playMoneyMax]];
            [self checkResultWithBillCode:newBillCode];
        }
        else {
            NSLog(@"%@",resultDic);
            [SVProgressHUD showErrorWithStatus:[resultDic objectForKey:@"memo"] ];
        }
    }];
    [_jiaofeiPay removeFromSuperview];
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];;
}


@end
