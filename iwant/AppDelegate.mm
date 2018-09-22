//
//  AppDelegate.m
//  iwant
//
//  Created by dongba on 16/3/6.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "AppDelegate.h"
#import "MainHeader.h"
#import "IQKeyboardManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import "MainHeader.h"
#import "WalletViewController.h"
#import "ExpressRequest.h"
#import "WXApi.h"
#import "AssessViewController.h"
#import "WXPayManager.h"
#import "MyMessageViewController.h"
//#import "ChatViewController.h"
#import "EvaluateViewController.h"
#import "ShunFengViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <UserNotifications/UserNotifications.h>
#import "CouponViewController.h"
#import "HomeViewController.h"
#import "WeChectLoginViewController.h"
#import "MMZCViewController.h"
#import "PersonalWealthVC.h"
#import "BiaoShiRewardVC.h"
#import "LeftMenuViewController.h"
#import "iflyMSC/IFlyMSC.h"

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#define BUGLY_APP_ID @"900033832"
#define APPID_VALUE  @"59ab8e3c"

@interface AppDelegate ()<WXApiDelegate,CLLocationManagerDelegate,BMKGeneralDelegate,UNUserNotificationCenterDelegate,UITabBarControllerDelegate,JPUSHRegisterDelegate>{
    BMKMapManager *_mapManager;
    NSDictionary *_adDic;
    BOOL _isNeedUpdate;
    NSString *_updateContent;
    CLLocationManager *_locationManager;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self rootHomeController];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.window makeKeyAndVisible];
    
    [self setNetWork];
    [self setBaiduMap];
   
    //设置警告框样式
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    [self setOpenShareKey];
    [self setKeyBoard];
    //极光
    [self configJPush:launchOptions];

    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidLogin:)
                          name:kJPFNetworkDidLoginNotification
                        object:nil];
  
    [WXApi registerApp:@"wx2a86c51f04882974" withDescription:@"我要"];
    [self checkVersion];
    //更新user表  更新用户信息
    [self updateUser];
    
    [JPUSHService setBadge:0];
    [application setApplicationIconBadgeNumber:0];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isJustLaunch"];
    
    //设置sdk的log等级，log保存在下面设置的工作路径中
    [IFlySetting setLogFile:LVL_ALL];
    
    //打开输出在console的log开关
    [IFlySetting showLogcat:YES];
    
    //设置sdk的工作路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    [IFlySetting setLogFilePath:cachePath];
    
    //创建语音配置,appid必须要传入，仅执行一次则可
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",APPID_VALUE];
    
    //所有服务启动前，需要确保执行createUtility
    [IFlySpeechUtility createUtility:initString];
    
    return YES;
}


- (void)networkDidLogin:(NSNotification *)notification {
    NSLog(@"已登录");
    //极光推送
    if ([UserManager getDefaultUser].userId) {
        NSString *tag = @"";
        switch ([UserManager getDefaultUser].userType) {
            case 1:
                tag = @"user";
                break;
            case 2:
                tag = @"courier";
                break;
            case 3:
                tag = @"driver";
                break;
                
            default:
                break;
        }
        [JPUSHService setTags:[NSSet setWithArray:@[tag]] alias:[UserManager getDefaultUser].userId fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
            NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags , iAlias);
        }];
    }
}

