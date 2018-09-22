//
//  BiaoshiInfoViewController.h
//  iwant
//
//  Created by dongba on 16/5/26.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "BaseViewController.h"
#import "MainHeader.h"
#import "Evaluation.h"
@interface BiaoshiInfoViewController : BaseViewController

@property(strong,nonatomic)Evaluation *model;


@property (copy, nonatomic)  NSString *userId;

@end
