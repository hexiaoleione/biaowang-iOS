//
//  Calculagraph.h
//  DelCalculagraph
//
//  Created by hehai on 16/11/24.
//  Copyright © 2016年 J. All rights reserved.
//

/**
    使用说明：
 原理：计时器开始运行，每过一秒就发送一次通知（Calculagraph），并将当前计时还剩多少秒作为参数，转换为NSNumber传输。
    在需要的vc中只要注册这个通知，并在计时期间，就会每秒接受一次这个通知。你就更新UI即可，如果为0，则隐藏UI。这样，你那个轮子界面的计时器也就不需要了
 
 [Calculagraph startCalculagraph:120]; 启动，输入描述
 
 */



#import <Foundation/Foundation.h>

@interface Calculagraph : NSObject

+(Calculagraph *)shareCalculagraph;
+(void) startCalculagraph:(NSInteger)seconds;
+(NSInteger) getCurrent;
@end
