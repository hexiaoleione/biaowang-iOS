//
//  JieViewController.m
//  iwant
//
//  Created by 公司 on 2017/6/1.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "JieViewController.h"
#import "MainHeader.h"
#import "JieSFViewController.h"
#import "JieXSViewController.h"
#import "JieWLViewController.h"
@interface JieViewController ()
{
    JieXSViewController * _xianshiVC;
    JieSFViewController * _shunfengVc;
    JieWLViewController * _wuliuVc;
}

@end

@implementation JieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
    if ([UserManager getDefaultUser].userId) {
         [self creatUI];
    }else{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(islogin) name:ISLOGIN object:nil];
    }
}
-(void)islogin{
 [self creatUI];
}

-(void)creatUI{
    _xianshiVC =[[JieXSViewController alloc]init];
    _xianshiVC.title = @"专程送";
    _shunfengVc =[[JieSFViewController alloc]init];
    _shunfengVc.title = @"顺路送";
    _wuliuVc =[[JieWLViewController alloc]init];
    _wuliuVc.title = @"物流/冷链";
    
    self.viewControllers = @[_shunfengVc,_xianshiVC,_wuliuVc];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
