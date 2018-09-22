//
//  MyEcoinCell.m
//  Express
//
//  Created by 刘耀光 on 15/9/30.
//  Copyright (c) 2015年 SCHT. All rights reserved.
//

#import "MyEcoinCell.h"
@interface MyEcoinCell()
//{
//    UILabel *_ruleLabel;
//    UILabel *_timeLabel;
//    UILabel *_ecoinLabel;
//}
@property (weak, nonatomic) IBOutlet UILabel *ruleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *ecoinLabel;

@end
@implementation MyEcoinCell
//
//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
////        [self configCell];
//    }
//    return self;
//}
#pragma mark -- 配置界面
- (void)configCell
{
//    _ruleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 200, 30)];
//    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, 200, 20)];
//    _timeLabel.textColor = [UIColor grayColor];
//    _timeLabel.font = [UIFont systemFontOfSize:12];
//    _ecoinLabel = [[UILabel alloc]initWithFrame:CGRectMake(200, 0, 100, 60)];
//    _ecoinLabel.textAlignment = NSTextAlignmentRight;
//    [self addSubview:_ruleLabel];
//    [self addSubview:_timeLabel];
//    [self addSubview:_ecoinLabel];
    
}

- (void)loadEcoin:(Ecoin *)ecoin
{
    _ruleLabel.text = ecoin.ecoinName;
    _timeLabel.text = ecoin.ecoinTime;
    _ecoinLabel.text = [NSString stringWithFormat:@"%ld",(long)ecoin.ecoinMoney];
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 0.5);  //线宽
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
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
