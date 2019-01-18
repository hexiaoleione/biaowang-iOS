//
//  XLScanBaseViewController.m
//  IDAndBankCard
//
//  Created by  on 2018/4/28.
//  Copyright © 2018年 Leione. All rights reserved.
//

#import "XLScanBaseViewController.h"

@interface XLScanBaseViewController ()

@end

@implementation XLScanBaseViewController

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.cameraManager doSomethingWhenWillDisappear];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.cameraManager doSomethingWhenWillAppear];

   
}

- (XLScanManager *)cameraManager {
    if (!_cameraManager) {
        _cameraManager = [[XLScanManager alloc] init];
    }
    return _cameraManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



@end
