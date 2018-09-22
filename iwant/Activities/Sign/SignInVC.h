//
//  SignInVC.h
//  SignInTest
//
//  Created by 公司 on 2016/12/18.
//  Copyright © 2016年 lcf. All rights reserved.
//

#import "BaseLeftViewController.h"

@interface SignInVC : BaseLeftViewController
@property (weak, nonatomic) IBOutlet UIImageView *firstImage;
@property (weak, nonatomic) IBOutlet UIImageView *secImage;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImage;
@property (weak, nonatomic) IBOutlet UIImageView *fourImage;
@property (weak, nonatomic) IBOutlet UIImageView *fiveImage;
@property (weak, nonatomic) IBOutlet UIImageView *sixImage;
@property (weak, nonatomic) IBOutlet UIImageView *sevImage;
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourLabel;
@property (weak, nonatomic) IBOutlet UILabel *fiveLabel;
@property (weak, nonatomic) IBOutlet UILabel *sixLabel;
@property (weak, nonatomic) IBOutlet UILabel *sevenLabel;

@property (weak, nonatomic) IBOutlet UIView *greenBgView;//绿色背景
@property (weak, nonatomic) IBOutlet UILabel *daysLabel; //连续签到天数
@property (weak, nonatomic) IBOutlet UILabel *ecoinTodayLabel;//今日积分数
@property (weak, nonatomic) IBOutlet UILabel *ecionTotolLabel;//积分总数
@property (weak, nonatomic) IBOutlet UIButton *signBtn; //签到按钮
@property (weak, nonatomic) IBOutlet UILabel *ruleOne;
@property (weak, nonatomic) IBOutlet UILabel *ruleTwo;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *disToTreeBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *disToBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *distanceHeight;
@end
