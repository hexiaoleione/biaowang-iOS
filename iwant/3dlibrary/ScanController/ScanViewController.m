//
//  ScanViewController.m
//  cmse
//
//  Created by user on 15-4-7.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import "ScanViewController.h"
#import "NSStringAdditions.h"
#import "MainHeader.h"
#import "AudioToolbox/AudioToolbox.h"
@interface ScanViewController (){
    UILabel * labIntroudction;
}

@end

@implementation ScanViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
	UIButton * scanButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [scanButton setBackgroundImage:[UIImage imageNamed:@"btn_normal"] forState:UIControlStateNormal];
    [scanButton setTitle:@"取消" forState:UIControlStateNormal];
    scanButton.titleLabel.font = [UIFont systemFontOfSize:18];
    scanButton.frame = CGRectMake(WINDOW_WIDTH *0.5 - 60, WINDOW_HEIGHT *0.5 +130, 120, 40);
    [scanButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scanButton];
    
    labIntroudction= [[UILabel alloc] initWithFrame:CGRectMake(15, 40, WINDOW_WIDTH - 30, 50)];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.numberOfLines=2;
    labIntroudction.textColor=[UIColor redColor];
    labIntroudction.text=@"将快递条形码图像置于矩形方框内，离手机摄像头10CM左右。";
    [self.view addSubview:labIntroudction];
    
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 190, WINDOW_WIDTH - 20, WINDOW_HEIGHT *0.2+20)];
    imageView.image = [UIImage imageNamed:@"camera_bk"];
    [self.view addSubview:imageView];
    
    upOrdown = NO;
    num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(30, 200+WINDOW_HEIGHT *0.1, WINDOW_WIDTH - 60, 5)];
    _line.image = [UIImage imageNamed:@"camera_line"];
    [self.view addSubview:_line];
//    
//  timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    
    if (_isChoice) {
        imageView.height = imageView.width = WINDOW_WIDTH - 100;
        imageView.centerX = self.view.centerX;
        _line.centerY = imageView.centerY;
        _line.width = imageView.width - 10;
        _line.centerX = self.view.centerX;
        scanButton.y = imageView.bottom + 10;
        labIntroudction.text=@"请扫描网页端的二维码登录";
    }
}
#pragma mark - 检测是否有权限打开相机
- (BOOL)cameraPemission
{
    BOOL isHavePemission = NO;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
    {
        //无权限
        isHavePemission = NO;
        
    }else{
        isHavePemission = YES;
    }
    
    return isHavePemission;
}
-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(30, 110+2*num,  WINDOW_WIDTH - 60, 5);
        if (2*num >= WINDOW_HEIGHT *0.5 ) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(30, 110+2*num,  WINDOW_WIDTH - 60, 5);
        if (num == 0) {
            upOrdown = NO;
        }
    }

}
-(void)backAction
{
    [timer invalidate];
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self dismissViewControllerAnimated:YES completion:^{
//        [timer invalidate];
//    }];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.navigationController.navigationBar) {
        self.navigationController.navigationBar.hidden = YES;
    }
    if (![self cameraPemission]) {
        labIntroudction.text = @"您没有开启相机权限，请到“设置”->“隐私”->“相机”中开启本程序相机的使用权限";
        return;
    }
    
    [self setupCamera];
    
}
- (void)setupCamera
{
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    
    _output.metadataObjectTypes =[NSArray arrayWithObjects:AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeQRCode, nil];
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame =CGRectMake(20,200,WINDOW_WIDTH -40,WINDOW_HEIGHT *0.2);
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    if (_isChoice) {
        _preview.frame =CGRectMake(0,labIntroudction.bottom,WINDOW_WIDTH,WINDOW_HEIGHT - 20);
    }
    
    // Start
    [_session startRunning];
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
   
    NSString *stringValue;
    
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    
    [_session stopRunning];
    if ([stringValue isOnlyNumAndAlpa] ) {
       
        if(self.returnCodeBlock) {
            if (!stringValue ||[stringValue isEqualToString:@""] ) {
                return;
            }
            self.returnCodeBlock(stringValue);
             AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);   //让手机震动
            
        }
    }else{
        NSLog(@"二维码不正确");
        [SVProgressHUD showErrorWithStatus:@"二维码不正确"];
    }
    
   [self dismissViewControllerAnimated:YES completion:^
    {
        [timer invalidate];
        
       NSLog(@"%@",stringValue);
//        if (![stringValue hasPrefix:@"http://cmse.xweb.cn/mobile/index.php?act=member_qrpay&qrcode=qjt"]) {
//           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"外部链接暂不识别" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
//            [alert show];
//            return ;
//        }else if(![stringValue hasPrefix:@"http://cmse.xweb.cn/mobile/index.php?act=member_qrpay&qrcode=qjt"]){
//           
//            }
        //[[NSNotificationCenter defaultCenter] postNotificationName:REFRESHECODE object:stringValue];
    }];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
