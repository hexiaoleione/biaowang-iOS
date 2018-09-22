//
//  CouponViewController.h
//  iwant
//
//  Created by pro on 16/3/8.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "BaseLeftViewController.h"
@class Wallet;
typedef void (^valueBlock)(Wallet *wallet);
typedef void (^ShunfengBlock)(NSString *couponId,NSMutableArray *selectedModelArray);
@interface CouponViewController : BaseLeftViewController
/*支付条转过来*/
@property (assign, nonatomic)  BOOL isPay;
/*billcode*/
@property (copy, nonatomic)  NSString *billcode;
/*needMoney*/
@property (copy, nonatomic)  NSString *needMoney;

/*<#uttext#>*/
@property (copy, nonatomic)  valueBlock block;

@property (copy, nonatomic)  ShunfengBlock shunfengBlock;
@end
