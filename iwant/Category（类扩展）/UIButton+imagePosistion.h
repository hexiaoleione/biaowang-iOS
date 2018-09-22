//
//  UIButton+imagePosistion.h
//  iwant
//
//  Created by dongba on 16/5/20.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,BtnType) {
    BtnTypeLeft = 0,
    BtnTypeBottom,
    };
@interface UIButton (imagePosistion)

- (void)SetbuttonType:(BtnType)type;
@end
