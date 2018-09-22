//
//  WXPayManager.h
//  iwant
//
//  Created by dongba on 16/5/24.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Package.h"
#define TRANSFERMONEY     @"transfer"//收到转账--余额增减都需要通知
#define WECHAT_BACK_SF    @"weixinPay_back_sf"//顺风微信支付成功回调
#define WECHAT_BACK_WL    @"weixinPay_back_wl"//物流微信支付成功回调
@interface WXPayManager : NSObject
/*billcode*/
@property (copy, nonatomic)  NSString *billCode;

/*一键快递详情*/
@property (strong, nonatomic)  Package *model;

/*支付失败已经提示过了*/
@property (assign, nonatomic)  BOOL isAlert;


@property (assign, nonatomic)  BOOL isNeedUpdate;
+(id)shareManager;
/*
 *微信支付完毕后跳转
 */
+(void)nextStep;
@end
