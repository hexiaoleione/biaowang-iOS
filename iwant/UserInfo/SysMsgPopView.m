//
//  SysMsgPopView.m
//  iwant
//
//  Created by dongba on 16/10/12.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "SysMsgPopView.h"
#import "MainHeader.h"
#import "Message.h"
#import "Utils.h"
@implementation SysMsgPopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
    [super awakeFromNib];
    [self insertColorGradient];
    _bgView.layer.cornerRadius = 25;
    _bgView.layer.masksToBounds = YES;
    if (WINDOW_WIDTH == 320) {
        _topToSuperView.constant = 64;
        [self layoutIfNeeded];
    }
    
}
//渐变色
-(void)insertColorGradient{
    UIColor *beginColor = [UIColor colorWithRed:255/255. green:255/255. blue:255/255. alpha:1];
    UIColor *endColor =  [UIColor colorWithRed:193/255. green:193/255. blue:250/255. alpha:1];
    NSArray *colors = [NSArray arrayWithObjects:(id)beginColor.CGColor,(id)endColor.CGColor, nil];
    NSNumber *beginNo = [NSNumber numberWithFloat:0.0];
    NSNumber *endNo = [NSNumber numberWithFloat:1.0];
    NSArray *locations = [NSArray arrayWithObjects:beginNo,endNo, nil];
    CAGradientLayer *headLayer = [CAGradientLayer layer];
    headLayer.colors = colors;
    headLayer.locations = locations;
    headLayer.frame = CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT);
    [self.layer insertSublayer:headLayer atIndex:0];
    
}

-(void)layoutSubviews{
    [super layoutSubviews];

}


-(void)setModel:(Message *)model{
    _titleLabel.text = model.messageTitle;
//    _contentLabel.text = model.messageDesc;
    _timeLabel.text = model.sendTime;
    NSAttributedString *str = [Utils ls_changeLineAndTextSpaceWithTotalString:model.messageDesc LineSpace:10 textSpace:5];
    [_contentLabel setAttributedText:str];
    
    [self layoutIfNeeded];
}

- (IBAction)closeAction:(id)sender {
    if (_block) {
        _block(sender);
    }
}

- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
@end
