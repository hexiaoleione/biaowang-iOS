//
//  LogistAddLuxianView.m
//  iwant
//
//  Created by dongba on 16/9/1.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "LogistAddLuxianView.h"

@implementation LogistAddLuxianView
- (IBAction)selectCityFrom:(UIButton *)sender {
    _block(sender.tag);
}

-(void)awakeFromNib{
    [super awakeFromNib];
    _startBGView.layer.cornerRadius = 15;
    _startBGView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _startBGView.layer.borderWidth = 1.0;
    _endBGV.layer.cornerRadius = 15;
    _endBGV.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _endBGV.layer.borderWidth = 1.0;
    _sureBtn.layer.cornerRadius = 15;
    _pullView.layer.cornerRadius = 5;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
