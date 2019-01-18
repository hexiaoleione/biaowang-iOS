//
//  XLScanManagerInitialize.h
//  IDAndBankCard
//
//  Created by mxl on 2018/4/28.
//  Copyright © 2018年 Leione. All rights reserved.
//

#import "XLScanBaseManager.h"

@interface XLScanManagerInitialize : XLScanBaseManager

- (void)configIDScan;

- (BOOL)configOutPutAtQue:(dispatch_queue_t)queue;

- (BOOL)configInPutAtQue:(dispatch_queue_t)queue;

- (void)configConnection;


@end
