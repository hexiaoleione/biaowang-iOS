//
//  SFFaViewConstroller.h
//  iwant
//
//  Created by 公司 on 2017/6/2.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "BaseViewController.h"

@interface SFFaViewConstroller : BaseViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *faViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shouViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameTextfieldHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *daishouHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remarkHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *noticeTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fabuBtnTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cargoTypeViewConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cargoTypeHeightConstraint1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cargoTypeHeightConstraint2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cargoTypeHeightConstraint3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cargoTypeHeightConstraint4;

@property (weak, nonatomic) IBOutlet UILabel *topNoticeL;

@property (weak, nonatomic) IBOutlet UITextField *sendNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *sendPhoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *receiveNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *receivePhoneTextField;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *remarkL;
@property (weak, nonatomic) IBOutlet UILabel *noticeL;

@property (weak, nonatomic) IBOutlet UITextField *mateNameTextField;
@property (weak, nonatomic) IBOutlet UIButton *toubaoBtn;
@property (weak, nonatomic) IBOutlet UIButton *replaceMoneyBtn;
@property (weak, nonatomic) IBOutlet UIButton *matTypeBtn;//货物类型
@property (weak, nonatomic) IBOutlet UITextField *mateType;
//货物类型textField

@property (weak, nonatomic) IBOutlet UITextField *mateValue;
@property (weak, nonatomic) IBOutlet UITextField *replaceMoneyTextField;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet UITextView *remarkTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineTopConstraint; //一般设置为8  超过5000元设置为 58
@property (weak, nonatomic) IBOutlet UILabel *insureLabel; //选择承保类型
@property (weak, nonatomic) IBOutlet UIButton *jiBenBtn; //基本险
@property (weak, nonatomic) IBOutlet UIButton *zongHeBtn;//综合险

@property (weak, nonatomic) IBOutlet UIView *mateTypeView;

@property (nonatomic,strong)ShunFeng * sfModel;

@property (nonatomic,assign) BOOL publishAgain;
@property (nonatomic,strong)NSString * weatherId;  //天气
@property (nonatomic,strong)NSString * temp; //温度

@property (nonatomic,copy)NSString * insureUrl; // 投保须知的链接
@property (nonatomic,strong) NSString *sendType;
@end
