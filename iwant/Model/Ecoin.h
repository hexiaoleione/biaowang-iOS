//
//  Ecoin.h
//  Express
//
//  Created by 张宾 on 15/8/13.
//  Copyright (c) 2015年 SCHT. All rights reserved.
//

#import "RFJModel.h"
@interface Ecoin : RFJModel
JProperty(NSString *createtime, createtime);
JProperty(NSString *rulename, rulename);
JProperty(NSInteger ecoin, ecoin);
JProperty(NSInteger ecoinMoney, ecoinMoney);
JProperty(NSString *ecoinTime, ecoinTime);
JProperty(NSString *ecoinName, ecoinName);
@end
