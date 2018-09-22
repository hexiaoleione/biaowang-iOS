//
//  OtherPayTableViewCell.h
//  iwant
//
//  Created by 公司 on 2017/6/23.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShunFeng.h"
@interface OtherPayTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *daifuNameL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *moneyL;
@property (weak, nonatomic) IBOutlet UILabel *cargoNameL;
@property (weak, nonatomic) IBOutlet UILabel *statusL;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;

@property (nonatomic,copy)void (^Block)();

-(void)setViewWithModel:(ShunFeng *)model;

@end
