//
//  CourierWalletViewController.m
//  iwant
//
//  Created by pro on 16/6/15.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "CourierWalletViewController.h"
#import "MainHeader.h"

#import "HistoricalbillViewController.h"
#import "AliWithdrawCashViewController.h"
#import "TransferViewController.h"
#import "InforWebViewController.h"
#import "EcoinWebViewController.h"

#define ScreenW                [[UIScreen mainScreen] bounds].size.width
#define ScreenH               [[UIScreen mainScreen] bounds].size.height
#define BTNTEXT_COLOR            [UIColor colorWithRed:50.0/255.0 green:142.0/255.0 blue:255.0/255.0 alpha:1.0]
#define LABELBACK_COLOR            [UIColor colorWithRed:249.0/255.0 green:182.0/255.0 blue:135.0/255.0 alpha:1.0]
#define TEXT_COLOR            [UIColor colorWithRed:162.0/255.0 green:38.0/255.0 blue:31.0/255.0 alpha:1.0]
//按比例获取高度
#define  WGiveHeight(HEIGHT) HEIGHT * [UIScreen mainScreen].bounds.size.height/568.0

//按比例获取宽度
#define  WGiveWidth(WIDTH) WIDTH * [UIScreen mainScreen].bounds.size.width/320.0

@interface CourierWalletViewController ()
{
    
    
    
    UIView *_topView;
    
    UILabel *_yesterdaymoney;
    
    UILabel *_totalmoney;
    
    
    UILabel *_wanfenshouyi;
    UILabel *_wanfenmoney;
    
    UILabel *_leijishouyi;
    UILabel *_leijimoney;
    
    UILabel *_AnnualyieldLabel;
    UILabel *_Annualyieldnumber;

    
    
    UILabel *_reward;
    UILabel *_rewardmoney;
    //广告
    UILabel *_advertisementlable;
    
    
    //通过判定金额
    
    UILabel *_pandingmoney;
    
    //转账
    
    UIButton *_transferBtn;
    
    //提现
    UIButton *_WithdrawalsBtn;
    

}
@end

@implementation CourierWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavgationBar];
    [self creatSubView];
    [self loadcourierWalletData];
    

}

-(void)loadcourierWalletData
{
    
    [RequestManager getcourierwalletDataWithuserId:[UserManager getDefaultUser].userId success:^(NSDictionary *result) {
        
        _yesterdaymoney.text = [NSString stringWithFormat:@"%@",result[@"yestodayReceiveMoney"] ];
        _totalmoney.text =[NSString stringWithFormat:@"%0.2f",[result[@"validBalance"] doubleValue]];
        _wanfenmoney.text =[NSString stringWithFormat:@"%@ 元",result[@"yestodayAllowance"] ];
        _leijimoney.text =[NSString stringWithFormat:@"%@ 元",result[@"yestodayRecommendMoney"] ];
        _Annualyieldnumber.text =[NSString stringWithFormat:@"%@",result[@"sevendayPercent"] ];
        _rewardmoney.text  =[NSString stringWithFormat:@"%@ 元",result[@"yestodayLuckyDrawMoney"] ];
        //广告
        _advertisementlable.text =[NSString stringWithFormat:@"  %@",result[@"courierMessage"] ];
        _pandingmoney.text = [NSString stringWithFormat:@"%0.2f",[result[@"passedExpressMoney"] doubleValue]];
        
       
    } Failed:^(NSString *error) {
        
        
    }];
    
    
    
}

