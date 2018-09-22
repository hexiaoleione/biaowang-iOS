//
//  HuoChangAdressCell.m
//  iwant
//
//  Created by 公司 on 2017/1/4.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "HuoChangAdressCell.h"

@implementation HuoChangAdressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)editBtn:(UIButton *)sender {
    if (_block) {
        _block(sender);
    }

    
}
- (IBAction)setDefault:(UIButton *)sender {
//    [self.setDefaultBtn setImage:[UIImage imageNamed:@"defaultDone"] forState:0];
    if (_block) {
        _block(sender);
    }

}
- (IBAction)deleteBtn:(UIButton *)sender {
    if (_block) {
        _block(sender);
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
