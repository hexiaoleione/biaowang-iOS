//
//  GoodSourceTableViewCell.m
//  iwant
//
//  Created by dongba on 16/8/30.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "GoodSourceTableViewCell.h"

@implementation GoodSourceTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    self.myBaojia.layer.cornerRadius = 5;
    self.takePhotosBtn.layer.cornerRadius = 5;
    self.arriveBtn.layer.cornerRadius = 5;
}
- (IBAction)baojia:(id)sender {
    if (_block) {
        _block(sender);
    }
}
- (void)setViewsWithModel:(Logist *)model{
    _name.text = [NSString stringWithFormat:@"物品：%@",model.cargoName];
    _publishTime.text = [NSString stringWithFormat:@"%@",model.publishTime];
    _distance.text = [NSString stringWithFormat:@"距离我%@km",model.distance];
    _weight.text = [NSString stringWithFormat:@"重量：%@",model.cargoWeight];
    _tiji.text = [NSString stringWithFormat:@"体积：%@立方",model.cargoVolume];
    _startPlace.text = [NSString stringWithFormat:@"%@",model.startPlace];
    _endPlace.text = [NSString stringWithFormat:@"%@",model.entPlace];
    _ifSend.hidden = model.sendCargo ? NO : YES;
    _ifReceive.hidden = model.takeCargo ? NO : YES;
    
        self.backgroundColor = [UIColor whiteColor];
        self.topBg.hidden = NO;
        self.carImage.hidden = NO;
        self.bottomView.hidden = NO;
    //根据支付状态判定
    switch ([model.status intValue]) {
        case 3:
            //已拍照 发货
        {
            [_takePhotosBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            _distance.hidden = YES;
        }

            break;
            
        case 4:
            //货物到达
        {
            [_arriveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_takePhotosBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            _threePoint.image = [UIImage imageNamed:@"greenPoint"];
            _distance .hidden = YES;
        }
        case 5:
            //待评价
        {
           
        }
            
            
            break;
        default:
            break;
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
