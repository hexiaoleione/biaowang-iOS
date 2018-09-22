//
//  DaiShouKuanAlert.h
//  iwant
//
//  Created by 公司 on 2017/2/20.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DaiShouKuanAlert : UIView
@property (weak, nonatomic) IBOutlet UIView *noticeView;

@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftDistanceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDistanceConstraint;

-(void)show;
-(void)dismiss;

@end
