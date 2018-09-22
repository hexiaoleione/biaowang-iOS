//
//  User.h
//  Express
//
//  Created by 张宾 on 15/7/15.
//  Copyright (c) 2015年 SCHT. All rights reserved.
//

#import "RFJModel.h"

@interface User : RFJModel
JProperty(NSString *payPassword, payPassword);   //支付密码
JProperty(NSString *headPath,headPath);            //头像地址
JProperty(NSString *idCardPath, idCardPath);     // 身份证照片地址
JProperty(NSString *filePath, filePath);        //物品照片
JProperty(int userType, userType);        //用户类型 1-普通用户 2-快递员 3-专车司机 4-物流司机
JProperty(int shopType, shopType);// 商户类型     0 普通用户      1    商户    2  商户禁用
JProperty(NSString *message, message);          //提示消息
JProperty(NSString *userId,userId);             //用户ID
JProperty(NSString *userName,userName);         //用户姓名
JProperty(NSString *mobile,mobile);             //手机号
JProperty(NSString *email,email);               //邮箱
JProperty(NSString *idCard,idCard);             //身份证
JProperty(NSString *idCardFileId,idCardFileId); //身份证照片ID
JProperty(NSInteger ecoin,ecoin);               //积分
JProperty(NSString *birthday,birthday);         //生日
JProperty(NSString *sex,sex);                   //M/F性别 男/女
JProperty(NSInteger headId,headId);             //头像ID
JProperty(NSInteger valid,valid);               //valid：是否有效
JProperty(NSString *userCode, userCode);        //邀请码
JProperty(NSString *balance, balance);        //钱包余额

JProperty(NSInteger score, score);              //（快递员）综合评分

JProperty(NSString *expAlias, expAlias);        //快递公司
JProperty(NSString *expId, expId);              //快递公司ID
JProperty(NSString *pointId, pointId);              //网点编号
JProperty(BOOL completed, completed);        //信息是否完整
JProperty(NSString *realManAuth, realManAuth);        //信息是否完整 Y-通过了 N-未通过 ON-审核中
JProperty(NSString *wlid, wlid);//0-普通用户 1-物流公司 2-物流司机 3-被禁用
JProperty(NSString *agreementType, agreementType);  //普通用户 0或空  海南代理 1  海南用户 2
JProperty(int driverMoney, driverMoney);   //镖师是否交押金  1是交押金  0是没交押金


@end
