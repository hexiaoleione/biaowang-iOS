//
//  ScanViewController.h
//  cmse
//
//  Created by user on 15-4-7.
//  Copyright (c) 2015年 user. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
typedef void (^ReturnCodeBlock)(NSString *code);

@interface ScanViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate>
{
    int num;
    BOOL upOrdown;
      NSTimer * timer;
}
@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;
@property (nonatomic, retain) UIImageView * line;
@property (nonatomic,copy)ReturnCodeBlock returnCodeBlock;
/*是不是扫描快递员二维码*/
@property (assign, nonatomic)  BOOL isChoice;

@end
