//
//  WLModel.h
//  iwant
//
//  Created by 公司 on 2017/6/11.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "RFJModel.h"

@interface WLModel : RFJModel
JProperty(NSString *sendPerson, sendPerson); //发件人姓名
JProperty(NSString *sendPhone, sendPhone); //电话
JProperty(NSString *cargoName, cargoName); //物品名称
JProperty(NSString *startPlace, startPlace); //发件地
JProperty(NSString *entPlace, entPlace);  //目的地
JProperty(NSString *takeCargo, takeCargo);  //取货
JProperty(NSString *sendCargo, sendCargo); //送货
JProperty(NSString *carType, carType); //物流为冷链车加的carType
JProperty(NSString *carName, carName);  //物流的carName


JProperty(NSString *cargoVolume, cargoVolume);

JProperty(NSString *cargoWeight, cargoWeight);//带单位的weight
JProperty(NSString *arriveTime, arriveTime); //要求到达时间
JProperty(NSString *takeName, takeName); //收件人姓名
JProperty(NSString *takeMobile, takeMobile);  //电话
JProperty(NSString *latitude, latitude);  //起始地经纬度
JProperty(NSString *longitude, longitude);

JProperty(NSString *startPlaceCityCode, startPlaceCityCode);
JProperty(NSString *entPlaceCityCode, entPlaceCityCode);
JProperty(NSString *startPlaceTownCode, startPlaceTownCode);

JProperty(NSString *latitudeTo, latitudeTo);
JProperty(NSString *longitudeTo, longitudeTo);
JProperty(NSString *appontSpace, appontSpace);  //指定物流园区
JProperty(NSString *cargoNumber, cargoNumber);  //旧的件数  string

JProperty(NSString *endPlaceName, endPlaceName); //市县的名字

JProperty(NSString *length, length);
JProperty(NSString *wide, wide);
JProperty(NSString *high, high);
JProperty(NSString *weight, weight); //新的weight

JProperty(NSString *cargoSize, cargoSize);//新的件数  int

JProperty(NSString *tem, tem); //温度要求


@end
