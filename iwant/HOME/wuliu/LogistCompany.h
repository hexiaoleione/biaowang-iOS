//
//  LogistCompany.h
//  iwant
//
//  Created by dongba on 16/9/17.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "RFJModel.h"

@interface LogistCompany : RFJModel

JProperty(NSString *address, address);
JProperty(NSString *bossName, bossName);
JProperty(NSString *bossPhone, bossPhone);
JProperty(NSString *businessLicense, businessLicense);
JProperty(NSString *companyContent, companyContent);
JProperty(NSString *companyName, companyName);
JProperty(NSString *companyScore, companyScore);
JProperty(NSString *companyTag, companyTag);
JProperty(NSString *evaluationNumber, evaluationNumber);
JProperty(NSString *matImageUrl, matImageUrl);
JProperty(NSString *organizationCode, organizationCode);
JProperty(NSString *registration, registration);
JProperty(NSString *shipNumber, shipNumber);
JProperty(NSString *status, status);



@end
