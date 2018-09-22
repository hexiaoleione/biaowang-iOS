//
//  GoodsOfferTableViewCell.m
//  iwant
//
//  Created by 公司 on 2016/11/27.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "GoodsOfferTableViewCell.h"
#import "MainHeader.h"
@implementation GoodsOfferTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.detailBtn.layer.cornerRadius= 5.0;
    [self.detailBtn clipsToBounds];
    [self.detailBtn sizeToFit];
    [self.detailBtn setBackgroundColor:COLOR_MainColor];
    [self.detailBtn setTitle:@"查看详情" forState:UIControlStateNormal];
    
    self.nameLabel.font = FONT(14, NO);
    self.distanceLabel.font = FONT(14, NO);
    self.baojiaMoney.font = FONT(14, NO);
    self.addressLabel.font = FONT(14, NO);
    self.baojiaL.font = FONT(14, NO);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//打电话
- (IBAction)dianhua:(UIButton *)sender {
    if (_block) {
        _block(sender);
    }
}
//查看详情
- (IBAction)doToDetail:(UIButton *)sender {
    if (_block) {
        _block(sender);
    }
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 0.8);  //线宽
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 8, rect.size.height);  //起点坐标
    CGContextAddLineToPoint(context, self.frame.size.width-8, self.frame.size.height);   //终点坐标
    CGContextStrokePath(context);
}


@end
