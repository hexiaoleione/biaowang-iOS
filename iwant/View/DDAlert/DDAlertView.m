//
//  DDAlertView.m
//  iwant
//
//  Created by dongba on 16/10/10.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "DDAlertView.h"
#define WINDOW_WIDTH                [[UIScreen mainScreen] bounds].size.width
#define FONT(A,IFBOLD)                IFBOLD ? [UIFont boldSystemFontOfSize:WINDOW_WIDTH > 320 ? A : A/1.5]: [UIFont systemFontOfSize:WINDOW_WIDTH > 320 ? A : A/1.5]
@implementation DDAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
    [super awakeFromNib];
    _greenView.layer.cornerRadius = 10;
    _greenView.layer.masksToBounds = YES;
    _whiteClearView.layer.cornerRadius = 10;
    _goToBtn.layer.cornerRadius = 11.5;
    [self setdefoutFont:FONT(20, NO)];
    _TitleLabel.font = FONT(22, NO);
    _redDian.layer.cornerRadius = 10;
    if (WINDOW_WIDTH == 414) {
        _gotoBtnHeight.constant = 35;
        _goToBtn.layer.cornerRadius = 17.5;
        [self layoutIfNeeded];
    }
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.8f;
    self.layer.shadowRadius = 4.f;
    self.layer.shadowOffset = CGSizeMake(0,0);
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
}

- (void)setdefoutFont:(UIFont *)font{
    
    _timeLabel.font = font;
    _contentLabel.font = font;
}

@end
