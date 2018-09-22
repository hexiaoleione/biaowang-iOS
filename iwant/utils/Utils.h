//
//  Utils.h
//  Express
//
//  Created by zhujohnle on 15/7/27.
//  Copyright (c) 2015年 SCHT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBookUI/AddressBookUI.h>

@interface Utils : NSObject

+(void)showAlertWithTitle:(NSString *)title Msg:(NSString *)msg BtnTitleArr:(NSArray *)btnTitleArr Handle:(void (^)(id obj, NSUInteger idx)) handle;
+ (BOOL)isEmailText:(NSString *) inputText;
+ (void)callAction:(NSString *) phoneNum;
+ (void)openAddressBook:(UIViewController *) parent;

+ (NSString *)intervalFromLastDate: (NSString *) dateString1  toTheDate:(NSString *) dateString2;


+ (UIViewController *)getCurrentVC;

+ (UIViewController *)presentingVC;

/**
 *  同时更改行间距和字间距
 *
 *  @param totalString 需要改变的字符串
 *  @param lineSpace   行间距
 *  @param textSpace   字间距
 *
 *  @return 生成的富文本
 */
+ (NSMutableAttributedString *)ls_changeLineAndTextSpaceWithTotalString:(NSString *)totalString LineSpace:(CGFloat)lineSpace textSpace:(CGFloat)textSpace;
@end
