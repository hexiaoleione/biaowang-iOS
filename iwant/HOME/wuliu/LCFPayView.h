//
//  LCFPayView.h
//  iwant
//
//  Created by 公司 on 2016/12/1.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ClickBlock) (id sender);


@interface LCFPayView : UIView
@property (weak, nonatomic) IBOutlet UIView *payView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet UIButton *thirdPayBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIButton *weChatBtn;
@property (weak, nonatomic) IBOutlet UIButton *zhiFuBaoBtn;
@property (weak, nonatomic) IBOutlet UIButton *guanbiBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightContraint;

@property (weak, nonatomic) IBOutlet UILabel *needPayMoney;

@property (weak, nonatomic) IBOutlet UILabel *noteLabelOne;
@property (weak, nonatomic) IBOutlet UILabel *noteLabelTwo;
@property (weak, nonatomic) IBOutlet UILabel *noteLabelThree;

@property (copy, nonatomic)  ClickBlock block;
@end
