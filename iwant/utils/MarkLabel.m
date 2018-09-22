//
//  MarkLabel.m
//  iwant
//
//  Created by dongba on 16/5/4.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "MarkLabel.h"

@implementation MarkLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(instancetype)initWithFrame:(CGRect)frame labelTextColor :(UIColor *)labelTextColor bgColor: (UIColor *) bgColor fontSzie:(int)fontSzie labelText:(NSString *)labelText attributedString:(UIImage *)image {
    self = [super initWithFrame:frame];
    if (self) {
        self.textAlignment = NSTextAlignmentCenter;
        self.adjustsFontSizeToFitWidth = YES;
        self.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
//        [self sizeToFit];
        self.backgroundColor = bgColor;
        self.text  = labelText;
        self.textColor = labelTextColor;
        self.font = [UIFont systemFontOfSize:fontSzie];
        self.layer.cornerRadius = self.frame.size.height *0.2;
        self.layer.masksToBounds = YES;
        

        if (image) {
            NSMutableAttributedString *str=[[NSMutableAttributedString alloc] initWithString:labelText attributes:nil];
    
            NSTextAttachment *attachment=[[NSTextAttachment alloc] initWithData:nil ofType:nil];
            CGFloat height = self.font.lineHeight;
            attachment.bounds = CGRectMake(0, 0, height, height);
//            UIImage *img=[UIImage imageNamed:@"dianzan.png"];
            attachment.image = image;
            NSAttributedString *text=[NSAttributedString attributedStringWithAttachment:attachment];
            [str appendAttributedString:text];
            self.attributedText=str;
        }
        
    }
    return self;
}

@end
