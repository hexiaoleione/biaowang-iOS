//
//  ShunFengViewController.h
//  iwant
//
//  Created by pro on 16/4/13.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShunFengViewController : UIViewController


@property (assign, nonatomic)  int type;//0-我是货主（看到镖师发布的行程列表） 1-我是镖师(看到用户发布的顺风任务)

@property (assign, nonatomic)  int sendType;//0-顺路送 1-专程送

@end
