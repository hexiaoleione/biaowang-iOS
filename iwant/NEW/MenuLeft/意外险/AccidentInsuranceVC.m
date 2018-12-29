//
//  AccidentInsuranceVC.m
//  iwant
//
//  Created by 公司 on 2017/10/26.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "AccidentInsuranceVC.h"
#import "MakeSureInfoVC.h"
#import "EcoinWebViewController.h"
#import "LCFAccidentAlert.h" //交纳保证金弹框
#import "DepositVC.h" //保证金
#import "DepositHaveVC.h" //已经缴纳保证金 或者显示退款中
@interface AccidentInsuranceVC ()<UIWebViewDelegate>

@property(nonatomic,copy)NSString * money; //保证金钱数
@end

@implementation AccidentInsuranceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCostomeTitle:@"意外险"];
    [self configNavgationBtn];
    [self initUI];
//    [self refreshData];
}
-(void)initUI{
    UILabel * topLabel = [[UILabel alloc]init];
    topLabel.text = @"镖师接单必须已经在保险机构购买交通意外险。";
    topLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:topLabel];
    
//    UIImageView * imgView1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"imgView1"]];
//    UIImageView * imgView2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"imgView2"]];
    UIImageView * imgView3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"imgView3"]];
    UIButton * btn = [[UIButton alloc]init];
    btn.tag = 0;
    [btn setTitle:@"我已购买意外险" forState:(UIControlStateNormal)];
    btn.backgroundColor = [UIColor colorWithRed:84/255.0 green:146/255.0 blue:227/255.0 alpha:1];
    [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
//    [btn setImage:[UIImage imageNamed:@"helpBtn"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * btn1 = [[UIButton alloc]init];
    btn1.tag = 1;
    [btn1 setTitle:@"我没有意外险" forState:(UIControlStateNormal)];
//    btn1.backgroundColor = [UIColor blueColor];
     btn1.backgroundColor = [UIColor colorWithRed:84/255.0 green:146/255.0 blue:227/255.0 alpha:1];
    [btn1 setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    btn1.titleLabel.font = [UIFont systemFontOfSize:15];
//    [btn1 setImage:[UIImage imageNamed:@"helpBtnNo"] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

//    [self.view addSubview:imgView1];
//    [self.view addSubview:imgView2];
    [self.view addSubview:imgView3];
    [self.view addSubview:btn];
    [self.view addSubview:btn1];
    
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(16);
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(SCREEN_WIDTH -20*RATIO_WIDTH);
        make.height.mas_equalTo(25);
    }];
    
//    [imgView1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(topLabel.mas_bottom).offset(16);
//        make.centerX.equalTo(self.view.mas_centerX).offset(0);
//        make.height.mas_equalTo(110*RATIO_HEIGHT);
//    }];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topLabel.mas_bottom).offset(8);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
//        make.centerX.equalTo(self.view.mas_centerX).offset(0);
        make.height.mas_equalTo(40*RATIO_HEIGHT);
    }];

//    [imgView2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(btn.mas_bottom).offset(25);
//        make.centerX.equalTo(self.view.mas_centerX).offset(0);
//        make.height.mas_equalTo(77*RATIO_HEIGHT);
//    }];
    
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btn.mas_bottom).offset(8);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
//        make.centerX.equalTo(self.view.mas_centerX).offset(0);
        make.height.mas_equalTo(40*RATIO_HEIGHT);
    }];
    
    [imgView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-36*RATIO_HEIGHT);
        make.centerX.equalTo(self.view.mas_centerX).offset(0);
        make.height.mas_equalTo(54*RATIO_HEIGHT);
    }];
    
//    if (_needHidden == YES) {
////        imgView2.hidden = YES;
//        btn1.hidden = YES;
//    }
}
-(void)refreshData{
    [SVProgressHUD show];
    NSString * urlStr = [NSString stringWithFormat:@"%@driver/driverMoney?userId=%@",BaseUrl,[UserManager getDefaultUser].userId];
    [ExpressRequest sendWithParameters:nil MethodStr:urlStr reqType:k_GET success:^(id object) {
        [SVProgressHUD dismiss];
        NSDictionary * dict = [object valueForKey:@"data"][0];
        self.money =[[dict objectForKey:@"money"] stringValue];
        NSInteger driverMoney = [[dict objectForKey:@"driverMoney"] integerValue];
    } failed:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
}

-(void)btnClick:(UIButton *)btn{
    if (btn.tag == 0) {
        //请求是否交纳押金的接口  缴纳了直接交保险 ，未缴纳弹框跳转
        [SVProgressHUD show];
        NSString * urlStr = [NSString stringWithFormat:@"%@driver/driverMoney?userId=%@",BaseUrl,[UserManager getDefaultUser].userId];
        [ExpressRequest sendWithParameters:nil MethodStr:urlStr reqType:k_GET success:^(id object) {
            [SVProgressHUD dismiss];
            NSDictionary * dict = [object valueForKey:@"data"][0];
            self.money =[[dict objectForKey:@"money"] stringValue];
            NSInteger driverMoney = [[dict objectForKey:@"driverMoney"] integerValue];
//            private Integer driverMoney;// 镖师押金     0 默认      1    已充值    2  退款中   3  已退款
            if (driverMoney == 1) {
                //跳转下一个界面  然后确认身份证信息。
                MakeSureInfoVC * VC = [[MakeSureInfoVC alloc]init];
                [self.navigationController pushViewController:VC animated:YES];
            }else{
                //提示意外险 先交纳保证金
                LCFAccidentAlert * alertView =[[LCFAccidentAlert alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                __weak typeof(LCFAccidentAlert *)alert = alertView;
                alert.Block  = ^(NSInteger tag) {
                    if (tag == 1) {
                        if (driverMoney == 2) {
                            DepositHaveVC * vc = [[DepositHaveVC alloc]init];
                            vc.money =self.money;
                            vc.status = driverMoney;
                            [self.navigationController pushViewController:vc animated:YES];
                        }else{
                            DepositVC * vc = [[DepositVC alloc]init];
                            vc.money = self.money;
                            [self.navigationController pushViewController:vc animated:YES];
                        }
                    }
                };
                [[UIApplication sharedApplication].keyWindow addSubview:alertView];
            }
        } failed:^(NSString *error) {
            [SVProgressHUD showErrorWithStatus:error];
        }];
        
    }else{
        NSString * urlStr =[NSString stringWithFormat:@"%@driver/driveSafe?userId=%@&ifBuyInsure=2&userName=%@&idCard=%@",BaseUrl,[UserManager getDefaultUser].userId,[UserManager getDefaultUser].userName,[UserManager getDefaultUser].userId];
        urlStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)urlStr, nil, nil, kCFStringEncodingUTF8));
        [SVProgressHUD show];
        [ExpressRequest sendWithParameters:nil MethodStr:urlStr reqType:k_GET success:^(id object) {
            [SVProgressHUD dismiss];
            [self.navigationController popViewControllerAnimated:YES];
        } failed:^(NSString *error) {
            [SVProgressHUD showErrorWithStatus:error];
        }];
    }
}

- (void)configNavgationBtn {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(shuoMing)
     forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 80, 30);
    [button setTitle:@"说明" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = menuButton;
}

-(void)shuoMing{
    EcoinWebViewController * vc = [[EcoinWebViewController alloc]init];
    vc.web_type = WEB_AccidentInsurance;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
