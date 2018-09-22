//
//  CarNumCell.m
//  iwant
//
//  Created by 公司 on 2017/8/3.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "CarNumCell.h"

@implementation CarNumCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(CarNumModel *)model{
    self.carNumLabel.text = model.carNum;
}
- (IBAction)cancelBtnClick:(UIButton *)sender {
    if (_Block) {
        _Block();
    }
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 0.5);  //线宽
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, rect.size.height);  //起点坐标
    CGContextAddLineToPoint(context, self.frame.size.width, self.frame.size.height);   //终点坐标
    CGContextStrokePath(context);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
