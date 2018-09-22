//
//  CouponViewController.m
//  iwant
//
//  Created by pro on 16/3/8.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "CouponViewController.h"
#import "UnUsedTableViewCell.h"
#import "MainHeader.h"
#import "UserManager.h"
#import "Wallet.h"
#import "InforWebViewController.h"
#define WYScreenW [UIScreen mainScreen].bounds.size.width
#define WYScreenH [UIScreen mainScreen].bounds.size.height

#define ROTIO  WINDOW_HEIGHT/736.0

@interface CouponViewController ()<UITableViewDelegate,UITableViewDataSource,UnUsedTableViewCellDelegate>
{
    
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    int _pageNo;
    NSString *_userCouponName;
    NSMutableArray *_couponIdArr;
    NSMutableArray *_selectedModelArray;
}
@end

@implementation CouponViewController


- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillAppear:YES];
    NSUserDefaults*pushJudge = [NSUserDefaults standardUserDefaults];
    if([[pushJudge objectForKey:@"push"]isEqualToString:@"push"]) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(rebackToRootViewAction)];
    }else{
//        self.navigationItem.leftBarButtonItem=nil;
    }
}

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
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStyleGrouped
                  ];
    _tableView.showsVerticalScrollIndicator = NO;
     _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    __weak CouponViewController *weakSelf = self;
//    [_tableView addLegendHeaderWithRefreshingBlock:^{
//        [weakSelf loadData:NO];
//    }];
//    [_tableView addLegendFooterWithRefreshingBlock:^{
//        [weakSelf loadData:YES];
//    }];
    _tableView.backgroundColor = [UIColor whiteColor];
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
        Wallet *model = _dataArray[indexPath.section];
        [cell configModel:model];
        cell.delegate =self;
    if ([_couponIdArr containsObject:model.userCouponId]) {
        [cell select];
    }
        return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 145;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (_isPay) {
        Wallet *model = _dataArray[indexPath.section];
        
        UnUsedTableViewCell *cell =  [tableView cellForRowAtIndexPath:indexPath];
        //UI实现单选
        [_tableView reloadData];
        
        [cell select];
        if (model.ifUsed || model.ifDeleted ||model.ifExpire) {
            [SVProgressHUD showInfoWithStatus:@"此现金券已过期或者已使用，请选择其他现金券!"];
            return;
        }else{
            if (cell.ifSelecct) {
                [_couponIdArr removeAllObjects];
                [_couponIdArr addObject: model.userCouponId];
                [_selectedModelArray removeAllObjects];
                [_selectedModelArray addObject:model];
            }else{
                [_couponIdArr removeObject:model.userCouponId];
                [_selectedModelArray removeObject:model];
            }
            [self clickSure];
        }
    }
}


//确认支付
- (void)clickSure{
    _userCouponName = [_couponIdArr componentsJoinedByString:@"&"];
    if (_shunfengBlock) {
        _shunfengBlock(_userCouponName,_selectedModelArray);
        [self.navigationController popViewControllerAnimated:YES];
    }
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
    if (_shunfengBlock) {
        _shunfengBlock(@"",nil);
    }
}
-(void)endRefresh{
    [_tableView.header endRefreshing];
    [_tableView.footer endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)UseCard:(UIButton *)Button tIndexPath:(NSInteger)path{
    
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
