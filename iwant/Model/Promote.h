//
//  Promote.h
//  iwant
//
//  Created by dongba on 16/5/28.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "RFJModel.h"

@interface Promote : RFJModel

//JProperty(NSString *userId, userId);/*快递员ID*/
JProperty(NSString *userName, userName);/*快递员名字*/
//JProperty(NSString *totalNumber, totalNumber);/*快递员总单数*/
//JProperty(double totalMoney, totalMoney);/*总收入*/
//JProperty(NSString *dayNumber, dayNumber);/*今日单数*/
//JProperty(double dayMoney, dayMoney);/*今日收入*/


JProperty(NSString *type, type);/*类型*/
JProperty(NSString *pushime, pushime);//时间
JProperty(NSString *money, money);/*钱数*/
JProperty(NSString *headPath, headPath);/*快递员头像*/

@end
