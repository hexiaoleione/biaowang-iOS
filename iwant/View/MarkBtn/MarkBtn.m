//
//  MarkBtn.m
//  iwant
//
//  Created by dongba on 16/5/6.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "MarkBtn.h"
const static CGFloat margin = 5.0;

@implementation MarkBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat height = self.frame.size.height - margin *2;
    self.titleLabel.frame = CGRectMake(height *0.5, margin, self.frame.size.width - height - height, height);
    self.titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    self.imageView.frame = CGRectMake(self.frame.size.width - height *1.5, margin, height, height);
    [self addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    self.layer.borderWidth = 1.0;
    self.layer.cornerRadius = self.frame.size.height *0.5;
//    self.titleLabel.adjustsFontSizeToFitWidth = YES;
}

-(void)click {
    if (!_isSelsect) {
        [self setTitleColor:[UIColor orangeColor] forState:0];
        self.layer.borderColor = [[UIColor orangeColor] CGColor];
        
    }else{
        [self setTitleColor:[UIColor lightGrayColor] forState:0];
        self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    }
    _isSelsect = !_isSelsect;
    NSLog(@"第%d个按钮被点击,点击后的状态为：%@",(int)self.tag,_isSelsect ? @"被点击状态" : @"未被点击状态");
}

@end
