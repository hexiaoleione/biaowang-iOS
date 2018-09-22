//
//  DepositVC.m
//  iwant
//
//  Created by 公司 on 2017/8/22.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "DepositVC.h"
#import "WXPayManager.h"
#import "MainHeader.h"
#import "WXApi.h"
#import "AlipayHeader.h"
#import "EcoinWebViewController.h"

@interface DepositVC ()
@property (weak, nonatomic) IBOutlet UILabel *noticeL;
@property (weak, nonatomic) IBOutlet UILabel *moneyL;
@property (weak, nonatomic) IBOutlet UIButton *WXBtn;
@property (weak, nonatomic) IBOutlet UIButton *AliPayBtn;

@end

@implementation DepositVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCostomeTitle:@"保证金"];
    [self configNavgationBtn];
    self.moneyL.text = [NSString stringWithFormat:@"¥%@元",self.money];
}

- (void)configNavgationBtn {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(yajinShuoMing)
     forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 80, 30);
    [button setTitle:@"保证金说明" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = menuButton;
}

//保证金说明
-(void)yajinShuoMing{
    EcoinWebViewController * vc = [[EcoinWebViewController alloc]init];
    vc.web_type = WEB_Deposit;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)yajinShuoMing:(UIButton *)sender {
    EcoinWebViewController * vc = [[EcoinWebViewController alloc]init];
    vc.web_type = WEB_Deposit;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark ---btnClick
- (IBAction)btnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.tag == 0) {
        _AliPayBtn.selected = NO;
    }else{
        _WXBtn.selected = NO;
    }
}
- (IBAction)JiaoBtnClick:(UIButton *)sender {
    if (_WXBtn.selected) {
        [self wxPay];
    }else if(_AliPayBtn.selected){
        [self AliPay];
    }else{
        [SVProgressHUD showErrorWithStatus:@"请先选择一种支付方式"];
    }
}

-(void)wxPay{
    [SVProgressHUD show];
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showInfoWithStatus:@"您没有安装微信客户端"];
        return;
    }
    [RequestManager getRechargePreUserId:[UserManager getDefaultUser].userId rechargeMoney:self.money recommandMobile:@" " success:^(NSDictionary *result) {
        [SVProgressHUD dismiss];
        PayReq* req             = [[PayReq alloc] init];
        req.partnerId           = [result valueForKey:@"partnerId"];
        req.prepayId            = [result valueForKey:@"prepayid"];
        req.nonceStr            = [result valueForKey:@"nonceStr"];
        req.timeStamp           = [[result valueForKey:@"timestamp"] intValue];
        req.package             = [result valueForKey:@"package_"];
        req.sign                = [result valueForKey:@"sign"];
        [WXApi sendReq:req];
        WXPayManager *manager = [WXPayManager shareManager];
        manager.billCode = [result valueForKey:@"billCode"];
        [self.navigationController popViewControllerAnimated:YES];

    } Failed:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
}

-(void)AliPay{
    [SVProgressHUD show];
    [AlipayRequestConfig alipayWithPartner:kPartnerID seller:kSellerAccount tradeNO:[self creatTradeNO] productName:@"镖王" productDescription:@"镖师保证金" amount:self.money notifyURL:kNotifyURL itBPay:@"30m" standbyCallback:^(NSDictionary *resultDic)
     {
         [SVProgressHUD dismiss];
         
         if ([[resultDic objectForKey:@"resultStatus"] integerValue]==9000) {
             [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"恭喜您成功缴纳%@元！",self.money] ];
             [self.navigationController popViewControllerAnimated:YES];
         }
         else {
             [SVProgressHUD showErrorWithStatus:@"支付失败" ];
         }
     }];
}

-(NSString *)creatTradeNO{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    NSString *result = [NSString stringWithFormat:@"%@%@%@",[UserManager getDefaultUser].userId,@"CZ",strDate];
    return result;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
