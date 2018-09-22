//
//  BaoDanCell.h
//  iwant
//
//  Created by 公司 on 2017/10/12.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AutoScrollLabel.h"
#import "Logist.h"
@interface BaoDanCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgViewBg;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet AutoScrollLabel *destationLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiveNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (weak, nonatomic) IBOutlet UIButton *centerBtn;

@property (nonatomic,copy) void (^Block)(NSInteger tag);
- (void)setModel:(Logist *)model;
@end