#pragma mark   -------创建加载首页
- (void)rootHomeController{
    [[UINavigationBar appearance] setTranslucent:NO];
    HomeViewController *centerVC = [[HomeViewController alloc] init];
    UINavigationController *centerNav = [[UINavigationController alloc] initWithRootViewController:centerVC];
    LeftMenuViewController *leftVC = [[LeftMenuViewController alloc] init];
    MMDrawerController *rootVC = [[MMDrawerController alloc] initWithCenterViewController:centerNav leftDrawerViewController:leftVC];
    
    [rootVC setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    [rootVC setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    self.window.rootViewController = rootVC;
}
-(void)setEaseWithapplication:(UIApplication *)application Options:(NSDictionary *)launchOptions{
    //distrbuition
//    [[EaseMob sharedInstance] registerSDKWithAppKey:@"scht#iwant" apnsCertName:@"distrbuition"];
    
//    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    //    //代码注册离线推送  您注册了推送功能，iOS 会自动回调以下方法，得到deviceToken，您需要将deviceToken传给SDK
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        
        if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
            [application registerForRemoteNotifications];
            UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge |
            UIUserNotificationTypeSound |
            UIUserNotificationTypeAlert;
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
            [application registerUserNotificationSettings:settings];
        }
        else{
            UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
            UIRemoteNotificationTypeSound |
            UIRemoteNotificationTypeAlert;
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
        }
        
    }
    //    实现注册,收到信息等等的回调代理
//    [[EaseMob sharedInstance].chatManager removeDelegate:self];
//    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[NSNotificationCenter defaultCenter] postNotificationName:ENTER_BACKGROUND object:application];
//    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
    //上传位置，只持续3分钟
    if ([UserManager getDefaultUser].userId) {
        /** 开始定位 */
        [_locationManager startUpdatingLocation];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
//    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
    [[NSNotificationCenter defaultCenter] postNotificationName:ENTER_FOREGROUND object:application];
    [_locationManager stopUpdatingLocation];
    
    //向后台查询微信支付结果 ios9 手机左上角返回功能导致微信不会走回调，故每次支付完回到程序调用[WXPayManager nextStep]去后台查询微信后台返回的支付结果
    if ([UserManager getDefaultUser].userId) {
        [WXPayManager nextStep];
    }
    application.applicationIconBadgeNumber = 0;
}
- (void)didReceiveMessageNotification:(NSNotification *)notification {
    [UIApplication sharedApplication].applicationIconBadgeNumber =
    [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
}
//程序启动进入程序
- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self checkVersion];
    //小红点置零
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    //极光推送
    if ([UserManager getDefaultUser].userId) {
        NSString *tag = @"";
        switch ([UserManager getDefaultUser].userType) {
            case 1:
                tag = @"user";
                break;
            case 2:
                tag = @"courier";
                break;
            case 3:
                tag = @"driver";
                break;
            default:
                break;
        }
        [JPUSHService setTags:[NSSet setWithArray:@[tag]] alias:[UserManager getDefaultUser].userId fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
            NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags , iAlias);
        }];
        
        //环信注册登陆
        [self EaseMobLogin];
    }

}


- (void)applicationWillTerminate:(UIApplication *)application {
//    [[EaseMob sharedInstance] applicationWillTerminate:application];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark -- 从其他应用返回回调
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    //跳转支付宝钱包进行支付，处理支付结果
    //在控制器中已处理，暂时无用
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        
        NSLog(@"alipayresult = %@",resultDic);
        //        [[NSNotificationCenter defaultCenter]postNotificationName:k_NOTIFACITION_APP_ACTIVE_FROM_ALIPAY object:@"alipay"];
    }];
    //第二步：添加回调
    if ([OpenShare handleOpenURL:url]|[WXApi handleOpenURL:url delegate:self]) {
        return YES;
    }
    //这里可以写上其他OpenShare不支持的客户端的回调，比如支付宝等。
//    [[IFlySpeechUtility getUtility] handleOpenURL:url];
    return YES;
}

