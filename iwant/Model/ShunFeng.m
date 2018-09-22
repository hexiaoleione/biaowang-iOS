//
//  ShunFeng.m
//  iwant
//
//  Created by dongba on 16/6/15.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "ShunFeng.h"

@implementation ShunFeng

  WZLSERIALIZE_COPY_WITH_ZONE()

@end
    /*
- (id)copyWithZone:(NSZone *)zone
{
    ShunFeng *shunfeng = [[ShunFeng allocWithZone:zone] init];

    shunfeng.address = self.address;
    shunfeng.leaveTime = self.leaveTime;
    shunfeng.personName = self.personName;
    shunfeng.latitude = self.latitude;
    shunfeng.longitude = self.longitude;
    shunfeng.mobile = self.mobile;
    shunfeng.driverMobile = self.driverMobile;
    shunfeng.cityCode = self.cityCode;
    shunfeng.townCode = self.townCode;
    shunfeng.fromLatitude = self.fromLatitude;
    shunfeng.fromLongitude = self.fromLongitude;
    shunfeng.personNameTo = self.personNameTo;
    shunfeng.mobileTo = self.mobileTo;
    shunfeng.addressTo = self.addressTo;
    shunfeng.cityCodeTo = self.cityCodeTo;
    shunfeng.toLatitude = self.toLatitude;
    shunfeng.toLongitude = self.toLongitude;
    shunfeng.matName = self.matName;
    shunfeng.matImageUrl = self.matImageUrl;
    shunfeng.matRemark = self.matRemark;
    shunfeng.userHeadPath = self.userHeadPath;
    shunfeng.carLength = self.carLength;
    shunfeng.matVolume = self.matVolume;
    shunfeng.matWeight = self.matWeight;
    shunfeng.orderTime = self.orderTime;
    shunfeng.length = self.length;
    shunfeng.wide = self.wide;
    shunfeng.high = self.high;
    shunfeng.cargoSize = self.cargoSize;
    shunfeng.carType = self.carType;
    shunfeng.ifAgree = self.ifAgree;
    shunfeng.useTime = self.useTime;
    shunfeng.remark = self.remark;
    shunfeng.userName = self.userName;
    shunfeng.billCode = self.billCode;
    shunfeng.businessRemark = self.businessRemark;
    shunfeng.dealPassword = self.dealPassword;
    shunfeng.distance = self.distance;
    shunfeng.driverDelete = self.driverDelete;
    shunfeng.driverId = self.driverId;
    shunfeng.userId = self.userId;
    shunfeng.driverName = self.driverName;
    shunfeng.payType = self.payType;
    shunfeng.publishTime = self.publishTime;
    shunfeng.recId = self.recId;
    shunfeng.transferMoney = self.transferMoney;
    shunfeng.transportationId = self.transportationId;
    shunfeng.transportationName = self.transportationName;
    shunfeng.updateTime = self.updateTime;
    shunfeng.limitTime = self.limitTime;
    shunfeng.finishTime = self.finishTime;
    shunfeng.userDelete = self.userDelete;
    shunfeng.status = self.status;
    shunfeng.whether = self.whether;
    shunfeng.premium = self.premium;
    shunfeng.insureCost = self.insureCost;
    shunfeng.replaceMoney = self.replaceMoney;
    shunfeng.ifReplaceMoney = self.ifReplaceMoney;
    shunfeng.category = self.category;
    return shunfeng;
}

*/

//#define WZLSERIALIZE_COPY_WITH_ZONE()  \
//\
///*如果不实现copyWithZone:方法，则[personObject copy]时会崩溃*/   \
//- (id)copyWithZone:(NSZone *)zone   \
//{   \
//NSLog(@"%s",__func__);  \
//id copy = [[[self class] allocWithZone:zone] init];    \
//Class cls = [self class];   \
//while (cls != [NSObject class]) {  \
///*判断是自身类还是父类*/    \
//BOOL bIsSelfClass = (cls == [self class]);  \
//unsigned int iVarCount = 0; \
//unsigned int propVarCount = 0;  \
//unsigned int sharedVarCount = 0;    \
//Ivar *ivarList = bIsSelfClass ? class_copyIvarList([cls class], &iVarCount) : NULL;/*变量列表，含属性以及私有变量*/   \
//objc_property_t *propList = bIsSelfClass ? NULL : class_copyPropertyList(cls, &propVarCount);/*属性列表*/   \
//sharedVarCount = bIsSelfClass ? iVarCount : propVarCount;   \
//\
//for (int i = 0; i < sharedVarCount; i++) {  \
//const char *varName = bIsSelfClass ? ivar_getName(*(ivarList + i)) : property_getName(*(propList + i)); \
//NSString *key = [NSString stringWithUTF8String:varName];    \
///*valueForKey只能获取本类所有变量以及所有层级父类的属性，不包含任何父类的私有变量(会崩溃)*/  \
//id varValue = [self valueForKey:key];   \
//NSArray *filters = @[@"superclass", @"description", @"debugDescription", @"hash"]; \
//if (varValue && [filters containsObject:key] == NO) { \
//[copy setValue:varValue forKey:key];    \
//}   \
//}   \
//free(ivarList); \
//free(propList); \
//cls = class_getSuperclass(cls); \
//}   \
//return copy;    \
//}


