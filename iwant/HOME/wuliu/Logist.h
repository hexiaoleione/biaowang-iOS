//
//  Logist.h
//  iwant
//
//  Created by dongba on 16/8/29.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "RFJModel.h"

@interface Logist : RFJModel
//物流出发前拍照
JProperty(NSString *firstPicture, firstPicture);
JProperty(NSString *secondPicture, secondPicture);
JProperty(NSString *thirdPicture, thirdPicture);


JProperty(NSString *recId, recId);
JProperty(NSString *cityCode, cityCode);
JProperty(NSString *cityCodeFrom, cityCodeFrom);
JProperty(NSString *cityCodeTo, cityCodeTo);
JProperty(NSString *startPlaceTownCode, startPlaceTownCode);
JProperty(NSString *address, address);
JProperty(NSString *startPlace, startPlace);//货物起始地点
JProperty(NSString *entPlace, entPlace);//货物到达地点
JProperty(NSString *cargoWeight, cargoWeight);//货物重量
JProperty(NSString *cargoCost, cargoCost);  //货物价值
JProperty(NSString *cargoVolume, cargoVolume);//货物体积

JProperty(NSString *length, length);
JProperty(NSString *wide, wide);
JProperty(NSString *high, high);
JProperty(NSString *weight, weight); //新的weight

JProperty(NSString *cargoSize, cargoSize);//新的件数  int

JProperty(NSString *takeTime, takeTime);//取货时间
JProperty(NSString *arriveTime, arriveTime);//到达时间
JProperty(NSString *takeName, takeName);//收货人姓名
JProperty(NSString *takeMobile, takeMobile);//收货电话
JProperty(NSString *remark, remark);//备注
JProperty(NSString *category, category);//货物种类 1 常规货物、2 蔬菜、3 水果、4 牲畜及禽鱼
JProperty(NSString *insurance, insurance);//   //承险类别  1 基本险  2综合险
JProperty(NSString * cargoNumber, cargoNumber);
JProperty(NSString * carNumImg, carNumImg);

JProperty(NSString *publistTime, publistTime);//发布时间
JProperty(NSString *yardAddress, yardAddress); //货场地址
JProperty(NSString *endPlaceName, endPlaceName); //目的地区县

JProperty(NSString *entPlaceCityCode, entPlaceCityCode);//到达城市code
JProperty(NSString *evaluationContent, evaluationContent);//评价内容
//JProperty(NSString *evaluationScore, evaluationScore);//评价分数或使用支付宝微信支付需要支付的钱（用户发布货源信息和物流公司报价都需要付钱）
//JProperty(NSString *evaluationStatus, evaluationStatus);//评价状态或使用余额需要支付的钱（用户发布货源信息和物流公司报价都需要付钱）
#pragma mark - 调试

JProperty(NSString *playMoneyMin, playMoneyMin);//物流模块发布报价时   使用余额支付的平台使用费
JProperty(NSString *playMoneyMax, playMoneyMax);//物流模块发布报价时    使用 微信支付或支付宝支付 的平台使用费
JProperty(BOOL ifQuotion, ifQuotion);   //是否报价

JProperty(NSString *evaluationTag, evaluationTag);//评价标记
JProperty(BOOL ifDelete, ifDelete);
JProperty(int payType, payType);
JProperty(NSString *publishTime, publishTime);
JProperty(NSString *startPlaceCityCode, startPlaceCityCode);
JProperty(NSString *status, status);//物流状态  发布时为0, 报价时为1 支付时为2  接货时为3 货物送达时为4   //物流状态  0 已发布(还没有支付手续费), 1 已报价, 2 已支付, 3 已接货, 4 已送达, 5 已评价  6 用户已支付发布时的手续费
JProperty(NSString *updateTime, updateTime);
JProperty(NSString *userToId, userToId);
JProperty(NSString *quotationNumber, quotationNumber);//报价公司数量
JProperty(NSString *transferMoney, transferMoney);//报价
JProperty(NSString *luMessage, luMessage);//留言
JProperty(NSString *sendName, sendName);//发货人
JProperty(NSString *sendMobile, sendMobile);//发货人电话

JProperty(NSString *sendPerson, sendPerson);//发货人
JProperty(NSString *sendPhone, sendPhone);//发货人电话
JProperty(NSString *appontSpace, appontSpace);//用户指定物流园区
JProperty(NSString *pdfURL, pdfURL); //保单

JProperty(NSString *sendNumber, sendNumber);//发货次数
JProperty(NSString *distance, distance);
JProperty(double latitude, latitude);
JProperty(double longitude, longitude);
JProperty(NSString *userId, userId);
JProperty(NSString *cityName, cityName);
JProperty(NSString *fromCity, fromCity);//城市编码citycode
JProperty(NSString *fromCityName, fromCityName);//发件城市
JProperty(BOOL takeCargo,takeCargo );//是否上门取件
JProperty(BOOL sendCargo,sendCargo);//是否送货上门
JProperty(NSString *cargoName,cargoName);//货物名称
JProperty(NSString *billCode, billCode);//单号

JProperty(NSString *takeCargoMoney, takeCargoMoney);  //上门取货费
JProperty(NSString *sendCargoMoney, sendCargoMoney);   //去送货费
JProperty(NSString *cargoTotal, cargoTotal);  //运费
JProperty(NSString *insureCost, insureCost);   //货物价值保险费

JProperty(NSString *latitudeTo, latitudeTo);
JProperty(NSString *longitudeTo, longitudeTo);

JProperty(NSString *carType, carType); //物流为冷链车加的carType
JProperty(NSString *carName, carName);  //物流的carName
JProperty(NSString *tem, tem); //温度要求

@end
