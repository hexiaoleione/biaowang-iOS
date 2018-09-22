//
//  BiaoshiInfoTableViewCell.h
//  iwant
//
//  Created by dongba on 16/5/26.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYRatingView.h"
@interface BiaoshiInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet ZYRatingView *starView;
@property (weak, nonatomic) IBOutlet UIView *xuxian;

- (void)addStar:(UIView *)view score:(float)score;
@end
