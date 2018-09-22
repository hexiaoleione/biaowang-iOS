//
//  detailCompanyInfo.m
//  iwant
//
//  Created by 公司 on 2017/1/10.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "detailCompanyInfo.h"
@implementation detailCompanyInfo

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
    _baojiaTimeLLabel.text = [NSString stringWithFormat:@"报价时间：%@",model.reportTime];
    _beizhuLabel.text = [NSString stringWithFormat:@"留言：%@",model.luMessage];
    
}


@end
