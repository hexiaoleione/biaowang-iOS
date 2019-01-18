//
//  XLIDScanViewController.h
//  IDAndBankCard
//
//  Created by mxl on 2018/4/28.
//  Copyright © 2018年 Leione. All rights reserved.
//

#import "XLScanBaseViewController.h"

@interface XLIDScanViewController : XLScanBaseViewController
- (instancetype)initWithBlock:( CompleteBlock )completeBlock idcardType:(int)type;

@end
