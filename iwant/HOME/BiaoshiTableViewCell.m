//
//  BiaoshiTableViewCell.m
//  iwant
//
//  Created by pro on 16/4/13.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "BiaoshiTableViewCell.h"

@interface BiaoshiTableViewCell()

- (IBAction)Call:(id)sender;

- (IBAction)location:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *limitTime;

@property (weak, nonatomic) IBOutlet UILabel *publishTime;

@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet UILabel *matName;

@property (weak, nonatomic) IBOutlet UILabel *address;

@property (weak, nonatomic) IBOutlet UILabel *addressTo;

@property (weak, nonatomic) IBOutlet UILabel *distance;  //距离

@property (weak, nonatomic) IBOutlet UILabel *transferMoney;

@property (weak, nonatomic) IBOutlet UIImageView *matImageUrl;
@end

@implementation BiaoshiTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(ShunFengBiaoShi *)model
{
    
    [_matImageUrl setImage:[UIImage imageNamed:@"物品"]];
//    [_matImageUrl sd_setImageWithURL:[NSURL URLWithString:model.matImageUrl] placeholderImage:[UIImage imageNamed:@"物品"]];
    _publishTime.text = model.publishTime;
//    _userName.text = [NSString stringWithFormat:@"%@",model.personName];
    _userName.text = model.ifReplaceMoney? [NSString stringWithFormat:@"代收款：%@",model.replaceMoney]:@"";

    _matName.text = [NSString stringWithFormat:@"物品名称:%@",model.matName];

    _address.text =[NSString stringWithFormat:@"起始地:%@", model.address];
    
    _addressTo.text = [NSString stringWithFormat:@"目的地:%@", model.addressTo];
    _distance.text = [NSString stringWithFormat:@"距离：%0.2f Km",[model.distance floatValue]/1000];
   

    _transferMoney.text = [NSString stringWithFormat:@"镖费:%0.2f元", [model.transferMoney doubleValue]];
    
    if (model.limitTime && ![model.limitTime isEqualToString:@""]) {
        _limitTime.hidden = NO;
        [_limitTime setTitle:[NSString stringWithFormat:@"送达时间%@",[model.limitTime substringFromIndex:5]] forState:UIControlStateNormal];
        _limitTime.titleLabel.text = [NSString stringWithFormat:@"送达时间%@",[model.limitTime substringFromIndex:5]];
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)Call:(id)sender {
    if ([_delegate respondsToSelector:@selector(Call:AtIndexPath:)]) {
        [_delegate Call:sender AtIndexPath:self.a];
    }
}

- (IBAction)location:(id)sender {
    
    if ([_delegate respondsToSelector:@selector(location:AtIndexPath:)]) {
        [_delegate location:sender AtIndexPath:self.a];
    }
}
@end
