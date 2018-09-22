//
//  WeiJiaoFeiCell.m
//  iwant
//
//  Created by 公司 on 2017/2/27.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "WeiJiaoFeiCell.h"
#import "MainHeader.h"
@implementation WeiJiaoFeiCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.jiaofeiBtn.layer.cornerRadius = 5;
    self.jiaofeiBtn.layer.masksToBounds = YES;
    self.jiaofeiBtn.backgroundColor = COLOR_PurpleColor;
}

-(void)setModel:(Logist *)model{
    self.timeLabel.text = [NSString stringWithFormat:@"要求到达时间：%@",model.arriveTime];
    self.endPlace.text = model.entPlace;
    self.nameLabel.text = [NSString stringWithFormat:@"物品名称：%@",model.cargoName];
}
- (IBAction)jiaofeiBtn:(UIButton *)sender {
    if (_block) {
        _block(sender);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
