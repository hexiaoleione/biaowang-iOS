//
//  myBlance.h
//  Express
//
//  Created by dongba on 15/12/26.
//  Copyright © 2015年 SCHT. All rights reserved.
//

#import "RFJModel.h"

@interface myBlance : RFJModel
JProperty(NSString *myBalance, myBalance);
JProperty(NSString *saveMoney, saveMoney);
JProperty(NSString *withdrawableMoney, withdrawableMoney);
JProperty(NSString *transferableMoney, transferableMoney);
JProperty(NSString *waitMoney, waitMoney);


@end
