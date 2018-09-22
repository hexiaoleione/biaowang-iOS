//
//  ShunFeng.h
//  iwant
//
//  Created by dongba on 16/6/15.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RFJModel.h"
@interface ShunFeng :RFJModel
JProperty(NSString *leaveTime, leaveTime);
JProperty(NSString *personName, personName);
JProperty(NSString *latitude, latitude);
JProperty(NSString *longitude, longitude);
JProperty(NSString *mobile, mobile);
JProperty(NSString *driverMobile, driverMobile);
JProperty(NSString *address, address);
JProperty(NSString *cityCode, cityCode);
JProperty(NSString *townCode, townCode);
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
JProperty(NSString *matRemark, matRemark);
JProperty(NSString *userHeadPath, userHeadPath);
JProperty(NSString *carLength,carLength );
JProperty(NSString * matVolume, matVolume);          //此处传matVolume  是为了之后显示那个carname  后台不用新的字段

JProperty(NSString *matWeight, matWeight);

JProperty(NSString *orderTime, orderTime); //判断30分钟罚款谁的钱

JProperty(NSString *length, length);
JProperty(NSString *wide, wide);
JProperty(NSString *high, high);
JProperty(NSString * cargoSize, cargoSize);//物品件数
JProperty(NSString *carType, carType);

JProperty(NSString *ifAgree, ifAgree);  //是否同意

JProperty(NSString * useTime, useTime); // 用车时间 取货时间

JProperty(NSString *remark, remark);

JProperty(NSString *userName, userName);

JProperty(NSString *billCode, billCode);
JProperty(NSString *businessRemark, businessRemark);
JProperty(NSString *dealPassword, dealPassword);
JProperty(NSString *distance, distance);
JProperty(BOOL driverDelete, driverDelete);
JProperty(NSString *driverId, driverId);
JProperty(NSString *userId, userId);
JProperty(NSString *driverName, driverName);
JProperty(NSString *payType, payType);
JProperty(NSString *publishTime, publishTime);
JProperty(NSString *recId, recId);
JProperty(NSString *transferMoney, transferMoney);
JProperty(NSString *transportationId, transportationId);//（1：快车 2：自行车 3：步行）
JProperty(NSString *transportationName, transportationName);
JProperty(NSString *updateTime, updateTime);
JProperty(NSString *limitTime, limitTime);
JProperty(NSString *finishTime, finishTime);
JProperty(BOOL userDelete, userDelete);
JProperty (NSString *status,status);//状态 0-预发布成功(未支付) 1-支付成功(已支付)  2(已抢单) 3 已取件 4订单取消  5 成功  6 删除 7 已评价
JProperty(NSString *whether, whether);//是否投保
JProperty(NSString *premium, premium);//货物价值
JProperty(NSString *insureCost, insureCost); //保费
JProperty(NSString * replaceMoney, replaceMoney); //代收货款
JProperty(BOOL ifReplaceMoney, ifReplaceMoney); //是否代收货款

JProperty(NSString *category, category); //超过5000投保转物流的

JProperty(NSString *cityName, cityName);  //方便天气传递
JProperty(NSString *replaceUserId, replaceUserId);  //保存找人代付的userId 区分是否找人代付款过
@end