-(void)creatSubView
{
    
    _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, WGiveHeight(250))];
    //    _topView.layer.cornerRadius = 10;
    
    _topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_topView];
    
    _advertisementlable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 30)];
    _advertisementlable.backgroundColor =LABELBACK_COLOR;
    _advertisementlable.font =FONT(13,NO);
    _advertisementlable.text = @"  本周推广之星，奖励500元人民币。";
    _advertisementlable.textColor =TEXT_COLOR;
    [self.view addSubview:_advertisementlable];
    
    
    
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(ScreenW-100, 0, 100, 30)];
    button.titleLabel.font = FONT(13,NO);
    [button setTitle:@"点击查看" forState:UIControlStateNormal];
    [button setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor clearColor]];
    [button addTarget:self action:@selector(Clicktoview) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    
    
    UIImageView *barView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 30, _topView.frame.size.width, _topView.frame.size.height-30)];
    barView.userInteractionEnabled = YES;
    barView.contentMode = UIViewContentModeScaleToFill;
    barView.clipsToBounds = YES;
    [barView setImage:[UIImage imageNamed:@"background_bg"]];
    [_topView addSubview:barView];
    
    
    UILabel *yesterdayLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, WGiveHeight(10), ScreenW, WGiveHeight(30))];
    yesterdayLabel.backgroundColor = [UIColor clearColor];
    yesterdayLabel.textAlignment = NSTextAlignmentCenter;
    yesterdayLabel.textColor = [UIColor whiteColor];
    yesterdayLabel.text = @"昨日收益（元）";
    [barView addSubview:yesterdayLabel];
    
    
    UIButton *helpBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenW - 50, WGiveHeight(10), WGiveWidth(30), WGiveHeight(30))];
    [helpBtn setImage:[UIImage imageNamed:@"rule_bar"] forState:UIControlStateNormal];
    
    [helpBtn addTarget:self action:@selector(help) forControlEvents:UIControlEventTouchUpInside];
    [barView addSubview: helpBtn];
    
    
    _yesterdaymoney = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(yesterdayLabel.frame)+20, ScreenW, WGiveHeight(80))];
    _yesterdaymoney.backgroundColor = [UIColor clearColor];
    _yesterdaymoney.textAlignment = NSTextAlignmentCenter;
    _yesterdaymoney.textColor = [UIColor whiteColor];
    _yesterdaymoney.font = [UIFont systemFontOfSize:60];
    _yesterdaymoney.text = @"0.00";
    [barView addSubview:_yesterdaymoney];
    
    CGFloat tem;
    if (self.view.height == 480) {
        tem = 20;
    }else{
        tem = 30;
    }
    
    UILabel *totalLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_yesterdaymoney.frame)+WGiveHeight(20), ScreenW/2, WGiveHeight(tem))];
    totalLabel.backgroundColor = [UIColor clearColor];
    totalLabel.textAlignment = NSTextAlignmentCenter;
    totalLabel.textColor = [UIColor whiteColor];
    totalLabel.text = @"总金额（元）";
    [barView addSubview:totalLabel];
    
    
    _totalmoney = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(totalLabel.frame), ScreenW/2, WGiveHeight(30))];
    _totalmoney.backgroundColor = [UIColor clearColor];
    _totalmoney.textAlignment = NSTextAlignmentCenter;
    _totalmoney.textColor = [UIColor whiteColor];
    _totalmoney.text = @"0.00";
