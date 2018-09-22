//
//  CompanyNews.h
//  iwant
//
//  Created by dongba on 16/5/10.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "RFJModel.h"

@interface CompanyNews : RFJModel
JProperty(NSInteger recId, recId);//主键
JProperty(NSString *newsName, newsName);//新闻名称
JProperty(NSString *newsContent, newsContent);//新闻内容
JProperty(NSString *publishTime, publishTime);//发布时间
JProperty(NSInteger adminId, adminId);//发布管理员id
JProperty(NSString *adminName, adminName);//发布管理员姓名
JProperty(NSString *pictureUrl, pictureUrl);//图片地址
JProperty(NSString *newsUrl, newsUrl);//新闻对应地址
JProperty(BOOL ifDelete, ifDelete);//是否被删除

@end