#pragma mark WXApiDelegate ios9返回功能导致微信不会走回调，故每次支付完回到程序调用[WXPayManager nextStep]查询后台支付结果
-(void) onResp:(BaseResp*)resp{
    if([resp isKindOfClass:[PayResp class]])
    {
        [SVProgressHUD dismiss];
        //        WXSuccess           = 0,    /**< 成功    */
        //        WXErrCodeCommon     = -1,   /**< 普通错误类型    */
        //        WXErrCodeUserCancel = -2,   /**< 用户点击取消并返回    */
        //        WXErrCodeSentFail   = -3,   /**< 发送失败    */
        //        WXErrCodeAuthDeny   = -4,   /**< 授权失败    */
        //        WXErrCodeUnsupport  = -5,   /**< 微信不支持    */
        
        //        WXPayManager *manager = [WXPayManager shareManager];
        //支付返回结果，实际支付结果需要去微信服务器端查询
        NSString *strMsg,*strTitle = [NSString stringWithFormat:@"支付结果"];
        switch (resp.errCode) {
            case WXSuccess:
                //                strMsg = @"支付结果：成功！";
                //                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                [WXPayManager nextStep];
                break;
            case WXErrCodeUserCancel:{
                strMsg = @"支付结果：用户取消支付";
                NSLog(@"支付取消－PayError，retcode = %d", resp.errCode);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
                
                break;
            default:{
                
                strMsg = @"支付结果：失败，授权失败或微信服务器出错或是微信不支持";
                NSLog(@"支付失败－PayError，retcode = %d", resp.errCode);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
    }
}

#pragma mark -- 自定义方法
- (void) setBaiduMap{
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"CoRlKOQ8CFUxP9cbI727zhRy"  generalDelegate:self];
    if (!ret) {
        NSLog(@"百度地图manager start failed!");
    }else{
        NSLog(@"百度地图启动成功");
    }
}

- (void)setOpenShareKey{
    [OpenShare connectQQWithAppId:@"1105302992"];
    //    [OpenShare connectWeiboWithAppKey:@"*********"];
    [OpenShare connectWeixinWithAppId:@"wx2a86c51f04882974"];
    
    //iphone7
    //  [OpenShare connectWeixinWithAppId:@"wx9e6f9ed0daf1a57b"];
}

- (void)setKeyBoard{
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;//取消keyboard
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
//    [IQKeyboardManager sharedManager].toolbarDoneBarButtonItemText = @"🔽";
}
- (void)checkVersion{
    //强制更新
    if (_isNeedUpdate) {
        return;
    }
    NSString *locaVersion =[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    [RequestManager getVersionUserId:@"" typeId:@"" content:@"" Success:^(NSDictionary *reslut) {
        NSString *str = [reslut valueForKey:@"iosVersion"];
        _updateContent = reslut[@"updateContent"];
        NSInteger _ifUpdate = [[reslut valueForKey:@"ifUpdate"] integerValue];
        NSComparisonResult result = [str compare:locaVersion];
        
        //升序排列  或者版本号相等时候  都不需要更新
        if (result == NSOrderedAscending || result == NSOrderedSame) {
            nil;
        }else{
            if (_ifUpdate == 0) {
                //用 ifShow 字段判断是否已经弹出过界面
                NSString * ifShow = [[NSUserDefaults standardUserDefaults] objectForKey:@"ifShow"];
                NSString * iosVersion =[[NSUserDefaults standardUserDefaults] objectForKey:@"iosVersion"];
                if ([ifShow isEqualToString:@"1"] && [str isEqualToString:iosVersion]) {
                }else{
                    [self updateAlertWithVersion:str];
                }
            }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"%@",reslut[@"updateContent"]] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *update = [UIAlertAction actionWithTitle:@"去更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/e-fa/id1031426530?l=zh&ls=1&mt=8"]];
            }];
            [alert addAction:update];
            [[Utils getCurrentVC] presentViewController:alert animated:YES completion:nil];
        }
     }
    } Failed:^(NSString *error) {
    }];
}

