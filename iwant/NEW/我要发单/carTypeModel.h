//
//  carTypeModel.h
//  iwant
//
//  Created by 公司 on 2017/7/2.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "RFJModel.h"

@interface carTypeModel : RFJModel

JProperty(NSString * carName, carName);
JProperty(NSString * carType, carType);
JProperty(NSString *cagoType, cagoType);

@end
