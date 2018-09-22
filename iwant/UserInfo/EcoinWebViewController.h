//
//  EcoinWebViewController.h
//  e发快递（测试）
//
//  Created by dongba on 15/11/11.
//  Copyright © 2015年 pro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EcoinWebViewController : UIViewController
typedef enum web_type{
    WEB_HELP,
    WEB_EXPLAIN,
    WEB_SHOPPING_MALL,
    WEB_LUCK_RULE,
    WEB_COURIER_EXPLNE, //快递员诚招区域代理
    WEB_USER_EXPLANE,
    WEB_USER_HELP,
    WEB_WALLET_HELP,
    WEB_BIAOSHI_HELP,
    WEB_USER_RENREN,
    WEB_insureWL,   //物流投保声明
    WEB_insureSF    //顺风投保声明
}WEB_TYPE;
@property (nonatomic , assign )WEB_TYPE web_type;
@end
