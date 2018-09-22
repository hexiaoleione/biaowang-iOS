//
//  RoleExplainView.m
//  RoleAuthentication
//
//  Created by 公司 on 2017/2/27.
//  Copyright © 2017年 lcf. All rights reserved.
//

#import "RoleExplainView.h"
#import "MainHeader.h"
@implementation RoleExplainView
-(void)awakeFromNib{
    [super awakeFromNib];
    self.view.layer.cornerRadius = 8.0;
    self.view.layer.masksToBounds = YES;
    self.guanbiBtn.layer.cornerRadius = 5.0;
    self.guanbiBtn.backgroundColor = COLOR_MainColor;
    self.layer.masksToBounds = YES;
}

- (IBAction)guanbiBtn:(UIButton *)sender {
    //关闭
    [UIView animateWithDuration:0.3 animations:^{
        self.y = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)show{
    [UIView animateWithDuration:0.3 animations:^{
        self.y = 0;
    } completion:^(BOOL finished) {
        self.frame = [UIApplication sharedApplication].windows.lastObject.bounds;
        [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    }];
}
-(void)dismiss{
    [UIView animateWithDuration:0.3 animations:^{
        self.y = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
