//
//  HuoWuInfoView.h
//  iwant
//
//  Created by 公司 on 2016/12/7.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Logist.h"
@interface HuoWuInfoView : UIView
@property (weak, nonatomic) IBOutlet UILabel *toPlaceLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsWeight;
@property (weak, nonatomic) IBOutlet UILabel *squareLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *goodsValue;
@property (weak, nonatomic) IBOutlet UILabel *quhuolabel; //上门取货
@property (weak, nonatomic) IBOutlet UILabel *songhuoLabel;

@property (weak, nonatomic) IBOutlet UILabel *sendTimeLabel;  // 发货时间
@property (weak, nonatomic) IBOutlet UILabel *arriveTimeLabel;  //到达时间
@property (weak, nonatomic) IBOutlet UILabel *sendAddress;   //发货地
@property (weak, nonatomic) IBOutlet UILabel *beizhuMessage;   //备注

- (void)setViewsWithModel:(Logist *)model;

@end
