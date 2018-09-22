//
//  UtilNotif.h
//  LocationNotice
//
//  Created by mac on 16/6/21.
//  Copyright © 2016年 dubo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface UtilNotif : NSObject



+(UtilNotif *)sharesInstance;


+(void)registAction;
+(void)sendMess:(NSInteger)alertTime body:(NSString *)alertBody noticeDic:(NSDictionary *)notic;

+ (void)cancelLocalNotificationWithKey:(NSString *)key;


@end
