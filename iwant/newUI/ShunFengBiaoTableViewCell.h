//
//  ShunFengBiaoTableViewCell.h
//  iwant
//
//  Created by 公司 on 2017/2/15.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShunFengBiaoShi.h"
@interface ShunFengBiaoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *publishTime;
@property (weak, nonatomic) IBOutlet UIButton *limitTime;

@property (weak, nonatomic) IBOutlet UILabel *replaceMoney;//代收款金额
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UILabel *matName;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *addressTo;
@property (weak, nonatomic) IBOutlet UILabel *disTance;
@property (weak, nonatomic) IBOutlet UIImageView *matImage;
@property (weak, nonatomic) IBOutlet UILabel *transforeMoney;
@property (weak, nonatomic) IBOutlet UILabel *carLengthL;
@property (weak, nonatomic) IBOutlet UILabel *matVolumeL;
@property (weak, nonatomic) IBOutlet UILabel *remarkL;
@property (weak, nonatomic) IBOutlet UILabel *useTimeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *valumeTopConstraint;


- (void)setModel:(ShunFengBiaoShi *)model;

@end
