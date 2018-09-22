//
//  ShunFengBiaoShi.h
//  iwant
//
//  Created by pro on 16/6/25.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "RFJModel.h"

@interface ShunFengBiaoShi:RFJModel

JProperty(NSString *userId, userId);
JProperty(NSString *personName, personName);
JProperty(NSString *latitude, latitude);
JProperty(NSString *longitude, longitude);
JProperty(NSString *mobile, mobile);
JProperty(NSString *address, address);
JProperty(NSString *cityCode, cityCode);
JProperty(NSString *fromLatitude, fromLatitude);
JProperty(NSString *fromLongitude, fromLongitude);
JProperty(NSString *personNameTo, personNameTo);
JProperty(NSString *mobileTo, mobileTo);
JProperty(NSString *addressTo, addressTo);
JProperty(NSString *cityCodeTo, cityCodeTo);
JProperty(NSString *toLatitude, toLatitude);
JProperty(NSString *toLongitude, toLongitude);
JProperty(NSString *matName, matName);
JProperty(NSString *matImageUrl, matImageUrl);
JProperty(NSString *matRemark, matRemark);  //备注
JProperty(NSString *matWeight, matWeight);
JProperty(NSString *userHeadPath, userHeadPath);
JProperty(NSString *status, status);//状态 0-预发布成功(未支付) 1-支付成功(已支付)  2(已抢单) 3 已取件 4 订单取消  5 成功  6 删除 7 已评价
JProperty(BOOL   ifReplaceMoney, ifReplaceMoney); //是否代收货款
JProperty(NSString *replaceMoney, replaceMoney); //代收款金额
JProperty(BOOL ifTackReplace, ifTackReplace); //是否已经收款
JProperty(NSString *useTime, useTime);  //要求取货用车时间
JProperty(NSString * cargoSize, cargoSize); //物品的件数
JProperty(NSString * carLength, carLength);
JProperty(NSString * matVolume,matVolume);
JProperty(NSString *length, length);
JProperty(NSString *wide, wide);
JProperty(NSString *high, high);
JProperty(NSString *limitTime, limitTime);
JProperty(NSString *finishTime, finishTime);
JProperty(NSString * readyTime,readyTime);//就位时间
JProperty(NSString * ifAgree, ifAgree);

JProperty(NSString * carType, carType); //要求车型

JProperty(NSString *remark, remark);
JProperty(NSString *userName, userName);

JProperty(NSString *recId, recId);

JProperty(NSString *billCode, billCode);
JProperty(NSString *businessRemark, businessRemark);
JProperty(NSString *dealPassword, dealPassword);
JProperty(NSString *distance, distance);
JProperty(BOOL driverDelete, driverDelete);
JProperty(NSString *driverId, driverId);
JProperty(NSString *driverName, driverName);
JProperty(NSString *payType, payType);
JProperty(NSString *publishTime, publishTime);
JProperty(NSString *transferMoney, transferMoney);
JProperty(NSString *transportationId, transportationId);//（1：快车 2：自行车 3：步行）
JProperty(NSString *transportationName, transportationName);
JProperty(NSString *updateTime, updateTime);
JProperty(BOOL userDelete, userDelete);

JProperty(NSString *whether, whether);//是否投保
JProperty(NSString *premium, premium);//货物价值
JProperty(NSString *carNumber, carNumber);  //车牌号码


@end
