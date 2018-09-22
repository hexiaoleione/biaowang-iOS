//
//  PersonalWealthVC.m
//  iwant
//
//  Created by 公司 on 2017/2/24.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "PersonalWealthVC.h"
#import "EcoinViewController.h"
#import "CouponViewController.h"
#import "MoneyMingXiVC.h"
#import "RechargeViewController.h"
#import "AliWithdrawCashViewController.h"
#import "TransferViewController.h"
#import "PromotionViewController.h"
#import "BiaoShiRewardVC.h"
#import "LogInRewardVC.h"
#import "DepositVC.h"
#import "DepositHaveVC.h"
#import "AccidentInsuranceVC.h"
#import "InsuranceInfoVC.h"
@interface PersonalWealthVC ()
{
    UIView *headView;
    UILabel * _balanceLB;
    UILabel * _moneyLB;
}

@end

@implementation PersonalWealthVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setCostomeTitle:@"个人财产"];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadwalletData];
    [self initSubViews];
    [self configNavgationBtn];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadwalletData) name:TRANSFERMONEY object:nil];
}

-(void)loadwalletData
{
    [RequestManager getuserwalletDataWithuserId:[UserManager getDefaultUser].userId success:^(NSDictionary *result) {
        _moneyLB.text =[NSString stringWithFormat:@"%0.2f",[result[@"validBalance"] doubleValue]];
    } Failed:^(NSString *error) {
        
    }];
}

