//
//  LuxianTableViewCell.m
//  iwant
//
//  Created by dongba on 16/9/1.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "LuxianTableViewCell.h"

@implementation LuxianTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)delete:(id)sender {
    if (_block) {
        _block(nil);
    }
}

@end
