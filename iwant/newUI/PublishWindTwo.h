//
//  PublishWindTwo.h
//  iwant
//
//  Created by 公司 on 2017/3/25.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublishWindTwo : UIView
@property (weak, nonatomic) IBOutlet UIView *sendView;
@property (weak, nonatomic) IBOutlet UIView *receiveView;
@property (weak, nonatomic) IBOutlet UIView *goodsView;
@property (weak, nonatomic) IBOutlet UIView *goodsNameView;
@property (weak, nonatomic) IBOutlet UILabel *topNoticeLabel;
@property (weak, nonatomic) IBOutlet UIView *remarkvIew;

@property (weak, nonatomic) IBOutlet UITextField *remarkTextField;
@property (weak, nonatomic) IBOutlet UIView *noticeView;


@property (weak, nonatomic) IBOutlet UITextField *sendNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *sendPhoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *receiveNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *receivePhoneTextField;
@property (weak, nonatomic) IBOutlet UIButton *toubaoBtn;
@property (weak, nonatomic) IBOutlet UITextField *goodsNameTextField;

@property (weak, nonatomic) IBOutlet UIButton *replaceMoneyBtn;

@property (weak, nonatomic) IBOutlet UITextField *goodsValueTextField;
@property (weak, nonatomic) IBOutlet UITextField *replaceMoneyTextField;
@property (weak, nonatomic) IBOutlet UILabel *toubaoImg;

@property (weak, nonatomic) IBOutlet UILabel *replaceMoneyImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeightConstraint;


@property (nonatomic, copy) void (^BlockTwo)(int tag);

@end
