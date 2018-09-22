//
//  MyKuaiDICell.m
//  iwant
//
//  Created by 公司 on 2017/2/22.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "MyKuaiDICell.h"

@implementation MyKuaiDICell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.cornerRadius = 8.0;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 0.3;
    self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
