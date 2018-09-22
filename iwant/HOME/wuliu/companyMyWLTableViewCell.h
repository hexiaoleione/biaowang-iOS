//
//  companyMyWLTableViewCell.h
//  iwant
//
//  Created by 公司 on 2016/11/29.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Logist.h"
#import "AutoScrollLabel.h"
typedef void (^ClickBlock) (id sender);
@interface companyMyWLTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel; //货物名

@property (weak, nonatomic) IBOutlet AutoScrollLabel *startLabel;
@property (weak, nonatomic) IBOutlet AutoScrollLabel *endLabel;

@property (weak, nonatomic) IBOutlet UILabel *quhuoLabel;

@property (weak, nonatomic) IBOutlet UILabel *zuitiLabel; //是否自提
@property (weak, nonatomic) IBOutlet UIButton *fahuoBtn;
@property (weak, nonatomic) IBOutlet UIButton *arriveBtn;
@property (weak, nonatomic) IBOutlet UILabel *StatusLabel;//状态为8的时候显示
@property (weak, nonatomic) IBOutlet UILabel *noticeL;

@property (weak, nonatomic) IBOutlet UILabel *fahuo;
@property (weak, nonatomic) IBOutlet UILabel *shouhuo;

//特殊需求冷链车
@property (weak, nonatomic) IBOutlet UILabel *specialNeedL;

@property (copy, nonatomic)  ClickBlock block;

- (void)setViewsWithModel:(Logist *)model;
@end
