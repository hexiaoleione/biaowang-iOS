//
//  Draw.h
//  Express
//
//  Created by dongba on 16/2/18.
//  Copyright © 2016年 SCHT. All rights reserved.
//

#import "RFJModel.h"

@interface Draw : RFJModel
JProperty(NSString *allMoney, allMoney);//奖金池总钱数
JProperty(NSString *luckyNum, luckyNum);//幸运号
JProperty(NSString *drawCount, drawCount);//已经中奖的
JProperty(NSMutableArray  *drawList, drawList);//抽奖显示的号码
JProperty(NSString *leftMoney, leftMoney);//奖金池剩余的
//JProperty(NSString *drawLevel, drawLevel);//中奖等级
//JProperty(NSString *drawNum, drawNum);//幸运号码
//JProperty(NSString *drawMoney, drawMoney);//奖励金额
//JProperty(NSString *endDate, endDate);//本期开始时间
//JProperty(NSString *fromDate, fromDate);//本期结束时间
//JProperty(NSString *publishTime, publishTime);//公布时间
//JProperty(NSMutableArray *daildyNums, daildyNums);//每日摇奖str组合
//JProperty(int leftChance, leftChance);//抽奖机会


@end
