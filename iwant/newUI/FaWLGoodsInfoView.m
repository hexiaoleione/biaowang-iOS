//
//  FaWLGoodsInfoView.m
//  iwant
//
//  Created by 公司 on 2017/2/14.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "FaWLGoodsInfoView.h"
#import "MainHeader.h"
@implementation FaWLGoodsInfoView
-(void)awakeFromNib{
    [super awakeFromNib];
    if (SCREEN_WIDTH == 320) {
        self.btnLeftConstraint.constant = 44.0;
        self.btnRightConstraint.constant = 44.0;
    }
    self.backgroundColor = BACKGROUND_COLOR;
    
    self.goodsInfoView.layer.cornerRadius = 5;
    self.goodsInfoView.layer.borderColor = [UIColorFromRGB(0xf5f5f5) CGColor];
    self.goodsInfoView.layer.borderWidth = 1;
    self.goodsInfoView.layer.masksToBounds = YES;
    
}

- (IBAction)timeSelect:(UIButton *)sender {
    //选择到达时间
    if (_block) {
        _block(1);
    }
}

- (IBAction)danweiBtn:(UIButton *)sender {
    //单位选择
    if (_block) {
        _block(2);
    }

}
- (IBAction)shangmenQuhuo:(UIButton *)sender {
    //上门取货btn
    if (_block) {
        _block(3);
    }
    sender.selected = !sender.selected;
    if (sender.selected) {
        [sender setImage:[UIImage imageNamed:@"toubaoxuanzhongLmg"] forState:UIControlStateNormal];
    }else{
        [sender setImage:[UIImage imageNamed:@"toubaokuangLmg"] forState:UIControlStateNormal];
    }
}

- (IBAction)yonghuziti:(UIButton *)sender {
    //用户自提
    if (_block) {
        _block(4);
    }
    sender.selected = !sender.selected;
    if (sender.selected) {
        [sender setImage:[UIImage imageNamed:@"toubaoxuanzhongLmg"] forState:UIControlStateNormal];
    }else{
        [sender setImage:[UIImage imageNamed:@"toubaokuangLmg"] forState:UIControlStateNormal];
    }
}
- (IBAction)shangyibuClick:(UIButton *)sender {
   //上一步
    if (_block) {
        _block(5);
    }
}

- (IBAction)makeSureFaBu:(UIButton *)sender {
   //确认发布
    if (_block) {
        _block(6);
    }
}

@end
