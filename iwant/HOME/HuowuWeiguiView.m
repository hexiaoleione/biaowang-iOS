//
//  HuowuWeiguiView.m
//  iwant
//
//  Created by 公司 on 2017/1/16.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "HuowuWeiguiView.h"

@implementation HuowuWeiguiView

-(void)awakeFromNib{

    [super awakeFromNib];
    self.weiguiView.layer.cornerRadius = 8;
    self.weiguiView.clipsToBounds = YES;
}
- (IBAction)btnClick:(UIButton *)sender {
    if (_block) {
        _block(sender.tag);
    }
}
- (IBAction)guanbiBtn:(UIButton *)sender {
    [UIView animateWithDuration:.35 animations:^{
        self.y = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

@end
