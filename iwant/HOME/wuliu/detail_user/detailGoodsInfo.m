//
//  detailGoodsInfo.m
//  iwant
//
//  Created by 公司 on 2017/1/10.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "detailGoodsInfo.h"
#import "NSString+BLExtension.h"

@implementation detailGoodsInfo

-(void)awakeFromNib{
    [super awakeFromNib];
}

-(void)setViewsWithModel:(Logist *)model{
    self.height = 280;
    _arriveTime.text = [NSString stringWithFormat:@"到达时间：%@",model.arriveTime];
    _goodsName.text = [NSString stringWithFormat:@"货物名称：%@",model.cargoName];
    int status = [model.status intValue];
    if (status ==2 ||status == 3 || status ==4 || status == 5 || status == 7 || status == 8) {
        if ([model.cargoCost intValue] == 0) {
            _goodsValue.text = @"";
            _disTopGoodsValueConstraint.constant = 0;
            _toubaoFree.text = @"";
            _disTopToubaoFreeConstraint.constant = 0;
            _goodsType.text = @"";
            self.disTopgoodsTypeconstraint.constant = 0;
            self.baoxianLabel.hidden = YES;
            self.baoxianType.hidden = YES;
            
            self.height -= 75;
        }else{
        _goodsValue.text = [NSString stringWithFormat:@"货物价值：%@元",model.cargoCost];
        _toubaoFree.text =[NSString stringWithFormat:@"投保费用：%@元",model.insureCost];
        _goodsType.text = [NSString stringWithFormat:@"货物种类：%@",model.category];
            
        self.baoxianLabel.hidden = NO;
        self.baoxianType.hidden = NO;            
        self.baoxianType.text = [NSString stringWithFormat:@"%@",model.insurance];
        }
    }else{
    _goodsValue.text = @"";
    _disTopGoodsValueConstraint.constant = 0;
    _toubaoFree.text = @"";
    _disTopToubaoFreeConstraint.constant = 0;
    self.height -= 50;
    }
    if (model.appontSpace.length ==0) {
        _YuanQuLabel.text =@"";
        _yuanquDisanceConstraint.constant = 0;
        self.height -= 25;
    }else{
    _YuanQuLabel.text = [NSString stringWithFormat:@"指定园区：%@",model.appontSpace];
    }
    _startPlace.text = [NSString stringWithFormat:@"%@",model.startPlace];
    _endPlace.text = [NSString stringWithFormat:@"%@",model.entPlace];

    
    CGSize  size =  [_startPlace.text sizeWithFont:[UIFont systemFontOfSize:14] maxW:SCREEN_WIDTH - 77.5];
    NSLog(@"%f   %f",size.width,size.height);
    
    CGSize size1 = [_endPlace.text sizeWithFont:[UIFont systemFontOfSize:14] maxW:SCREEN_WIDTH-77.5];
    self.height += size.height+size1.height;
    
    _goodsWeight.text=[NSString stringWithFormat:@"货物重量：%@",model.cargoWeight];
    _goodsSqure.text = [NSString stringWithFormat:@"%@立方米",model.cargoVolume];
    _quhuo.text = model.takeCargo ? @"物流公司上门取货" : @"发货人送到货场";
    _songhuo.text = model.sendCargo ? @"物流公司送货上门" : @"收货人自提";
    _sendPerson.text = [NSString stringWithFormat:@"发件人：%@   %@",model.sendPerson,model.sendPhone];

    _shouPerson.text = [NSString stringWithFormat:@"收件人：%@   %@",model.takeName,model.takeMobile];

}

@end
