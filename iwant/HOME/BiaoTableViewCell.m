//
//  BiaoTableViewCell.m
//  iwant
//
//  Created by pro on 16/4/29.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "BiaoTableViewCell.h"
#import "MainHeader.h"

@interface BiaoTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *statusCenterL;
@property (weak, nonatomic) IBOutlet UILabel *statusRightL;
@property (weak, nonatomic) IBOutlet UILabel *limitTimeL;
@property (weak, nonatomic) IBOutlet UILabel *matNameL;
@property (weak, nonatomic) IBOutlet UILabel *receiveNameL;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;


@end

@implementation BiaoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.statusCenterL.font = FONT(14,NO);
    self.statusRightL.font = FONT(14,NO);
    self.limitTimeL.font = FONT(14,NO);
    self.matNameL.font = FONT(14,NO);
    self.receiveNameL.font = FONT(14,NO);
    self.cancelBtn.titleLabel.font = FONT(14, NO);
}
- (void)setModel:(ShunFengBiaoShi *)model
{
    if (model.limitTime.length == 0) {
       self.limitTimeL.text =[NSString stringWithFormat:@"要求到达时间：%@",model.useTime];
    }else{
       self.limitTimeL.text = [NSString stringWithFormat:@"要求到达时间：%@",model.limitTime];
    }
    self.matNameL.text = [NSString stringWithFormat:@"物品名称：%@",model.matName];
    self.receiveNameL.text = [NSString stringWithFormat:@"收件人：%@",model.personNameTo];
    //状态 0-预发布成功(未支付) 1-支付成功(已支付)  2(已抢单) 3 已取件(不需要代收款) 4 订单取消(镖师)  5 成功  6 删除
    //   7 已评价    8订单取消(用户)   9货物违规状态(镖师点击货物违规按钮后,用户界面出现是否同意的按钮)  10 无密码完成 ,待结算镖费   11 被投诉,冻结金额
    self.statusCenterL.text = @"      ";
    self.statusRightL.text = @"     ";
    switch ([model.status integerValue]) {
        case 2:{
            self.statusCenterL.text = @"未取件";
            self.cancelBtn.hidden = NO;
        }
            break;
        case 3:{
            self.statusCenterL.text =@"未送达";
        }
            break;
        case 4:{
            self.statusRightL.textColor =[UIColor lightGrayColor];
          if (model.ifAgree.length != 0) {
           self.statusRightL.text =@"货物违规取消";
          }else{
           self.statusRightL.text = @"镖师取消";
          }
        }
            break;
        case 5:{
            self.statusRightL.text = @"已完成";
        }
            break;
        case 7:{
            self.statusRightL.text = @"已完成";
        }
            break;
        case 8:
        {
            self.statusRightL.textColor =[UIColor lightGrayColor];
            self.statusRightL.text = @"用户取消";
        }
            break;
        case 9:{
            self.statusRightL.textColor =[UIColor lightGrayColor];
            self.statusRightL.text = @"货物违规";
        }
            break;
        case 10:{
            self.statusRightL.textColor =[UIColor redColor];
            self.statusRightL.text = @"已完成等待结算运费";
        }
            break;
        case 11:{
            self.statusRightL.textColor =[UIColor lightGrayColor];
            self.statusRightL.text = @"已冻结";
        }
            break;
        default:
            break;
    }
    /*
    //4 订单取消  5 成功  6 删除 7 已评价 不必显示倒计时
    if ([model.status integerValue] >3) {
        return;
    }
        if (model.limitTime && ![model.limitTime isEqualToString:@""]) {
        //转换时间格式
        NSDateFormatter*df = [[NSDateFormatter alloc]init];//格式化
        [df setDateFormat:@"yyyy-MM-dd HH:mm"];
        [df setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"] ];
        NSDate*date2 =[[NSDate alloc]init];
        date2 =[df dateFromString:model.limitTime];

        
        NSCalendar *cal = [NSCalendar currentCalendar];
        
        unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        
        NSDateComponents *d = [cal components:unitFlags fromDate:[NSDate date] toDate:date2 options:0];
        
        NSInteger sec = [d hour]*3600+[d minute]*60+[d second];
            NSLog(@"limitTime ===================%@",model.limitTime);
            NSLog(@"秒数———————————————————%ld",(long)sec);
            NSLog(@"date2__________________%@",date2);
        CZCountDownView *countView = [CZCountDownView countDown];
        countView.frame = CGRectMake(0, 0, 150, 15);
        countView.timestamp = sec;
                if (sec < 1) {
                    if ([model.status integerValue] == 3 || [model.status integerValue] == 2) {
                        _successImage.hidden = NO;
                        _successImage.image = [UIImage imageNamed:@"chao_nosmill"];
                        return;
                    }
        countView.timestamp = 0;
                }
        countView.backgroundImageName = @"search_k";
        countView.timerStopBlock = ^{
            NSLog(@"时间停止");
        };
        [_countLabel addSubview:countView];
        countView.right = _countLabel.width;
        _countLabel.hidden = YES;
    }
     */
}
- (IBAction)cancelBtnClick:(UIButton *)sender {
//取消该订单
    if (_Block) {
        _Block(1);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
