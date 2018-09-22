//
//  Business.h
//  Express
//
//  Created by 张宾 on 15/7/19.
//  Copyright (c) 2015年 SCHT. All rights reserved.
//

/*
 8.	保存和发布快递信息：method=saveBusiness
*/
#import "RFJModel.h"

@interface Business : RFJModel

JProperty(NSInteger businessId, businessId);
JProperty(NSInteger userId, userId);
JProperty(NSString *status, status);//支付状态
JProperty(NSString *personName, personName);
JProperty(NSString *personNameTo, personNameTo);
JProperty(NSString *mobile, mobile);
JProperty(NSString *mobileTo, mobileTo);
JProperty(double latitude, latitude);
JProperty(double longitude, longitude);
JProperty(NSString *areaName, areaName);
JProperty(NSString *areaNameTo, areaNameTo);
JProperty(NSString *address, address);
JProperty(NSString *addressTo, addressTo);
JProperty(NSString *fromCity, fromCity);
JProperty(NSString *toCity, toCity);
JProperty(NSString *matType, matType); //货品类型(1代表文件,2代表其他)
JProperty(NSString *matName, matName);
JProperty(NSInteger weight, weight);
JProperty(NSInteger imageId, imageId);
JProperty(Boolean published, published);//true发布/false 保存
JProperty(NSInteger courierId, courierId);//true发布/false 保存

JProperty(NSInteger payPrepared, payPrepared);//支付方式

JProperty(NSString *insuranceFee, insuranceFee);
JProperty(NSString *insureMoney, insureMoney);


@end
