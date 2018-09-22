//
//  TouBaoRuleVC.h
//  iwant
//
//  Created by 公司 on 2017/5/18.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "BaseViewController.h"

@interface TouBaoRuleVC : BaseViewController

@property (copy, nonatomic) void (^Block)(int ifAgree);

@end
