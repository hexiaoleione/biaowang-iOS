//
//  CompanyOrderView.h
//  iwant
//
//  Created by dongba on 16/9/18.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Logist.h"
@interface CompanyOrderView : UIView

@property (weak, nonatomic) IBOutlet UILabel *destination;   //目的地
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet UILabel *squareLabel;

@property (weak, nonatomic) IBOutlet UILabel *goodsName;

@property (weak, nonatomic) IBOutlet UILabel *goodsValue;

@property (weak, nonatomic) IBOutlet UILabel *quhuolabel; //上门取货
@property (weak, nonatomic) IBOutlet UILabel *zitiLabel;   //用户自提
@property (weak, nonatomic) IBOutlet UILabel *sendTimeLabel;  // 发货时间
@property (weak, nonatomic) IBOutlet UILabel *arriveTimeLabel;  //到达时间
@property (weak, nonatomic) IBOutlet UILabel *sendAddress;   //发货地
@property (weak, nonatomic) IBOutlet UILabel *receiveName;   //收件人姓名
@property (weak, nonatomic) IBOutlet UILabel *telNum; //电话
@property (weak, nonatomic) IBOutlet UILabel *sendName;//发件人姓名
@property (weak, nonatomic) IBOutlet UILabel *sendTelNum; //发件人的电话

@property (weak, nonatomic) IBOutlet UILabel *beizhuMessage;   //备注


- (void)setViewsWithModel:(Logist *)model;
@end
