//
//  EcoinViewController.m
//  iwant
//
//  Created by pro on 16/3/8.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "EcoinViewController.h"
#import "Masonry.h"
#import "EcoinHistoryViewController.h"
#import "EcoinWebViewController.h"
#import "MainHeader.h"
#import "UIImageView+WebCache.h"
#import "CouponViewController.h"
#import "ExchangeJiFenVC.h"
#define RATIO   WINDOW_HEIGHT/736.0

@interface EcoinViewController ()<UITableViewDataSource,UITableViewDelegate>

{
    NSArray *_array;
    UITableView *_tableView;
    UILabel *jifenlabel;
}

@end

@implementation EcoinViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getEcoin];

    [self configNavgationBar];
    [self configSubviews];

    _array = @[@"兑换积分",@"历史明细",@"积分说明",@"积分商城"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getEcoinAgain) name:JIFENBUY object:nil];

}
-(void)getEcoin
{
    // 更新user
    [RequestManager getuserinfoWithuserId:[UserManager getDefaultUser].userId success:^(NSString *reslut) {
        NSLog(@" 获取用户信息成功(积分)");
        
    } Failed:^(NSString *error) {

        NSLog(@" 获取用户信息失败（积分）");
        
    }];
}
-(void)getEcoinAgain{
    // 更新user
    [RequestManager getuserinfoWithuserId:[UserManager getDefaultUser].userId success:^(NSString *reslut) {
        NSLog(@" 获取用户信息成功(积分)");
        jifenlabel.text = [NSString stringWithFormat:@"%ld",(long)[UserManager getDefaultUser].ecoin ];
    } Failed:^(NSString *error) {
        
        NSLog(@" 获取用户信息失败（积分）");
    }];

}
- (void)configSubviews
{
    UIView *imgV = [[UIView alloc]init];
    imgV.backgroundColor = UIColorFromRGB(0x2d2d42);
    [self.view addSubview:imgV];
    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(160 *RATIO);
    }];
    
    jifenlabel = [[UILabel alloc]init];
    jifenlabel.tag = 1;
    jifenlabel.text = [NSString stringWithFormat:@"%ld",(long)[UserManager getDefaultUser].ecoin ];
    
    jifenlabel.textColor = [UIColor whiteColor];
    jifenlabel.font = [UIFont systemFontOfSize:40];
    [self.view addSubview:jifenlabel];
    jifenlabel.textAlignment = NSTextAlignmentCenter;
    [jifenlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.top.mas_equalTo(54*RATIO);
        make.height.mas_equalTo(60 *RATIO);
    }];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.scrollEnabled = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.mas_equalTo(imgV.mas_bottom).with.offset(0);
        make.height.mas_equalTo(60 *WINDOW_HEIGHT/736.0 *4);
    }];
    self.view.backgroundColor = COLOR_(236, 239, 246, 1);
    _tableView.backgroundView.backgroundColor = COLOR_(236, 239, 246, 1);
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60 *WINDOW_HEIGHT/736.0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"myEcoinCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = [_array objectAtIndex:indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    EcoinWebViewController *ecoinWebVC = [[EcoinWebViewController alloc]init];
    switch (indexPath.row) {
        case 0:{
            ExchangeJiFenVC * vc = [[ExchangeJiFenVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:{
            EcoinHistoryViewController *ecHisVC = [[EcoinHistoryViewController alloc]init];
            [self.navigationController pushViewController:ecHisVC animated:YES];
        }
            break;
        case 2:{
            ecoinWebVC.web_type = WEB_EXPLAIN;
            [self.navigationController pushViewController:ecoinWebVC animated:YES];
        }
            break;
        case 3:{
            ecoinWebVC.web_type = WEB_SHOPPING_MALL;
            [self.navigationController pushViewController:ecoinWebVC animated:YES];
        }
            break;
        default:
            break;
    }}

- (void)configNavgationBar {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 60)];
    label.textColor = [UIColor whiteColor];
    label.text = @"我的积分";
    label.textAlignment = 1;
    self.navigationItem.titleView = label;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(backToMenuView)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;    
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
