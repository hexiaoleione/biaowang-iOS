//
//  OrderDetailViewController.m
//  iwant
//
//  Created by dongba on 16/8/26.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "MainHeader.h"
#import "ZYRatingView.h"
#import "UserLogListViewController.h"
#import "CouponViewController.h"
#import "Wallet.h"
#import "AlipayRequestConfig.h"
#import "WXPay.h"
#import "WXApi.h"
#import "WXPayManager.h"
#import "GoodsInfoView.h"
#import "companyInfoView.h"//物流公司的详情view
#import "DanBaoViewController.h"  //是否担保交易界面

@interface OrderDetailViewController ()<RatingViewDelegate>{
    UIScrollView *_scrollView;
    GoodsInfoView *_matView;//货物信息
    companyInfoView * _companyInfoView;
    NSString *_couponId;
    BOOL _selected;
    UIVisualEffectView *visualEffectView;
    NSString *_status;
    NSString *_payType;
}
@property (nonatomic, copy) NSString *premium;//参保金额

@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCostomeTitle:@"详情"];
    [self configSubviews];
    
}

- (void)configSubviews{
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)];
    _scrollView.contentSize = CGSizeMake(WINDOW_WIDTH, 736.0);
    _scrollView.backgroundColor = BACKGROUND_COLOR;
    [self.view addSubview:_scrollView];
    _matView = [[[NSBundle mainBundle] loadNibNamed:@"GoodsInfoView" owner:nil options:nil] lastObject];
    [_matView setViewsWithModel:_model];
    _matView.width = WINDOW_WIDTH;
    _matView.y = 8;
    [_scrollView addSubview:_matView];
    
    _companyInfoView = [[[NSBundle mainBundle] loadNibNamed:@"companyInfoView" owner:nil options:nil] lastObject];
    _companyInfoView.y = _matView.bottom+8;
    _companyInfoView.width = WINDOW_WIDTH;
    [_companyInfoView setViewsWithModel:self.baojiaModel];
    [_scrollView addSubview:_companyInfoView];
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectBtn setBackgroundColor:COLOR_ORANGE_DEFOUT];
    //已经做出选择 未支付
    if ([self.model.status intValue]==8||[self.model.status intValue]==2) {
        if ([self.model.status intValue] ==8 && self.baojiaModel.choose != 1) {
        _companyInfoView.telHeightConstraint.constant = 0;
        _companyInfoView.disistanceConstraint.constant = 0;
        _companyInfoView.height -= 24;
        [selectBtn setTitle:@"就选TA了" forState:UIControlStateNormal];
        }else{
        [selectBtn setTitle:@"去支付" forState:UIControlStateNormal];
        }
    }else{
        _companyInfoView.telHeightConstraint.constant = 0;
        _companyInfoView.disistanceConstraint.constant = 0;
        _companyInfoView.height -= 24;
        [selectBtn setTitle:@"就选TA了" forState:UIControlStateNormal];
    }
    selectBtn.top = _companyInfoView.bottom + 30;
    
    [selectBtn sizeToFit];
    selectBtn.width = selectBtn.width *1.5;
    selectBtn.layer.cornerRadius = 8;
    selectBtn.centerX = _scrollView.centerX;
    
    selectBtn.centerX = _scrollView.centerX;
    [_scrollView addSubview:selectBtn];
    [selectBtn addTarget:self action:@selector(selected) forControlEvents:UIControlEventTouchUpInside];
}

