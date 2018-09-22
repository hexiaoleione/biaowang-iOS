//
//  JieBiaoViewController.m
//  iwant
//
//  Created by 公司 on 2017/2/4.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "JieBiaoViewController.h"
#import "MainHeader.h"
#import "XianShiBiaoViewController.h"
#import "ShunFengBiaoViewController.h"
#import "WuLiuBiaoViewController.h"
#import "WeChectLoginViewController.h"
#import "MMZCViewController.h"
#import "ActivityNewVC.h"
#import "MyUserCenterVC.h"


@interface JieBiaoViewController ()
{
    XianShiBiaoViewController * _xianshiVC;
    ShunFengBiaoViewController * _shunfengVc;
    WuLiuBiaoViewController * _wuliuVc;
}

@end

@implementation JieBiaoViewController

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self creatNavgationItem];
    [self creatUI];
//     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(islogin) name:ISLOGIN object:nil];
}
-(void)creatUI{
    _xianshiVC =[[XianShiBiaoViewController alloc]init];
    _xianshiVC.title = @"限时镖";
    _shunfengVc =[[ShunFengBiaoViewController alloc]init];
    _shunfengVc.title = @"顺风镖";
    _wuliuVc =[[WuLiuBiaoViewController alloc]init];
    _wuliuVc.title = @"物流镖";
    
//    if ([[UserManager getDefaultUser].wlid intValue] == 0 ) {
//        self.viewControllers = @[_xianshiVC,_shunfengVc];
//    }else{
//        self.viewControllers = @[_xianshiVC,_shunfengVc,_wuliuVc];
//    }
    self.viewControllers = @[_shunfengVc,_xianshiVC,_wuliuVc];

}

#pragma mark ----- navigationBar
-(void)creatNavgationItem{
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(userCenter)];
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"giftImage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(activity)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 40, 40)];//初始化图片视图控件
    imageView.contentMode = UIViewContentModeScaleAspectFit;//设置内容样式,通过保持长宽比缩放内容适应视图的大小,任何剩余的区域的视图的界限是透明的。
    UIImage *image = [UIImage imageNamed:@"biaowangLogo"];//初始化图像视图
    [imageView setImage:image];
    self.navigationItem.titleView = imageView;//设置导航栏的titleView为imageView
}

-(void)userCenter{
    if (![self checkIfLogin]) {
        return;
    }
    self.tabBarController.selectedIndex = 0;
//    MyUserCenterVC *  userVc = [[MyUserCenterVC alloc]init];
//    [self.navigationController pushViewController:userVc animated:YES];
}
-(void)activity{
    if (![self checkIfLogin]) {
        return;
    }
    //    跳转活动页面
    ActivityNewVC * activityVC = [[ActivityNewVC alloc]init];
    [self.navigationController pushViewController:activityVC animated:YES];
}

- (BOOL)checkIfLogin{
    if (![UserManager getDefaultUser]) {
        [self goToLogin];
        return NO;
    }
    return YES;
}

#pragma mark -- 进入登陆界面
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

#pragma mark ---- 登录
-(void)islogin{
//    if ([[UserManager getDefaultUser].wlid intValue] == 0 ) {
//        self.viewControllers = @[_xianshiVC,_shunfengVc];
//    }else{
//        self.viewControllers = @[_xianshiVC,_shunfengVc,_wuliuVc];
//    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
