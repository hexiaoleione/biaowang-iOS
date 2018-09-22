//
//  PayView.h
//  iwant
//
//  Created by dongba on 16/10/14.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Wallet;
typedef void (^PayBackBlock) (NSInteger tag);//0-开关  1-余额支2-微信 3-支付宝 4-支付
@interface PayView : UIView
@property (strong, nonatomic)  UIButton *btn;
@property (weak, nonatomic) IBOutlet UILabel *payType;
@property (weak, nonatomic) IBOutlet UILabel *payMoney;
@property (weak, nonatomic) IBOutlet UILabel *insuerMoney;
@property (weak, nonatomic) IBOutlet UISwitch *couponSwitch;
@property (weak, nonatomic) IBOutlet UILabel *resultMoney;
@property (nonatomic, strong) UIControl *overlayView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *payBtns;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgImgHeight;
@property (weak, nonatomic) IBOutlet UIView *table;

@property (weak, nonatomic) IBOutlet UIButton *yueBtn;
@property (weak, nonatomic) IBOutlet UIButton *weixinBtn;
@property (weak, nonatomic) IBOutlet UIButton *alipayBtn;
@property (weak, nonatomic) IBOutlet UILabel *noCopon;
@property (weak, nonatomic) IBOutlet UILabel *insureLable;

@property (weak, nonatomic) IBOutlet UILabel *daishouHuokuanL;

@property (weak, nonatomic) IBOutlet UILabel *replaceMoneyLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDiatanceConstraint;

@property (weak, nonatomic) IBOutlet UISwitch *daifuSwitch;
@property (weak, nonatomic) IBOutlet UILabel *daifuLabel;



/*<#uttext#>*/
@property (copy, nonatomic)  PayBackBlock block;

-(void)show;
- (void)dismiss;
- (void)setLogistModel:(NSArray *)strArr;
- (void)setModel:(NSArray *)strArr;
- (void)reloadDataWithCoupon:(NSMutableArray *)couponArray;

- (void)setWLLogistModel:(NSArray *)strArr;

@property (nonatomic,copy) void (^needPayBlock)(double needPayMoney);


@end
