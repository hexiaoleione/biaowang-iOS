//
//  CarNumCell.h
//  iwant
//
//  Created by 公司 on 2017/8/3.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarNumModel.h"

@interface CarNumCell : UITableViewCell

- (void)setModel:(CarNumModel *)model;

@property (nonatomic,copy)void (^Block)();

@property (weak, nonatomic) IBOutlet UILabel *carNumLabel;

@end
