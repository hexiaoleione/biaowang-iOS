//
//  WLUserPay.h
//  iwant
//
//  Created by 公司 on 2017/1/6.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^PayBackBlock) (NSInteger tag);//0-开关  1-余额支2-微信 3-支付宝 4-支付

@interface WLUserPay : UIView
@property (weak, nonatomic) IBOutlet UIView *payView;
@property (weak, nonatomic) IBOutlet UIButton *YueEPayBtn;
@property (weak, nonatomic) IBOutlet UIButton *WeChatBtn;
@property (weak, nonatomic) IBOutlet UIButton *AliPayBtn;
@property (weak, nonatomic) IBOutlet UIButton *makeSurePay;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *payBtn;

@property (weak, nonatomic) IBOutlet UIButton *paySureBtn;
@property (weak, nonatomic) IBOutlet UISwitch *couponSwitch;

@property (weak, nonatomic) IBOutlet UILabel *realPayMoney;
@property (weak, nonatomic) IBOutlet UILabel *payMoney;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;

@property (copy, nonatomic)  PayBackBlock block;


-(void)show;
-(void)dismiss;
- (void)setLogistModel:(NSArray *)strArr;

@end
