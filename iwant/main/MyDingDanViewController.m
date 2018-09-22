//
//  MyDingDanViewController.m
//  iwant
//
//  Created by 公司 on 2017/2/4.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "MyDingDanViewController.h"
#import "ActivityNewVC.h"
#import "WeChectLoginViewController.h"
#import "MMZCViewController.h"
#import "UserLogListViewController.h" //我的物流
#import "MyexpressViewController.h" // 我的快递
#import  "MywindViewController.h" //我的顺风
#import "XianShiDingDanFaVC.h"
#import "XianshiDingdanJieVC.h"
#import "ShunFengDingdanVC.h"
#import "ShunFengDingdanJieVC.h"
#import "KuaiDiDingDanVC.h"
#import "MyExpReceiveViewController.h"
#import "CompanyLogistViewController.h"
#import "MyUserCenterVC.h"

@interface MyDingDanViewController ()<UITableViewDelegate,UITableViewDataSource>{

    UITableView * _tableViewSelect;
    UIButton * _viewbtn;
    XianShiDingDanFaVC * _xianshiFaVC;  //限时发
    XianshiDingdanJieVC * _xianshiJieVC; //限时接
    ShunFengDingdanVC * _shunfengFaVC;  //顺风发
    ShunFengDingdanJieVC * _shunfengJieVC; //顺风接
    KuaiDiDingDanVC * _kuaidiFaVC; //快递发
    MyExpReceiveViewController * _kuaidiJieVC;  //快递接
    UserLogListViewController * _wuliuFaVC; //物流发
    CompanyLogistViewController * _wuliuJieVC; //物流接
    UIButton * centerBtn;
    UIButton * _btn1;
    UIButton * _btn2;
    
}

@end

@implementation MyDingDanViewController

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
    [self btnUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self  creatNavgationItem];
    [self creatUI];

}
-(void)creatUI{
    _xianshiFaVC =[[XianShiDingDanFaVC alloc]init];
    _xianshiFaVC.title = @"限时镖";
    
    _xianshiJieVC = [[XianshiDingdanJieVC alloc]init];
    _xianshiJieVC.title = @"限时镖";
    
   _shunfengFaVC =[[ShunFengDingdanVC alloc]init];
    _shunfengFaVC.title = @"顺风镖";
    
    _shunfengJieVC = [[ShunFengDingdanJieVC alloc]init];
    _shunfengJieVC.title = @"顺风镖";
    
     _kuaidiFaVC =[[KuaiDiDingDanVC alloc]init];
     _kuaidiFaVC.title = @"快递";
    
    _kuaidiJieVC = [[MyExpReceiveViewController alloc]init];
    _kuaidiJieVC.title = @"快递";
    
    _wuliuFaVC =[[UserLogListViewController alloc]init];
    _wuliuFaVC.title = @"物流镖";
    
    _wuliuJieVC = [[CompanyLogistViewController alloc]init];
    _wuliuJieVC.title = @"物流镖";
    
    if([UserManager getDefaultUser].userType == 2){
        if([[UserManager getDefaultUser].wlid intValue] != 0){
            self.viewControllers = @[_shunfengFaVC,_xianshiFaVC];
        }else{
            self.viewControllers = @[_shunfengFaVC,_xianshiFaVC,_wuliuFaVC];
        }
    }else{
        if([[UserManager getDefaultUser].wlid intValue] != 0){
            self.viewControllers = @[_shunfengFaVC,_xianshiFaVC];
        }else{
            self.viewControllers = @[_shunfengFaVC,_xianshiFaVC,_wuliuFaVC];
        }
    }
//    
//    btn1 =[UIButton buttonWithType:UIButtonTypeCustom];
//    btn1.frame = CGRectMake(0, 0, SCREEN_WIDTH/2, 49);
//    btn1.backgroundColor = [UIColor orangeColor];
//    btn1.tag = 101;
//    [btn1 setTitle:@"我发的镖" forState:UIControlStateNormal];
//    [btn1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.tabBarController.tabBar addSubview:btn1];
////    [self.view addSubview:btn1];
//    
//     btn2 =[UIButton buttonWithType:UIButtonTypeCustom];
//    btn2.frame = CGRectMake(SCREEN_WIDTH/2,0, SCREEN_WIDTH/2, 49);
//    btn2.backgroundColor = [UIColor orangeColor];
//    btn2.tag = 102;
//    [btn2 setTitle:@"我接的镖" forState:UIControlStateNormal];
//    [btn2 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.tabBarController.tabBar addSubview:btn2];
////    [self.view addSubview:btn2];
    
}

