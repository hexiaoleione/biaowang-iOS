//
//  PublishWindThree.m
//  iwant
//
//  Created by 公司 on 2017/3/27.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "PublishWindThree.h"
#import "MainHeader.h"
#define ration 234/328
#define rationElse  352/242
@implementation PublishWindThree

-(void)awakeFromNib{
    [super awakeFromNib];
    self.goodsInfoView.layer.cornerRadius = 8.0;
    self.goodsInfoView.layer.masksToBounds = YES;
    
    self.titleLabel.textColor =UIColorFromRGB(0xff5b00);
    self.MiddleTruckBtn.backgroundColor =UIColorFromRGB(0xff5b00);;
    self.SmallTruckBtn.backgroundColor =UIColorFromRGB(0xff5b00);
    self.MiddleMinibusBtn.backgroundColor =UIColorFromRGB(0xff5b00);
    self.SmallMinibusBtn.backgroundColor =UIColorFromRGB(0xff5b00);
    
    self.MiddleTruckLabel.textColor = UIColorFromRGB(0xff5b00);
    self.smallMinBusLabel.textColor =  UIColorFromRGB(0xff5b00);
    self.MiddleMinibusLabel.textColor =  UIColorFromRGB(0xff5b00);
    self.SmallTruckLabel.textColor =  UIColorFromRGB(0xff5b00);
    
    self.MiddleMinibusBtn.layer.cornerRadius = 15;
    self.SmallTruckBtn.layer.cornerRadius = 15;
    self.MiddleTruckBtn.layer.cornerRadius = 15;
    self.SmallMinibusBtn.layer.cornerRadius = 15;

}
- (IBAction)cancelBtnClick:(UIButton *)sender {
    [UIView animateWithDuration:0.35 animations:^{
        self.y = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (IBAction)carTypeTwoClick:(UIButton *)sender {
    if (_BlockThree) {
        _BlockThree((int)sender.tag);
    }
}

@end
