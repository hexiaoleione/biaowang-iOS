//
//  CustomAlert.h
//  弹出视图
//
//  Created by 银谷 on 16/4/27.
//  Copyright © 2016年 银谷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomAlert : UIView

+ (CustomAlert *)_alert;

- (instancetype)initWithTitle:(NSString *)title
                 leftBtnTitle:(NSString *)leftBtntitle
                rightBtnTitle:(NSString *)rightBtntitle
                  bottomTitle:(NSString *)bottomtitle;

/** 标题*/
@property (nonatomic, copy) NSString *mainTitle;

/** 左Btn*/
@property (nonatomic, copy) NSString *leftBtntitle;

/** 右Btn*/
@property (nonatomic, copy) NSString *rightBtntitle;

/** 备注*/
@property (nonatomic, copy) NSString *bottomtitle;

/** 显示*/
+ (void)show;

/** 隐藏*/
+ (void)hide;

@end