//创建选择按钮
- (void)btnUI {
    
    _btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn1.frame = CGRectMake(0, 0, SCREEN_WIDTH/2, 49);
    [_btn1 setTitleColor:COLOR_ORANGE_DEFOUT forState:UIControlStateNormal];
     _btn1.titleLabel.font = [UIFont systemFontOfSize: 15.0];
    [_btn1 setTitle:@"我发的镖" forState:UIControlStateNormal];
    _btn1.backgroundColor = [UIColor whiteColor];
    [_btn1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBarController.tabBar addSubview:_btn1];
    
    _btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn2.frame = CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 49);
    [_btn2 setTitle:@"我接的镖" forState:UIControlStateNormal];
    _btn2.titleLabel.font = [UIFont systemFontOfSize: 15.0];
    [_btn2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _btn2.backgroundColor = [UIColor whiteColor];
    [_btn2 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBarController.tabBar addSubview:_btn2];
    
    if ([_btn1.titleLabel.text isEqualToString:centerBtn.titleLabel.text]) {
        [_btn1 setTitleColor:COLOR_ORANGE_DEFOUT forState:UIControlStateNormal];
        [_btn2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    } else {
        [_btn2 setTitleColor:COLOR_ORANGE_DEFOUT forState:UIControlStateNormal];
        [_btn1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [_btn1 removeFromSuperview];
    [_btn2 removeFromSuperview];
}
//这个是按钮的点击方法  就写在这了
-(void)btnClick:(UIButton *)sender{
    if (sender == _btn1) {
        [sender setTitleColor:COLOR_ORANGE_DEFOUT forState:UIControlStateNormal];
        [_btn2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        if([UserManager getDefaultUser].userType == 2){
            if([[UserManager getDefaultUser].wlid intValue] != 0){
                self.viewControllers = @[_shunfengFaVC,_xianshiFaVC];
            }else{
                self.viewControllers = @[_shunfengFaVC,_xianshiFaVC,_wuliuFaVC];
            }
        }else{
            if([[UserManager getDefaultUser].wlid intValue] != 0){
                self.viewControllers = @[_shunfengFaVC,_xianshiFaVC];
            }else{
                self.viewControllers = @[_shunfengFaVC,_xianshiFaVC,_wuliuFaVC];
            }
        }
        [centerBtn setTitle:@"我发的镖" forState:UIControlStateNormal];

    }else{
        [sender setTitleColor:COLOR_ORANGE_DEFOUT forState:UIControlStateNormal];
        [_btn1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        if([UserManager getDefaultUser].userType == 2){
            if([[UserManager getDefaultUser].wlid intValue] != 0){
                self.viewControllers = @[_shunfengJieVC,_xianshiJieVC,_wuliuJieVC];
            }else{
                self.viewControllers = @[_shunfengJieVC,_xianshiJieVC];
            }
        }else{
            if([[UserManager getDefaultUser].wlid intValue] != 0){
                self.viewControllers = @[_shunfengJieVC,_xianshiJieVC,_wuliuJieVC];
            }else{
                self.viewControllers = @[_shunfengJieVC,_xianshiJieVC];
            }
        }
        [centerBtn setTitle:@"我接的镖" forState:UIControlStateNormal];
    }
}

-(void)creatNavgationItem{
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(userCenter)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"giftImage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(activity)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    
    centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    centerBtn.size = CGSizeMake(144, 44);
    centerBtn.x = 0;
    centerBtn.y = 0;
    [centerBtn setTitle:@"我发的镖" forState:UIControlStateNormal];
//    [centerBtn setImage:[UIImage imageNamed:@"AA"] forState:UIControlStateNormal];
//    centerBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 100, 0, 0);
//    centerBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 44);
    self.navigationItem.titleView = centerBtn;
//    [centerBtn addTarget:self action:@selector(choice:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)choice:(UIButton *)btn{
    _viewbtn = [[UIButton alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _viewbtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [_viewbtn addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
    _tableViewSelect = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 64, 120, 100) style:UITableViewStylePlain];
    _tableViewSelect.scrollEnabled = NO;
    _tableViewSelect.layer.cornerRadius = 6;
    _tableViewSelect.layer.masksToBounds = YES;
    _tableViewSelect.delegate = self;
    _tableViewSelect.dataSource = self;
    [_viewbtn addSubview:_tableViewSelect];
    [[UIApplication sharedApplication].keyWindow addSubview:_viewbtn];
}

-(void)remove{
    [UIView animateWithDuration:0.3 animations:^{
        [_viewbtn removeFromSuperview];
    }];
}

#pragma mark  ----- tabelView  delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
     if (cell == nil){
     cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
     }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"我发的镖";
    }else{
        cell.textLabel.text = @"我接的镖";
    }
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        if([UserManager getDefaultUser].userType == 2){
            if([[UserManager getDefaultUser].wlid intValue] != 0){
                self.viewControllers = @[_shunfengFaVC,_xianshiFaVC];
            }else{
                self.viewControllers = @[_shunfengFaVC,_xianshiFaVC,_wuliuFaVC];
            }
        }else{
            if([[UserManager getDefaultUser].wlid intValue] != 0){
                self.viewControllers = @[_shunfengFaVC,_xianshiFaVC];
            }else{
                self.viewControllers = @[_shunfengFaVC,_xianshiFaVC,_wuliuFaVC];
            }
        }
        [centerBtn setTitle:@"我发的镖" forState:UIControlStateNormal];
        
    }else{
        
        if([UserManager getDefaultUser].userType == 2){
            if([[UserManager getDefaultUser].wlid intValue] != 0){
                self.viewControllers = @[_shunfengJieVC,_xianshiJieVC,_wuliuJieVC];
            }else{
                self.viewControllers = @[_shunfengJieVC,_xianshiJieVC];
            }
        }else{
            if([[UserManager getDefaultUser].wlid intValue] != 0){
                self.viewControllers = @[_shunfengJieVC,_xianshiJieVC,_wuliuJieVC];
            }else{
                self.viewControllers = @[_shunfengJieVC,_xianshiJieVC];
            }
        }
        
        [centerBtn setTitle:@"我接的镖" forState:UIControlStateNormal];
    }
    [_viewbtn removeFromSuperview];
}


#pragma mark ------ 导航上的跳转
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
