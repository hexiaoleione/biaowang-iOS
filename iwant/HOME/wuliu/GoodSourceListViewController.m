//
//  GoodSourceListViewController.m
//  iwant
//
//  Created by dongba on 16/8/30.
//  Copyright © 2016年 FatherDong. All rights reserved.
//
#import "GoodSourceListViewController.h"
#import "GoodSourceTableViewCell.h"
#import "OrderViewController.h"
#import "LogistSettingViewController.h"
#import "MainHeader.h"
#import "Logist.h"
#import "NothingBGView.h"
@interface GoodSourceListViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UIImageView *backImg;
    int _pageNo;
    int _areaPageNo;
    int _luxianPageNo;
    UIScrollView *_scrollView;
    NothingBGView *_bgv;
}

@property (strong, nonatomic)  UITableView *tableView;
@property (strong, nonatomic)  UITableView *luxianTableView;
@property (strong, nonatomic)  UITableView *areaTableView;
@property (strong, nonatomic)  NSMutableArray *dataArray;
@property (strong, nonatomic)  NSMutableArray *luxianDataArray;
@property (strong, nonatomic)  NSMutableArray *areaDataArray;

@end

@implementation GoodSourceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self setCostomeTitle:@"货源信息"];
    [self configSubviews];
    [self refreshData];
    
}
- (void)refreshData{
    [self.tableView.header beginRefreshing];
    //    [self.areaTableView.header beginRefreshing];
    //    [self.luxianTableView.header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(15, 5, WINDOW_WIDTH - 30, WINDOW_HEIGHT - 105) style:UITableViewStylePlain];
        _tableView.tag = 0;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        __weak GoodSourceListViewController *weakSelf = self;
        [_tableView addLegendHeaderWithRefreshingBlock:^{
            [weakSelf loadData:NO];
        }];
        [_tableView addLegendFooterWithRefreshingBlock:^{
            [weakSelf loadData:YES];
        }];
        
    }
    return _tableView;
}

-(UITableView *)luxianTableView{
    if (!_luxianTableView) {
        _luxianTableView = [[UITableView alloc]initWithFrame:CGRectMake(15 + WINDOW_WIDTH, 5, WINDOW_WIDTH - 30, WINDOW_HEIGHT - 105) style:UITableViewStylePlain];
        _luxianTableView.tag = 1;
        _luxianTableView.delegate = self;
        _luxianTableView.dataSource = self;
        _luxianTableView.showsVerticalScrollIndicator = NO;
        _luxianTableView.showsHorizontalScrollIndicator = NO;
        _luxianTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _luxianTableView.backgroundColor =  [UIColor clearColor];
        __weak GoodSourceListViewController *weakSelf = self;
        [_luxianTableView addLegendHeaderWithRefreshingBlock:^{
            [weakSelf loadLuxianData:NO];
        }];
        [_luxianTableView addLegendFooterWithRefreshingBlock:^{
            [weakSelf loadLuxianData:YES];
        }];
        
    }
    return _luxianTableView;
}

-(UITableView *)areaTableView{
    if (!_areaTableView) {
        _areaTableView = [[UITableView alloc]initWithFrame:CGRectMake(15 + 2*WINDOW_WIDTH, 5, WINDOW_WIDTH - 30, WINDOW_HEIGHT - 105) style:UITableViewStylePlain];
        _areaTableView.tag = 2;
        _areaTableView.delegate = self;
        _areaTableView.dataSource = self;
        _areaTableView.showsVerticalScrollIndicator = NO;
        _areaTableView.showsHorizontalScrollIndicator = NO;
        _areaTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _areaTableView.backgroundColor =  [UIColor clearColor];
        __weak GoodSourceListViewController *weakSelf = self;
        [_areaTableView addLegendHeaderWithRefreshingBlock:^{
            [weakSelf loadAreaData:NO];
        }];
        [_areaTableView addLegendFooterWithRefreshingBlock:^{
            [weakSelf loadAreaData:YES];
        }];
        
    }
    return _areaTableView;
}


-(NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        
    }
    return _dataArray;
}
-(NSArray *)luxianDataArray{
    if (!_luxianDataArray) {
        _luxianDataArray = [NSMutableArray array];
        
    }
    return _luxianDataArray;
}
-(NSArray *)areaDataArray{
    if (!_areaDataArray) {
        _areaDataArray = [NSMutableArray array];
        
    }
    return _areaDataArray;
}