//    if ([[UserManager getDefaultUser].balance doubleValue] == 0) {
//        _totalmoney.text = @"0";
//    }else{
//        _totalmoney.text = [NSString stringWithFormat:@"%0.2f",[[UserManager getDefaultUser].balance doubleValue]];
//    }
    [barView addSubview:_totalmoney];
    
    //已判定金额
    UILabel *panding = [[UILabel alloc]initWithFrame:CGRectMake(ScreenW/2, CGRectGetMaxY(_yesterdaymoney.frame)+WGiveHeight(20), ScreenW/2, WGiveHeight(tem))];
    panding.backgroundColor = [UIColor clearColor];
    panding.textAlignment = NSTextAlignmentCenter;
    panding.textColor = [UIColor whiteColor];
    panding.text = @"已判定金额（元）";
    [barView addSubview:panding];
   
    _pandingmoney = [[UILabel alloc]initWithFrame:CGRectMake(ScreenW/2, CGRectGetMaxY(panding.frame), ScreenW/2, WGiveHeight(30))];
    _pandingmoney.backgroundColor = [UIColor clearColor];
    _pandingmoney.textAlignment = NSTextAlignmentCenter;
    _pandingmoney.textColor = [UIColor whiteColor];
    _pandingmoney.text = @"0.00";
    
    [barView addSubview:_pandingmoney];
    
    
    
    
    
    
    
    
    
    //昨日获得补贴
    
    _wanfenshouyi = [self creatwithText:@"获得补贴(判定中)" textcolor:[UIColor grayColor] textfont:14 X:0 Y:CGRectGetMaxY(_topView.frame) W:ScreenW/2 H:WGiveHeight(35)];
    
    _wanfenmoney = [self creatwithText:@"0.00元" textcolor:[UIColor orangeColor] textfont:14 X:0 Y:CGRectGetMaxY(_wanfenshouyi.frame) W:ScreenW/2 H:WGiveHeight(35)];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(ScreenW/2, CGRectGetMaxY(_topView.frame)+10, 0.5, WGiveHeight(60))];
    line.backgroundColor = [UIColor grayColor];
    [self.view addSubview:line];

    //昨日推广收益
    _leijishouyi = [self creatwithText:@"推广收益(判定中)" textcolor:[UIColor grayColor] textfont:14 X:ScreenW/2 Y:CGRectGetMaxY(_topView.frame) W:ScreenW/2 H:WGiveHeight(35)];
    
    
    _leijimoney = [self creatwithText:@"0.00元" textcolor:[UIColor orangeColor] textfont:14 X:ScreenW/2 Y:CGRectGetMaxY(_leijishouyi.frame) W:ScreenW/2 H:WGiveHeight(35)];
    
  //七日年化率 红包 View
    
    UIView *buttomView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame)+20, ScreenW, 110)];
    buttomView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    [self.view addSubview:buttomView];
    
    
    
    
    
    // 七日年化率
    
    _AnnualyieldLabel =[self creatwithText:@"七日年化收益率（%）" textcolor:[UIColor grayColor] textfont:14 X:0 Y:CGRectGetMaxY(line.frame)+40 W:ScreenW/2 H:WGiveHeight(35)];
    _Annualyieldnumber =[self creatwithText:@"0.0000" textcolor:[UIColor orangeColor] textfont:14 X:0 Y:CGRectGetMaxY(_AnnualyieldLabel.frame) W:ScreenW/2 H:WGiveHeight(35)];
    
    //红包

    
    _reward= [self creatwithText:@"红包（抽奖）" textcolor:[UIColor grayColor] textfont:14 X:ScreenW/2 Y:CGRectGetMaxY(line.frame)+40 W:ScreenW/2 H:WGiveHeight(35)];
    
    _rewardmoney= [self creatwithText:@"0.00元" textcolor:[UIColor orangeColor] textfont:14 X:ScreenW/2 Y:CGRectGetMaxY(_reward.frame) W:ScreenW/2 H:WGiveHeight(35)];
    
    
    
    //转账
    CGFloat btnY;
    if (WINDOW_HEIGHT == 480) {
        btnY = ScreenH - 64 - WGiveHeight(50);
    }else {
        btnY = ScreenH-WGiveHeight(114);
    }
    _transferBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,  btnY, ScreenW/2,WGiveHeight(50))];
    _transferBtn.titleLabel.font = FONT(25,NO);
    
    [_transferBtn setTitle:@"转账" forState:UIControlStateNormal];
    [_transferBtn setTitleColor:BTNTEXT_COLOR forState:UIControlStateNormal];
    _transferBtn.backgroundColor = [UIColor whiteColor];
    [_transferBtn addTarget:self action:@selector(transfer) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_transferBtn];
    
    //提现
    _WithdrawalsBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenW/2,  btnY, ScreenW/2, WGiveHeight(50))];
    _WithdrawalsBtn.titleLabel.font = FONT(25,NO);
    
    [_WithdrawalsBtn setTitle:@"提现" forState:UIControlStateNormal];
    [_WithdrawalsBtn setTitleColor:BTNTEXT_COLOR forState:UIControlStateNormal];
    _WithdrawalsBtn.backgroundColor = [UIColor whiteColor];
    
    [_WithdrawalsBtn addTarget:self action:@selector(Withdrawals) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_WithdrawalsBtn];
}

-(void)Clicktoview
{
    EcoinWebViewController *WebVC = [[EcoinWebViewController alloc]init];
    
    WebVC.web_type = WEB_COURIER_EXPLNE;
    
    [self.navigationController pushViewController:WebVC animated:YES];
    NSLog(@"点击查看");
    
}


//转账
-(void)transfer
{
    NSLog(@"转账");
    TransferViewController *rechVC =  [TransferViewController alloc];
    [self.navigationController pushViewController:rechVC animated:YES];
    
    
}
//提现

-(void)Withdrawals
{
    NSLog(@"提现");
    
    AliWithdrawCashViewController *VC = [[AliWithdrawCashViewController alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
    
    
    
}

-(void)help
{
    EcoinWebViewController *WebVC = [[EcoinWebViewController alloc]init];
    
    WebVC.web_type = WEB_WALLET_HELP;
    
    [self.navigationController pushViewController:WebVC animated:YES];
    
}




//账单
-(void)more
{
    
    NSLog(@"历史账单");
    HistoricalbillViewController *VC = [[HistoricalbillViewController alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
    
}
-(UILabel *)creatwithText:(NSString *)text textcolor:(UIColor *)color textfont:(int)font X:(CGFloat)x Y:(CGFloat)y W:(CGFloat)w H:(CGFloat)h
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(x, y, w, h)];
    label.text = text;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = color;
    label.font = FONT(font,NO);
    [self.view addSubview:label];
    
    return label;
    
}

- (void)configNavgationBar {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 60)];
    label.textColor = [UIColor whiteColor];
    label.text = @"我的钱包";
    label.textAlignment = 1;
    self.navigationItem.titleView = label;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(backToMenuView)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    // UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"更多" style:UIBarButtonItemStylePlain target:self action:@selector(more)];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"topright_bar"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(more)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    
}

- (void)backToMenuView
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
