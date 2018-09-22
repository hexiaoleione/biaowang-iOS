//
//  GoodsOfferTableViewCell.h
//  iwant
//
//  Created by 公司 on 2016/11/27.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CallBlock) (id sender);

@interface GoodsOfferTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel; //公司名
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel; //距离
@property (weak, nonatomic) IBOutlet UILabel *baojiaMoney;//报价
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;//货场地址
@property (weak, nonatomic) IBOutlet UIButton *dianhuaBtn;//打电话
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;//详情按钮
@property (weak, nonatomic) IBOutlet UILabel *baojiaL;  //报价金额四个字

@property (strong, nonatomic)  CallBlock block;

@end
