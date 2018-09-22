//
//  JieWLCell.m
//  iwant
//
//  Created by 公司 on 2017/6/5.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "JieWLCell.h"
#import "MainHeader.h"
@implementation JieWLCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.weight.font = FONT(14, NO);
    self.matWeightL.font = FONT(14, NO);
    self.endPlace.font = FONT(14, NO);
    self.timeL.font = FONT(14, NO);
    self.matNameL.font = FONT(14, NO);
    self.destinationL.font = FONT(14, NO);
    self.guiGeL.font = FONT(14, NO);
    self.takeCargoL.font = FONT(14, NO);
    self.sendCargoL.font = FONT(14, NO);
    self.specialNeedL.font = FONT(14, NO);
    self.btnHeightConstraint.constant = 30*RATIO_HEIGHT;
    self.btnWidthConstraint.constant = 100*RATIO_WIDTH;
    self.destinationL.textColor = [UIColor blackColor];
}

- (void)setModel:(Logist *)model{
    self.timeL.text = [NSString stringWithFormat:@"要求到达时间：%@",model.arriveTime];
    self.destinationL.text = model.endPlaceName.length ? model.endPlaceName: model.entPlace;
    self.matNameL.text =[NSString stringWithFormat:@"物品名称：%@",model.cargoName];
    
    self.matWeightL.text = [NSString stringWithFormat:@"总重量：%@",model.cargoWeight];
    if ([model.carType isEqualToString:@"cold"]) {
        self.specialNeedL.hidden = NO;
        self.specialNeedL.text = [NSString stringWithFormat:@"需求:%@",model.carName];
    }
    self.guiGeL.text = [NSString stringWithFormat:@"总体积：%@",model.cargoVolume];
    //温度要求的问题
    if ([model.carType isEqualToString:@"cold"]) {
        self.takeCargoL.text = [NSString stringWithFormat:@"温度要求：%@",model.tem];
        self.sendCargoL.hidden = YES;
    }else{
       self.takeCargoL.text = model.takeCargo?@"物流公司上门取货":@"发货人送到货场";
       self.sendCargoL.text = model.sendCargo ? @"物流公司送货上门":@"收货人自提";
    }
    if (model.ifQuotion) {
        [self.quotionBtn setTitle:@"修改报价" forState:UIControlStateNormal];
    }else{
        [self.quotionBtn setTitle:@"报  价" forState:UIControlStateNormal];
    }
}

- (IBAction)baojiaBtnClick:(UIButton *)sender {
    if (_Block) {
        _Block(0);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
