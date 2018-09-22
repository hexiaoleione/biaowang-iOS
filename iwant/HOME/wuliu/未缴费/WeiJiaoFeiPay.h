//
//  WeiJiaoFeiPay.h
//  iwant
//
//  Created by 公司 on 2017/2/28.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PayBackBlock) (NSInteger tag); //记载tag值

@interface WeiJiaoFeiPay : UIView

@property (weak, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *surePay;
@property (weak, nonatomic) IBOutlet UIButton *yuEbtn;
@property (weak, nonatomic) IBOutlet UIButton *weChatBtn;
@property (weak, nonatomic) IBOutlet UIButton *AliPay;

@property (copy, nonatomic)  PayBackBlock block;


-(void)show;
-(void)dismiss;
@end