-(void)selected{
    NSLog(@"就选他了~~~~~~/去支付~~");
    NSString * strUrl = [NSString stringWithFormat:@"%@logistics/task/chose?recId=%@&userId=%@",BaseUrl,self.model.recId,self.comId];
    [ExpressRequest sendWithParameters:nil MethodStr:strUrl reqType:k_GET success:^(id object) {
        
        DanBaoViewController * danbaoVc =[[DanBaoViewController alloc]init];
        danbaoVc.isZhiFu = YES;
        danbaoVc.recId = self.model.recId;
        [self.navigationController pushViewController:danbaoVc animated:YES];
        
    } failed:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
}

-(void)ratingChanged:(float)newRating{
    
}

- (void)setMohu{
    if (visualEffectView) {
        visualEffectView.hidden = NO;
        return;
    }
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    visualEffectView.frame = self.view.bounds;
    visualEffectView.alpha = 0.6;
    [self.view addSubview:visualEffectView];
    visualEffectView.hidden = NO;
}

- (void)paySure:(NSInteger )tag{
//    self.premium = [self countPremiumWith:_comView.premiumTextFiled.text];
    NSString *countMoney = [NSString stringWithFormat:@"%f",([self.premium doubleValue] + [_money doubleValue])];
    switch (tag) {
        case 0:{//余额支付
            //余额支付
            [SVProgressHUD showWithStatus:@"正在支付"];
            [ExpressRequest sendWithParameters:nil
                                     MethodStr:[NSString stringWithFormat:@"%@logistics/task/pay/balance?userId=%@&WLBId=%@&whether=%@&premium=%@",BaseUrl,_comId,_model.recId,_status,self.premium]
                                       reqType:k_GET success:^(id object) {
                                           [SVProgressHUD showSuccessWithStatus:[object valueForKey:@"message"]];
                                           [self goBackRefresh];
                                       }
                                        failed:^(NSString *error) {
                                            [SVProgressHUD showErrorWithStatus:error];
                                        }];
        }
            break;
        case 1:{//支付宝支付
            if (_selected) {
                [SVProgressHUD showInfoWithStatus:@"现金券仅限余额支付使用"];
                return;
            }
            [SVProgressHUD show];
            NSString *newBillCode = [NSString stringWithFormat:@"%@C",_model.billCode];
            [AlipayRequestConfig alipayWithPartner:kPartnerID seller:kSellerAccount tradeNO:newBillCode productName:@"镖王" productDescription: @"快递费" amount:countMoney notifyURL:kNotifyURL itBPay:@"30m" standbyCallback:^(NSDictionary *resultDic)
             {
                 if ([[resultDic objectForKey:@"resultStatus"] integerValue]==9000) {
                     [SVProgressHUD showSuccessWithStatus:@"支付成功"];
                     [self goBackRefresh];
                 }
                 else {
                     [SVProgressHUD showErrorWithStatus:[resultDic objectForKey:@"memo"] ];
                 }
             }];

        }
            break;
        case 2:{//微信支付
            if (_selected) {
                [SVProgressHUD showInfoWithStatus:@"现金券仅限余额支付使用"];
                return;
            }
            [SVProgressHUD show];
            NSLog(@"个人支付微信报价");
            [SVProgressHUD show];
            NSString *URLStr = [NSString stringWithFormat:@"%@logistics/task/pay/wechat/pre?billCode=%@&price=%@&type=%@",BaseUrl,_model.billCode,countMoney,_payType];
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
                                           wxManager.billCode = _model.billCode;
                                       }
                                        failed:^(NSString *error) {
                                            [SVProgressHUD showErrorWithStatus:error];
                                        }];

                               }
            break;
        case 11:
            //取消支付
            visualEffectView.hidden = YES;
            _selected = NO;
            break;
            
        default:
            break;
    }
}

//计算保费
- (NSString *)countPremiumWith:(NSString *)money{

    if (money.length) {
        double newMoney = [money doubleValue];
        double tempMoney = (newMoney - 1000) * 0.001;
        if (tempMoney) {
            return [NSString stringWithFormat:@"%f",tempMoney];
        }
    }
    return @"0";
}

- (void)goBackRefresh{
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[UserLogListViewController class]]) {
            [self.navigationController popToViewController:temp animated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_WULIU object:nil];
        }
    }
}

- (void)pay{
    
//    [self showPayType];
//        //余额支付
//    [SVProgressHUD showWithStatus:@"正在支付"];
//    [ExpressRequest sendWithParameters:nil
//                             MethodStr:[NSString stringWithFormat:@"logistics/task/pay/balance?userId=%@&price=%@&WLBId=%@",_comId,_money,_model.recId]
//                               reqType:k_PUT success:^(id object) {
//                                   [SVProgressHUD showSuccessWithStatus:[object valueForKey:@"message"]];
//                                   for (UIViewController *temp in self.navigationController.viewControllers) {
//                                       if ([temp isKindOfClass:[UserLogListViewController class]]) {
//                                           [self.navigationController popToViewController:temp animated:YES];
//                                           [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_WULIU object:nil];
//                                       }
//                                   }
//    }
//                                failed:^(NSString *error) {
//                                    [SVProgressHUD showErrorWithStatus:error];
//    }];
}

- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
