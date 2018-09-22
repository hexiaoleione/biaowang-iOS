//
//  CargodetailView.m
//  iwant
//
//  Created by 公司 on 2017/2/20.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "CargodetailView.h"
@implementation CargodetailView

-(void)setModel:(ShunFengBiaoShi *)model{
    self.timeLable.text = [NSString stringWithFormat:@"发布时间:%@",model.publishTime];
    self.replacerMoneyLabel.text = [NSString stringWithFormat:@"代收货款:%@元",model.replaceMoney];
    self.fromAdress.text =model.address;
    self.toAdress.text = model.addressTo;
    self.nameLabel.text = [NSString stringWithFormat:@"货物:%@",model.matName];
    self.moneyLabel.text = [NSString stringWithFormat:@"金额:%@元",model.transferMoney];
    self.weightLabel.text =[NSString stringWithFormat:@"重量:%@kg", model.matWeight];
}
@end
