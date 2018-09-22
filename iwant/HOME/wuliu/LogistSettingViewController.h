//
//  LogistSettingViewController.h
//  iwant
//
//  Created by dongba on 16/9/1.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^Block) (id sender);
@interface LogistSettingViewController : BaseViewController
@property (strong, nonatomic)  UITableView *tableView;

@property (copy, nonatomic)  Block block;
@end
