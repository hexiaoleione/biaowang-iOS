//
//  GoodsInfoView.h
//  iwant
//
//  Created by 公司 on 2016/12/22.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Logist.h"
@interface GoodsInfoView : UIView
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *startAdress;
@property (weak, nonatomic) IBOutlet UILabel *endAdress;
@property (weak, nonatomic) IBOutlet UILabel *endTime;
@property (weak, nonatomic) IBOutlet UILabel *goodsWeight;
@property (weak, nonatomic) IBOutlet UILabel *goodsSqure;
@property (weak, nonatomic) IBOutlet UILabel *quhuoLabel;
@property (weak, nonatomic) IBOutlet UILabel *songhuoLabel;
@property (weak, nonatomic) IBOutlet UILabel *sendName;
@property (weak, nonatomic) IBOutlet UILabel *receiveName;
@property (weak, nonatomic) IBOutlet UILabel *cargoNumberLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *YanQuTopDistance;

@property (weak, nonatomic) IBOutlet UILabel *YuanQuLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *distanceConstraint; //发件人top距离约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightContraint;//发件人高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightReceiveContraint;//收件人高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *distanceReceiveContraint;//收件人距离top距离

- (void)setViewsWithModel:(Logist *)model;
@end
