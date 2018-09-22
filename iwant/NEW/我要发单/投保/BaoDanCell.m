//
//  BaoDanCell.m
//  iwant
//
//  Created by 公司 on 2017/10/12.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "BaoDanCell.h"

@implementation BaoDanCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(Logist *)model{
    self.nameLabel.text = [NSString stringWithFormat:@"物品名称：%@",model.cargoName];
    [self.destationLabel setTextColor:[UIColor blackColor]];
    [self.destationLabel setFont:[UIFont systemFontOfSize:14]];
    self.destationLabel.text = [NSString stringWithFormat:@"%@",model.entPlace];
    self.receiveNameLabel.text = [NSString stringWithFormat:@"收件人：%@",model.takeName];
    self.phoneLabel.text = [NSString stringWithFormat:@"联系电话：%@",model.takeMobile];
    self.timeLabel.text = [NSString stringWithFormat:@"%@",model.publishTime];
    self.moneyLabel.text =[NSString stringWithFormat:@"%@元", model.insureCost];
    self.centerBtn.tag = [model.status integerValue];
    if ([model.status intValue] == 11) {
        [self.imgViewBg setImage:[UIImage imageNamed:@"daifuBg"]];
        [self.centerBtn setImage:[UIImage imageNamed:@"toubaoDaiFu"] forState:UIControlStateNormal];
        [self.timeLabel setTextColor:[UIColor blackColor]];
    }else{
        [self.imgViewBg setImage:[UIImage imageNamed:@"shengxiaoBg"]];
        [self.centerBtn setImage:[UIImage imageNamed:@"toubaoDownLoad"] forState:UIControlStateNormal];
        [self.timeLabel setTextColor:[UIColor whiteColor]];
    }
}

- (IBAction)centerBtnClick:(UIButton *)sender {
    if (_Block) {
        _Block(sender.tag);
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
