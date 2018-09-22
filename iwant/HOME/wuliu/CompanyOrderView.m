//
//  CompanyOrderView.m
//  iwant
//
//  Created by dongba on 16/9/18.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "CompanyOrderView.h"

@implementation CompanyOrderView

- (void)setViewsWithModel:(Logist *)model{
    
    _destination.text = model.entPlace;
    _sendAddress.text = model.startPlace;
    _squareLabel.text = [NSString stringWithFormat:@"货物体积：%@方",model.cargoVolume];
    _weightLabel.text = model.cargoWeight;
    _goodsValue.text =[NSString stringWithFormat:@"货物价值：%@元" ,model.cargoCost];
    _goodsName.text = model.cargoName;
//    _quhuolabel.hidden = model.takeCargo ? NO :YES;
//    _zitiLabel.hidden =  model.sendCargo ? NO :YES;
    
    _quhuolabel.text = model.takeCargo ? @"上门取货：是" : @"上门取货：否";
    _zitiLabel.text = model.sendCargo ? @"送货上门：是" : @"送货上门：否";
    
    _receiveName.text = model.takeName;
    _telNum.text = [NSString stringWithFormat:@"联系方式:%@",model.takeMobile];
    _sendName.text = model.sendName;
    _sendTelNum.text = [NSString stringWithFormat:@"联系方式:%@",model.sendMobile];
    _beizhuMessage.text = model.remark;
    _sendTimeLabel.text = [NSString stringWithFormat:@"发货时间：%@",model.takeTime];
    _arriveTimeLabel.text = [NSString stringWithFormat:@"到达时间：%@",model.arriveTime];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
