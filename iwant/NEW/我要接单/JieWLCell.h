//
//  JieWLCell.h
//  iwant
//
//  Created by 公司 on 2017/6/5.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AutoScrollLabel.h"
#import "Logist.h"
@interface JieWLCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *weight;
@property (weak, nonatomic) IBOutlet UILabel *endPlace;


@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *matNameL;
@property (weak, nonatomic) IBOutlet UILabel *matWeightL;
@property (weak, nonatomic) IBOutlet AutoScrollLabel *destinationL;

@property (weak, nonatomic) IBOutlet UILabel *guiGeL;
@property (weak, nonatomic) IBOutlet UILabel *takeCargoL;
@property (weak, nonatomic) IBOutlet UILabel *sendCargoL;
@property (weak, nonatomic) IBOutlet UIButton *quotionBtn;
//特殊需求冷链
@property (weak, nonatomic) IBOutlet UILabel *specialNeedL;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnWidthConstraint;

@property (nonatomic,copy) void (^Block)(int tag);

- (void)setModel:(Logist *)model;

@end