- (void)configSubviews{
    _bgv = [[NothingBGView alloc] initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT - 64)];
    _bgv.textLabel.text = @"暂无货源信息";
    _bgv.hidden = YES;
    [self.view addSubview:_bgv];
    
    UIView *whiteView = [UIView new];
    whiteView.frame = CGRectMake(0, 0, WINDOW_WIDTH, 35);
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.layer.masksToBounds = YES;
    [self.view addSubview:whiteView];
    
    backImg = [[UIImageView alloc] init];
    backImg.backgroundColor = BACKGROUND_COLOR;
    backImg.layer.cornerRadius = 10;
    backImg.frame = CGRectMake(10 , 10, WINDOW_WIDTH/3 -40 , 35);
    backImg.centerX = WINDOW_WIDTH/3/2;
    [whiteView addSubview:backImg];
    
    NSArray *strArr = @[@"附近",@"长途",@"地区"];
    for (int i = 0; i<3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        [btn setTitle:strArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor orangeColor ] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(i*WINDOW_WIDTH/3 , 8, WINDOW_WIDTH/3, 35);
        [whiteView addSubview:btn];
    }
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    [btn setBackgroundImage:[UIImage imageNamed:@"wuliu_lingdang_white"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(setting) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 35, WINDOW_WIDTH, WINDOW_HEIGHT - 64 - 35)];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.contentSize = CGSizeMake(WINDOW_WIDTH *3, WINDOW_HEIGHT);
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.scrollEnabled  = NO;
    [self.view addSubview:_scrollView];
    
    [_scrollView addSubview:self.tableView];
    [_scrollView addSubview:self.luxianTableView];
    [_scrollView addSubview:self.areaTableView];
    
    
    
}

- (void)setting{
    LogistSettingViewController *vc = [[LogistSettingViewController alloc] init];
    __weak GoodSourceListViewController *weakSelf = self;
    [self.navigationController pushViewController:vc animated:YES];
    vc.block = ^(id sender){
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = 0;
        btn.frame = CGRectMake(0*WINDOW_WIDTH/3 , 8, WINDOW_WIDTH/3, 35);
        [weakSelf click:btn];
    };
}

- (void)click:(UIButton *)btn{
    NSLog(@"点击了第%d个按钮",(int)btn.tag);
    _bgv.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        backImg.centerX =btn.centerX;
        _scrollView.contentOffset = CGPointMake(WINDOW_WIDTH * btn.tag, 0);
    }];
    
    switch (btn.tag) {
        case 0:
            if (_dataArray.count == 0) {
                [_tableView.header beginRefreshing];
            }
            break;
        case 1:
            if (_luxianDataArray.count == 0) {
                [_luxianTableView.header beginRefreshing];
            }
            break;
        case 2:
            if (_areaDataArray.count == 0) {
                [_areaTableView.header beginRefreshing];
            }
            break;
            
        default:
            break;
    }
    
    
    
}
-(void)loadData:(BOOL)isAdd
{
    if (!isAdd) {
        _pageNo = 1;
    }else{
        _pageNo++;
    }
    NSString *cityCode = [[NSUserDefaults standardUserDefaults] valueForKey:USER_CITY_CODE];
    [ExpressRequest sendWithParameters:nil
                             MethodStr:[NSString stringWithFormat:@"%@logistics/task/look/nearBy?userId=%@&cityCode=%@&pageNo=%d&pageSize=20",BaseUrl,[UserManager getDefaultUser].userId,cityCode,_pageNo]
                               reqType:k_GET
                               success:^(id object) {
                                   NSArray *arr = [object valueForKey:@"data"];
                                   if (_pageNo == 1) {
                                       self.dataArray  = [NSMutableArray array];
                                       if (arr.count == 0 ) {
                                           _tableView.footerHidden = YES;
                                           _bgv.hidden = NO;
                                       }else{
                                           _bgv.hidden = YES;
                                       }
                                   }
                                   for (NSDictionary *dic in arr) {
                                       Logist *model = [[Logist alloc] initWithJsonDict:dic];
                                       
                                       [self.dataArray addObject:model];
                                       
                                   }
                                   
                                   
                                   [_tableView reloadData];
                                   
                                   [_tableView.header endRefreshing];
                                   [_tableView.footer endRefreshing];
                               }
                                failed:^(NSString *error) {
                                    [_tableView.header endRefreshing];
                                    [_tableView.footer endRefreshing];
                                }];
}

