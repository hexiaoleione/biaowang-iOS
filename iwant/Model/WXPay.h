//
//  WXPay.h
//  iwant
//
//  Created by dongba on 16/5/21.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "RFJModel.h"

@interface WXPay : RFJModel

/**
 *  向服务器请求签名等数据
 */
@property (nonatomic, copy) NSString *appId;
@property (nonatomic, copy) NSString *nonceStr;
@property (nonatomic, copy) NSString *partnerId;
@property (nonatomic, copy) NSString *prepayid;
@property (nonatomic, copy) NSString *sign;
@property (nonatomic, copy) NSString *timestamp;
@property (nonatomic, copy) NSString *package_;
@end
