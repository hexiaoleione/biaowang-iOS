//
//  CityViewController.h
//  Express
//
//  Created by user on 15/7/23.
//  Copyright (c) 2015年 SCHT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
typedef void (^ReturnTextBlock)(NSString *address,NSString *citycode,NSString *towncode,NSString *cityname,NSString *townname);
@interface CityViewController : BaseViewController
@property (nonatomic, copy) ReturnTextBlock returnTextBlock;

- (void)returnText:(ReturnTextBlock)block;
@end