-(void)loadLuxianData:(BOOL)isAdd
{
    if (!isAdd) {
        _luxianPageNo = 1;
    }else{
        _luxianPageNo++;
    }
    [ExpressRequest sendWithParameters:nil
                             MethodStr:[NSString stringWithFormat:@"%@logistics/task/look/line?userId=%@&pageNo=%d&pageSize=20",BaseUrl,[UserManager getDefaultUser].userId,_luxianPageNo]
                               reqType:k_GET
                               success:^(id object) {
                                   NSArray *arr = [object valueForKey:@"data"];
                                   
                                   if (_luxianPageNo == 1) {
                                       self.luxianDataArray  = [NSMutableArray array];
                                       if (arr.count == 0 ) {
                                           _luxianTableView.footerHidden = YES;
                                           _bgv.hidden = NO;
                                       }else{
                                           _bgv.hidden = YES;
                                       }
                                   }
                                   for (NSDictionary *dic in arr) {
                                       Logist *model = [[Logist alloc] initWithJsonDict:dic];
                                       
                                       [self.luxianDataArray addObject:model];
                                       
                                       
                                   }
                                   
                                   
                                   [_luxianTableView reloadData];
                                   
                                   [_luxianTableView.header endRefreshing];
                                   [_luxianTableView.footer endRefreshing];
                               }
                                failed:^(NSString *error) {
                                    [_luxianTableView.header endRefreshing];
                                    [_luxianTableView.footer endRefreshing];
                                }];
}
//
-(void)loadAreaData:(BOOL)isAdd
{
    if (!isAdd) {
        _areaPageNo = 1;
    }else{
        _areaPageNo++;
    }
    NSString *cityCode = [[NSUserDefaults standardUserDefaults] valueForKey:USER_CITY_CODE];
    [ExpressRequest sendWithParameters:nil
                             MethodStr:[NSString stringWithFormat:@"%@logistics/task/look/area?userId=%@&cityCode=%@&pageNo=%d&pageSize=20",BaseUrl,[UserManager getDefaultUser].userId,cityCode,_areaPageNo]
                               reqType:k_GET
                               success:^(id object) {
                                   NSArray *arr = [object valueForKey:@"data"];
                                   
                                   if (_areaPageNo == 1) {
                                       self.areaDataArray  = [NSMutableArray array];
                                       if (arr.count == 0 ) {
                                           _areaTableView.footerHidden = YES;
                                           _bgv.hidden = NO;
                                       }else{
                                           _bgv.hidden = YES;
                                       }
                                   }
                                   for (NSDictionary *dic in arr) {
                                       Logist *model = [[Logist alloc] initWithJsonDict:dic];
                                       
                                       [self.areaDataArray addObject:model];
                                       
                                       
                                   }
                                   
                                   
                                   [_areaTableView reloadData];
                                   
                                   [_areaTableView.header endRefreshing];
                                   [_areaTableView.footer endRefreshing];
                               }
                                failed:^(NSString *error) {
                                    [_areaTableView.header endRefreshing];
                                    [_areaTableView.footer endRefreshing];
                                }];
}



#pragma mark  TableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    switch (tableView.tag) {
        case 0:
            return  self.dataArray.count;
            break;
        case 1:
            return self.luxianDataArray.count;
            break;
        case 2:
            return self.areaDataArray.count;
            break;
            
        default:
            break;
    }
    return 0;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
//section头部间距
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
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
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodSourceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"GoodSourceTableViewCell" owner:nil options:nil] lastObject];
        cell.layer.cornerRadius = 10;
        cell.layer.borderWidth = 0.3;
        cell.layer.masksToBounds  = YES;
        cell.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    }
    NSMutableArray *arr = [NSMutableArray array];
    switch (tableView.tag) {
        case 0:
            arr = self.dataArray;
            break;
        case 1:
            arr =self.luxianDataArray;
            break;
        case 2:
            arr = self.areaDataArray;
            break;
        default:
            break;
    }
    
    Logist *model = arr[indexPath.section];
    cell.distance.text = [NSString stringWithFormat:@"距我%@km",model.distance];
    cell.name.text = [NSString stringWithFormat:@"物品：%@",model.cargoName];
    cell.publishTime.text = [NSString stringWithFormat:@"%@",model.publishTime];
    cell.weight.text = [NSString stringWithFormat:@"重量：%@",model.cargoWeight];
    cell.tiji.text = [NSString stringWithFormat:@"体积：%@立方",model.cargoVolume];
    cell.startPlace.text = [NSString stringWithFormat:@"%@",model.startPlace];
    cell.endPlace.text = [NSString stringWithFormat:@"%@",model.entPlace];
    cell.ifSend.hidden = model.sendCargo ? NO : YES;
    cell.ifReceive.hidden = model.takeCargo ? NO : YES;
    
    cell.block = ^(id sender){
        OrderViewController *vc = [[OrderViewController alloc]init];
        vc.model = [[Logist alloc]init];
        vc.block = ^(id send){
            int num =  _scrollView.contentOffset.x/WINDOW_WIDTH;
            switch (num) {
                case 0:
                    [_tableView.header beginRefreshing];
                    break;
                case 1:
                    [_luxianTableView.header beginRefreshing];
                    break;
                case 2:
                    [_areaTableView.header beginRefreshing];
                    break;
                    
                default:
                    break;
            }
        };
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    };
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 158;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    //    OfferViewController *offerVC = [OfferViewController new];
    
    
}
//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
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

