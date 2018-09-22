//
//  Courier.h
//  Express
//
//  Created by user on 15/8/18.
//  Copyright (c) 2015年 SCHT. All rights reserved.
//

#import "RFJModel.h"

@interface Courier : RFJModel
JProperty(NSString *enableCourier, enableCourier);//是否可用
JProperty(NSString *manager, manager);//管理员名字
JProperty(NSString *streetId, streetId);//街道
JProperty(NSString *uid, uid);



JProperty(NSString  *recId,recId);//录入ID
JProperty(NSString  *courierId, courierId);//快递员ID
JProperty(NSString  *courierName, courierName);//快递员名字
JProperty(NSString  *courierMobile, courierMobile);//快递员电话


JProperty(NSString *businessId, businessId);


//JProperty(NSInteger  *addressId,addressId);//地址ID
JProperty(NSString  *addressType,addressType);//地址类型
JProperty(NSString  *cityCode,cityCode);//城市code
JProperty(NSString  *cityName,cityName);//城市名称
JProperty(NSString  *personName,personName);//发件人/收件人姓名
JProperty(NSString  *addressTo,addressTo);
JProperty(NSString  *areaNameTo,areaNameTo);
JProperty(NSString  *areaName,areaName);//所在区域
JProperty(NSString  *pickupScore, pickupScore);//取件分数
JProperty(NSString  *sendScore, sendScore);//送件分数
JProperty(NSString  *userDelete, userDelete);
JProperty(NSString  *userMobile, userMobile);//用户手机号

JProperty(NSString *publishTime, publishTime);
JProperty(NSString *matName, matName);
JProperty(NSString *distance, distance);


JProperty(NSString  *currentCount , currentCount);//快递员已抢单未完成的单数
JProperty(NSInteger typeId, typeId);// 1-快递员，2-服务点
JProperty(NSInteger userId, userId);// 用户ID
JProperty(NSString *userName, userName);//用户名字
JProperty(NSString *mobile, mobile);//快递员或服务点手机号
JProperty(NSInteger expId, expId);//快递公司ID
JProperty(NSString *expCode, expCode);//快递公司编号
JProperty(NSString *expName, expName);//快递公司名称
JProperty(double latitude, latitude);//纬度
JProperty(double longitude, longitude);
JProperty(NSString *updatetime, updatetime);//最新获取经纬度的时间
JProperty(NSString *address, address);//地图上显示的网点地址

JProperty(NSInteger checked, checked);
JProperty(NSInteger count, count);//快递员抢到单未完成的单数
JProperty(NSInteger ecoin, ecoin);
JProperty(NSString *email, email);
JProperty(NSInteger expType, expType);
JProperty(NSInteger headId, headId);
JProperty(NSString *idCard, idCard);
JProperty(NSString *idCardFileId, idCardFileId);
JProperty(NSString *inviteCode, inviteCode);


JProperty(NSString *password, password);
JProperty(NSString *pointId, pointId);
JProperty(NSString *pointName, pointName);
JProperty(NSString *score, score);
JProperty(NSString *sex, sex);
JProperty(NSString *userCode, userCode);
JProperty(NSString *userType, userType);
JProperty(NSString *valid, valid);

@end