- (void)updateAlertWithVersion:(NSString *)str{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"\"镖王\"有新的版本,是否前去更新？\n%@",_updateContent] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"暂不更新" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
       //需要处理一下，避免不强制更新的时候重复弹框
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"ifShow"];
        [[NSUserDefaults standardUserDefaults] setValue:str forKey:@"iosVersion"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
    UIAlertAction *update = [UIAlertAction actionWithTitle:@"去更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/e-fa/id1031426530?l=zh&ls=1&mt=8"]];
    }];
    
    [alert addAction:cancle];
    [alert addAction:update];
    [[Utils getCurrentVC] presentViewController:alert animated:YES completion:nil];
}
//注册APNS
- (void)configJPush:(NSDictionary*)launchOptions
{
#pragma mark 极光推送
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
#endif
    } else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }
    else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    //需进行注册后才能运行下面对应的程序
    [JPUSHService setupWithOption:launchOptions appKey:@"29c778ec2a50f6127b579e4a"
                          channel:nil
                 apsForProduction:YES
            advertisingIdentifier:nil];
    
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if (resCode == 0) {
            NSLog(@"registrationID获取成功：%@",registrationID);
        } else {
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
}

- (void)getPushFromLaunch:(NSDictionary*)launchOptions
{
    // apn 内容获取：
    NSDictionary *remoteNotification = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    NSLog(@"%@",remoteNotification);
//     [PXAlertView showAlertWithTitle:[NSString stringWithFormat:@"apns 内容获取：%@",remoteNotification]];
    
}
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    [application registerForRemoteNotifications];
}

