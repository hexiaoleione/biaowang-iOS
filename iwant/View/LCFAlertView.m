//
//  LCFAlertView.m
//  iwant
//
//  Created by 公司 on 2016/11/15.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "LCFAlertView.h"
#import "UserNameViewController.h"
@implementation LCFAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)goToRZ:(UIButton *)sender {
//    UserNameViewController *userVC = [UserNameViewController new];
//                    userVC.courentbtnTag = 2;
//    [self.navigationController pushViewController:userVC animated:YES];
    [self removeFromSuperview];


}
- (IBAction)IKnow:(UIButton *)sender {
    [self removeFromSuperview];
}

@end
