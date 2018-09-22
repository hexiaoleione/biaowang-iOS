//
//  UIButton+imagePosistion.m
//  iwant
//
//  Created by dongba on 16/5/20.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "UIButton+imagePosistion.h"

@implementation UIButton (imagePosistion)

- (void)SetbuttonType:(BtnType)type {
    
    //需要在外部修改标题背景色的时候将此代码注释
    self.titleLabel.backgroundColor = self.backgroundColor;
    self.imageView.backgroundColor = self.backgroundColor;
    
    CGSize titleSize = self.titleLabel.bounds.size;
    CGSize imageSize = self.imageView.bounds.size;
    CGFloat interval = 1.0;
    
    if (type == BtnTypeLeft) {
        
        [self setImageEdgeInsets:UIEdgeInsetsMake(0,titleSize.width + interval, 0, -(titleSize.width + interval))];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -(imageSize.width + interval), 0, imageSize.width + interval)];
        
    } else if(type == BtnTypeBottom) {
        
        [self setImageEdgeInsets:UIEdgeInsetsMake(0,0, titleSize.height + interval, -(titleSize.width))];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(imageSize.height + interval, -(imageSize.width), 0, 0)];
    }
}
@end
