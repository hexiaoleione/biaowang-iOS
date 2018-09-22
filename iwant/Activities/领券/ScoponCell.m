//
//  ScoponCell.m
//  iwant
//
//  Created by 公司 on 2017/4/19.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "ScoponCell.h"
#import "MainHeader.h"
@implementation ScoponCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.couponName.font = FONT(30, YES);
    self.couponFrom.font = FONT(15, NO);
    self.couponLabel.font = FONT(12, NO);
    self.countLabel.font = FONT(15, NO);
    self.ReceiveBtn.titleLabel.font = FONT(15, NO);
}
- (IBAction)receiveBtnClick:(UIButton *)sender {
    if (_Block) {
        _Block();
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
