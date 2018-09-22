//
//  OfferViewController.m
//  iwant
//
//  Created by dongba on 16/8/26.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "OfferViewController.h"
#import "TopBarView.h"
#import "XPQScrollLabel.h"
#import "OrderDetailViewController.h"
#import "MainHeader.h"
#import "Baojia.h"
#import "MainHeader.h"
#import "Utils.h"
#import "GoodsOfferTableViewCell.h" //货物报价cell
#import "BaoJiaDetailViewController.h"
#import "NothingBGView.h"
@interface OfferViewController ()<UITableViewDelegate,UITableViewDataSource>{
    TopBarView *_topView;
    int _pageNo;
    NothingBGView * _bgv;
}

@property (strong, nonatomic)  UITableView *tableView;

@property (strong, nonatomic)  NSMutableArray *dataArray;


@end

@implementation OfferViewController
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT - 64-36) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        __weak OfferViewController *weakSelf = self;
        [_tableView addLegendHeaderWithRefreshingBlock:^{
            [weakSelf loadData:NO];
        }];
        [_tableView addLegendFooterWithRefreshingBlock:^{
            [weakSelf loadData:YES];
        }];
    }
    return _tableView;
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCostomeTitle:@"货物报价"];
    [self configSubviews];
    _bgv = [[NothingBGView alloc] initWithFrame:_tableView.frame];
    _bgv.textLabel.text = @"暂无数据";
    _bgv.hidden = YES;
    [self.view addSubview:_bgv];

    [_tableView.header beginRefreshing];
}

- (void)configSubviews{
    [self.view addSubview:self.tableView];
    if ([_model.status intValue] == 8) {
    self.tableView.height = SCREEN_HEIGHT-64-44-36;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(cancelSelected)forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, SCREEN_WIDTH/2, 44);
        button.centerX = SCREEN_WIDTH/2;
        button.y = self.tableView.bottom;
    [button setTitle:@"取消已选公司" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = COLOR_MainColor;
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    [self.view addSubview:button];
    }
}

-(void)loadData:(BOOL)isAdd
{
    if (!isAdd) {
        _pageNo = 1;
    }else{
        _pageNo++;
    }
    
    NSString *URLStr = [NSString stringWithFormat:@"%@quotation/list?WLBId=%@&pageNo=%d&pageSize=20",BaseUrl,_wlbID,_pageNo];
    [ExpressRequest sendWithParameters:nil
                             MethodStr:URLStr
                               reqType:k_GET
                               success:^(id object) {
                                   NSArray *dataArr = [object valueForKey:@"data"];
                                   if (_pageNo == 1) {
                                       self.dataArray = [NSMutableArray array];
                                   }
                                   for (NSDictionary *dic in dataArr) {
                                       Baojia *model = [[Baojia alloc] initWithJsonDict:dic];
                                       [self.dataArray addObject:model];
                                   }
                                   if (_dataArray.count == 0)
                                   {
                                       _tableView.footer.hidden = YES;
                                       _bgv.hidden = NO;
                                   }else{
                                       _tableView.footer.hidden  = NO;
                                       _bgv.hidden = YES;
                                   }

                                   [_tableView reloadData];
                                   [_tableView.header endRefreshing];
                                   [_tableView.footer endRefreshing];
                               }
                                failed:^(NSString *error) {
                                    [SVProgressHUD showErrorWithStatus:error];
                                    [_tableView.header endRefreshing];
                                    [_tableView.footer endRefreshing];
                                }];
}

#pragma mark ------ 取消全部选择
-(void)cancelSelected{
//logistics/task/restartQuo   物流模块 用户取消已选择的报价  传 recId    GET
    NSString * urlStr = [NSString stringWithFormat:@"%@logistics/task/restartQuo?recId=%@",BaseUrl,self.wlbID];
    [SVProgressHUD show];
    [ExpressRequest sendWithParameters:nil MethodStr:urlStr reqType:k_GET success:^(id object) {
        [SVProgressHUD dismiss];
        NSArray * arr = self.navigationController.viewControllers;
        UIViewController * vc = arr[arr.count -3];
        [self.navigationController popToViewController:vc animated:YES];
    } failed:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  TableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
//section头部间距
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}
//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH - 20, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
//section底部间距
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH - 20, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsOfferTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"GoodsOfferTableViewCell" owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    Baojia *model = _dataArray[indexPath.section];
    cell.nameLabel.text = [NSString stringWithFormat:@"公司名称：%@",model.companyName];
    cell.distanceLabel.text = model.distance.length > 0 ? [NSString stringWithFormat:@"距我:%@km",model.distance] : @"";
    cell.baojiaMoney.text = [NSString stringWithFormat:@"%@元",model.transferMoney];
    if (model.takeCargo) {
        cell.addressLabel.text = @"";
    }else{
        cell.addressLabel.text = [NSString stringWithFormat:@"货场地址：%@",model.yardAddress];
    }
    
    cell.block = ^(id sender){
        UIButton *btn = (UIButton *)sender;
        switch (btn.tag) {
            case 1:
                //打电话
                [Utils callAction:model.mobile];
                break;
            case 2:
                //看详情
                [self goToDetailComId:model];
                break;
            default:
                break;
        }
    };     
    return cell;
}
-(void)ratingChanged:(float)newRating{
    NSLog(@"评分");
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140*RATIO_HEIGHT;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
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

- (void)goToDetailComId:(Baojia *)model{
    BaoJiaDetailViewController * vc =[[BaoJiaDetailViewController alloc]init];
    vc.model = _model;
    vc.comId = model.userId;
    vc.baojiaModel = model;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
