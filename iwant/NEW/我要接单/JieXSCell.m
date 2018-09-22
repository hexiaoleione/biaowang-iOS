//
//  JieXSCell.m
//  iwant
//
//  Created by 公司 on 2017/6/9.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "JieXSCell.h"
#import "MainHeader.h"
@implementation JieXSCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.topConstraint.constant = 8*RATIO_HEIGHT;
    self.start.font = FONT(14, NO);
    self.end.font = FONT(14, NO);
    self.matWeight.font = FONT(14, NO);
    self.startLabel.textColor = [UIColor blackColor];
    self.endLabel.textColor = [UIColor blackColor];
    self.startLabel.font = FONT(14, NO);
    self.endLabel.font = FONT(14, NO);
    self.limitTimeL.font = FONT(14, NO);
    self.yunMoneyL.font = FONT(14, YES);
    self.replaceMoneyL.font = FONT(14, NO);
    self.distanceL.font = FONT(14, NO);
    self.guiGeL.font = FONT(14, NO);
    self.remarkL.font = FONT(14, NO);
    self.jianshuL.font = FONT(14, NO);
    self.matName.font = FONT(14, NO);
}

- (void)setModel:(ShunFengBiaoShi *)model{
    self.limitTimeL.text = [NSString stringWithFormat:@"要求到达时间：%@",model.limitTime];
    if (model.ifReplaceMoney) {
        self.replaceMoneyL.text = [NSString stringWithFormat:@"代收款：%@元",model.replaceMoney];
    }else{
        self.replaceMoneyL.text = @"";
    }
    if ([model.status intValue]!=1) {
        self.statusImg.hidden = NO;
        self.jieBtn.hidden = YES;
        self.phoneBtn.hidden = YES;
    }
    
    self.matName.text = [NSString stringWithFormat:@"物品名称：%@",model.matName];
    
    if (model.matVolume.length == 0) {
        self.guiGeL.text = [NSString stringWithFormat:@"要求车型：无要求"];
    }else{
        self.guiGeL.text = [NSString stringWithFormat:@"要求车型：%@",model.matVolume];
    }
    
    if ([model.matWeight intValue]==5) {
        self.matWeight.text = [NSString stringWithFormat:@"总重量：≤5公斤"];
    }else{
        self.matWeight.text = [NSString stringWithFormat:@"总重量：%@公斤",model.matWeight];
    }
    if (model.cargoSize.length == 0) {
        self.jianshuL.text = @"";
    }else{
        self.jianshuL.text = [NSString stringWithFormat:@"件数：%@件",model.cargoSize];
    }
    self.startLabel.text =[NSString stringWithFormat:@"%@",model.address];
    self.endLabel.text =[NSString stringWithFormat:@"%@", model.addressTo];
    self.yunMoneyL.text = [NSString stringWithFormat:@"运费：%.2f元",[model.transferMoney doubleValue]];
    self.distanceL.text = [NSString stringWithFormat:@"运送距离：大约%.2f公里",[model.distance floatValue]/1000];
    if (model.matRemark.length == 0) {
        self.remarkL.text = @"";
    }else{
    self.remarkL.text = [NSString stringWithFormat:@"备注：%@。若因此产生额外费用，请提前协商！",model.matRemark];
    }
    self.sendPersonPhone = model.mobile;
}
- (IBAction)danghangBtn:(UIButton *)sender {
    if (_Block) {
        _Block(0);
    }
}
- (IBAction)jiedanBtn:(UIButton *)sender {
    if (_Block) {
        _Block(1);
    }
}

- (IBAction)phoneBtn:(UIButton *)sender {
    [Utils callAction:self.sendPersonPhone];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
