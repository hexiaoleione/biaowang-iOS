//
//  TopBarView.m
//  iwant
//
//  Created by dongba on 16/8/24.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "TopBarView.h"
#import "XPQScrollLabel.h"


@implementation TopBarView

-(void)awakeFromNib{
    [super awakeFromNib];
    _tipsLabel.font = [UIFont systemFontOfSize:14];
    
}

- (void)setScroll:(BOOL)ifScroll{
    if (ifScroll) {
        _tipsLabel.type = XPQScrollLabelTypeRepeat;
    }else{
        _tipsLabel.type = XPQScrollLabelTypeBan;
    }
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
//    if ([self getLabelWidthWithText:_tipsLabel.text] - _tipsLabel.width > 0) {
//        _tipsLabel.type = XPQScrollLabelTypeClick;
//    }else{
//        _tipsLabel.type = XPQScrollLabelTypeBan;
//    }
}

- (CGFloat )getLabelWidthWithText:(NSString *)text{
    UILabel *label = [UILabel new];
    label.text = text;
    label.font = [UIFont systemFontOfSize:14];
    [label sizeToFit];
    
    return label.size.width;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
