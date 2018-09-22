//
//  HuoWuInfoView.m
//  iwant
//
//  Created by 公司 on 2016/12/7.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "HuoWuInfoView.h"

@implementation HuoWuInfoView

- (void)setViewsWithModel:(Logist *)model{
    
    _toPlaceLabel.text = model.entPlace;
    _sendAddress.text = model.startPlace;
    _squareLabel.text = [NSString stringWithFormat:@"货物体积：%@方",model.cargoVolume];
    _goodsWeight.text = model.cargoWeight;
    _goodsValue.text =[NSString stringWithFormat:@"货物价值：%@元" ,model.cargoCost];
    _goodsName.text = model.cargoName;

    _quhuolabel.text = model.takeCargo ? @"上门取货：是" : @"上门取货：否";
    _songhuoLabel.text = model.sendCargo ? @"送货上门：是" : @"送货上门：否";
    _sendTimeLabel.text = [NSString stringWithFormat:@"发货时间%@",model.takeTime];
    _arriveTimeLabel.text = [NSString stringWithFormat:@"送达时间%@",model.arriveTime];
    _beizhuMessage.text = model.remark;

}

@end
