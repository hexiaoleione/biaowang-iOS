//
//  XLScanBaseViewController.h
//  IDAndBankCard
//
//  Created by mxl on 2018/4/28.
//  Copyright © 2018年 Leione. All rights reserved.
//

#import "XLBaseViewController.h"
#import "XLScanManager.h"

#define iOS9Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)

@interface XLScanBaseViewController : XLBaseViewController

@property (nonatomic, strong) XLScanManager *cameraManager;

@end
