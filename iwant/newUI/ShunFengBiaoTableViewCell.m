//
//  ShunFengBiaoTableViewCell.m
//  iwant
//
//  Created by 公司 on 2017/2/15.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "ShunFengBiaoTableViewCell.h"
#import "MainHeader.h"

@implementation ShunFengBiaoTableViewCell


-(void)setModel:(ShunFengBiaoShi *)model{
   
    
    _publishTime.text = model.publishTime;
    _replaceMoney.text = model.ifReplaceMoney? [NSString stringWithFormat:@"代收款：%@元",model.replaceMoney]:@"";
    _matName.text = [NSString stringWithFormat:@"物品名称:%@",model.matName];
    _address.text =[NSString stringWithFormat:@"起始地:%@", model.address];
    
    _addressTo.text = [NSString stringWithFormat:@"目的地:%@", model.addressTo];
    _disTance.text = [NSString stringWithFormat:@"距离：%0.2f Km",[model.distance floatValue]/1000];
    
    _transforeMoney.text = [NSString stringWithFormat:@"镖费:%0.2f元", [model.transferMoney doubleValue]];
    _useTimeLabel.font = FONT(12, NO);
    _useTimeLabel.text = model.useTime.length ? [NSString stringWithFormat:@"取货时间：%@",model.useTime] :@"";
    if ([model.carLength intValue] == 1 || [model.carLength isEqualToString:@""]) {
        _carLengthL.text = @"车长要求：无";
        [_matImage setImage:[UIImage imageNamed:@"SFImg"]];
    }else if ([model.carLength intValue] == 2){
        _carLengthL.text = [NSString stringWithFormat:@"车长要求：1.8米"];
        [_matImage setImage:[UIImage imageNamed:@"carLength2"]];
    }else if([model.carLength intValue] == 3){
        _carLengthL.text = [NSString stringWithFormat:@"车长要求：2.7米"];
        [_matImage setImage:[UIImage imageNamed:@"carLength3"]];
    }else if([model.carLength intValue] == 4){
        _carLengthL.text = [NSString stringWithFormat:@"车长要求：4.2米"];
        [_matImage setImage:[UIImage imageNamed:@"carLength4"]];
    }
//    if (model.matRemark.length != 0 ) {
//        _remarkL.text = [NSString stringWithFormat:@"备注：%@",model.matRemark];
//    }else{
//        _remarkL.text = @"";
//        self.height -= 20;
//    }
    
    if (model.matVolume.length == 0) {
        _matVolumeL.hidden = YES;
        _matVolumeL.text = @"";
        _valumeTopConstraint.constant = 0.0;
    }else if([model.matVolume intValue] == 0){
        _matVolumeL.text = [NSString stringWithFormat:@"体积：1立方米以下"];
    }else{
     _matVolumeL.text = [NSString stringWithFormat:@"体积：%@",model.matVolume];
    }
    
    if ([model.status intValue]!=1) {
        self.statusLabel.hidden = NO;
    }
    
    if (model.limitTime && ![model.limitTime isEqualToString:@""]) {
        [_matImage setImage:[UIImage imageNamed:@"XSImg"]];

        _limitTime.hidden = NO;
        _matVolumeL.hidden = YES;
        _carLengthL.hidden = YES;
        _useTimeLabel.hidden = YES;
        [_limitTime setTitle:[NSString stringWithFormat:@"限定到达时间：%@",[model.limitTime substringFromIndex:5]] forState:UIControlStateNormal];
        if (model.matRemark.length != 0 ) {
            _remarkL.text = [NSString stringWithFormat:@"备注：%@",model.matRemark];
        }else{
            _remarkL.text = @"";
            self.height -= 20;
        }

    }else{
        if (model.matRemark.length != 0 ) {
            _remarkL.text = [NSString stringWithFormat:@"备注：%@",model.matRemark];
        }else{
            _remarkL.text = @"";
            self.height -= 20;
        }
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
