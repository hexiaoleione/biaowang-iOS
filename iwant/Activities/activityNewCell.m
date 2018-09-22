//
//  activityNewCell.m
//  iwant
//
//  Created by 公司 on 2016/12/20.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "activityNewCell.h"

@implementation activityNewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//-(void)drawRect:(CGRect)rect{
//    [super drawRect:rect];
//    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetLineCap(context, kCGLineCapRound);
//    CGContextSetLineWidth(context, 0.5);  //线宽
//    CGContextSetStrokeColorWithColor(context, [UIColor orangeColor].CGColor);
//    CGContextBeginPath(context);
//    CGContextMoveToPoint(context, 0, rect.size.height);  //起点坐标
//    CGContextAddLineToPoint(context, self.frame.size.width, self.frame.size.height);   //终点坐标
//    CGContextStrokePath(context);
//}
@end