#pragma mark -  上传deviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required -    DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}
#pragma mark -  实现注册APNs失败接
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *) error {
    //Optional
    NSLog(@"获取DeviceToken失败！！！");
    NSLog(@"Error: %@", error);
}
#pragma mark - 添加处理APNs通知回调方法 代理回调两个方法
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]
        ]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执 这个 法,选择 是否提醒 户,有Badge、Sound、Alert三种类型可以选择设置
    // IOS 7 Support Required
    NSString *action = [userInfo objectForKey:@"action"];
    NSString *message = [userInfo objectForKey:@"message"];
    [PXAlertView showAlertWithTitle:@"温馨提示" message:message completion:^(BOOL cancelled, NSInteger buttonIndex) {
        HomeViewController * faVC = [[HomeViewController alloc]init];
        
        if ([action isEqualToString:ACTION_TRANSFERMONEY]) {
            if ([(UIViewController *)((UINavigationController *)[Utils getCurrentVC].childViewControllers.lastObject) isKindOfClass:[PersonalWealthVC class]]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:TRANSFERMONEY object:nil];
            }else{
                //[(UINavigationController *)[Utils getCurrentVC] pushViewController:[[PersonalWealthVC alloc]init] animated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:TRANSFERMONEY object:nil];
                //                [faVC.navigationController pushViewController:[[PersonalWealthVC alloc]init] animated:YES];
            }
        }else if ([action isEqualToString:COURIER_AUTH]) {
            NSString *userType = [NSString stringWithFormat:@"%@",[userInfo valueForKey:@"flag"]];
            //userType是2的时候表示快递员审核通过啦 发送审核通过的通知  界面上展示变化
            if ([userType isEqualToString:@"2"]) {
                [JPUSHService setTags:[NSSet setWithArray:@[@"courier"]] alias:[UserManager getDefaultUser].userId fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags , iAlias);
                }];
            }
            //更新user表的数据 界面判断需要
            [self updateUser];
        }else if ([action isEqualToString:ACTION_SYSTEM_MESSAGE]){
            [[NSNotificationCenter defaultCenter] postNotificationName:action object:nil];
            [faVC.navigationController pushViewController:[[MyMessageViewController alloc]init] animated:YES];
        }else if ([action isEqualToString:@"CouponViewController"]){
            [[NSNotificationCenter defaultCenter] postNotificationName:action object:nil];
            [faVC.navigationController pushViewController:[[NSClassFromString(@"SCouponVC") alloc] init] animated:YES];
        }else if ([action isEqualToString:DRIVER_AUTH]){
            [faVC.navigationController pushViewController:[[NSClassFromString(@"BiaoShiRewardVC") alloc] init] animated:YES];
            [self updateUser];
            [JPUSHService setTags:[NSSet setWithArray:@[@"driver"]] alias:[UserManager getDefaultUser].userId fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags , iAlias);
            }];
            
        }else if ([action isEqualToString:TRUE_TAKE]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:action object:nil];
            NSString *userid_recid = [NSString stringWithFormat:@"%@",[userInfo valueForKey:@"flag"]];
            NSArray *arr  = [userid_recid componentsSeparatedByString:@"_"];
            NSString *userId = arr[0];
            NSString *recId = arr[1];
            EvaluateViewController * VC = [[EvaluateViewController alloc] init];
            VC.userId = userId;
            VC.recId = recId;
            [faVC.navigationController pushViewController:VC animated:YES];
        }else if ([action isEqualToString:NEAR_TASK]){
            [[NSNotificationCenter defaultCenter] postNotificationName:action object:nil];
        }
        else {
            [[NSNotificationCenter defaultCenter] postNotificationName:action object:nil];
            //收到推送,推送有类名就跳转到那个界面
            Class OneVC = NSClassFromString([userInfo valueForKey:@"className_ios"]);
            SEL method = NSSelectorFromString([userInfo valueForKey:@"method_ios"]);
            if (!OneVC) {
                return ;
            }
            UIViewController *vc = [OneVC new];
            //有函数名，就在跳转到的界面执行此函数
            if (![(UIViewController *)((UINavigationController *)[Utils getCurrentVC].childViewControllers.lastObject) isKindOfClass:[OneVC class]]) {
                [faVC.navigationController pushViewController:vc animated:YES];
            }else{
                if (method) {
                    [vc performSelectorOnMainThread:method withObject:nil waitUntilDone:1.];
                }
            }
        }
    }];
    
    [JPUSHService handleRemoteNotification:userInfo];
}
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    HomeViewController * faVC = [[HomeViewController alloc]init];    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    
    NSString *action = [userInfo objectForKey:@"action"];
        //    NSString *message = [userInfo objectForKey:@"message"];
    if ([action isEqualToString:ACTION_TRANSFERMONEY]) {
        if ([(UIViewController *)((UINavigationController *)[Utils getCurrentVC].childViewControllers.lastObject) isKindOfClass:[PersonalWealthVC class]]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:TRANSFERMONEY object:nil];
        }else{
            //[(UINavigationController *)[Utils getCurrentVC] pushViewController:[[PersonalWealthVC alloc]init] animated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:TRANSFERMONEY object:nil];
            //                [faVC.navigationController pushViewController:[[PersonalWealthVC alloc]init] animated:YES];
        }
    }else if ([action isEqualToString:COURIER_AUTH]) {
        NSString *userType = [NSString stringWithFormat:@"%@",[userInfo valueForKey:@"flag"]];
        //userType是2的时候表示快递员审核通过啦 发送审核通过的通知  界面上展示变化
        if ([userType isEqualToString:@"2"]) {
            [JPUSHService setTags:[NSSet setWithArray:@[@"courier"]] alias:[UserManager getDefaultUser].userId fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags , iAlias);
            }];
        }
        //更新user表的数据 界面判断需要
        [self updateUser];
    }else if ([action isEqualToString:ACTION_SYSTEM_MESSAGE]){
        [[NSNotificationCenter defaultCenter] postNotificationName:action object:nil];
        [faVC.navigationController pushViewController:[[MyMessageViewController alloc]init] animated:YES];
    }else if ([action isEqualToString:@"CouponViewController"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:action object:nil];
        [faVC.navigationController pushViewController:[[NSClassFromString(@"SCouponVC") alloc] init] animated:YES];
    }else if ([action isEqualToString:DRIVER_AUTH]){
        [faVC.navigationController pushViewController:[[NSClassFromString(@"BiaoShiRewardVC") alloc] init] animated:YES];
        [self updateUser];
        [JPUSHService setTags:[NSSet setWithArray:@[@"driver"]] alias:[UserManager getDefaultUser].userId fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
            NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags , iAlias);
        }];
        
    }else if ([action isEqualToString:TRUE_TAKE]){
        
        [[NSNotificationCenter defaultCenter] postNotificationName:action object:nil];
        NSString *userid_recid = [NSString stringWithFormat:@"%@",[userInfo valueForKey:@"flag"]];
        NSArray *arr  = [userid_recid componentsSeparatedByString:@"_"];
        NSString *userId = arr[0];
        NSString *recId = arr[1];
        EvaluateViewController * VC = [[EvaluateViewController alloc] init];
        VC.userId = userId;
        VC.recId = recId;
        [faVC.navigationController pushViewController:VC animated:YES];
    }else if ([action isEqualToString:NEAR_TASK]){
        [[NSNotificationCenter defaultCenter] postNotificationName:action object:nil];
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:action object:nil];
        //收到推送,推送有类名就跳转到那个界面
        Class OneVC = NSClassFromString([userInfo valueForKey:@"className_ios"]);
        SEL method = NSSelectorFromString([userInfo valueForKey:@"method_ios"]);
        if (!OneVC) {
            return ;
        }
        UIViewController *vc = [OneVC new];
        //有函数名，就在跳转到的界面执行此函数
        if (![(UIViewController *)((UINavigationController *)[Utils getCurrentVC].childViewControllers.lastObject) isKindOfClass:[OneVC class]]) {
            [faVC.navigationController pushViewController:vc animated:YES];
        }else{
            if (method) {
                [vc performSelectorOnMainThread:method withObject:nil waitUntilDone:1.];
            }
        }
    }
    completionHandler(); // 系统要求执 这个 法

}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
//    NSLog(@"推送内容：Received remote notification with userInfo %@", userInfo);
    //         // 取得 APNs 标准信息内容
    //         NSDictionary *aps = [userInfo valueForKey:@"aps"];
    //         NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
    //         NSInteger badge = [[aps valueForKey:@"badge"] integerValue]; //badge数量
    //         NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
    //         // 取得自定义字段内容
    //         NSString *customizeField1 = [userInfo valueForKey:@"extras"]; //自定义参数，key是自己定义的
    //
    //         NSLog(@"content =[%@], badge=[%ld], sound=[%@], customize field =[%@]",content,(long)badge,sound,customizeField1);
    //
    //        NSString *action = [userInfo objectForKey:@"action"];
    //        NSString *message = [userInfo objectForKey:@"message"];
    //        [PXAlertView showAlertWithTitle:@"温馨提示" message:message completion:^(BOOL cancelled, NSInteger buttonIndex) {
    //            if ([action isEqualToString:ACTION_TRANSFERMONEY]) {
    //                if ([(UIViewController *)((UINavigationController *)[Utils getCurrentVC].childViewControllers.lastObject) isKindOfClass:[WalletViewController class]]) {
    //                    [[NSNotificationCenter defaultCenter] postNotificationName:TRANSFERMONEY object:nil];
    //                }else{
    //                    [(UINavigationController *)[Utils getCurrentVC] pushViewController:[[WalletViewController alloc]init] animated:YES];
    //                }
    //            }else if ([action isEqualToString:COURIER_AUTH]) {
    //                NSString *userType = [userInfo valueForKey:@"userType"];
    //                if ([userType isEqualToString:@"2"]) {
    //                    [JPUSHService setTags:[NSSet setWithArray:@[@"courier"]] alias:[UserManager getDefaultUser].userId fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
    //                        NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags , iAlias);
    //                    }];
    //
    //                    if ([(UIViewController *)((UINavigationController *)[Utils getCurrentVC].childViewControllers.lastObject) isKindOfClass:[FaBiaoViewController class]]) {
    //                        [[NSNotificationCenter defaultCenter] postNotificationName:COURIER_SUCCESS object:nil];
    //                    }
    //                }
    //
    //            }
    //            else {
    //                [[NSNotificationCenter defaultCenter] postNotificationName:action object:nil];
    //            }
    //            application.applicationIconBadgeNumber = 0;
    //            [self goToMssageViewControllerWith:userInfo];
    //
    //        }];
    //
    //        // Required
    //        [JPUSHService handleRemoteNotification:userInfo];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
    [UIApplication sharedApplication].applicationIconBadgeNumber =
    [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
}


