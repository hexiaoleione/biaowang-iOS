//
//  ActivityModel.h
//  hhhh
//
//  Created by yaojiaqi on 2016/11/19.
//  Copyright © 2016年 Shangji Online (Beijing) Network Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityModel : NSObject
/*
 private Integer activityUrlStatus;    //活动APP跳转链接  1-领取现金券   2-签到    3—抽奖   0  不跳转
 
 //2017.6.25
 private String gotoUrl;     //跳转的web页面
 private String imagesUrl;     //活动图片
 */

@property (nonatomic , strong) NSString *activityUrlStatus; //跳转链接
@property (nonatomic , strong) NSString *gotoUrl; //活动web页面
@property (nonatomic, strong)NSString * imagesUrl;//活动图片

+ (instancetype)modelWithDic:(NSDictionary *)dic;

@end
