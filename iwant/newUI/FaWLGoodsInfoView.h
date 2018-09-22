//
//  FaWLGoodsInfoView.h
//  iwant
//
//  Created by 公司 on 2017/2/14.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^Block)(int tag);// 1-期望时间选择 2-重量的单位 3-上门取货 4-用户自提 5-上一步  6- 确认发布

@interface FaWLGoodsInfoView : UIView
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *goodsInfoView;

@property (weak, nonatomic) IBOutlet UITextField *goodsNameTextfield;
@property (weak, nonatomic) IBOutlet UITextField *timeTextField;
@property (weak, nonatomic) IBOutlet UITextField *goodsWeightTextField;
@property (weak, nonatomic) IBOutlet UIButton *danweiBtn;

@property (weak, nonatomic) IBOutlet UITextField *goodsSqureTextField;
@property (weak, nonatomic) IBOutlet UIButton *shangmenQuhuoBtn;
@property (weak, nonatomic) IBOutlet UIButton *songhuoShangmenBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnRightConstraint;

@property (nonatomic,copy) Block block;
@end
