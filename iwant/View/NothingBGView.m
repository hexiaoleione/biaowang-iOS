//
//  NothingBGView.m
//  iwant
//
//  Created by dongba on 16/9/18.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "NothingBGView.h"
#import "UIView+Layout.h"
#define WINDOW_WIDTH                [[UIScreen mainScreen] bounds].size.width
#define WINDOW_HEIGHT               [[UIScreen mainScreen] bounds].size.height
@implementation NothingBGView

-(instancetype)initWithFrame:(CGRect)frame{

    if (self == [super initWithFrame:frame]) {
    }
     [self setUp];
    return self;
}
- (void)setUp{

    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.width/2-75, 200, 150, 150)];

    _imageView.centerX = self.width *0.5;
    _imageView.centerY = self.height*0.5;
    _imageView.image = [UIImage imageNamed:@"garbage"];

    _textLabel= [UILabel new];
    _textLabel.textColor = [UIColor lightGrayColor];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.font = [UIFont systemFontOfSize:20];//采用系统默认文字设置大小
    _textLabel.text = @"暂无订单";
    _textLabel.width = WINDOW_WIDTH;
    _textLabel.height = 60;

    _textLabel.y = _imageView.bottom + 10;
    _textLabel.centerX = self.width *0.5;
    
    [self addSubview:_imageView];
    
    [self addSubview:_textLabel];
        
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
