//
//  XuxianView.m
//  iwant
//
//  Created by dongba on 16/3/22.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "XuxianView.h"

#define BACKGROUND_COLOR            [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0]
#define kInterval 10                                // 全局间距
@implementation XuxianView

- (id)initWithFrame:(CGRect)frame
{
    
    self= [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = [UIColor whiteColor];
        _lineColor = BACKGROUND_COLOR;
        _startPoint = CGPointMake(0, 1);
        _endPoint = CGPointMake(screen_width , 1);
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextBeginPath(context);
    
    CGContextSetLineWidth(context,3);//线宽度
    
    CGContextSetStrokeColorWithColor(context,self.lineColor.CGColor);
    
    CGFloat lengths[] = {4,2};//先画4个点再画2个点
    
    CGContextSetLineDash(context,0, lengths,2);//注意2(count)的值等于lengths数组的长度
    
    CGContextMoveToPoint(context,self.startPoint.x,self.startPoint.y);
    
    CGContextAddLineToPoint(context,self.endPoint.x,self.endPoint.y);
    
    CGContextStrokePath(context);
    
    CGContextClosePath(context);
    
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end




