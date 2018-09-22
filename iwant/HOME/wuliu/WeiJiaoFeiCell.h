//
//  WeiJiaoFeiCell.h
//  iwant
//
//  Created by 公司 on 2017/2/27.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Logist.h"
typedef void (^ClickBlock) (id sender);

@interface WeiJiaoFeiCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *endPlace;
@property (weak, nonatomic) IBOutlet UIButton *jiaofeiBtn;


@property (copy, nonatomic)  ClickBlock block;

-(void)setModel:(Logist *)model;

@end
