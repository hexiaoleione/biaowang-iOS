//
//  companyInfoView.m
//  iwant
//
//  Created by 公司 on 2016/11/29.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "companyInfoView.h"

@implementation companyInfoView

-(void)setViewsWithModel:(Baojia *)model{

    _companyImagevIew.layer.cornerRadius = 2;
    _companyImagevIew.clipsToBounds = YES;
    [_companyImagevIew sd_setImageWithURL:[NSURL URLWithString:model.matImageUrl] placeholderImage:[UIImage imageNamed:@"tu.png"]];
    _companyName.text =[NSString stringWithFormat:@"运货方：%@", model.companyName];
    _totolTransforMoney.text = [NSString stringWithFormat:@"总价：%@元",model.transferMoney];
    _yunfei.text =[NSString stringWithFormat:@"运费：%@元",model.cargoTotal ];
    _quhuoFree.text =[NSString stringWithFormat:@"上门取货：%@元", model.takeCargoMoney];
    _songhuoFree.text = [NSString stringWithFormat:@"送货上门：%@元", model.sendCargoMoney];
    //货场地址
    _companyAdress.text = model.yardAddress;
    _telNumLabel.text = [NSString stringWithFormat:@"联系方式：%@",model.companyMobile];
    //报价时间
    _baojiaTimeLLabel.text = model.reportTime;
    _beizhuLabel.text = [NSString stringWithFormat:@"留言：%@",model.luMessage];
    
 }





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
