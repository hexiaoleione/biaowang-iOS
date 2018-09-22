//
//  HuoChangModel.h
//  iwant
//
//  Created by 公司 on 2017/1/4.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "RFJModel.h"

@interface HuoChangModel : RFJModel

JProperty(NSString *locationAddress, locationAddress); //地址（定位获得）
JProperty(NSString *address, address);//详细地址
JProperty(NSString *recId, recId);//地址编号
JProperty(BOOL ifDefault, ifDefault); //是否默认
JProperty(BOOL ifDelete, ifDelete); //是否删除
JProperty(NSString *cityCode, cityCode);
JProperty(NSString *latitude, latitude);//纬度
JProperty(NSString *longitude, longitude);//经度



@end
