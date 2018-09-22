//
//  Crowd.h
//  iwant
//
//  Created by dongba on 16/5/10.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "RFJModel.h"

@interface Crowd : RFJModel
JProperty(NSString *fundingMoney, fundingMoney);//已经筹集的金额
JProperty(NSString *fundingName, fundingName);//众筹项目名称
JProperty(NSString *fundingPercent, fundingPercent);//目标股份
JProperty(NSString *fundingUserMount, fundingUserMount);//已参与用户数量
JProperty(NSString *limitMinMoney, limitMinMoney);//起投金额
JProperty(NSString *targetTotalMoney, targetTotalMoney);//目标金额
JProperty(NSString *targetTotalPercent, targetTotalPercent);//目标股份
JProperty(NSString *userFundingMoney, userFundingMoney);//用户个人众筹的金额
JProperty(NSString *userFundingPercent, userFundingPercent);//所占股份
JProperty(NSString *userFundingRanking, userFundingRanking);//排名
JProperty(NSString *userFundingTimes, userFundingTimes);//众筹次数

@end
