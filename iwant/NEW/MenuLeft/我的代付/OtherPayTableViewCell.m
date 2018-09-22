//
//  OtherPayTableViewCell.m
//  iwant
//
//  Created by 公司 on 2017/6/23.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "OtherPayTableViewCell.h"

@implementation OtherPayTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setViewWithModel:(ShunFeng *)model{
    if ([model.status intValue]!=0) {
        self.statusL.hidden = NO;
        self.payBtn.hidden = YES;
    }
    self.daifuNameL.text = [NSString stringWithFormat:@"%@(%@)找您代付",model.personName,model.mobile];
    self.timeL.text = [NSString stringWithFormat:@"发布时间：%@",model.publishTime];
    self.cargoNameL.text =[NSString stringWithFormat:@"物品名称：%@",model.matName];
    
    self.moneyL.text = [NSString stringWithFormat:@"代付金额:%@元",model.transferMoney];
}

- (IBAction)btnClickPay:(UIButton *)sender {
    if (_Block) {
        _Block();
    }
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 0.6);  //线宽
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
