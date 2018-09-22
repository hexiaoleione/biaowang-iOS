//
//  QuickControl.h
//  YLYQ
//
//  Created by work on 15-3-6.
//  Copyright (c) 2015年 work. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <UIKit/UIKit.h>

@interface QuickControl : NSObject

//MD5加密
+ ( NSString *)md5String:( NSString *)str;
//获取当亲时间戳
+(NSString *)getNowTime;
+ (NSString *)shijianchuoOfTime:(NSString *)str;

+(float)getWidth;
+(float)getHeight;
+(NSString *)getDateTimeStr;

+ (UIImage *)getImageWithImageName:(NSString *)imageName;

+ (UIImageView *)createImageViewWithFrame:(CGRect)frame image:(NSString *)image;

+ (UILabel *)createLabelWithFrame:(CGRect)frame backgroundColor:(UIColor *)backColor text:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font;

+ (UIView *)createViewWithFrame:(CGRect)frame backgroundColor:(UIColor *)color;

+ (UIButton *)createButtonWithFrame:(CGRect)frame backgroundColor:(UIColor *)backColor title:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font target:(id)target action:(SEL)action;

+ (UIButton *)createButtonWithFrame:(CGRect)frame backgroundColor:(UIColor *)backColor title:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font image:(NSString *)image imageEdgeInsets:(UIEdgeInsets)imageEdgeInsets target:(id)target action:(SEL)action;

+ (UIButton *)createButtonWithFrame:(CGRect)frame backgroundImage:(NSString *)backImage target:(id)target action:(SEL)action;

+ (UIButton *)createButtonWithFrame:(CGRect)frame backgroundImage:(NSString *)backImage title:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font target:(id)target action:(SEL)action;

+ (UITextField *)createTextFieldWithFrame:(CGRect)frame font:(UIFont *)font textColor:(UIColor *)textColor borderStyle:(UITextBorderStyle)borderStyle returnKeyType:(UIReturnKeyType)returnKeyType placeholder:(NSString *)placeholder;

@end

//顶部对齐
@interface UILabel (VerticalUpAlignment)

- (void)verticalUpAlignmentWithText:(NSString *)text maxHeight:(CGFloat)maxHeight;

@end
