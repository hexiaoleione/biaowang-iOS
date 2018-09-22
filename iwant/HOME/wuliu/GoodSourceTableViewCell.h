//
//  GoodSourceTableViewCell.h
//  iwant
//
//  Created by dongba on 16/8/30.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Logist.h"
typedef void (^ClickBlock) (id sender);

@interface GoodSourceTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *carImage;
@property (weak, nonatomic) IBOutlet UIImageView *topBg;
//我要报价按钮
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
//我的报价按钮
@property (weak, nonatomic) IBOutlet UIButton *myBaojia;
//中间按钮
@property (weak, nonatomic) IBOutlet UIButton *takePhotosBtn;
//到达按钮
@property (weak, nonatomic) IBOutlet UIButton *arriveBtn;

@property (weak, nonatomic) IBOutlet UIView *hidView;

@property (weak, nonatomic) IBOutlet UILabel *publishTime;
@property (weak, nonatomic) IBOutlet UILabel *distance;

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *weight;

@property (weak, nonatomic) IBOutlet UILabel *tiji;
@property (weak, nonatomic) IBOutlet UILabel *startPlace;
@property (weak, nonatomic) IBOutlet UILabel *endPlace;
@property (weak, nonatomic) IBOutlet UILabel *ifReceive;
@property (weak, nonatomic) IBOutlet UILabel *ifSend;

@property (weak, nonatomic) IBOutlet UIImageView *threePoint;
@property (copy, nonatomic)  ClickBlock block;

@property (strong, nonatomic) Logist *data;

- (void)setViewsWithModel:(Logist *)model;
@end
