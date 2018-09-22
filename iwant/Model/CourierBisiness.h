//
//  CourierBisiness.h
//  iwant
//
//  Created by dongba on 16/5/31.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "RFJModel.h"

@interface CourierBisiness : RFJModel

JProperty(NSString *dayMount, dayMount);//日单量
JProperty(NSString *dayMoney, dayMoney);//日金额
JProperty(NSString *weekMount, weekMount);//周单量
JProperty(NSString *weekMoney, weekMoney);//周金额
JProperty(NSString *monthMount, monthMount);//月单量
JProperty(NSString *monthMoney, monthMoney);//月金额
JProperty(NSString *totalMount, totalMount);//总单量
JProperty(NSString *totalMoney, totalMoney);//总金额
JProperty(NSString *creditScore, creditScore);
JProperty(BOOL ifAvalid, ifAvalid);




@end
