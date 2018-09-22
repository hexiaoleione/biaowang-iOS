//
//  ConsignorTableViewCell.m
//  iwant
//
//  Created by pro on 16/4/13.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "ConsignorTableViewCell.h"
#import "MainHeader.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"

@interface ConsignorTableViewCell()

- (IBAction)Call:(id)sender;

- (IBAction)location:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *HeadImage;
@property (weak, nonatomic) IBOutlet UILabel *publishTime;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *addressTo;
@property (weak, nonatomic) IBOutlet UILabel *distance;

@end

@implementation ConsignorTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(location:)];
    [self.headImg addGestureRecognizer:tap];
    self.headImg.userInteractionEnabled = YES;
}
- (void)setModel:(ShunFeng *)model
{
    
//  [_HeadImage sd_setBackgroundImageWithURL:model.userHeadPath forState:0 placeholderImage:[UIImage imageNamed:@"user-1"]];
   
    [_HeadImage sd_setImageWithURL:[NSURL URLWithString:model.userHeadPath] placeholderImage:[UIImage imageNamed:@"place_ribbit"]];
    
    _headImg.layer.masksToBounds = YES;
    _publishTime.text = model.publishTime;
    _userName.text = [NSString stringWithFormat:@"%@",model.userName];
    
    _address.text =[NSString stringWithFormat:@"起始地:%@", model.address];
    
    _addressTo.text = [NSString stringWithFormat:@"目的地:%@", model.addressTo];
    _distance.text = [NSString stringWithFormat:@"出发时间：%@",model.leaveTime];
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    _headImg.layer.cornerRadius = _headImg.width *0.5;
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
