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

@interface PersonalWealthVC ()<UITableViewDelegate,UITableViewDataSource>
{

    UILabel * _balanceLB;
    UILabel * _moneyLB;
    
    UITableView * _tableView;
    NSArray *_array;
    NSArray *_imgArray;
}

@end

@implementation PersonalWealthVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setCostomeTitle:@"个人财产"];
    _array = @[@"我的E币",@"现金券"];
    _imgArray = @[@"ELmg",@"xianjinquanLmg"];
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self initSubViews];
    [self configNavgationBtn];
}

-(void)initSubViews{
    
    UIView *headView = [UIView new];
    [self.view addSubview:headView];
        
    headView.sd_layout
    .topEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(150*RATIO_HEIGHT);
        
    UIImageView *bgImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"user-bj"]];
    [headView addSubview:bgImg];
    bgImg.sd_layout.spaceToSuperView ( UIEdgeInsetsMake(0, 0, 0, 0));
    
    _moneyLB = [[UILabel alloc]initWithFrame:CGRectMake(0, headView.height*0.15, WINDOW_WIDTH, headView.height*0.3)];
    if ([[UserManager getDefaultUser].balance doubleValue] == 0) {
        _moneyLB.text = @"0";
    }else{
        _moneyLB.text = [NSString stringWithFormat:@"%0.2f",[[UserManager getDefaultUser].balance doubleValue]];
    }
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
    UIImageView  *imgC = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"chongzhiLmg"]];
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
    chongBtn.frame = CGRectMake(imgC.x, imgC.y, chongL.right - imgC.x, imgC.height);
    chongBtn.backgroundColor = [UIColor clearColor];
    [chongBtn addTarget:self action:@selector(chongzhi) forControlEvents:UIControlEventTouchUpInside];
    
    [headView addSubview:imgC];
    [headView addSubview:chongL];
    [headView addSubview:chongBtn];
    
 //提现
    UIImageView  *imgT = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tixianLmg"]];
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
    tixianBtn.frame = CGRectMake(imgT.x, imgT.y, labelT.right - imgT.x, imgT.height);
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
    
    UIImageView  *imgZ = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"zhuanzhangLmg"]];
    imgZ.right = labelZ.left -8;
    imgZ.y = imgC.y;
    
    UIButton * zhuanzhangBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    zhuanzhangBtn.frame = CGRectMake(imgZ.x, imgZ.y, labelZ.right - imgZ.x, imgZ.height);
    zhuanzhangBtn.backgroundColor = [UIColor clearColor];
    [zhuanzhangBtn addTarget:self action:@selector(zhuanzhang) forControlEvents:UIControlEventTouchUpInside];
    
    [headView addSubview:imgZ];
    [headView addSubview:labelZ];
    [headView addSubview:zhuanzhangBtn];
    
    
//tableview
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, headView.bottom + 20, SCREEN_WIDTH, 2*60 * RATIO_HEIGHT)];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
}
#pragma mark ------ 充值  转账    提现
-(void)chongzhi{
    RechargeViewController *VC = [[RechargeViewController alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
}

-(void)tixian{
    NSLog(@"tiixna!!!!!!!");
    AliWithdrawCashViewController * VC = [[AliWithdrawCashViewController alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
}

-(void)zhuanzhang{
    TransferViewController * vc = [[TransferViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];

}

#pragma mark ---- tableview   delegate
- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60 * RATIO_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"PersonalWealthVC";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = [_array objectAtIndex:indexPath.row];
        [cell.imageView setImage:[UIImage imageNamed:[_imgArray objectAtIndex:indexPath.row]]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        //我的e币
        EcoinViewController *vc = [EcoinViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        //现金券
        CouponViewController *VC = [[CouponViewController alloc]init];
        [self.navigationController pushViewController:VC animated:YES];
    }
}

- (void)configNavgationBtn {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(caichanmingxi)
     forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 80, 30);
    [button setTitle:@"财产明细" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = menuButton;
}

//财产明细
-(void)caichanmingxi{
    NSLog(@"财产明细~~~~");
    MoneyMingXiVC * vc = [[MoneyMingXiVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
