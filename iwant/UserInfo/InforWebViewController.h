//
//  InforWebViewController.h
//  e发快递（测试）
//
//  Created by pro on 15/9/28.
//  Copyright (c) 2015年 pro. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum info_type{
    INFO_APP_INTRODUCE = 0,
    INFO_COMPANY,
    INFO_LAW,
    INFO_LUCK_HELP,
    INFO_AD_WEB,
    INFO_ZHONGCHOU,
    INFO_RULE,
    INFO_USERER_RULE,
    INFO_DRIVER_RULE,
    INFO_WULIU_RULE,
    INFO_ELSE_RULE,
    INFO_VIDEO,
    INFO_SCOUPON_RULE,
    INFO_RECHARGE_RULE,
    WEB_WL_insure     //物流投保协议新
}INFO_TYPE;

@interface InforWebViewController : UIViewController
@property(nonatomic,assign)INFO_TYPE info_type;

@property (copy, nonatomic)  NSString *adUrl;

@property (copy, nonatomic)  NSString *adName;

@end