-(void)initSubViews{
    
    headView = [UIView new];
    [self.view addSubview:headView];

    headView.sd_layout
    .topEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(150*RATIO_HEIGHT);
    
    headView.backgroundColor = UIColorFromRGB(0x2d2d42);
    
    _moneyLB = [[UILabel alloc]initWithFrame:CGRectMake(0, headView.height*0.15, WINDOW_WIDTH, headView.height*0.3)];
//    if ([[UserManager getDefaultUser].balance doubleValue] == 0) {
//        _moneyLB.text = @"0";
//    }else{
//        _moneyLB.text = [NSString stringWithFormat:@"%0.2f",[[UserManager getDefaultUser].balance doubleValue]];
//    }
    _moneyLB.text = @"0";
    _moneyLB.textColor = [UIColor whiteColor];
    _moneyLB.textAlignment = NSTextAlignmentCenter;
    _moneyLB.font = [UIFont systemFontOfSize:40];

    [headView addSubview:_moneyLB];
    
    _balanceLB  = [[UILabel alloc]initWithFrame:CGRectMake(0, headView.bounds.size.height *0.5, WINDOW_WIDTH, headView.bounds.size.height *0.1)];
    _balanceLB.text = @" 余额（元）";
    _balanceLB.textColor = [UIColor whiteColor];
    _balanceLB.font = [UIFont systemFontOfSize:15];
    _balanceLB.textAlignment = NSTextAlignmentCenter;

    [headView addSubview:_balanceLB];

//充值 提现 转帐
    UIImageView  *imgC = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"chongzhiImg"]];
    imgC.x = 30;
    imgC.y = headView.bottom - 30;
    
    UILabel * chongL = [[UILabel alloc]init];
    chongL.x = imgC.right + 8;
    chongL.y = imgC.y;
    chongL.text = @"充值";
    [chongL sizeToFit];
    chongL.textColor = [UIColor whiteColor];
    chongL.font = [UIFont systemFontOfSize:15];
    
    UIButton * chongBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    chongBtn.frame = CGRectMake(imgC.x, imgC.y-5, chongL.right - imgC.x, imgC.height+10);
    chongBtn.backgroundColor = [UIColor clearColor];
    [chongBtn addTarget:self action:@selector(chongzhi) forControlEvents:UIControlEventTouchUpInside];
    
    [headView addSubview:imgC];
    [headView addSubview:chongL];
    [headView addSubview:chongBtn];
    
 //提现
    UIImageView  *imgT = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tixianImg"]];
    imgT.x = SCREEN_WIDTH/2-20;
    imgT.y = imgC.y;
    
    UILabel * labelT = [[UILabel alloc]init];
    labelT.x = imgT.right +8;
    labelT.y = imgT.y;
    labelT.text = @"提现";
    [labelT sizeToFit];
    labelT.textColor = [UIColor whiteColor];
    labelT.font = [UIFont systemFontOfSize:15];
    
    UIButton * tixianBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tixianBtn.frame = CGRectMake(imgT.x, imgT.y-5, labelT.right - imgT.x, imgT.height+10);
    tixianBtn.backgroundColor = [UIColor clearColor];
    [tixianBtn addTarget:self action:@selector(tixian) forControlEvents:UIControlEventTouchUpInside];
    
    [headView addSubview:imgT];
    [headView addSubview:labelT];
    [headView addSubview:tixianBtn];
    
   //转帐
    
    UILabel * labelZ = [[UILabel alloc]init];
    labelZ.right = SCREEN_WIDTH-50;
    labelZ.y = imgT.y;
    labelZ.text = @"转账";
    [labelZ sizeToFit];
    labelZ.textColor = [UIColor whiteColor];
    labelZ.font = [UIFont systemFontOfSize:15];
    
    UIImageView  *imgZ = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"zhuanImg"]];
    imgZ.right = labelZ.left -8;
    imgZ.y = imgC.y;
    
    UIButton * zhuanzhangBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    zhuanzhangBtn.frame = CGRectMake(imgZ.x, imgZ.y-5, labelZ.right - imgZ.x, imgZ.height+10);
    zhuanzhangBtn.backgroundColor = [UIColor clearColor];
    [zhuanzhangBtn addTarget:self action:@selector(zhuanzhang) forControlEvents:UIControlEventTouchUpInside];
    
    [headView addSubview:imgZ];
    [headView addSubview:labelZ];
    [headView addSubview:zhuanzhangBtn];
    
    [self creatButtons];
}
-(void)creatButtons{
#define Start_X 0          // 第一个按钮的X坐标
#define Start_Y headView.bottom + 30 *RATIO_HEIGHT         // 第一个按钮的Y坐标
#define Width_Space 1.0f        // 2个按钮之间的横间距
#define Height_Space 1.0f      // 竖间距
#define Button_Height   130* RATIO_HEIGHT  // 高
#define Button_Width (WINDOW_WIDTH - 2)/3 // 宽
    
#pragma mark ----镖师需要显示交押金界面
    if ([UserManager getDefaultUser].userType == 2 || [UserManager getDefaultUser].userType == 3) {
        NSArray *imageNameArr = [[NSArray alloc]init];
        NSArray *titleArr = [[NSArray alloc]init];
        
    //12.1号 有个判断，意外险的显示问题，镖师没交意外险也要显示出来。把判断修改。判断条件只判断是否是镖师
//        if ([UserManager getDefaultUser].driverMoney == 1) {
           imageNameArr = [NSArray arrayWithObjects:@"jifenImg",@"XJquanImg",@"BSjiang",@"dengluImg",@"biaoshiyajin",@"yiwaixian",nil];
               titleArr = [NSArray arrayWithObjects:@"我的积分",@"现金券",@"镖师奖励",@"登录奖励",@"保证金",@"意外险",nil];
//        }else{
//            imageNameArr = [NSArray arrayWithObjects:@"jifenImg",@"XJquanImg",@"BSjiang",@"dengluImg",@"biaoshiyajin",@"threePoints",nil];
//            titleArr = [NSArray arrayWithObjects:@"我的积分",@"现金券",@"镖师奖励",@"登录奖励",@"保证金",@"  ",nil];
//        }
        for (int i = 0 ; i < 6; i++) {
            NSInteger index = i % 3;
            NSInteger page = i / 3;
            UIButton *btn = [[UIButton alloc]init];
            btn.frame = CGRectMake(index * (Button_Width + Width_Space) + Start_X, page  * (Button_Height + Height_Space)+Start_Y, Button_Width, Button_Height);
            [btn setImage:[UIImage imageNamed:imageNameArr[i]] forState:UIControlStateNormal];
            [btn setTitle:titleArr[i] forState:UIControlStateNormal];
            btn.titleLabel.font = FONT(18, NO);
            btn.tag = i;
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            float  spacing = 21*RATIO_HEIGHT;//图片和文字的上下间距
            CGSize imageSize = btn.imageView.frame.size;
            CGSize titleSize = btn.titleLabel.frame.size;
            CGSize textSize = [btn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : btn.titleLabel.font}];
            CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
            if (titleSize.width + 0.5 < frameSize.width) {
                titleSize.width = frameSize.width;
            }
            CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
            btn.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width, - (totalHeight - titleSize.height), 0);
            [btn addTarget:self action:@selector(BiaoShibtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:btn];
        }
        for (int i = 0; i<4; i++) {
            NSInteger index = i % 2;
            NSInteger page = i / 2;
            UIView * lineH = [[UIView alloc]init];
            lineH.backgroundColor = BACKGROUND_COLOR;
            lineH.frame = CGRectMake(index * (1 + Button_Width) + Button_Width, page  * (100*RATIO_HEIGHT + 30 *RATIO_HEIGHT)+headView.bottom + 45 *RATIO_HEIGHT, 1, 100*RATIO_HEIGHT);
            [self.view addSubview:lineH];
        }
        for (int i =0; i<2; i++) {
            UIView * lineX = [[UIView alloc]init];
            lineX.backgroundColor = BACKGROUND_COLOR;
            lineX.frame = CGRectMake(8, Start_Y+Button_Height*(i+1), SCREEN_WIDTH-16, 1);
            [self.view addSubview:lineX];
        }
    }else{
        
        NSArray *imageNameArr = [NSArray arrayWithObjects:@"jifenImg",@"XJquanImg",@"BSjiang",@"dengluImg",@"threePoints",nil];
        NSArray *titleArr = [NSArray arrayWithObjects:@"我的积分",@"现金券",@"镖师奖励",@"登录奖励",@" ",nil];
        for (int i = 0 ; i < 5; i++) {
            NSInteger index = i % 3;
            NSInteger page = i / 3;
            UIButton *btn = [[UIButton alloc]init];
            btn.frame = CGRectMake(index * (Button_Width + Width_Space) + Start_X, page  * (Button_Height + Height_Space)+Start_Y, Button_Width, Button_Height);
            [btn setImage:[UIImage imageNamed:imageNameArr[i]] forState:UIControlStateNormal];
            [btn setTitle:titleArr[i] forState:UIControlStateNormal];
            btn.titleLabel.font = FONT(18, NO);
            btn.tag = i;
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            float  spacing = 21*RATIO_HEIGHT;//图片和文字的上下间距
            CGSize imageSize = btn.imageView.frame.size;
            CGSize titleSize = btn.titleLabel.frame.size;
            CGSize textSize = [btn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : btn.titleLabel.font}];
            CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
            if (titleSize.width + 0.5 < frameSize.width) {
                titleSize.width = frameSize.width;
            }
            CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
            btn.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width, - (totalHeight - titleSize.height), 0);
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:btn];
        }
        for (int i = 0; i<4; i++) {
            NSInteger index = i % 2;
            NSInteger page = i / 2;
            UIView * lineH = [[UIView alloc]init];
            lineH.backgroundColor = BACKGROUND_COLOR;
            lineH.frame = CGRectMake(index * (1 + Button_Width) + Button_Width, page  * (100*RATIO_HEIGHT + 30 *RATIO_HEIGHT)+headView.bottom + 45 *RATIO_HEIGHT, 1, 100*RATIO_HEIGHT);
            [self.view addSubview:lineH];
        }
        for (int i =0; i<2; i++) {
            UIView * lineX = [[UIView alloc]init];
            lineX.backgroundColor = BACKGROUND_COLOR;
            lineX.frame = CGRectMake(8, Start_Y+Button_Height*(i+1), SCREEN_WIDTH-16, 1);
            [self.view addSubview:lineX];
        }
    }
}


