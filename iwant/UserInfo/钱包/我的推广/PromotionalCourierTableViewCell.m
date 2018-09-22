//
//  PromotionalCourierTableViewCell.m
//  iwant
//
//  Created by pro on 16/5/27.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "PromotionalCourierTableViewCell.h"
@interface  PromotionalCourierTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
@implementation PromotionalCourierTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    _headerImageView.layer.cornerRadius = 25;
    _headerImageView.layer.masksToBounds = YES;
    

}
- (void)configModel:(Promote *)model{
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:model.headPath]placeholderImage:[UIImage imageNamed:@"user-1"]];
    _nameLabel.text = model.userName;
    _desLabel.text = model.type;
    _moneyLabel.text = [NSString stringWithFormat:@"%@元",model.money];
    _timeLabel.text = model.pushime;
//    _personName.text = model.userName;
//    _allMoney.text = [NSString stringWithFormat:@"累计单数：%@/%0.2f元",model.totalNumber,model.totalMoney];
//    _TodyMoney.text = [NSString stringWithFormat:@"今日单数：%@/%0.2f元",model.dayNumber,model.dayMoney];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
