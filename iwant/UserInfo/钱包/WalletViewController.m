//
//  WalletViewController.m
//  iwant
//
//  Created by pro on 16/3/8.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "WalletViewController.h"
#import "WalletTableViewCell.h"
#import "MainHeader.h"
#import "SVProgressHUD.h"
#import "RequestManager.h"
#import "UserManager.h"
#import "User.h"
#import "RechargeViewController.h"

#import "AliWithdrawCashViewController.h"
#import "TransferViewController.h"
#import "EcoinViewController.h"
#import "CouponViewController.h"
#import "PromoteViewController.h"

@interface WalletViewController ()<UITableViewDataSource,UITableViewDelegate,WalletTableViewCellDelegate>

{
    int _pageNo;
    UITableView *_tableView;
    UILabel * _moneyLB;
    UILabel * _balanceLB;
   //充值
    
    UIButton *_RechargeBtn;
    NSMutableArray *_modelArray;

   //提现
    UIButton *_WithdrawalsBtn;
    UIButton *_eCoin;
    UIView *_moreView;
}

@end

@implementation WalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pageNo = 1;
    [self configNavgationBar];
    [self configView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:TRANSFERMONEY object:nil];
}
-(void)refresh{
    [self loadData:NO];
}

-(void)configView
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT *0.2)];
    [headView setBackgroundColor:COLOR_ORANGE_DEFOUT];
    [self.view addSubview:headView];

    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(30, 0+WINDOW_HEIGHT *0.2, 100, 34)];
    [label setBackgroundColor:[UIColor whiteColor]];
    label.textColor =[UIColor grayColor];
    label.text = @"流水详情";
    label.font = [UIFont systemFontOfSize:14];

    [self.view addSubview:label];
    
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(5, 34 + WINDOW_HEIGHT *0.2, WINDOW_WIDTH-10, 0.5)];
    [line setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:line];
    
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 35 + WINDOW_HEIGHT *0.2, WINDOW_WIDTH, WINDOW_HEIGHT - (35 + WINDOW_HEIGHT *0.2 + 64))];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    __weak WalletViewController *weakSelf = self;
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf loadData:NO];
    }];
    [_tableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf loadData:YES];
    }];
    [_tableView.header beginRefreshing];
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
 
//余额
    _balanceLB  = [[UILabel alloc]initWithFrame:CGRectMake(0, headView.bounds.size.height *0.15, WINDOW_WIDTH, headView.bounds.size.height *0.1)];
    _balanceLB.text = @" 余额（元）";
    _balanceLB.textColor = [UIColor whiteColor];
    _balanceLB.font = [UIFont systemFontOfSize:15];
    _balanceLB.textAlignment = NSTextAlignmentCenter;
    
    _moneyLB = [[UILabel alloc]initWithFrame:CGRectMake(0, headView.bounds.size.height *0.4, WINDOW_WIDTH, headView.bounds.size.height *0.3)];
//    _moneyLB.text = @"88.88";
    if ([[UserManager getDefaultUser].balance doubleValue] == 0) {
        _moneyLB.text = @"0";
    }else{
        _moneyLB.text = [NSString stringWithFormat:@"%0.2f",[[UserManager getDefaultUser].balance doubleValue]];
    }
    
    _moneyLB.textColor = [UIColor whiteColor];
    _moneyLB.textAlignment = NSTextAlignmentCenter;
    _moneyLB.font = [UIFont systemFontOfSize:40];
    
//充值
    _RechargeBtn = [[UIButton alloc]initWithFrame:CGRectMake(WINDOW_WIDTH-80, headView.bounds.size.height *0.68, 60,25)];
//    [_RechargeBtn setImage:[UIImage imageNamed:@"zhuanzhang"] forState:UIControlStateNormal];
    [_RechargeBtn setBackgroundImage:[UIImage imageNamed:@"zhuanzhang"] forState:UIControlStateNormal];
    _RechargeBtn.layer.borderWidth = 0.0f;
    [_RechargeBtn setTintColor:[UIColor whiteColor]];
//    _RechargeBtn.backgroundColor = [UIColor orangeColor];
//    _RechargeBtn.layer.cornerRadius =15;
    [_RechargeBtn addTarget:self action:@selector(Recharge) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:_RechargeBtn];
    
