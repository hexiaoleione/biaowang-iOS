//
//  PublishWLOne.h
//  iwant
//
//  Created by 公司 on 2017/4/6.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XPQScrollLabel.h"
#import "MainHeader.h"
@interface PublishWLOne : UIView
@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UITextField *startTextField;
@property (weak, nonatomic) IBOutlet XPQScrollLabel *locatLabel;
@property (weak, nonatomic) IBOutlet UITextField *startDetailTextField;
@property (weak, nonatomic) IBOutlet UITextField *endTextField;

@property (weak, nonatomic) IBOutlet XPQScrollLabel *endLocatLabel;

@property (weak, nonatomic) IBOutlet UITextField *endDetailTextField;
@property (weak, nonatomic) IBOutlet UITextField *weightTextField;
@property (weak, nonatomic) IBOutlet UITextField *cargoNumberTextField;

@property (weak, nonatomic) IBOutlet UITextField *goodsNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *goodsSqureTextField;
@property (weak, nonatomic) IBOutlet UIButton *timeSelectBtn;
@property (weak, nonatomic) IBOutlet UITextField *timeTextField;

@property (weak, nonatomic) IBOutlet UIButton *danweiBtn;

@property (nonatomic, copy) void (^BlockOne)(UIButton * sender,int tag);
@end
