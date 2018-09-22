//
//  HuoChangAdressVC.h
//  iwant
//
//  Created by 公司 on 2017/1/3.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "BaseViewController.h"
@class HuoChangModel;
typedef void (^PassValueBlock)(HuoChangModel *model);

@interface HuoChangAdressVC :BaseViewController

@property(nonatomic,copy) PassValueBlock block;

@property (assign, nonatomic)  BOOL isGuanLI;// 由物流管理跳转过来


@end
