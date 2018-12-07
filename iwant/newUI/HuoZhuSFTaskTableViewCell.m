//
//  HuoZhuSFTaskTableViewCell.m
//  iwant
//
//  Created by 公司 on 2017/2/20.
//  Copyright © 2017年 FatherDong. All rights reserved.
//
typedef enum status_type{
    PRE_PAY = 0,
    PAYED,
    GET_BILL,
    PICKED,
    CANCLED,
    SUCCESSED,
    DELETE,
    EVALUTED,
    USERCANCEL,
    HUOWUWEIGUI
}STATUS_TYPE;

#import "HuoZhuSFTaskTableViewCell.h"
#import "YLGIFImage.h"
#import "MainHeader.h"
@interface HuoZhuSFTaskTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *requireTime;
@property (weak, nonatomic) IBOutlet UILabel *matName;
@property (weak, nonatomic) IBOutlet UILabel *driverLabel;
@property (weak, nonatomic) IBOutlet UIImageView *StateGif;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;

@end


@implementation HuoZhuSFTaskTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLabel.font = FONT(14, NO);
    self.requireTime.font =FONT(14, NO);
    self.requireTime.font =FONT(14, NO);
    self.matName.font =FONT(14, NO);
    self.driverLabel.font = FONT(14, NO);
    self.cancelBtn.titleLabel.font =FONT(14, NO);
    [self.cancelBtn setTitleColor:COLOR_PurpleColor forState:UIControlStateNormal];
}
-(void)setModel:(ShunFeng *)model{
    if (model.limitTime.length == 0) {
        //顺风
        if (model.useTime.length == 0 || model.useTime == nil) {
            _requireTime.text = [NSString stringWithFormat:@"发布时间：%@",model.publishTime];
        }else{
            _requireTime.text = [NSString stringWithFormat:@"要求到达时间：%@",model.useTime];
        }
    }else{
        _requireTime.text = [NSString stringWithFormat:@"要求到达时间：%@",model.limitTime];
    }
    _matName.text = [NSString stringWithFormat:@"物品名称:%@",model.matName];
     switch ([model.status integerValue]) {
    //状态 0-预发布成功(未支付) 1-支付成功(已支付)  2(已抢单) 3 已取件(不需要代收款) 4 订单取消(镖师)  5 成功  6 删除
    //   7 已评价    8订单取消(用户)   9货物违规状态(镖师点击货物违规按钮后,用户界面出现是否同意的按钮)
        case 0:
            self.payBtn.hidden = NO;
            _StateGif.hidden = YES;
            _titleLabel.text = @"待付款";
            _StateGif.hidden = YES;
            _driverLabel.text = [NSString stringWithFormat:@"收件人:%@",model.personNameTo];
            break;
        case 1:
            _titleLabel.text = @"等待接单";
            _StateGif.image = [UIImage imageNamed:@"zhuangtai1"];
            _cancelBtn.hidden = NO;
            _driverLabel.text = [NSString stringWithFormat:@"收件人:%@",model.personNameTo];
            break;
        case 2:
            _titleLabel.text = @"等待取件";
            _cancelBtn.hidden = NO;
            _StateGif.image =[UIImage imageNamed:@"zhuangtai5"];
            _driverLabel.text = [NSString stringWithFormat:@"收件人：%@",model.personNameTo];
            break;
        case 3:
            _titleLabel.text = @"送件中";
            _StateGif.image = [UIImage imageNamed:@"zhuangtai2"];
            _driverLabel.text = [NSString stringWithFormat:@"收件人：%@",model.personNameTo];
            break;
        case 4:
            if (model.ifAgree.length >0) {
                _titleLabel.text = @"货物违规取消";
            }else{
                _titleLabel.text = @"镖师取消订单";
            }
            _titleLabel.textColor = [UIColor redColor];
            _StateGif.image = [UIImage imageNamed:@"zhuangtai6"];
            _driverLabel.text = [NSString stringWithFormat:@"收件人：%@",model.personNameTo];
            break;
        case 5:
            _titleLabel.text = @"已送达";
            _StateGif.image = [UIImage imageNamed:@"zhuangtai3"];
            _driverLabel.text = [NSString stringWithFormat:@"收件人：%@",model.personNameTo];
            break;
        case 6:
            _titleLabel.text = @"过期(已退款)";
            _titleLabel.textColor = [UIColor redColor];
            _StateGif.image = [UIImage imageNamed:@"zhuangtai4"];
            _driverLabel.text = [NSString stringWithFormat:@"收件人：%@",model.personNameTo];
            break;
        case 7:
            _titleLabel.text = @"已送达(完成评价)";
            _StateGif.image = [UIImage imageNamed:@"zhuangtai3"];
            _driverLabel.text = [NSString stringWithFormat:@"收件人：%@",model.personNameTo];
            break;
        case 8:
            _titleLabel.text = @"已取消发布";
            _titleLabel.textColor = [UIColor redColor];
            _StateGif.image = [UIImage imageNamed:@"zhuangtai4"];
            _driverLabel.text = [NSString stringWithFormat:@"收件人：%@",model.personNameTo];
            break;
        case 9:
            _titleLabel.text =@"货物违规";
            _titleLabel.textColor = [UIColor redColor];
            _StateGif.image = [UIImage imageNamed:@"zhuangtai6"];
            _driverLabel.text = [NSString stringWithFormat:@"收件人：%@",model.personNameTo];
            break;
        case 10:
             _titleLabel.text =@"已送达";
             _titleLabel.textColor = [UIColor redColor];
             _StateGif.image = [UIImage imageNamed:@"zhuangtai3"];
             _driverLabel.text = [NSString stringWithFormat:@"收件人：%@",model.personNameTo];
             break;
         case 11:
             _titleLabel.text =@"已退款";
             _titleLabel.textColor = [UIColor redColor];
             _StateGif.image = [UIImage imageNamed:@"zhuangtai3"];
             _driverLabel.text = [NSString stringWithFormat:@"收件人：%@",model.personNameTo];
             break;
        default:
            break;
    }
}
- (IBAction)cancel:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(cancel:AtIndexPath:)]) {
        [_delegate cancel:sender AtIndexPath:self.a];
    }
}
- (IBAction)gotoPayClick:(UIButton *)sender {
    NSLog(@"调付款界面！");
    if (_Block) {
        _Block(1);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

// Configure the view for the selected state
}

@end