//提现
    _WithdrawalsBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, headView.bounds.size.height *0.68, 60, 25)];
//    [_WithdrawalsBtn setImage:[UIImage imageNamed:@"提现"] forState:UIControlStateNormal];
    [_WithdrawalsBtn setBackgroundImage:[UIImage imageNamed:@"提现"] forState:UIControlStateNormal];
//    [_WithdrawalsBtn setTitle:@"提现" forState:UIControlStateNormal];
//    _WithdrawalsBtn.layer.borderWidth = 1.0f;
//    [_WithdrawalsBtn setTintColor:[UIColor whiteColor]];
//    _RechargeBtn.backgroundColor = [UIColor orangeColor];

//    _WithdrawalsBtn.layer.cornerRadius =5;

    [_WithdrawalsBtn addTarget:self action:@selector(Withdrawals) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:_WithdrawalsBtn];
    
    
    [headView addSubview:_moneyLB];
    [headView addSubview:_balanceLB];

//    _eCoin = [UIButton buttonWithType:0];
//    _eCoin.frame = CGRectMake(0, 0, 60, 60);
//    _eCoin.centerY = self.view.centerY;
//    _eCoin.centerX = self.view.centerX;
//    _eCoin.centerY = WINDOW_HEIGHT -64 - 60;
//    [_eCoin setTitle:@"200" forState:0];
//    [_eCoin setTitleColor:[UIColor whiteColor] forState:0];
////    [eCoin setImage:[UIImage imageNamed:@"zhuanzhang"] forState:UIControlStateNormal];
//    _eCoin.backgroundColor = COLOR_(43, 122, 244, 1);
//    _eCoin.layer.cornerRadius = 30;
//    [_eCoin addTarget:self action:@selector(Recharge) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_eCoin];
    
    _moreView = [UIView new];
    _moreView.backgroundColor = [UIColor whiteColor];
    _moreView.layer.cornerRadius = 5;
    _moreView.layer.borderColor = [[UIColor whiteColor] CGColor];
    _moreView.layer.borderWidth = 1;
//    _moreView.layer.shadowColor = [UIColor blackColor].CGColor;
//    _moreView.layer.shadowOffset = CGSizeMake(-5.0, 5.0);
//    _moreView.layer.shadowOpacity = 0.45;
    _moreView.layer.masksToBounds = YES;
    _moreView.frame = CGRectMake(WINDOW_WIDTH -90,-30, 80, 60);
    
    UIButton *youhuiBtn = [UIButton buttonWithType:0];
    youhuiBtn.frame = CGRectMake(0, 0, 80, 30);
    youhuiBtn.titleLabel.font = FONT(13, YES);
    [youhuiBtn setTitleColor:[UIColor grayColor] forState:0];
    [youhuiBtn setTitle:@"现金券" forState:0];
    [youhuiBtn addTarget:self action:@selector(youhui) forControlEvents:UIControlEventTouchUpInside];
    youhuiBtn.layer.borderWidth = 0.5;
    youhuiBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [youhuiBtn setImage:[UIImage imageNamed:@"quan"] forState:0];
    [_moreView addSubview:youhuiBtn];
    
    UIButton *eCoinBtn = [UIButton buttonWithType:0];
    eCoinBtn.frame = CGRectMake(0, 30, 80, 30);
    eCoinBtn.titleLabel.font = FONT(13, YES);
    [eCoinBtn setTitleColor:[UIColor grayColor] forState:0];
    eCoinBtn.titleLabel.textColor = [UIColor blackColor];
    [eCoinBtn setTitle:@" 积分    " forState:0];
    [eCoinBtn addTarget:self action:@selector(eCoin) forControlEvents:UIControlEventTouchUpInside];
    eCoinBtn.layer.borderWidth = 0.5;
    eCoinBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
     [eCoinBtn setImage:[UIImage imageNamed:@"ebi"] forState:0];
    [_moreView addSubview:eCoinBtn];
    
    
    
    
    
    
    [self.view addSubview:_moreView];
//    _moreView.hidden = YES;
    _moreView.userInteractionEnabled = NO;
    _moreView.transform = CGAffineTransformMakeScale(0.001, 0.001);
    _moreView.layer.anchorPoint = CGPointMake(0.5, 0);
    //快递员
