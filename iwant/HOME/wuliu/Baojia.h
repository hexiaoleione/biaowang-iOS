//
//  Baojia.h
//  iwant
//
//  Created by dongba on 16/9/14.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "RFJModel.h"
@interface Baojia : RFJModel

JProperty(NSString *address, address);
JProperty(NSString *companyName, companyName);
JProperty(NSString *distance, distance);
JProperty(NSString *evaluation, evaluation);
JProperty(NSString *matImageUrl, matImageUrl);//头像
JProperty(NSString *publishTime, publishTime);
JProperty(NSString *realManAuth, realManAuth);
JProperty(NSString *shipNumber, shipNumber);
JProperty(NSString *luMessage, luMessage);
JProperty(NSString *mobile, mobile); //电话
JProperty(NSString *companyMobile, companyMobile); //电话
JProperty(NSString *userId, userId); //公司的useid
JProperty(NSString *wlid, wlid);
JProperty(NSString *reportTime, reportTime); //报价时间
JProperty(NSString *yardAddress, yardAddress); //货场地址
JProperty(NSInteger choose, choose);//报价后是否被用户选择  1-已被用户选择

JProperty(BOOL takeCargo,takeCargo );//是否上门取件
JProperty(BOOL sendCargo,sendCargo);//是否送货上门


JProperty(NSString *insureCost, insureCost);  //参加保险需要的付的钱  保险费

JProperty(NSString *takeCargoMoney, takeCargoMoney);  //上门取货费
JProperty(NSString *sendCargoMoney, sendCargoMoney);   //去送货费
JProperty(NSString *cargoTotal, cargoTotal);  //运费
JProperty(NSString *transferMoney, transferMoney);//总的费用

JProperty(NSString *carType, carType); //物流为冷链车加的carType
JProperty(NSString *carName, carName);  //物流的carName
JProperty(NSString *tem, tem); //温度要求


@end
