//
//  SGQRCodeScanningVC.h
//  SGQRCodeExample
//
//  Created by kingsic on 17/3/20.
//  Copyright © 2017年 kingsic. All rights reserved.
//

#import "XLScanBaseViewController.h"
@protocol SGQRCodeScanningVCDelegate <NSObject>
- (void)readQrCodeStatus:(BOOL)status result:(NSString *)result;
@end
@interface SGQRCodeScanningVC : XLBaseViewController
@property (nonatomic,weak) id<SGQRCodeScanningVCDelegate> delegate;
- (instancetype)initWithBlock:( CompleteBlock )completeBlock;
@end
