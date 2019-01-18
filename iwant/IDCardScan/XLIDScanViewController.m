//
//  XLIDScanViewController.m
//  IDAndBankCard
//
//  Created by  on 2018/4/28.
//  Copyright © 2018年 Leione. All rights reserved.
//

#import "XLIDScanViewController.h"
#import "IDOverLayerView.h"

@interface XLIDScanViewController ()<UIAlertViewDelegate>
{
    BOOL isReadSuccess;
    int idcardType;
}
@property (nonatomic, strong) IDOverLayerView *overlayView;
@property (nonatomic,copy) CompleteBlock completeBlock;

@end

@implementation XLIDScanViewController
- (instancetype)initWithBlock:(CompleteBlock)completeBlock idcardType:(int)type
{
    self = [super init];
    
    if (self) {
        _completeBlock = completeBlock;
        idcardType = type;
    }
    
    return self;
}
-(IDOverLayerView *)overlayView {
    if(!_overlayView) {
        CGRect rect = [IDOverLayerView getOverlayFrame:[UIScreen mainScreen].bounds];
        _overlayView = [[IDOverLayerView alloc] initWithFrame:rect];
    }
    return _overlayView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"身份证扫描";
    self.cameraManager.sessionPreset = AVCaptureSessionPresetHigh;
    
    isReadSuccess = NO;
    if ([self.cameraManager configIDScanManager]) {
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
    [self.cameraManager.idCardScanSuccess subscribeNext:^(id x) {
        
        if (self->isReadSuccess == false) {
            self->isReadSuccess = YES;
            [self.cameraManager stopSession];
            
            [self showResult:x];
        }
        
    }];
    [self.cameraManager.scanError subscribeNext:^(id x) {
        
    }];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    

}
-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self.view insertSubview:self.overlayView atIndex:1];
    UIButton *leftButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    leftButton.frame = CGRectMake(10, 30, 40, 30);
    leftButton.backgroundColor = [UIColor clearColor];
    [leftButton setTitle:@"关闭" forState:(UIControlStateNormal)];
    [leftButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [leftButton addTarget:self action:@selector(leftButonClick) forControlEvents:(UIControlEventTouchUpInside)];

    [self.view addSubview:leftButton];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
    
    
        
//    });
    
}

-(void)leftButonClick {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showResult:(id)result {
    
    
    XLScanResultModel *model = (XLScanResultModel *)result;

    
    UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"操作提示" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    if (idcardType == 1) {
        
        if (!model.code || model.code.length < 15) {
            alertV.message = @"识别失败，请扫描身份证正面";
            [alertV show];
            return;
        }
        
    }else if (idcardType == 2){
        if (!model.valid || model.valid.length < 8) {
            alertV.message = @"识别失败，请扫描身份证反面";
            [alertV show];
            return;
        }
    }else{
        alertV.message = @"识别失败，请扫描身份证";
        [alertV show];
        
        return;
    }
    
    
    NSData *data = UIImageJPEGRepresentation(model.image, 1.0f);
    
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    model.imageData =encodedImageStr;
    
    _completeBlock(YES,model);
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    isReadSuccess = false;
    [self.cameraManager startSession];
}

@end
