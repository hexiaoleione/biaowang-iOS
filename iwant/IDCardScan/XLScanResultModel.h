//
//  XLScanResultModel.h
//  IDAndBankCard
//
//  Created by mxl on 2018/4/28.
//  Copyright © 2018年 Leione. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XLScanResultModel : NSObject

@property (assign, nonatomic) int type; //1:正面  2:反面
@property (copy, nonatomic) NSString *code; //身份证号/扫描码
@property (copy, nonatomic) NSString *name; //姓名
@property (copy, nonatomic) NSString *gender; //性别
@property (copy, nonatomic) NSString *nation; //民族
@property (copy, nonatomic) NSString *address; //地址
@property (copy, nonatomic) NSString *issue; //签发机关
@property (copy, nonatomic) NSString *valid; //有效期


@property (nonatomic, copy) NSString *bankNumber;
@property (nonatomic, copy) NSString *bankName;


@property (nonatomic, strong) UIImage *image;
@property (copy, nonatomic) NSString *imageData; //照片base64信息


@property (copy, nonatomic) NSString *errMsg; //错误信息


-(NSString *)toString;

-(BOOL)isOK;

@end
