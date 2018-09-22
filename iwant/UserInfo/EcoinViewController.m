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
//#import "UserManager.h"
//#import "RequestManager.h"
#import "MainHeader.h"
#import "UIImageView+WebCache.h"
#define RATIO   WINDOW_HEIGHT/736.0

@interface EcoinViewController ()<UITableViewDataSource,UITableViewDelegate>

{
    NSArray *_array;
    UITableView *_tableView;
    
}


@end

@implementation EcoinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getEcoin];

    [self configNavgationBar];
    [self configSubviews];

    _array = @[@"历史明细",@"E币说明",@"E币商城"];

}
-(void)getEcoin
{
//    UILabel *ecoinLabel = (UILabel *)[self.view viewWithTag:1];
////    ecoinLabel.text = [NSString stringWithFormat:@"%ld",(long)result] ;
//   ecoinLabel.text = @"100";
//    
    // 更新user
    [RequestManager getuserinfoWithuserId:[UserManager getDefaultUser].userId success:^(NSString *reslut) {
        NSLog(@" 获取用户信息成功(E币)");
        
    } Failed:^(NSString *error) {
        
        NSLog(@" 获取用户信息失败（E币）");
        
    }];
    
}
- (void)configSubviews
{
    UIImageView *imgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ecoin_bgimg"]];
    [self.view addSubview:imgV];
    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(160 *RATIO);
    }];
    
    UILabel *label = [[UILabel alloc]init];
    label.tag = 1;
    label.text = [NSString stringWithFormat:@"%ld",(long)[UserManager getDefaultUser].ecoin ];
    
//    label.text = @"200";
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:40];
    [self.view addSubview:label];
    label.textAlignment = NSTextAlignmentCenter;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
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
        make.height.mas_equalTo(60 *WINDOW_HEIGHT/736.0 *3);
    }];
    
    UIImageView *bottomView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80 *RATIO)];
//    bottomView.image = [UIImage imageNamed:@"ad1"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmm"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    
    [bottomView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.efamax.com/mobile_document/ecoin/business.png?%@",strDate]]];
    
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.mas_equalTo(_tableView.mas_bottom).with.offset(15*RATIO);
        make.height.mas_equalTo(125 *RATIO);
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
    return 3;
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
            EcoinHistoryViewController *ecHisVC = [[EcoinHistoryViewController alloc]init];
            [self.navigationController pushViewController:ecHisVC animated:YES];
        }
            break;
        case 1:{
            ecoinWebVC.web_type = WEB_EXPLAIN;
            [self.navigationController pushViewController:ecoinWebVC animated:YES];
        }
            break;
        case 2:{
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
    label.text = @"我的E币";
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
