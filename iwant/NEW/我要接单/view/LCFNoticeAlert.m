//
//  LCFNoticeAlert.m
//  iwant
//
//  Created by 公司 on 2017/7/13.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "LCFNoticeAlert.h"

@implementation LCFNoticeAlert


-(void)awakeFromNib{
    [super awakeFromNib];
    self.noticView.layer.cornerRadius = 5.0;
    self.noticView.layer.masksToBounds = YES;
}
-(void)show{
//    self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
//    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.frame = [UIApplication sharedApplication].windows.lastObject.bounds;
    self.y = SCREEN_HEIGHT;
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    [self fadeIn];
}

-(void)dismiss{
    [self fadeOut];
}
- (IBAction)btnClick:(UIButton *)sender {
    if (_Block) {
        _Block(sender.tag);
    }
}

//弹入层
- (void)fadeIn
{
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
        self.y = 0;
    }];
}
//弹出层
- (void)fadeOut
{
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 0.0;
        self.y = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
            [self removeFromSuperview];
        }
    }];
}

@end
