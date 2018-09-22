//
//  GoodsInfoView.m
//  iwant
//
//  Created by 公司 on 2016/12/22.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "GoodsInfoView.h"

@implementation GoodsInfoView

- (void)setViewsWithModel:(Logist *)model{
 
    _goodsName.text = [NSString stringWithFormat:@"货物名称：%@",model.cargoName];
    _startAdress.text = [NSString stringWithFormat:@"%@",model.startPlace];
    _endAdress.text = [NSString stringWithFormat:@"%@",model.entPlace];
    _endTime.text = [NSString stringWithFormat:@"到达时间：%@",model.arriveTime];
    _goodsWeight.text = [NSString stringWithFormat:@"货物重量：%@",model.cargoWeight];
    _goodsSqure.text = [NSString  stringWithFormat:@"%@方",model.cargoVolume];
    _sendName.text = [NSString stringWithFormat:@"发件人：%@   %@",model.sendPerson,model.sendPhone];
    if (model.cargoNumber.length == 0) {
        _cargoNumberLabel.text = @"";
    }else{
    _cargoNumberLabel.text = [NSString stringWithFormat:@"件数：%@件",model.cargoNumber];
    }
    if (model.appontSpace.length == 0) {
        self.YuanQuLabel.text = @"";
        self.height -=  16;
        self.YanQuTopDistance.constant = 0;
    }else{
        self.YuanQuLabel.text = [NSString stringWithFormat:@"指定园区:%@",model.appontSpace];
    }
    //用户没有必要看到发件人（自己的信息）  所以选择隐藏
    if (model.sendPerson.length == 0 || model.sendPhone.length==0) {
        _sendName.hidden = YES;
        self.distanceConstraint.constant = 0;
        self.heightContraint.constant = 0;
    }

    _receiveName.text = [NSString stringWithFormat:@"收件人：%@   %@",model.takeName,model.takeMobile];
    _quhuoLabel.text = model.takeCargo ? @"物流公司上门取货" : @"发货人送到货场";
    _songhuoLabel.text = model.sendCargo ? @"物流公司送货上门" : @"收货人自提";
}

@end
