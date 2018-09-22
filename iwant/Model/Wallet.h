//
//  Wallet.h
//  e发快递员
//
//  Created by dongba on 15/12/17.
//  Copyright © 2015年 pro. All rights reserved.
//

#import "RFJModel.h"

@interface Wallet : RFJModel
JProperty(NSString *tradeNo, tradeNo);
JProperty(NSString *tradeMoney, tradeMoney);
JProperty(NSString *tradeType, tradeType);//钱包交易类型
JProperty(NSString *updateTime, updateTime);
JProperty(NSString *status, status);
JProperty(NSString *recordName, recordName);
JProperty(NSString *recordMoney, recordMoney);
JProperty(NSString *recordTime, recordTime);
//转帐描述
JProperty(NSString *recordDesc, recordDesc);


/*我的现金券*/
JProperty(NSString *recordId, recordId);//唯一编号
JProperty(NSString *userCouponId, userCouponId);//唯一编号
JProperty(int couponId, couponId);//couponId;// 现金券类别id id为 1是通用类型   2为顺丰速递  3为专程送 加(4一键快递 		5-抢单发布)
JProperty(NSString *mobile, mobile);//手机号
JProperty(BOOL ifExpire, ifExpire);//是否过期
JProperty(BOOL ifUsed, ifUsed);//是否使用过
JProperty(BOOL ifDeleted, ifDeleted);//是否已删除
JProperty(NSString *expId, expId);//快递公司ID
JProperty(NSString *couponName, couponName);//现金券名称
JProperty(NSString *money, money);//现金券金额
JProperty(NSString *lowerLimit, lowerLimit);//最低消费额度
JProperty(NSString *coupontime, coupontime);//截止日期
JProperty(NSString *conditions, conditions);//现金券类型
JProperty(NSString *expName, expName);//快递公司名称
JProperty(NSString *cityCode, cityCode);//限制城市编号 0-全国


@end
