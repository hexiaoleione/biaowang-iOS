//
//  Province.h
//  Express
//
//  Created by 张宾 on 15/7/15.
//  Copyright (c) 2015年 SCHT. All rights reserved.
//

#import "RFJModel.h"

@interface Province : RFJModel

JProperty(NSString *provcode,provcode);
JProperty(NSString *provname,provname);
JProperty(NSString *provalias,provalias);

@end

@interface City : RFJModel

JProperty(NSString *citycode,citycode);
JProperty(NSString *cityname,cityname);
JProperty(NSString *provcode,provcode);
JProperty(NSString *bdcode,bdcode);
@end

@interface Country : RFJModel

JProperty(NSString *countrycode,countrycode);
JProperty(NSString *countryname,countryname);
JProperty(NSString *provcode,provcode);
JProperty(NSString *citycode,citycode);

@end