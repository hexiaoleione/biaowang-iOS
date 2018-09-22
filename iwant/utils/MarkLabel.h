//
//  MarkLabel.h
//  iwant
//
//  Created by dongba on 16/5/4.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MarkLabel : UILabel
@property(nonatomic,retain) UIColor *labelTextColor;
@property (strong, nonatomic)  UIColor *bgColor;
@property (assign, nonatomic)  int fontSzie;
@property (copy, nonatomic)  NSString *labelText;

-(instancetype)initWithFrame:(CGRect)frame labelTextColor:(UIColor *)labelTextColor bgColor: (UIColor *) bgColor fontSzie:(int)fontSzie labelText:(NSString *)labelText attributedString:(UIImage *)image;
@end
