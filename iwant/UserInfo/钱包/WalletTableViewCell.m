//
//  WalletTableViewCell.m
//  iwant
//
//  Created by pro on 16/3/9.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "WalletTableViewCell.h"
#import "Wallet.h"
@interface WalletTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *recordName;

@property (weak, nonatomic) IBOutlet UILabel *recordTime;

@property (weak, nonatomic) IBOutlet UILabel *recordMoney;

@property (weak, nonatomic) IBOutlet UILabel *recordDesc;
@end

@implementation WalletTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)configModel:(Wallet *)model
{
    _recordName.text = model.recordName;
    if (model.recordMoney.doubleValue == 0) {
        _recordMoney.text = @"0 元";
    }else{
        _recordMoney.text = [NSString stringWithFormat:@"%0.2lf 元",[model.recordMoney doubleValue]];
    }
    
    _recordTime.text = model.recordTime;
    
    if (model.recordDesc  == NULL) {
        _recordDesc.text = @"";

    } else {
        _recordDesc.text = model.recordDesc;

    }
    

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
