//
//  FindGoodsTableViewCell.m
//  iwant
//
//  Created by 公司 on 2016/11/28.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "FindGoodsTableViewCell.h"

@implementation FindGoodsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.detailBtn.layer.cornerRadius = 8;
    self.detailBtn.clipsToBounds = YES;
    self.detailBtn.backgroundColor = kUIColorFromRGBForBoard(0xfd7716);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//查看详情去报价
- (IBAction)goToDetail:(UIButton *)sender {
    if (_block) {
        _block(sender);
    }
}

@end
