//
//  FaBiaoPersonView.h
//  iwant
//
//  Created by 公司 on 2017/2/8.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XPQScrollLabel.h"
typedef void (^Block) (int tag);//0-顶部的btn 1-手机联系人 2-定位 3-发件人下一步 4-收件人上一步 5-收件人下一步
@interface FaBiaoPersonView : UIView
@property (weak, nonatomic) IBOutlet UIView *sendView;
@property (weak, nonatomic) IBOutlet UIButton *TopBtn;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UIButton *tongxunluBtn;
@property (weak, nonatomic) IBOutlet XPQScrollLabel *locatLabel;

@property (weak, nonatomic) IBOutlet UITextField *detailAddressTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendNextBtn;

@property (weak, nonatomic) IBOutlet UIButton *beforeBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnDistanceCobstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *diatanceConstraint;

@property (weak, nonatomic) IBOutlet UILabel *noticeLbael;//顶部提示条


@property (copy, nonatomic)  Block block;

@end
