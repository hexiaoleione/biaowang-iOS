//
//  matView.h
//  iwant
//
//  Created by dongba on 16/7/21.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMHeaderView.h"
typedef void (^Block) (int tag);
@interface matView : UIView
@property (weak, nonatomic) IBOutlet UITextField *receiveTime;
@property (weak, nonatomic) IBOutlet YMHeaderView *matImg;
@property (weak, nonatomic) IBOutlet UITextField *matName;
@property (weak, nonatomic) IBOutlet UITextField *matWeight;
@property (weak, nonatomic) IBOutlet UITextField *matLength;//长
@property (weak, nonatomic) IBOutlet UITextField *matWidth; //宽
@property (weak, nonatomic) IBOutlet UITextField *matHeight; //高
@property (weak, nonatomic) IBOutlet UIImageView *matLengthImage;
@property (weak, nonatomic) IBOutlet UITextField *matLengthDanWei;
@property (weak, nonatomic) IBOutlet UIImageView *matWidthimage;
@property (weak, nonatomic) IBOutlet UITextField *matWidthDanWei;
@property (weak, nonatomic) IBOutlet UIImageView *matHeightImage;
@property (weak, nonatomic) IBOutlet UITextField *matHeightDanwei;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *matLengthHeightConstraint;  //高的约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topToConstraint;//距离上边的约束

@property (weak, nonatomic) IBOutlet UIButton *pickTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *ifTouBaoBtn;

@property (weak, nonatomic) IBOutlet UITextField *baojiaField;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *checkBox;
@property (weak, nonatomic) IBOutlet UILabel *needSpecialLabel; //是否需要大型货车运输label

@property (weak, nonatomic) IBOutlet UIButton *ifNeedSpecial;//是否需要大型车运输
@property (weak, nonatomic) IBOutlet UILabel *noticeLabel; //提醒填写尺寸label

@property (weak, nonatomic) IBOutlet UIView *line4;

@property (copy, nonatomic)  Block block;

@end