-(void)btnClick:(UIButton *)sender{
    switch (sender.tag) {
        case 0:{
            //积分
            EcoinViewController *vc = [EcoinViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:{
            //现金券
            CouponViewController *VC = [[CouponViewController alloc]init];
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case 2:{
            //镖师奖励
            BiaoShiRewardVC * vc =[[BiaoShiRewardVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            }
            break;
        case 3:{
            //登录奖励
            LogInRewardVC * vc =[[LogInRewardVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            }
            break;
        case 4:{
            //UI说为了好看而已 没任何作用 threePoint
            }
            break;
        case 5:{
            
            }
            break;
        default:
            break;
    }
}

-(void)BiaoShibtnClick:(UIButton *)sender{
    
    switch (sender.tag) {
        case 0:{
            //积分
            EcoinViewController *vc = [EcoinViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:{
            //现金券
            CouponViewController *VC = [[CouponViewController alloc]init];
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case 2:{
            //镖师奖励
            BiaoShiRewardVC * vc =[[BiaoShiRewardVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:{
            //登录奖励
            LogInRewardVC * vc =[[LogInRewardVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4:{
            //镖师押金
            [SVProgressHUD show];
            NSString * urlStr = [NSString stringWithFormat:@"%@driver/driverMoney?userId=%@",BaseUrl,[UserManager getDefaultUser].userId];
            [ExpressRequest sendWithParameters:nil MethodStr:urlStr reqType:k_GET success:^(id object) {
                [SVProgressHUD dismiss];
                NSDictionary * dict = [object valueForKey:@"data"][0];
                NSInteger driverMoney = [[dict objectForKey:@"driverMoney"] integerValue];
                NSString * money =[[dict objectForKey:@"money"] stringValue];
                switch (driverMoney) {
                    case 0:{
                        DepositVC * vc = [[DepositVC alloc]init];
                        vc.money =money;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                        break;
                    case 1:{
                        DepositHaveVC * vc = [[DepositHaveVC alloc]init];
                        vc.money =money;
                        vc.status = driverMoney;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                        break;
                    case 2:{
                        DepositHaveVC * vc = [[DepositHaveVC alloc]init];
                        vc.money =money;
                        vc.status = driverMoney;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                        break;
                    case 3:{
                        DepositVC * vc = [[DepositVC alloc]init];
                        vc.money =money;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                         break;
                    default:
                        break;
                }
            } failed:^(NSString *error) {
                [SVProgressHUD showErrorWithStatus:error];
            }];
        }
            break;
        case 5:{
//            if([UserManager getDefaultUser].driverMoney == 1){
            //意外险
            [SVProgressHUD show];
            [ExpressRequest sendWithParameters:nil MethodStr:[NSString stringWithFormat:@"%@driver/driveInfo?userId=%@",BaseUrl,[UserManager getDefaultUser].userId] reqType:k_GET success:^(id object) {
                [SVProgressHUD dismiss];
                NSDictionary * dict = [object valueForKey:@"data"][0];
                NSInteger ifBuyInsure = [[dict valueForKey:@"ifBuyInsure"] integerValue];
                if(ifBuyInsure == 1){
                    [ExpressRequest sendWithParameters:nil MethodStr:[NSString stringWithFormat:@"%@driver/getDriverSafe?userId=%@",BaseUrl,[UserManager getDefaultUser].userId] reqType:k_GET success:^(id object) {
                        NSDictionary * dict = [object valueForKey:@"data"][0];
                        NSInteger ifPass = [[dict valueForKey:@"ifPass"] integerValue];
                        InsuranceInfoVC * vc = [[InsuranceInfoVC alloc]init];
                        vc.ifPass = ifPass;
                        [self.navigationController pushViewController:vc animated:YES];
                    } failed:^(NSString *error) {
                        
                    }];
                }else if (ifBuyInsure == 2) {
                    //如果ifBuyInsure= 2 则只展示购买意外险那个框
                    AccidentInsuranceVC * vc =[[AccidentInsuranceVC alloc]init];
                    vc.needHidden = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    //没买过显示买的那个框
                 AccidentInsuranceVC * vc =[[AccidentInsuranceVC alloc]init];
                 [self.navigationController pushViewController:vc animated:YES];
               }
            } failed:^(NSString *error) {
                [SVProgressHUD showErrorWithStatus:error];
            }];
//            }else{
////                UI占位图  无点击效果
//            }
        }
            break;
        default:
            break;
    }
}

#pragma mark ------ 充值  转账    提现
-(void)chongzhi{
//充值
    RechargeViewController *VC = [[RechargeViewController alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
}

-(void)tixian{
//提现
    AliWithdrawCashViewController * VC = [[AliWithdrawCashViewController alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
}

-(void)zhuanzhang{
//转账
    TransferViewController * vc = [[TransferViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)configNavgationBtn {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(caichanmingxi)
     forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 80, 30);
    [button setTitle:@"账单明细" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = menuButton;
}

//财产明细
-(void)caichanmingxi{
    MoneyMingXiVC * vc = [[MoneyMingXiVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
