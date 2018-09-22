//
//  UnUsedTableViewCell.m
//  iwant
//
//  Created by pro on 16/3/9.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "UnUsedTableViewCell.h"
#import "Wallet.h"
#import "MainHeader.h"
@interface UnUsedTableViewCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moneyLeftTo;

@property (weak, nonatomic) IBOutlet UILabel *couponName;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn;

@property (weak, nonatomic) IBOutlet UILabel *conditions;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *danweiYuan;


@property (weak, nonatomic) IBOutlet UILabel *coupontime;

@property (weak, nonatomic) IBOutlet UIButton *ifUseBtn;
@end
@implementation UnUsedTableViewCell

- (void)select{
    if (_ifSelecct) {
        _ifSelecct = NO;
    }else{
        _ifSelecct = YES;
    }
}

- (void)configModel:(Wallet *)model
{
    _couponName.text = [NSString stringWithFormat:@"%@",model.couponName];
    _money.text = [NSString stringWithFormat:@"%@",model.money];
    if (WINDOW_WIDTH == 320) {
//        _money.font = [UIFont systemFontOfSize:25];
//        _moneyLeftTo.constant = 15;
//        [self layoutIfNeeded];
    }
    
    _conditions.text = model.conditions;
    _coupontime.text =[NSString stringWithFormat:@"有效期至：%@",model.coupontime];
    [_typeBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"couponType_%d",model.couponId]] forState:UIControlStateNormal];
    if (model.ifUsed ) {
        _money.textColor = [UIColor lightGrayColor];
        [self.ifUseBtn setTitle:@"已使用" forState:0];
        
        [self.ifUseBtn setBackgroundColor:[UIColor grayColor]];
    }
    if (model.ifExpire) {
        _money.textColor = [UIColor lightGrayColor];
        [self.ifUseBtn setTitle:@"已过期" forState:0];
        [self.ifUseBtn setBackgroundColor:[UIColor grayColor]];
    }
}
- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.couponName.textColor = COLOR_PurpleColor;
    self.money.textColor = COLOR_PurpleColor;
    self.conditions.textColor = COLOR_PurpleColor;
    self.danweiYuan.textColor = COLOR_PurpleColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
