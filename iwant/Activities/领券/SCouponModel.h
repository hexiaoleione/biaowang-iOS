//
//  SCouponModel.h
//  iwant
//
//  Created by 公司 on 2017/4/19.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "RFJModel.h"

@interface SCouponModel : RFJModel
JProperty(NSString *couponName, couponName);//现金券的名字
JProperty(NSString *couponFrom, couponFrom);//现金券来源
JProperty(NSString *conditionId, conditionId);//现金券来源类型
JProperty(NSString *couponCount, couponCount);//现金券数量
JProperty(NSString *money, money);//现金券jine


@end
