//
//  PublishWindOne.h
//  iwant
//
//  Created by 公司 on 2017/3/25.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XPQScrollLabel.h"
@interface PublishWindOne : UIView
@property (weak, nonatomic) IBOutlet UIView *startView;
@property (weak, nonatomic) IBOutlet UIView *deataintView;
@property (weak, nonatomic) IBOutlet UIView *weightView;
@property (weak, nonatomic) IBOutlet UIView *timeView;
@property (weak, nonatomic) IBOutlet UILabel *topNoticeLabel;

@property (weak, nonatomic) IBOutlet UITextField *startTextField;
@property (weak, nonatomic) IBOutlet XPQScrollLabel *locatLabel;
@property (weak, nonatomic) IBOutlet UITextField *startDetailTextField;
@property (weak, nonatomic) IBOutlet UITextField *endTextField;

@property (weak, nonatomic) IBOutlet XPQScrollLabel *endLocatLabel;

@property (weak, nonatomic) IBOutlet UITextField *endDetailTextField;

@property (weak, nonatomic) IBOutlet UITextField *weightTextField;
@property (weak, nonatomic) IBOutlet UITextField *timeTextField;
@property (weak, nonatomic) IBOutlet UIButton *timeSelectBtn;

@property (weak, nonatomic) IBOutlet UILabel *kgDanwei; //kg的单位
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraintHeight;

@property (nonatomic, copy) void (^BlockOne)(int tag);

@property (nonatomic, strong) NSMutableArray *arr;
@property (copy, nonatomic) void (^WeightBlock)(NSString * weightStr,NSString * weight);
@end