// iOS 10收到通知,前台有通知栏下拉提示（ios10新特性）
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
        [JPUSHService handleRemoteNotification:userInfo];
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\\\\nbody:%@，\\\\ntitle:%@,\\\\nsubtitle:%@,\\\\nbadge：%@，\\\\nsound：%@，\\\\nuserInfo：%@\\\\n}",body,title,subtitle,badge,sound,userInfo);
        //        [PXAlertView showAlertWithTitle:[NSString stringWithFormat:@"iOS10 前台收到本地通知:{\\\\nbody:%@，\\\\ntitle:%@,\\\\nsubtitle:%@,\\\\nbadge：%@，\\\\nsound：%@，\\\\nuserInfo：%@\\\\n}",body,title,subtitle,badge,sound,userInfo]];
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

//获取广告url
- (void)getUrl{
    if (![UserManager getDefaultUser]) {
        return;
    }
    [RequestManager getAdsWithUserId:[UserManager getDefaultUser].userId deviceId:nil success:^(id object) {
        if (![object objectForKey:@"data"] || [(NSArray *)[object objectForKey:@"data"] count] == 0) {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",object]];
            
        }else{
            NSDictionary *dic = [object objectForKey:@"data"][0];
            NSString *adurl = [dic valueForKey:@"advertiseImageUrl"];
            NSNumber *adImageId = [dic valueForKey:@"advertiseId"];
            _adDic = dic;
            
            if (![[NSUserDefaults standardUserDefaults] valueForKey:@"advertiseId"]) {
                
                [self downloadAds:adurl];
            }else{
                NSNumber *adId = [[NSUserDefaults standardUserDefaults] valueForKey:@"advertiseId"];
                if (adId == adImageId) {
                    //广告页没变不下载
                }else{
                    [self downloadAds:adurl];
                }
            }
        }
    } Failed:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
}
//下载广告图片

- (void)downloadAds:(NSString *)url{
    
    NSLog(@"开始下载图片");
    
    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:url] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        
         
         if (error) {
             NSLog(@"error is %@",error);
         }
         if (image) {
             NSData *data;
             if (UIImagePNGRepresentation(image) == nil) {
                 
                 data = UIImageJPEGRepresentation(image, 1);
                 
             } else {
                 
                 data = UIImagePNGRepresentation(image);
             }
             image = nil;
             NSNumber *adImageId = [_adDic valueForKey:@"advertiseId"];
             NSString *adHtml = [_adDic valueForKey:@"advertiseHtmlUrl"];
             NSString *adName = [_adDic valueForKey:@"advertiseName"];
             
             [[NSUserDefaults standardUserDefaults] setObject:data forKey:[NSString stringWithFormat:@"%@.png",adImageId]];
             [[NSUserDefaults standardUserDefaults] setValue:adHtml forKey:[NSString stringWithFormat:@"%@.html",adImageId]];
             [[NSUserDefaults standardUserDefaults] setValue:adName forKey:[NSString stringWithFormat:@"image_%@",adImageId]];
             [[NSUserDefaults standardUserDefaults] setValue:adImageId forKey:@"advertiseId"];
             [[NSUserDefaults standardUserDefaults] synchronize];
         }
     }];
}

