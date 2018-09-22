//
//  advermentModel.h
//  iwant
//
//  Created by 公司 on 2016/11/18.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface advermentModel : NSObject

@property (nonatomic ,strong) NSString * advertiseHtmlUrl;   //跳转的详情页
@property (nonatomic ,strong) NSString * advertiseImageUrl;  //图片网址
@property (nonatomic ,strong) NSString * advertiseName; //截取字符串最后一个字符 Y   N

/*
    advertiseHtmlUrl = "http://www.efamax.com/zhuandiculler.html";
    advertiseId = 22;
    advertiseImageUrl = "http://www.efamax.com/mobile/advertisement/advice.png";
    advertiseName = "\U4f18\U60e0\U4fe1\U606fY";
    generateTime = "2016-11-18 12:04";
*/
+ (instancetype)modelWithDic:(NSDictionary *)dic;

@end
