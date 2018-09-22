//
//  FinishDetailView.m
//  iwant
//
//  Created by 公司 on 2017/6/23.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "FinishDetailView.h"
#import "MainHeader.h"
@implementation FinishDetailView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.nameL.font = FONT(14, NO);
    self.limitTimeL.font = FONT(14, NO);
    self.guiGeL.font = FONT(14, NO);
    self.sizeL.font = FONT(14, NO);
    self.takeCargoL.font = FONT(14, NO);
    self.sendCargoL.font = FONT(14, NO);
    self.sendNameL.font = FONT(14, NO);
    self.sendPhoneL.font = FONT(14, NO);
    self.arriveNameL.font = FONT(14, NO);
    self.arrivePhoneL.font = FONT(14, NO);
    self.start.font = FONT(14, NO);
    self.end.font = FONT(14, NO);
    self.startL.font = FONT(14, NO);
    self.endL.font = FONT(14, NO);
    self.noticeL.font = FONT(17, NO);
    self.companyNameL.font = FONT(14, NO);
    self.huochangL.font = FONT(14, NO);
    self.baijia.font = FONT(14, NO);
    self.weightL.font = FONT(14, NO);
    self.quL.font = FONT(14, NO);
    self.quqFree.font = FONT(14, NO);
    self.quDanwei.font = FONT(14, NO);
    self.songL.font = FONT(14, NO);
    self.songFree.font = FONT(14, NO);
    self.songDanwei.font = FONT(14, NO);
    self.yunfeiL.font = FONT(14, NO);
    self.yunfeiFree.font = FONT(14, NO);
    self.yunfeiYuan.font = FONT(14, NO);
    self.hejiL.font = FONT(14, NO);
    self.hejiDanwei.font = FONT(14, NO);
    self.totolFree.font = FONT(14, NO);
    self.messgaeL.font = FONT(14, NO);
    self.telNumLabel.font = FONT(14, NO);
    self.baoxianType.font = FONT(14, NO);
    self.goodsType.font = FONT(14, NO);
    self.goodValueL.font = FONT(14, NO);
    self.specialNeedL.font = FONT(14, NO);
    
    self.goOnBtn.layer.cornerRadius = 5;
    self.goOnBtn.layer.masksToBounds = YES;
    self.selectAgainBtn.layer.cornerRadius = 5;
    self.selectAgainBtn.layer.masksToBounds =YES;
}

