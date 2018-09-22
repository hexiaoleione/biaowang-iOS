//
//  OrderViewController.h
//  iwant
//
//  Created by dongba on 16/8/30.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "BaseViewController.h"
#import "Logist.h"
typedef void (^BackBlock) (id sender);
@interface OrderViewController : BaseViewController


@property (copy, nonatomic)  BackBlock  block;
@property (strong, nonatomic)  Logist *model;
@property (assign, nonatomic)  BOOL ifJustLookUp;//只是查看
@end
