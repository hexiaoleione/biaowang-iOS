//
//  CouponTableViewCell.h
//  iwant
//
//  Created by dongba on 16/10/17.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Wallet;
@interface CouponTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLable;

- (void)configModel:(Wallet *)model;

@end
