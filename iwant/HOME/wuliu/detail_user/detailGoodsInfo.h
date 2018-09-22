//
//  detailGoodsInfo.h
//  iwant
//
//  Created by 公司 on 2017/1/10.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Logist.h"
@interface detailGoodsInfo : UIView
@property (weak, nonatomic) IBOutlet UILabel *arriveTime;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *goodsValue;
@property (weak, nonatomic) IBOutlet UILabel *startPlace;
@property (weak, nonatomic) IBOutlet UILabel *endPlace;
@property (weak, nonatomic) IBOutlet UILabel *goodsWeight;
@property (weak, nonatomic) IBOutlet UILabel *goodsSqure;
@property (weak, nonatomic) IBOutlet UILabel *quhuo;
@property (weak, nonatomic) IBOutlet UILabel *songhuo;
@property (weak, nonatomic) IBOutlet UILabel *toubaoFree;
@property (weak, nonatomic) IBOutlet UILabel *goodsType;  //货物种类
@property (weak, nonatomic) IBOutlet UILabel *baoxianLabel;//承险类别四个字

@property (weak, nonatomic) IBOutlet UILabel *baoxianType;  //承险类别
@property (weak, nonatomic) IBOutlet UILabel *YuanQuLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yuanquDisanceConstraint; //指定园区距上

@property (weak, nonatomic) IBOutlet UILabel *shouPerson;
@property (weak, nonatomic) IBOutlet UILabel *sendPerson;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *disTopGoodsValueConstraint;  //货物价值距上

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *disTopToubaoFreeConstraint; //投保费用距上

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *disTopgoodsTypeconstraint; //货物种类距上


- (void)setViewsWithModel:(Logist *)model;

@end
