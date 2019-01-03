//
//  AccidentInsuranceVC.h
//  iwant
//
//  Created by 公司 on 2017/10/26.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "BaseLeftViewController.h"
typedef void(^Dismiss)(void);
@interface AccidentInsuranceVC : BaseLeftViewController
@property (nonatomic, copy) Dismiss dismiss;

@property (nonatomic,assign)BOOL needHidden;
- (instancetype)initWithDismissOpration:(void(^)(void))dismissfn;

@end