//
- (void)setNetWork{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUrl) name:WIFI_START object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUrl) name:WWAN_START object:nil];
    [ExpressRequest StartNetReachablityListen];
}

// 本地通知回调
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    // 更新显示的徽章个数
    NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
    badge--;
    badge = badge >= 0 ? badge : 0;
    [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
    // 这里真实需要处理交互的地方
    // 获取通知所带的数据
    //    本地通知(前台)
    
    BOOL ifNeedShowAlert = YES;
   
    
    NSString *notMess = [notification.userInfo objectForKey:@"from"];
       if (ifNeedShowAlert) {
        [JKNotifier showNotifer:[NSString stringWithFormat:@"来自%@的消息",notMess]  name:@"我要" icon:[UIImage imageNamed:@"icon"] dismissAfter:100.0];
        
        [JKNotifier handleClickAction:^(NSString *name, NSString *detail, JKNotifier *notifier) {
           
            [JKNotifier dismiss];
           
        }];
    }
    // 在不需要再推送时，可以取消推送
    //    [UtilNotif cancelLocalNotificationWithKey:@"key"];
}

- (void)EaseMobLogin{
   
}



- (void)updateUser{
    if ([UserManager getDefaultUser].userId) {
        [RequestManager getuserinfoWithuserId:[UserManager getDefaultUser].userId success:^(NSString *reslut) {
            NSLog(@"更新信息成功");
            [[NSNotificationCenter defaultCenter] postNotificationName:DRIVER_AUTH object:nil];
        } Failed:^(NSString *error) {
            NSLog(@"更新失败");
        }];
    }
}

