//
//  CouponTableViewCell.m
//  iwant
//
//  Created by dongba on 16/10/17.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "CouponTableViewCell.h"
#import "Wallet.h"

@implementation CouponTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configModel:(Wallet *)model{
    _nameLabel.text =  model.couponName;
    _moneyLable.text = [NSString stringWithFormat:@"%@元",model.money];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
