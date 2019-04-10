//
//  ShareViewController.h
//  iwant
//
//  Created by 公司 on 2017/7/1.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "BaseLeftViewController.h"

typedef void(^Dismiss)(void);

@interface ShareViewController : BaseLeftViewController
@property (nonatomic, copy) Dismiss dismiss;
@property (nonatomic, assign) NSInteger types;

- (instancetype)initWithDismissOpration:(void (^)(void))dismissfn;

@end
