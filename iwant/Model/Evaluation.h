//
//  Evaluation.h
//  iwant
//
//  Created by pro on 16/6/29.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "RFJModel.h"

@interface Evaluation : RFJModel

JProperty(NSString *userName, userName);

JProperty(NSString *driverId, driverId);

JProperty(NSString *driverMobile, driverMobile);

JProperty(NSString *recId, recId);

JProperty(NSString *userId, userId);

JProperty(NSString *driverScore, driverScore);

JProperty(NSString *driverContent, driverContent);

JProperty(NSString *driverTag, driverTag);

JProperty(NSString *userScore, userScore);

JProperty(NSString *userContent, userContent);

JProperty(NSString *userTag, userTag);

JProperty(NSString *updateTime, updateTime);

JProperty(NSString *userHeadPath, userHeadPath);

JProperty(NSString *evaluateCount, evaluateCount);

JProperty(NSString *driverRouteCount, driverRouteCount);

JProperty(NSString *synthesisEvaluate, synthesisEvaluate);

JProperty(NSString *sex, sex);

@end
