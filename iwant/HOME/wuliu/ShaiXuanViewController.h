//
//  ShaiXuanViewController.h
//  iwant
//
//  Created by 公司 on 2016/12/6.
//  Copyright © 2016年 FatherDong. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "BaseViewController.h"
//typedef void (^ReturnTextBlock)(NSString *address,NSString *citycode,NSString *towncode,NSString *cityname,NSString *townname);
typedef void (^ShaiXuanBlock)(NSString * endPlaceCode,NSString * type);

@interface  ShaiXuanViewController: BaseViewController
//@property (nonatomic, copy) ReturnTextBlock returnTextBlock;
//
//- (void)returnText:(ReturnTextBlock)block;

@property(nonatomic,copy) ShaiXuanBlock shaixuanBlock;

@end
