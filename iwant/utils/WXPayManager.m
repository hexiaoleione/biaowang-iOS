//
//  WXPayManager.m
//  iwant
//
//  Created by dongba on 16/5/24.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "WXPayManager.h"
#import "AssessViewController.h"
#import "Utils.h"
#import "RequestManager.h"
#import "SVProgressHUD.h"
static WXPayManager *wxPayManager = nil;
@implementation WXPayManager

+(id)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        wxPayManager = [[WXPayManager alloc] init];
        
    });
    
    return wxPayManager;
}

+(void)nextStep{
    WXPayManager *manager = [WXPayManager shareManager];
    manager.isAlert = YES;
    //有billcode表明之前不久调起了微信支付
    if (!manager.billCode | [manager.billCode isEqualToString: @""]) {
//        [SVProgressHUD dismiss];//影响第三方登陆
        return;
    }else{
        [SVProgressHUD show];
        //微信充值
        NSString *strMsg = nil;
        NSString *titleStr = nil;
        NSRange range = [manager.billCode rangeOfString:@"CZ"];
        NSRange range_sf = [manager.billCode rangeOfString:@"SF"];
        NSRange range_wl = [manager.billCode rangeOfString:@"WL"];
        if (range.location != NSNotFound) {
            titleStr = @"充值结果";
            strMsg = @"恭喜您充值成功！";
        }else{
            titleStr = @"支付结果";
            strMsg = @"恭喜您支付成功！";
        }
        [RequestManager getPayResultWithBillCode:manager.billCode success:^(NSDictionary *result) {
            NSLog(@"%@",result);
            if (range.location != NSNotFound){
                UIViewController *currentVC = (UIViewController *)((UINavigationController *)[Utils getCurrentVC].childViewControllers.lastObject);
                [currentVC.navigationController popViewControllerAnimated:YES];

            }
            [[NSNotificationCenter defaultCenter] postNotificationName:TRANSFERMONEY object:nil];
            
            
            [SVProgressHUD dismiss];
            //微信支付成功通知
            if (range_sf.location != NSNotFound) {
                [[NSNotificationCenter defaultCenter] postNotificationName:WECHAT_BACK_SF object:nil];
            }else if (range_wl.location != NSNotFound){
                [[NSNotificationCenter defaultCenter] postNotificationName:WECHAT_BACK_WL object:nil];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titleStr message:strMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                [self gotoNextVC];
            }
        } Failed:^(NSString *error) {
            [SVProgressHUD showErrorWithStatus:error];
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titleStr message:error delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
        }];
        manager.billCode = nil;
    }
}
//快递模块微信成功 处理
+ (void)gotoNextVC{
    WXPayManager *manager = [WXPayManager shareManager];
    //当前控制器
    UIViewController *currentVC = (UIViewController *)((UINavigationController *)[Utils getCurrentVC].childViewControllers.lastObject);
   }
@end
