//
//  Address.h
//  Express
//
//  Created by 张宾 on 15/7/20.
//  Copyright (c) 2015年 SCHT. All rights reserved.
//
/*
 addressid: 地址ID，唯一标识
 addresstag: 地址标注名称
 provcode: 省份编码
 provname: 省份名称
 citycode: 地市编码
 cityname：地市名称
 address: 详细地址
 defaultaddress: 是否默认
 */

/*
 区分收件人？发件人？寄件人发件人不一样？
 */

#import "RFJModel.h"

@interface Address : RFJModel
JProperty(NSInteger addressId, addressId);
JProperty(NSString *addressTag, addressTag);
JProperty(NSString *cityCode, cityCode);
JProperty(NSString *address, address);
JProperty(NSString *addressType, addressType);
JProperty(NSString *personName, personName);
JProperty(NSString *mobile, mobile);
JProperty(NSString *areaName, areaName);
JProperty(NSString *townCode, townCode);
JProperty(BOOL defaultAddress, defaultAddress);
JProperty(double latitude, latitude);
JProperty(double longitude, longitude);
JProperty(NSString *userId, userId);
JProperty(NSString *cityName, cityName);
JProperty(BOOL ifDefault, ifDefault);//是否默认
JProperty(BOOL ifDelete, ifDelete);//是否删除

//一键快递返回的填充信息
JProperty(NSString *fromCity, fromCity);//城市编码citycode
JProperty(NSString *fromCityName, fromCityName);//发件城市
@end

