//
//  DaiShouKuanAlert.m
//  iwant
//
//  Created by 公司 on 2017/2/20.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "DaiShouKuanAlert.h"

@implementation DaiShouKuanAlert

-(void)awakeFromNib{
    [super awakeFromNib];
    self.noticeView.layer.cornerRadius = 10;
    self.noticeView.layer.masksToBounds = YES;
    self.sureBtn.layer.cornerRadius = 15;
    self.sureBtn.layer.masksToBounds = YES;
    
}
-(void)show{
    
    self.frame = [UIApplication sharedApplication].windows.lastObject.bounds;
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];

}
-(void)dismiss{
    [UIView animateWithDuration:0.3 animations:^{
        self.y = SCREEN_HEIGHT;
      } completion:^(BOOL finished) {
         [self removeFromSuperview];
    }];
   
}
- (IBAction)cancel:(UIButton *)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.y = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
