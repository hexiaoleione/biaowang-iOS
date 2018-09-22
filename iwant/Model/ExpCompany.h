//
//  ExpCompany.h
//  Express
//
//  Created by 张宾 on 15/8/25.
//  Copyright (c) 2015年 SCHT. All rights reserved.
//

#import "RFJModel.h"

@interface ExpCompany : RFJModel
JProperty(NSString *expName, expName);
JProperty(NSString *expCode, expCode);
JProperty(NSString *expId, expId);
JProperty(NSString *nameWord, nameWord);
JProperty(NSString *valid, valid);
JProperty(NSString *favorite, favorite);

@end