-(void)setViewsWithLogistModel:(Logist *)model withBaojiaModel:(Baojia *)baojiaModel{
    self.nameL.text = [NSString stringWithFormat:@"物品名称：%@",model.cargoName];
    self.limitTimeL.text = [NSString stringWithFormat:@"要求到达时间：%@",model.arriveTime];
    self.guiGeL.text = [NSString stringWithFormat:@"总体积：%@",model.cargoVolume];
    if ([model.carType isEqualToString:@"cold"]) {
        self.specialNeedL.hidden = NO;
        self.specialNeedL.text = [NSString stringWithFormat:@"需求：%@",model.carName];
    }
    
    self.weightL.text = [NSString stringWithFormat:@"总重量：%@",model.cargoWeight];
    self.sizeL.text = [NSString stringWithFormat:@"件数：%@件",model.cargoSize];
    //温度要求问题
    if ([model.carType isEqualToString:@"cold"]) {
        self.takeCargoL.text = [NSString stringWithFormat:@"温度要求：%@",model.tem];
        self.sendCargoL.hidden  = YES;
    }else{
        self.takeCargoL.text = model.takeCargo ?@"物流公司上门取货":@"发件人送到货场";
        self.sendCargoL.text = model.sendCargo ?@"物流公司送货上门":@"收件人自提";
    }

    self.startL.text = model.startPlace;
    self.endL.text = model.entPlace;
    self.sendNameL.text = [NSString stringWithFormat:@"发件人：%@",model.sendPerson];
    self.sendPhoneL.text = [NSString stringWithFormat:@"电话：%@",model.sendPhone];
    self.arriveNameL.text = [NSString stringWithFormat:@"收件人：%@",model.takeName];
    self.arrivePhoneL.text = [NSString stringWithFormat:@"电话：%@",model.takeMobile];
    
    int status = [model.status intValue];
    if (status ==2 ||status == 3 || status ==4 || status == 5 || status == 7 || status == 8) {
        if ([model.cargoCost intValue] == 0) {
            _goodValueL.text = @"";
            _disTopGoodsValueConstraint.constant = 0;
            _toubaoFree.text = @"";
            _disTopToubaoFreeConstraint.constant = 0;
            _goodsType.text = @"";
            self.baoxianType.hidden = YES;
            self.baoxianType.text = @"";
        }else{
            _goodValueL.text = [NSString stringWithFormat:@"货物价值：%@元",model.cargoCost];
            _toubaoFree.text =[NSString stringWithFormat:@"投保费用：%@元",model.insureCost];
            switch ([model.category intValue]) {
                case 1:
                    _goodsType.text = [NSString stringWithFormat:@"货物种类：常规货物"];
                    break;
                case 2:
                    _goodsType.text = [NSString stringWithFormat:@"货物种类：蔬菜"];
                    break;
                case 3:
                    _goodsType.text = [NSString stringWithFormat:@"货物种类：水果"];
                    break;
                case 4:
                    _goodsType.text = [NSString stringWithFormat:@"货物种类：牲畜及禽鱼"];
                    break;
                default:
                    break;
            }
            self.baoxianType.hidden = NO;
            if ([model.insurance isEqualToString:@"1"]) {
                self.baoxianType.text = [NSString stringWithFormat:@"承保类别：基本险"];
            }
            if([model.insurance isEqualToString:@"2"]){
               self.baoxianType.text = [NSString stringWithFormat:@"承保类别：综合险"];
            }
        }
    }
    if ([model.status intValue] == 7) {
        self.rightConstraint.constant =  (SCREEN_WIDTH-self.goOnBtn.width)/2;
        self.goOnBtn.hidden = NO;
    }
    self.companyNameL.text = [NSString stringWithFormat:@"名称：%@",baojiaModel.companyName];
    
    if (model.takeCargo) {
        self.huochangL.text = @"";
    }else{
        self.huochangL.text = [NSString stringWithFormat:@"货场地址：%@",baojiaModel.yardAddress];
    }
    //温度要求问题
    if ([model.carType isEqualToString:@"cold"]) {
        self.quL.text = @"运费";
        self.quqFree.text =[NSString stringWithFormat:@"%@",baojiaModel.cargoTotal];
        self.songL.text = @"合计";
        self.songFree.text = [NSString stringWithFormat:@"%@",baojiaModel.transferMoney];
        self.yunfeiL.hidden = YES;
        self.yunfeiFree.hidden = YES;
        self.yunfeiYuan.hidden = YES;
        self.hejiL.hidden = YES;
        self.hejiDanwei.hidden = YES;
        self.totolFree.hidden = YES;
    }else{
        
        self.quqFree.text = [NSString stringWithFormat:@"%@",baojiaModel.takeCargoMoney];
        self.songFree.text = [NSString stringWithFormat:@"%@",baojiaModel.sendCargoMoney];
        self.yunfeiFree.text = [NSString stringWithFormat:@"%@",baojiaModel.cargoTotal];
        self.totolFree.text =[NSString stringWithFormat:@"%@",baojiaModel.transferMoney];
    }

        self.messgaeL.text = [NSString stringWithFormat:@"留言：%@",baojiaModel.luMessage];
    self.telNumLabel.text = [NSString stringWithFormat:@"联系方式：%@",baojiaModel.companyMobile];
    
}
- (IBAction)btnClick:(UIButton *)sender {
    if (_Block) {
        _Block(sender.tag);
    }
}

@end
