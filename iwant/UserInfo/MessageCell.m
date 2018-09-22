//
//  MessageCell.m
//  e发快递（测试）
//
//  Created by dongba on 15/11/8.
//  Copyright © 2015年 pro. All rights reserved.
//

#import "MessageCell.h"
#import "MainHeader.h"
#define FONT(A,IFBOLD)                IFBOLD ? [UIFont boldSystemFontOfSize:WINDOW_WIDTH > 320 ? A : A/1.3]: [UIFont systemFontOfSize:WINDOW_WIDTH > 320 ? A : A/1.3]
#define WINDOW_WIDTH                [[UIScreen mainScreen] bounds].size.width
#define WINDOW_HEIGHT               [[UIScreen mainScreen] bounds].size.height

@implementation MessageCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:( NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configCell];
    }
    return self;
}

- (void)configCell
{
    self.width = WINDOW_WIDTH;
    self.imageV = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, self.bounds.size.width * 0.1, self.bounds.size.height)];
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width * 0.11, 5, self.bounds.size.width * 0.6 - 40, self.bounds.size.height *0.5)];
    self.detailTextLabel.textColor = [UIColor darkGrayColor];

    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width *0.70, 10, self.bounds.size.width * 0.25, self.bounds.size.height * 0.3)];
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    _timeLabel.textColor = [UIColor grayColor];
    _timeLabel.font = FONT(12, NO);
    
    _leftDownLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width *0.75, self.bounds.size.height * 0.3 + 10, self.bounds.size.width * 0.25, self.bounds.size.height * 0.7 - 15)];
    
    [self addSubview:self.imageV];
    [self addSubview:self.titleLabel];
    [self addSubview:_timeLabel];
    [self addSubview:_leftDownLabel];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.textLabel.width = self.titleLabel.width;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
