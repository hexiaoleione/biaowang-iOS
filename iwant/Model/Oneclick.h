//
//  Oneclick.h
//  Express
//
//  Created by dongba on 16/1/4.
//  Copyright © 2016年 SCHT. All rights reserved.
//

#import "RFJModel.h"

@interface Oneclick : RFJModel

JProperty(NSString *fromPerson, fromPerson);

JProperty(NSString *mobile, mobile);

JProperty(NSString *address, address);

JProperty(NSString *fromCity, fromCity);

JProperty(NSString *areaName, areaName);

JProperty(NSString *expName, expName);

JProperty(NSString *expId, expId);

JProperty(NSString *courierName, courierName);

JProperty(NSString *courierMobile, courierMobile);

JProperty(NSString *pointId, pointId);

JProperty(NSString *mobileTo, mobileTo);
@end
