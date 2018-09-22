//
//  DwHelp.m
//  iwant
//
//  Created by 公司 on 2017/11/1.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "DwHelp.h"
#import "RequestConfig.h"
#import "RequestManager.h"
#import "UserManager.h"
@implementation DwHelp

+(NSDictionary *)LHGetStartTime
{
    NSDate *date =[[NSDate date] dateByAddingTimeInterval:60*60];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //    NSDictionary *weekDict = @{@"2" : @"周一", @"3" : @"周二", @"4" : @"周三", @"5" : @"周四", @"6" : @"周五", @"7" : @"周六", @"1" : @"周日"};
    // 日期格式
    NSDateFormatter *fullFormatter = [[NSDateFormatter alloc] init];
    fullFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    // 获取当前几时(晚上23点要把今天的时间做处理)
    /*
     NSCalendarUnitEra                = kCFCalendarUnitEra,
     NSCalendarUnitYear               = kCFCalendarUnitYear,
     NSCalendarUnitMonth              = kCFCalendarUnitMonth,
     NSCalendarUnitDay                = kCFCalendarUnitDay,
     NSCalendarUnitHour               = kCFCalendarUnitHour,
     NSCalendarUnitMinute             = kCFCalendarUnitMinute,
     NSCalendarUnitSecond             = kCFCalendarUnitSecond,
     NSCalendarUnitWeekday            = kCFCalendarUnitWeekday,
     */
    NSInteger currentHour = [calendar component:NSCalendarUnitMinute fromDate:date];
    // 存放周几和时间的数组
    NSMutableArray *weekStrArr = [NSMutableArray array];
    NSMutableArray *detailTimeArr = [NSMutableArray array];
    // 设置合适的时间
    for (int i = 0; i < 30; i++) {
        NSDate *new = [calendar dateByAddingUnit:NSCalendarUnitDay value:i toDate:date options:NSCalendarMatchStrictly];
        //        NSInteger week = [calendar component:NSCalendarUnitWeekday fromDate:new];
        // 周几
        //    NSString *weekStr = weekDict[[NSString stringWithFormat:@"%ld",week]];
        //        NSString *todayOrOther = @"";
        //        if (i == 0) {
        //            todayOrOther = @"今天";
        //        }else if (i == 1) {
        //            todayOrOther = @"明天";
        //        }else if (i == 2){
        //            todayOrOther = @"后天";
        //        }
        // 今天周几 明天周几 后天周几
        //        NSString *resultWeekStr = [NSString stringWithFormat:@"%@ %@",todayOrOther,weekStr];
        NSInteger year = [calendar component:NSCalendarUnitYear fromDate:new];
        NSInteger month = [calendar component:NSCalendarUnitMonth fromDate:new];
        NSInteger day = [calendar component:NSCalendarUnitDay fromDate:new];
        NSString * resultDate = [NSString stringWithFormat:@"%ld月 %ld日",(long)month,(long)day];
        [weekStrArr addObject:resultDate];
        
        // 把符合条件的时间筛选出来
        NSMutableArray *smallArr = [NSMutableArray array];
        for (int hour = 0; hour < 24; hour++) {
            for (int min = 0; min < 60; min ++) {
                if (min % 5 == 0) {
                    NSString *tempDateStr = [NSString stringWithFormat:@"%ld-%ld-%ld %d:%d",year,month,day,hour,min];
                    
                    NSDate *tempDate = [fullFormatter dateFromString:tempDateStr];
                    // 今天 之后的时间段
                    if (i == 0) {
                        if ([calendar compareDate:tempDate toDate:date toUnitGranularity:NSCalendarUnitMinute] == 1) {
                            [smallArr addObject:tempDate];
                        }
                    }else{
                        [smallArr addObject:tempDate];
                    }
                }
            }
        }
        [detailTimeArr addObject:smallArr];
    }
    // 晚上23点把今天对应的周几和今天的时间空数组去掉
    if (currentHour == 23) {
        [weekStrArr removeObjectAtIndex:0];
        [detailTimeArr removeObjectAtIndex:0];
    }
    NSDictionary *resultDic = @{@"week" : weekStrArr , @"time" : detailTimeArr};
    return resultDic;
}

+ (UIViewController *)getCurrentVC{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    UIView * frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    return result;
}

//更新user表  存储的东西
+ (void)updateUser{
    if ([UserManager getDefaultUser].userId) {
        [RequestManager getuserinfoWithuserId:[UserManager getDefaultUser].userId success:^(NSString *reslut) {
        } Failed:^(NSString *error) {
        }];
    }
}

@end
