//
//  EcoinHistoryViewController.m
//  Express
//
//  Created by 刘耀光 on 15/9/26.
//  Copyright (c) 2015年 SCHT. All rights reserved.
//

#import "EcoinHistoryViewController.h"
#import "MyEcoinCell.h"
#import "RequestManager.h"
#import "SVProgressHUD.h"
#import "Masonry.h"
#import "UserManager.h"
#import "MJRefresh.h"

#define COLOR_APP_BASIC_BK   [UIColor colorWithWhite:1 alpha:1] //===tablecell 背景色

@interface EcoinHistoryViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    int _pageNo;
    UITableView *_tableView;
    NSMutableArray *_historyArray;
}
@end

@implementation EcoinHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_APP_BASIC_BK;
    
    [self configNavgationBar];
    _pageNo = 1;
    [self configTableView];
}




- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}

- (void)requestEcoinHistory:(BOOL )isAdd
{
    if (!isAdd) {
        _pageNo = 1;
    }else{
        _pageNo++;
    }
    [RequestManager getEcoinHistoryWithuserId:[UserManager getDefaultUser].userId
                                     pageSize:@"20"
                                       pageNo:[NSString stringWithFormat:@"%d",_pageNo]
                                      Success:^(NSArray *result) {
                                          [self endRefresh];
                                          if (_pageNo == 1) {
                                              _historyArray = [NSMutableArray array];
                                              [_historyArray addObjectsFromArray:result];
                                          }else{
                                              [_historyArray addObjectsFromArray:result];
                                          }
        
                //处理没有数据时。
                if (_historyArray.count == 0) {
        
                    _tableView.hidden = YES;
        
                }
                [_tableView reloadData];
                [SVProgressHUD dismiss];
    } Failed:^(NSString *error) {
    [self endRefresh];
    [SVProgressHUD showErrorWithStatus:error];

    }];
}

#pragma mark tableview
- (void)configTableView {
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    __weak EcoinHistoryViewController *weakSelf = self;
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf requestEcoinHistory:NO];
    }];
    [_tableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf requestEcoinHistory:YES];
    }];
    [_tableView.header beginRefreshing];
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view).with.offset(0);
        make.top.equalTo(self.view).with.offset(0);
        make.bottom.equalTo(self.view).with.offset(0);
    }];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _historyArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"EcoinHisCellIdentifier";
    MyEcoinCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyEcoinCell" owner:self options:nil]lastObject];
    }
    [cell loadEcoin:[_historyArray objectAtIndex:indexPath.row]];

    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}




- (void)configNavgationBar {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 60)];
    label.textColor = [UIColor whiteColor];
    label.text = @"历史积分";
    label.textAlignment = 1;
    self.navigationItem.titleView = label;
    
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