//    if ([UserManager getDefaultUser].userType == 2) {
//        _moreView.height = 90;
//        UIButton *marketBtn = [UIButton buttonWithType:0];
//        marketBtn.frame = CGRectMake(0, 60, 80, 30);
//        marketBtn.titleLabel.font = FONT(13, YES);
//        [marketBtn setTitleColor:[UIColor grayColor] forState:0];
//        marketBtn.titleLabel.textColor = [UIColor blackColor];
//        [marketBtn setTitle:@" 我的推广" forState:0];
//        [marketBtn addTarget:self action:@selector(market) forControlEvents:UIControlEventTouchUpInside];
//        marketBtn.layer.borderWidth = 0.5;
//        marketBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
//        [marketBtn setImage:[UIImage imageNamed:@""] forState:0];
//        [_moreView addSubview:marketBtn];
//        _moreView.layer.anchorPoint = CGPointMake(0.5, 0.18);
//    }
    
//    [self addAnimation];
}
- (void)addAnimation{
    [UIView animateWithDuration:1. animations:^{
        _eCoin.centerY = WINDOW_HEIGHT -64 - 60;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            _eCoin.width = 60;
            _eCoin.height = 60;
            _eCoin.layer.cornerRadius = 30;
        } completion:^(BOOL finished) {
//            _eCoin.width = 30;
//            _eCoin.height = 30;
            nil;
        }];
    }];
}
-(void)loadData:(BOOL)isAdd
{
    if (!isAdd) {
        _pageNo = 1;
    }else{
        _pageNo++;
    }
    // 更新user
    [RequestManager getuserinfoWithuserId:[UserManager getDefaultUser].userId success:^(NSString *reslut) {
        NSLog(@" 获取用户信息成功");
        _moneyLB.text = [NSString stringWithFormat:@"%0.2f",[[UserManager getDefaultUser].balance floatValue]];
        
    } Failed:^(NSString *error) {
        
        NSLog(@" 获取用户信息失败");

    }];
    
    [RequestManager walletHistoryWithuserId:[UserManager getDefaultUser].userId pageNo:[NSString stringWithFormat:@"%d",_pageNo] pageSize:@"20" Success:^(NSArray *result) {
        [self endRefresh];
        if (_pageNo == 1) {
            _modelArray = [NSMutableArray array];
            [_modelArray addObjectsFromArray:result];
        }else{
            [_modelArray addObjectsFromArray:result];
        }

        [_tableView reloadData];

    }
Failed:^(NSString *error) {
    [self endRefresh];
    NSLog(@"%@",error);

        
    }];
}

//充值
-(void)Recharge
{
    TransferViewController *rechVC =  [TransferViewController alloc];
    [self.navigationController pushViewController:rechVC animated:YES];
    
    
}
//提现
-(void)Withdrawals
{
    AliWithdrawCashViewController *VC = [[AliWithdrawCashViewController alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
    

}

#pragma mark  TableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _modelArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WalletTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"WalletTableViewCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    Wallet *model = _modelArray[indexPath.row];
    [cell configModel:model];
    cell.delegate =self;
    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
    
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
}

-(void)more{
    
    if (!_moreView.userInteractionEnabled) {
        _moreView.userInteractionEnabled = YES;
        [UIView animateWithDuration:0.3 animations:^{
            _moreView.transform = CGAffineTransformMakeScale(1, 1);
        }];
    }else{
        _moreView.userInteractionEnabled = NO;
        [UIView animateWithDuration:0.3 animations:^{
            _moreView.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
        }];
    }
    
}
//现金券
-(void)youhui{
    CouponViewController *VC = [[CouponViewController alloc]init];
    
    [self.navigationController pushViewController:VC animated:YES];
//    _moreView.hidden = YES;
    [self more];
}
//积分
-(void)eCoin{
    EcoinViewController *VC = [[EcoinViewController alloc]init];
    
    [self.navigationController pushViewController:VC animated:YES];
//    _moreView.hidden = YES;
    [self more];
}
//我的推广
-(void)market
{
    NSLog(@"我的推广");
    PromoteViewController *VC = [[PromoteViewController alloc]init];
    
    [self.navigationController pushViewController:VC animated:YES];
    
}



- (void)backToMenuView
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)endRefresh{
    [_tableView.header endRefreshing];
    [_tableView.footer endRefreshing];
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
