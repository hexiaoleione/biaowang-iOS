//
//  ExchangeJiFenVC.m
//  iwant
//
//  Created by 公司 on 2017/4/25.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "ExchangeJiFenVC.h"
#import  "MainHeader.h"
#import "UnUsedTableViewCell.h"
#import "Wallet.h"
#import "InforWebViewController.h"
#define WYScreenW [UIScreen mainScreen].bounds.size.width
#define WYScreenH [UIScreen mainScreen].bounds.size.height

#define ROTIO  WINDOW_HEIGHT/736.0

@interface ExchangeJiFenVC ()<UITableViewDelegate,UITableViewDataSource>
{
    
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    int _pageNo;
    NSString *_userCouponName;
    NSMutableArray *_couponIdArr;
    NSMutableArray *_selectedModelArray;
}
@end

@implementation ExchangeJiFenVC


//- (void)viewWillAppear:(BOOL)animated{
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    [super viewWillAppear:YES];
//    NSUserDefaults*pushJudge = [NSUserDefaults standardUserDefaults];
//    if([[pushJudge objectForKey:@"push"]isEqualToString:@"push"]) {
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(rebackToRootViewAction)];
//    }else{
//
//    }
//}

- (void)rebackToRootViewAction {
    NSUserDefaults * pushJudge = [NSUserDefaults standardUserDefaults];
    [pushJudge setObject:@""forKey:@"push"];
    [pushJudge synchronize];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavgationBar];
    _pageNo = 1;
    [self createTableView];
    //_tableView.hidden = YES;
    [self loadData:NO];
    
    _couponIdArr = [NSMutableArray array];
    _selectedModelArray = [NSMutableArray array];
    
    
}
-(void)loadData:(BOOL)isAdd
{
    if (!isAdd) {
        _pageNo = 1;
    }else{
        _pageNo++;
    }
    [RequestManager getCouponWithuserId:[UserManager getDefaultUser].userId
                               pageSize:@"2000"
                                 pageNo:[NSString stringWithFormat:@"%d",_pageNo]
                                Success:^(NSArray *result) {
                                    //                                    [self endRefresh];
                                    if (_pageNo == 1) {
                                        _dataArray = [NSMutableArray array];
                                        [_dataArray addObjectsFromArray:result];
                                    }else{
                                        [_dataArray addObjectsFromArray:result];
                                    }
                                    if (_dataArray.count == 0) {
                                        _tableView.hidden = YES;
                                    }
                                    [_tableView reloadData];
                                } Failed:^(NSString *error) {
                                    //        [self endRefresh];
                                    NSLog(@"数据加载错误,%@",error);
                                }];
}
- (void)createTableView
{
    UILabel * noticeL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 22)];
    noticeL.backgroundColor = BACKGROUND_COLOR;
    noticeL.textColor = [UIColor redColor];
    noticeL.text = @"现金券可兑换积分，详见右上角说明";
    noticeL.font = FONT(14, NO);
    noticeL.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:noticeL];
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 22, self.view.frame.size.width, self.view.frame.size.height - 64-22) style:UITableViewStyleGrouped];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
 
    [_tableView.header beginRefreshing];
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 200 *ROTIO, WYScreenW, 100)];
    textLabel.text = @"暂无现金券";
    textLabel.font = [UIFont systemFontOfSize:30];//采用系统默认文字设置大小
    
    textLabel.textColor = [UIColor grayColor];
    textLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:textLabel];
    [self.view addSubview:_tableView];
}

#pragma mark  TableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
//section头部间距
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}
//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH - 20, 1)];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}
//section底部间距
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH - 20, 1)];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UnUsedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    UIView *aVIew = [[UIView alloc]initWithFrame:cell.frame];
    aVIew.backgroundColor = [UIColor whiteColor];
    cell.selectedBackgroundView = aVIew;
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"UnUsedTableViewCell" owner:nil options:nil] lastObject];
    }
    Wallet *model = _dataArray[indexPath.row];
    [cell configModel:model];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 145;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
    Wallet *model = _dataArray[indexPath.row];
    NSString * couponId = model.userCouponId;
    [ExpressRequest sendWithParameters:nil MethodStr:[NSString stringWithFormat:@"%@ecoin/exchangeCoupon?userId=%@&couponId=%@",BaseUrl,[UserManager getDefaultUser].userId,couponId] reqType:k_GET success:^(id object) {
       [[NSNotificationCenter defaultCenter] postNotificationName:JIFENBUY object:nil];
       [self.navigationController popViewControllerAnimated:YES];
       [SVProgressHUD showSuccessWithStatus:[object objectForKey:@"message"]];
    } failed:^(NSString *error) {
       [SVProgressHUD showErrorWithStatus:error];
    }];
}


- (void)configNavgationBar {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 60)];
    label.textColor = [UIColor whiteColor];
    label.text = @"我的现金券";
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(backToMenuView)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"说明" style:UIBarButtonItemStylePlain target:self action:@selector(goToWebView)];
    rightItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)goToWebView{
    InforWebViewController *webView = [[InforWebViewController alloc]init];
    webView.info_type = INFO_SCOUPON_RULE;
    [self.navigationController pushViewController:webView animated:YES];
}

- (void)backToMenuView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
