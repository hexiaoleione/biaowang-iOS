//
//  QuickControl.m
//  YLYQ
//
//  Created by work on 15-3-6.
//  Copyright (c) 2015年 work. All rights reserved.
//

#import "QuickControl.h"
#define IsIOS8 ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue]>=8)
@implementation QuickControl

+(float)getWidth{

    return IsIOS8?[UIScreen mainScreen].bounds.size.width:[UIScreen mainScreen].bounds.size.height;
}
+(float)getHeight{

    return IsIOS8?[UIScreen mainScreen].bounds.size.height:[UIScreen mainScreen].bounds.size.width;
}
+(NSString*)getDateTimeStr{
//    NSString* timeStr = @"2011-01-26 17:40:50";
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
//    [formatter setTimeStyle:NSDateFormatterShortStyle];
//    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
//    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
//    [formatter setTimeZone:timeZone];
//    NSDate* date = [formatter dateFromString:timeStr]; //------------将字符串按formatter转成nsdate
//    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
//    NSString *nowtimeStr = [formatter stringFromDate:datenow];//----------将nsdate按formatter格式转成nsstring
    // 时间转时间戳的方法:
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    NSLog(@"timeSp:%@",timeSp); //时间戳的值
    return timeSp;
}

+ (UIImage *)getImageWithImageName:(NSString *)imageName{
//    NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:nil];
//    UIImage *image = [UIImage imageWithContentsOfFile:path];
    UIImage *image = [UIImage imageNamed:imageName];
    return image;
}

+ (UIImageView *)createImageViewWithFrame:(CGRect)frame image:(NSString *)image{

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = [QuickControl getImageWithImageName:image];
    return imageView;
}

+ (UILabel *)createLabelWithFrame:(CGRect)frame backgroundColor:(UIColor *)backColor text:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font{

    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = backColor;
//    label.adjustsFontSizeToFitWidth = YES;
    if ([text isKindOfClass:[NSNull class]]) {
        text = @"";
    }
    label.text = text;
    label.textColor = textColor;
    label.font = font;
    return label;
}

+ (UIView *)createViewWithFrame:(CGRect)frame backgroundColor:(UIColor *)color{

    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = color;
    return view;
}

+ (UIButton *)createButtonWithFrame:(CGRect)frame backgroundColor:(UIColor *)backColor title:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font target:(id)target action:(SEL)action{

    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    button.backgroundColor = backColor;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    button.titleLabel.font = font;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (UIButton *)createButtonWithFrame:(CGRect)frame backgroundColor:(UIColor *)backColor title:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font image:(NSString *)image imageEdgeInsets:(UIEdgeInsets)imageEdgeInsets target:(id)target action:(SEL)action{
    
    UIButton *button = [QuickControl createButtonWithFrame:frame backgroundColor:backColor title:title titleColor:titleColor font:font target:target action:action];
    [button setImage:[QuickControl getImageWithImageName:image] forState:UIControlStateNormal];
    [button setImageEdgeInsets:imageEdgeInsets];
    return button;
}

+ (UIButton *)createButtonWithFrame:(CGRect)frame backgroundImage:(NSString *)backImage target:(id)target action:(SEL)action{

    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button setBackgroundImage:[QuickControl getImageWithImageName:backImage] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (UIButton *)createButtonWithFrame:(CGRect)frame backgroundImage:(NSString *)backImage title:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font target:(id)target action:(SEL)action{
    
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button setBackgroundImage:[QuickControl getImageWithImageName:backImage] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    button.titleLabel.font = font;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (UITextField *)createTextFieldWithFrame:(CGRect)frame font:(UIFont *)font textColor:(UIColor *)textColor borderStyle:(UITextBorderStyle)borderStyle returnKeyType:(UIReturnKeyType)returnKeyType placeholder:(NSString *)placeholder{

    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.font = font;
    textField.textColor = textColor;
    textField.borderStyle = borderStyle;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.returnKeyType = returnKeyType;
    textField.placeholder = placeholder;
    return textField;
}

//获取当前时间戳
+ (NSString *)getNowTime{
    
    NSString *tsr = [NSString stringWithFormat:@"%d",(int)[[NSDate date] timeIntervalSince1970]];
    
    return tsr;
}
/** md5 一般加密 */

+ ( NSString *)md5String:( NSString *)str

{
    const char *myPasswd = [str UTF8String ];
    
    unsigned char mdc[ 16 ];
    
    CC_MD5 (myPasswd, ( CC_LONG ) strlen (myPasswd), mdc);
    
    NSMutableString *md5String = [ NSMutableString string ];
    
    for ( int i = 0 ; i< 16 ; i++) {
        
        [md5String appendFormat : @"%02x" ,mdc[i]];
        
    }
    
    return md5String;
    
}

+ (NSString *)shijianchuoOfTime:(NSString *)str{
//    NSString *str=@"1368082020";//时间戳
 //   NSTimeInterval time=[str doubleValue]+28800;//因为时差问题要加8小时 == 28800 sec
    NSTimeInterval time=[str doubleValue];//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSLog(@"date:%@",[detaildate description]);
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式@"yyyy-MM-dd HH:mm:ss"
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    return currentDateStr;
}

@end

//顶部对齐
@implementation UILabel (VerticalUpAlignment)

- (void)verticalUpAlignmentWithText:(NSString *)text maxHeight:(CGFloat)maxHeight
{
    CGRect frame = self.frame;
    CGSize size = [text sizeWithFont:self.font constrainedToSize:CGSizeMake(frame.size.width, maxHeight)];
    frame.size = CGSizeMake(frame.size.width, size.height);
    self.frame = frame;
    self.text = text;
}

@end
