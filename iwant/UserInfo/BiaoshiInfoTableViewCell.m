//
//  BiaoshiInfoTableViewCell.m
//  iwant
//
//  Created by dongba on 16/5/26.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "BiaoshiInfoTableViewCell.h"
#import "XuxianView.h"
#define BACKGROUND_COLOR            [UIColor colorWithRed:210.0/255.0 green:210.0/255.0 blue:210.0/255.0 alpha:1.0]
@interface BiaoshiInfoTableViewCell ()<RatingViewDelegate>
@end
@implementation BiaoshiInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    XuxianView *xuxian = [[XuxianView alloc]initWithFrame:CGRectMake(0, 0, screen_width - 32, 2)];
    xuxian.lineColor = BACKGROUND_COLOR;
    [self.xuxian addSubview:xuxian];
//    [self addStar:_starView score:8.0];
}

- (void)addStar:(UIView *)view score:(float)score{
    ZYRatingView *starView = [[ZYRatingView alloc]initWithFrame:CGRectMake(0, 0, 90, 18)];
    [starView setImagesDeselected:@"star_zero.png" partlySelected:@"star_one.png" fullSelected:@"star_one.png" andDelegate:self];
    [starView displayRating:score *2];
    starView.userInteractionEnabled = NO;
    [view addSubview:starView];
}
- (void)ratingChanged:(float)newRating{
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
