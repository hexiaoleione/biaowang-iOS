//
//  LCFPayViewConstroller.h
//  iwant
//
//  Created by 公司 on 2017/10/12.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "BaseViewController.h"
#import "ShunFeng.h"
@interface LCFPayViewConstroller : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *payNameLabel;  //专程送/顺路送
@property (weak, nonatomic) IBOutlet UILabel *transformoneyLable;  // 运费1200元
@property (weak, nonatomic) IBOutlet UILabel *baoXianLabel;    //保险费用
@property (weak, nonatomic) IBOutlet UILabel *insureLabel;    //保费
@property (weak, nonatomic) IBOutlet UILabel *couponLabel;    //现金券
@property (weak, nonatomic) IBOutlet UILabel *needPayMoneyLabel;   //共计
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *baoxianConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeightConstraint;


@property (weak, nonatomic) IBOutlet UIButton *couponSwitchBtn;  //选择现金券按钮
@property (weak, nonatomic) IBOutlet UIView *btnBgView;

@property (nonatomic,strong) UIButton * yueBtn;
@property (nonatomic,strong) UIButton * weChatBtn;
@property (nonatomic,strong) UIButton * AliBtn;
@property (nonatomic,strong) UIButton * otherPayBtn;



@property (nonatomic,strong)ShunFeng * model;
@property (nonatomic,copy)NSString * payName;
@property (nonatomic,strong) NSString *sendType;
@end
