//
//  Package.h
//  Express
//
//  Created by 张宾 on 15/7/15.
//  Copyright (c) 2015年 SCHT. All rights reserved.
//
/*
 9.	我的快递信息：method=myPackage
 */

#import "RFJModel.h"
/*
 businessId: 业务单据ID
 billCode: 单据编号
 matName: 快递货品名称
 expId：快递公司ID
 expName：快递公司名称
 expNo：快递单号
 payed: 是否支付
 courierId：快递员ID
 courierName：快递员名称
 mobile：快递员电话
 status：状态（A-全部，U-未发布，P-已发布，D-已删除，0-已抢单，1-已取件，2-已签收）
 updateTime: 单据发布时间
 */
@interface Package : RFJModel

JProperty(NSString *shipMoney, shipMoney);//运费
JProperty(NSString *needPayMoney, needPayMoney);//需要支付的钱

JProperty(NSInteger businessId, businessId);
JProperty(NSInteger userId, userId);
JProperty(NSInteger userIdTo,userIdTo);

JProperty(NSString *matImageUrl, matImageUrl);

JProperty(NSString *toCityName, toCityName);
JProperty(NSString *fromCityName, fromCityName);
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
JProperty(NSString *weight, weight);
JProperty(NSInteger imageId, imageId);
JProperty(Boolean published, published);//true发布/false 保存
JProperty(NSString *pickTime, pickTime);
JProperty(NSString *publishTime, publishTime);
JProperty(NSString *money, money);
JProperty(NSInteger score, score);
JProperty(NSString *contendTime, contendTime);//抢单时间


JProperty(NSString *billCode, billCode);
//JProperty(NSString *matName, matName);
JProperty(NSString *expId, expId); //公司编号
JProperty(NSString *expName, expName);//公司中文名称
JProperty(NSString *expNo, expNo);  //快递单号
JProperty(NSString *expCode, expCode); //公司拼音
JProperty(NSString *payed, payed);//支付状态
JProperty(NSString *courierId, courierId);
JProperty(NSString *courierName, courierName);
JProperty(NSString *courierMobile, courierMobile);
//状态：0-已发布，1-已接单，2-已取件(已支付),3 发布未被抢 4 快递员已抢单未支付（待取件）
//5-发件人已评价,6-已到货,7-收件人已评价，9-已退件
JProperty(NSString *status, status);//1-已发布未支付  2-已支付 3-到付月结
JProperty(NSString *statusName, statusName);
JProperty(NSString *updateTime, updateTime);
JProperty(NSString *payeType, payType);//支付方式

JProperty(NSInteger payPrepared, payPrepared);//支付方式 1-现付 2-到付 3-月结 0-未设置


JProperty(NSString *insuranceFee, insuranceFee);
JProperty(NSString *insureMoney, insureMoney);
JProperty(NSString *pointId, pointId);//网点ID
JProperty(NSString *pointStatus, pointStatus);// “1”-网点已审核，可支付 “xxxx”(其他字符串)-网点未审核或快递员未审核等等的提示话语
//网点审核状态：0-未审核，1-已审核，2-已禁用
//JProperty(NSString *pointStatus, pointStatus);//y-能用 n-不能用

JProperty(BOOL joinNo, joinNo);



@end
