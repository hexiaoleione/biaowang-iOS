//
//  companyMyWLTableViewCell.m
//  iwant
//
//  Created by 公司 on 2016/11/29.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "companyMyWLTableViewCell.h"
#import "MainHeader.h"
@implementation companyMyWLTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.timeLabel.font = FONT(14, NO);
    self.nameLabel.font = FONT(14, NO);
    self.startLabel.font = FONT(14, NO);
    self.endLabel.font = FONT(14, NO);
    self.startLabel.textColor = [UIColor blackColor];
    self.endLabel.textColor = [UIColor blackColor];
    self.quhuoLabel.font = FONT(14, NO);
    self.zuitiLabel.font = FONT(14, NO);
    self.fahuoBtn.titleLabel.font = FONT(14, NO);
    self.arriveBtn.titleLabel.font = FONT(14, NO);
    self.startLabel.font = FONT(14, NO);
    self.specialNeedL.font = FONT(14, NO);
    
    self.fahuo.font = FONT(14, NO);
    self.shouhuo.font = FONT(14, NO);
    self.fahuoBtn.backgroundColor = COLOR_MainColor;
    self.arriveBtn.backgroundColor = COLOR_MainColor;
    self.fahuoBtn.layer.cornerRadius = 5.0;
    self.arriveBtn.layer.cornerRadius = 5.0;
    
}
- (IBAction)btnClick:(UIButton *)sender {
    if (_block) {
        _block(sender);
    }
}

- (void)setViewsWithModel:(Logist *)model{
    _timeLabel.text = [NSString stringWithFormat:@"要求到达时间：%@",model.arriveTime];
    _nameLabel.text = [NSString stringWithFormat:@"物品名称：%@",model.cargoName];
    if ([model.carType isEqualToString:@"cold"]) {
        self.specialNeedL.hidden = NO;
        self.specialNeedL.text = [NSString stringWithFormat:@"需求：%@",model.carName];
    }
    if ([model.carType isEqualToString:@"cold"]) {
        _quhuoLabel.text = [NSString stringWithFormat:@"温度要求：%@",model.tem];
        _zuitiLabel.hidden = YES;
    }else{
       _quhuoLabel.text = model.takeCargo ? @"物流公司上门取货" : @"发货人送到货场";
       _zuitiLabel.text = model.sendCargo ? @"物流公司送货上门" : @"收货人自提";
    }
    _startLabel.text = model.startPlace;
    _endLabel.text = model.entPlace;
    
    //根据支付状态判定
    switch ([model.status intValue]) {
        case 2:{
        //已中标
            _StatusLabel.hidden = NO;
            _StatusLabel.text = @"担保交易";
        }
            break;
        case 3:
            //已拍照 发货
        {
            _StatusLabel.hidden = NO;
            _StatusLabel.text = @"担保交易";
            [_fahuoBtn setTitle:@"已取货" forState:UIControlStateNormal];
            [_fahuoBtn setBackgroundColor:COLOR_PurpleColor];
            [_arriveBtn setBackgroundColor:COLOR_MainColor];
        }
            break;
            
        case 4:
            //货物到达
        {
            _StatusLabel.hidden = NO;
            _StatusLabel.text = @"担保交易";
            [_fahuoBtn setBackgroundColor:COLOR_PurpleColor];
            [_fahuoBtn setTitle:@"已取货" forState:UIControlStateNormal];
            [_arriveBtn setTitle:@"已送达" forState:UIControlStateNormal];
            [_arriveBtn setBackgroundColor:COLOR_PurpleColor];
        }
            break;
        case 5:
            //待评价
        {
            _StatusLabel.hidden = NO;
            _StatusLabel.text = @"担保交易";
            [_fahuoBtn setTitle:@"已取货" forState:UIControlStateNormal];
            [_fahuoBtn setBackgroundColor:COLOR_PurpleColor];
            [_arriveBtn setTitle:@"已送达" forState:UIControlStateNormal];
            [_arriveBtn setBackgroundColor:COLOR_PurpleColor];
        }
            break;
        case 7:
            //选择了非担保交易
        {
//          _StatusLabel.text = @"非担保交易";
            self.noticeL.hidden = NO;
            [_fahuoBtn setTitle:@"已取货" forState:UIControlStateNormal];
            [_fahuoBtn setBackgroundColor:COLOR_PurpleColor];
            _fahuoBtn.hidden = YES;
            _arriveBtn.hidden = YES;

        
        }
            break;
        case 8:
            //选择了一家物流公司
        {

        }
            break;
        case 9:
        {
//            _StatusLabel.text = @"非担保交易";
            self.noticeL.hidden = NO;
            [_fahuoBtn setBackgroundColor:COLOR_PurpleColor];
            _fahuoBtn.hidden = YES;
            _arriveBtn.hidden = YES;
            
        }
            break;
        default:
            break;
    }
    
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 0.6);  //线宽
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 8, rect.size.height);  //起点坐标
    CGContextAddLineToPoint(context, self.frame.size.width-8, self.frame.size.height);   //终点坐标
    CGContextStrokePath(context);
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
