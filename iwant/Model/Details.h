//
//  Details.h
//  Express
//
//  Created by 郑 on 15/11/10.
//  Copyright © 2015年 SCHT. All rights reserved.
//

#import "RFJModel.h"

@interface Details : RFJModel

JProperty(NSString *address, address);

JProperty(NSString *addressTo, addressTo);

JProperty(NSString *businessId, businessId);

JProperty(NSString *mobile, mobile);

JProperty(NSString *mobileTo, mobileTo);

JProperty(NSString *personName, personName);

JProperty(NSString *personNameTo, personNameTo);

JProperty(NSString *status, status);

JProperty(NSString *matName, matName);


JProperty(NSString *updateTime, updateTime);

@end
