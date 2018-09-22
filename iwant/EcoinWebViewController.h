//
//  EcoinWebViewController.h
//  e发快递（测试）
//
//  Created by dongba on 15/11/11.
//  Copyright © 2015年 pro. All rights reserved.
//

#import "BaseLeftViewController.h"

@interface EcoinWebViewController :BaseLeftViewController
typedef enum web_type{
    WEB_HELP,
    WEB_EXPLAIN,   //积分说明
    WEB_SHOPPING_MALL,
    WEB_LUCK_RULE,
    WEB_COURIER_EXPLNE, //快递员诚招区域代理
    WEB_USER_EXPLANE,
    WEB_USER_HELP,
    WEB_WALLET_HELP,
    WEB_BIAOSHI_HELP,
    WEB_USER_RENREN,
    WEB_insureWL,   //物流投保声明
    WEB_insureSF,    //顺风投保声明
    WEB_BiaoShiReward,
    WEB_LOGIN_Reward,
    WEB_Deposit, //保证金说明
    WEB_AccidentInsurance,
}WEB_TYPE;
@property (nonatomic , assign )WEB_TYPE web_type;

//同城模块  投保须知的链接
@property (nonatomic,copy)NSString * insureUrl; // 投保须知的链接

@end
