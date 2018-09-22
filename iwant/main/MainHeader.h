//
//  MainHeader.h
//  iwant
//
//  Created by dongba on 16/3/7.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#ifndef MainHeader_h
#define MainHeader_h
#import "UserManager.h"
#import "SVProgressHUD.h"
#import "ShareView.h"
#import "UIControl+Blocks.h"
#import "WMUserDataManager.h"
#import "RequestManager.h"
#import "Masonry.h"
#import "NSStringAdditions.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "Utils.h"
#import "UIViewController+show.h"
#import "HHAlertView.h"
#import "UIButton+WebCache.h"
#import "BigButton.h"
#import "PXAlertView.h"
#import "UIView+Layout.h"
#import "UIView+SDAutoLayout.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "UIImage+ProportionalFill.h"
#import "WZLBadgeImport.h"
#import "BGFMDB.h"
#import "UIButton+imagePosistion.h"
#import "SDWebImageManager.h"
#import "UtilNotif.h"
#import "JKNotifier.h"



#ifdef DEBUG
# define DLog(fmt, ...) NSLog((@"[文件名:%s]\n" "[函数名:%s]\n" "[行号:%d] \n" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
# define DLog(...);
#endif

#endif /* MainHeader_h */
#define WINDOW_WIDTH                [[UIScreen mainScreen] bounds].size.width
#define WINDOW_HEIGHT               [[UIScreen mainScreen] bounds].size.height
#define BACKGROUND_COLOR            [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0]

#define FONT(A,IFBOLD)                IFBOLD ? [UIFont boldSystemFontOfSize:WINDOW_WIDTH > 320 ? A : A/1.3]: [UIFont systemFontOfSize:WINDOW_WIDTH > 320 ? A : A/1.3]
#define BTN_FONT    [UIFont systemFontOfSize:WINDOW_WIDTH > 320 ? 16 : 16/1.3]
#define RATIO_HEIGHT                 WINDOW_HEIGHT/667.0
#define RATIO_WIDTH                  WINDOW_WIDTH/375.0
#define UserDefault                  [NSUserDefaults standardUserDefaults]
/****************第三方key*****************/
#define QQAPPID                     @"1105302992"



//通知
#define ISLOGIN                     @"isLogin"
#define ISLOGOUT                    @"isLogout"
#define ISPOST                      @"isPost"//一键快递发布了
#define K_DEFAULT_SEND_ADDRESS      @"sendAddress"
#define K_DEFAULT_RECE_ADDRESS      @"receAddress"
#define User_HEAD_URL     @"userHeadUrl"//微信QQ头像
#define WXPAYED                     @"WXPAYED"//微信支付成功
#define GOTOVC                      @"gotoVC"//跳转到某个界面
#define CLASS_NAME                  @"className"//要跳转到的控制器类名
#define OTHER                       @"other_p"//其他属性
#define METHOD_NAME                      @"methodName"//要跳转到的控制器需要调用的方法名
#define REFRESH                     @"refreshData"//刷新数据(顺风)
#define REFRESH_WULIU               @"refresh_wuliu"//我的物流刷新数据
#define JIFENBUY                    @"refresh_jifen"


#define USER_LOC_CHANGED  @"user_location_changed"//用户位置改变
#define USER_LOCATION_LAT @"latitude"//定位
#define USER_LOCATION_LON @"longitude"
#define USER_BMK_LOCATION @"userLocation"//用户百度地图的位置
#define USER_CITY         @"userCity"//用户cityName
#define USER_CITY_CODE    @"userCiteCODE"
#define USER_TOWN_CODE    @"userTownCode"//town县区的code
#define USER_TOWN_NAME    @"userTownName" //区县的name
#define USER_LOCASTR      @"locatStr"//用户位置（根据经纬度反地理编码获得）
#define TRANSFERMONEY     @"transfer"//收到转账--余额增减都需要通知
#define LUCK_MESSAGE      @"luckMessage"//中奖信息
#define COURIER_SUCCESS   @"courier_success"//快递员审核成功
#define ENTER_BACKGROUND  @"applicationDidEnterBackground"//程序进入后台
#define ENTER_FOREGROUND  @"applicationDidEnterForeground"//程序进入前台


//极光推送
#define ACTION_TRANSFERMONEY        @"JPush_transfer_money"//转账
#define COURIER_AUTH                @"Jpush_courier_auth"//快递员审核推送
#define ACTION_SYSTEM_MESSAGE       @"JPush_send_system_message"//系统消息推送
#define DRIVER_AUTH                 @"Jpush_driverr_auth"//镖师审核推送
#define TRUE_TAKE                   @"TRUE_TAKE"//完成押镖
#define NEAR_TASK                   @"NEARBYAFTERPUBLISHTODOWNWINDTASK"//用户发布顺风任务给附近的快递员和镖师推送字段
/**************请求********************/
#define REGIST_PHONE                @"regist_phone"//注册时所填写的手机号
#define REGIST_PASSWORD             @"regist_password"//注册是所填的密码

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0] 
#define COLOR_(R,G,B,a)               [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:a]
#define COLOR_ORANGE_DEFOUT         COLOR_(250, 112, 36, 1)
#define COLOR_MainColor             UIColorFromRGB(0x222231)
#define COLOR_PurpleColor             UIColorFromRGB(0xc1c1fa)
