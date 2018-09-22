//
//  Message.h
//  e发快递（测试）
//
//  Created by dongba on 15/11/6.
//  Copyright © 2015年 pro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RFJModel.h"

@interface Message : RFJModel

JProperty(NSString *messageTitle, messageTitle);
JProperty(NSString *messageDesc, messageDesc);
JProperty(NSString *sendTime, sendTime);
JProperty(NSString *messageId, messageId);
JProperty(NSString *serverId, serverId);
JProperty(NSString *status, status);
JProperty(NSString *userId, userId);
JProperty(Boolean ifReaded, ifReaded);
JProperty(Boolean ifDelete, ifDelete);

JProperty(NSString *messageUrl, messageUrl);



@end
