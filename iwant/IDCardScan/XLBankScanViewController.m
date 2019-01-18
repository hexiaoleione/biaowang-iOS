//
//  XLBankScanViewController.m
//  IDAndBankCard
//
//  Created by mxl on 2018/4/28.
//  Copyright © 2018年 Leione. All rights reserved.
//

#import "XLBankScanViewController.h"
#import "OverlayView.h"

@interface XLBankScanViewController ()<UIAlertViewDelegate>

@property (nonatomic, strong) OverlayView *overlayView;
@property (nonatomic,copy) CompleteBlock completeBlock;

@end

@implementation XLBankScanViewController

- (instancetype)initWithBlock:(CompleteBlock)completeBlock
{
    self = [super init];
    
    if (self) {
        _completeBlock = completeBlock;
    }
    
    return self;
}
- (OverlayView *)overlayView {
    if(!_overlayView) {
        CGRect rect = [OverlayView getOverlayFrame:[UIScreen mainScreen].bounds];
        _overlayView = [[OverlayView alloc] initWithFrame:rect];
    }
    return _overlayView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"银行卡扫描";
    
    [self.view insertSubview:self.overlayView atIndex:0];
    
    self.cameraManager.sessionPreset = AVCaptureSessionPreset1280x720;
    
    if ([self.cameraManager configBankScanManager]) {
        UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
        [self.view insertSubview:view atIndex:0];
        AVCaptureVideoPreviewLayer *preLayer = [AVCaptureVideoPreviewLayer layerWithSession: self.cameraManager.captureSession];
        preLayer.frame = [UIScreen mainScreen].bounds;
        
        preLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        
        [view.layer addSublayer:preLayer];
        
        [self.cameraManager startSession];
    }
    else {
        NSLog(@"打开相机失败");
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    [self.cameraManager.bankScanSuccess subscribeNext:^(id x) {
        [self showResult:x];
    }];
    [self.cameraManager.scanError subscribeNext:^(id x) {
        
    }];
    
}

- (void)showResult:(id)result {
    XLScanResultModel *model = (XLScanResultModel *)result;
    
    
    if (!model.bankNumber || model.bankNumber.length < 8) {
        
        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"操作提示" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        alertV.message = @"识别失败，请扫描结算卡反面";
        [alertV show];
        return;
    }
    
    
    NSData *data = UIImageJPEGRepresentation(model.image, 1.0f);
    
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    model.imageData =encodedImageStr;
    
    _completeBlock(YES,model);
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}


@end
