//
//  XLTableDelegateObj.h
//  IDAndBankCard
//
//  Created by mxl on 2018/4/28.
//  Copyright © 2018年 Leione. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface XLTableDelegateObj : NSObject <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) RACSubject *selectSubject;

@end
