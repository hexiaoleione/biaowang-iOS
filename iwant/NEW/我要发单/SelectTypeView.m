//
//  SelectTypeView.m
//  iwant
//
//  Created by 公司 on 2017/8/24.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "SelectTypeView.h"

@implementation SelectTypeView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.viewBg.layer.masksToBounds = YES;
    self.viewBg.layer.cornerRadius = 5.0;
    self.viewWidthConstraint.constant = 300*SCREEN_WIDTH/375.0;
    if (SCREEN_WIDTH == 320) {
        self.viewWidthConstraint.constant = 290;
    }
    self.topHeightConstraint.constant = 40*SCREEN_HEIGHT/667.0;
    self.distanceConstraint.constant = 35*SCREEN_HEIGHT/667;
}

- (IBAction)selectTypeBtn:(UIButton *)sender {
    if (_Block) {
        _Block(sender.tag);
    }
}

//背景消失按钮
- (IBAction)cancelBtnClick:(UIButton *)sender {
//    [UIView animateWithDuration:0.35 animations:^{
//        self.y = SCREEN_HEIGHT;
//    } completion:^(BOOL finished) {
//        [self removeFromSuperview];
//    }];
    [self removeFromSuperview];
}

@end
