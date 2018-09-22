//
//  RoleExplainVC.h
//  iwant
//
//  Created by 公司 on 2017/2/27.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "BaseLeftViewController.h"

@interface RoleExplainVC : BaseLeftViewController
@property (weak, nonatomic) IBOutlet UIView *viewOne;
@property (weak, nonatomic) IBOutlet UIView *viewThree;
@property (weak, nonatomic) IBOutlet UIView *viewFour;
@property (weak, nonatomic) IBOutlet UIView *viewTwo;
@property (weak, nonatomic) IBOutlet UIView *viewFive;


@property (weak, nonatomic) IBOutlet UIImageView *imgOne;
@property (weak, nonatomic) IBOutlet UIImageView *imgTwo;
@property (weak, nonatomic) IBOutlet UIImageView *imgThree;
@property (weak, nonatomic) IBOutlet UIImageView *imgFour;
@property (weak, nonatomic) IBOutlet UIImageView *imgFive;

@property (weak, nonatomic) IBOutlet UIButton *centerBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewOneConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewTwoConstrainr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewThreeConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewFourConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fiveViewConstraint;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topNoticeConstraint;


@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDistanceConstraint;
@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;

/*是否注册的时候完善*/
@property (assign, nonatomic)  BOOL isRegist;


@end
