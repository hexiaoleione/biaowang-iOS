//
//  DrawReturn.h
//  Express
//
//  Created by dongba on 16/2/19.
//  Copyright © 2016年 SCHT. All rights reserved.
//

#import "RFJModel.h"

@interface DrawReturn : RFJModel
JProperty(int drawLevel, drawLevel);//中奖等级 0-未中奖 1-中了一组数 2-中两组。。。
JProperty(NSString *termId, termId);//抽奖期次
JProperty(NSString *drawTime, drawTime);//中奖金额
JProperty(NSString *drawType, drawType);//1-快递券 2-现金
JProperty(BOOL isUsed, isUsed);//该号码是否用过
JProperty(NSString *message, message);//提示语

@end
