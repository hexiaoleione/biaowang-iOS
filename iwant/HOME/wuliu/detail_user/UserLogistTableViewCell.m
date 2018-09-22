//
//  UserLogistTableViewCell.m
//  iwant
//
//  Created by 公司 on 2016/11/27.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "UserLogistTableViewCell.h"

@implementation UserLogistTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.endAdress.textColor = [UIColor blackColor];
    self.endAdress.font = [UIFont systemFontOfSize:13];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)cancelBtn:(UIButton *)sender {
    if (_block) {
        _block(sender);
    }
}


- (IBAction)seeDetail:(UIButton *)sender {
    if (_block) {
        _block(sender);
    }

}
- (IBAction)finishBtn:(UIButton *)sender {
    
    if (_block) {
        _block(sender);
    }
}
- (IBAction)lookDetail:(UIButton *)sender {
    if (_block) {
        _block(sender);
    }
}

@end