#pragma mark-- updateLocation

- (void)uploadLocation:(CLLocationCoordinate2D )loc{
    NSDictionary *dic = @{k_USER_ID:[UserManager getDefaultUser].userId,
                          k_USER_TYPE:[NSNumber numberWithInt:[UserManager getDefaultUser].userType],
                          USER_LOCATION_LAT:[NSNumber numberWithDouble:loc.latitude],
                          USER_LOCATION_LON:[NSNumber numberWithDouble:loc.longitude]};
    [ExpressRequest sendWithParameters:dic MethodStr:API_LOCAT_UPLOAD reqType:k_POST success:^(id object) {
        NSLog(@"后台上传位置成功");
    } failed:^(NSString *error) {
        NSLog(@"后台上传位置失败:%@",error);
    }];
}

#pragma mark -  定位代理方法
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *loc = [locations objectAtIndex:0];
    
    NSLog(@"谷歌地球经纬度  %f  %f ",loc.coordinate.latitude,loc.coordinate.longitude);
    
    CLLocationCoordinate2D coor = loc.coordinate;//原始坐标
    //转换GPS坐标至百度坐标(加密后的坐标)
    NSDictionary* testdic = BMKConvertBaiduCoorFrom(coor,BMK_COORDTYPE_GPS);
    
    //解密加密后的坐标字典
    CLLocationCoordinate2D baiduCoor = BMKCoorDictionaryDecode(testdic);//转换后的百度坐标
    [self uploadLocation:baiduCoor];
}

- (void)onGetPermissionState:(int)iError{
    NSLog(@"%d",iError);
}
- (void)onGetNetworkState:(int)iError{
    NSLog(@"%d",iError);
}

#pragma mark  判断是否登陆
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if (![self checkIfLogin]) {
        return NO;
    }
    return YES;
}

- (BOOL)checkIfLogin{
    if (![UserManager getDefaultUser]) {
        [self goToLogin];
        return NO;
    }
    return YES;
}

- (void)goToLogin{
    //    _isGoTOLogin = YES;
    //如果用户装了微信就只能微信登陆，如果没装微信，就进入账号登陆
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
        WeChectLoginViewController *vc = [[WeChectLoginViewController alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
        
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
    }else{
        MMZCViewController *vc = [[MMZCViewController alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
        
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
    }
}

#pragma mark -----检测是否开启了定位
-(void)ifAllowLocation{
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请打开[定位服务]来允许[镖王]确定您的位置，否则将影响您继续使用软件" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置" , nil];
        alertView.delegate = self;
        alertView.tag = 1;
        [alertView show];
    }else{
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1) {
        if (buttonIndex == 1) {
            //跳转到定位权限页面
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if( [[UIApplication sharedApplication]canOpenURL:url] ) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }else{
            //取消了 没开启
        }
    }
}

-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
