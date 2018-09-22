//
//  ShaiXuanView.m
//  iwant
//
//  Created by 公司 on 2017/3/24.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "ScreenView.h"

@implementation ScreenView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.sureBtn.layer.cornerRadius = 15;
    self.sureBtn.layer.masksToBounds = YES;

}



-(void)showShaiXuanView{
    self.frame = [UIScreen mainScreen].bounds;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}


- (IBAction)sureBtnClick:(UIButton *)sender {
    if (_shaixuanBlock) {
        _shaixuanBlock();
    }
}


- (IBAction)cancelBtnClick:(UIButton *)sender {
    [self removeFromSuperview];
}

@end
