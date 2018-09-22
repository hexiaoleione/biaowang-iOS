//
//  ShunFengDingdanJieVC.m
//  iwant
//
//  Created by 公司 on 2017/2/22.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "ShunFengDingdanJieVC.h"
#import "MainHeader.h"
#import "LogisticsTrackingViewController.h"
#import "BiaoTableViewCell.h"
#import "ShunFengBiaoShi.h"
#import "HuoZhuSFTaskTableViewCell.h"
#import "JieOrderDetailVC.h"

@interface ShunFengDingdanJieVC ()<UITableViewDelegate,UITableViewDataSource>{
    
    int _pageNo;
    UITableView * _tableView;
    NSMutableArray * _modelArray;
    UIImageView * _touyingImg;
}

@end

@implementation ShunFengDingdanJieVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    _pageNo = 1;
    _touyingImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"yinying"]];
    _touyingImg.frame = CGRectMake(0,  8, SCREEN_WIDTH, 8);
    [self.view addSubview:_touyingImg];
    [self creatTableView];
}

-(void)loadData:(BOOL)isAdd
{
    if (!isAdd) {
        _pageNo = 1;
    }else{
        _pageNo++;
    }
    _tableView.hidden = NO;
        [RequestManager GetBiaoShiShunFengTaskRouteWithuserId:[UserManager getDefaultUser].userId pageNo:[NSString stringWithFormat:@"%d",_pageNo] pageSize:@"5" Success:^(NSArray *result) {
            [self endRefresh];
            if (_pageNo == 1) {
                _modelArray = [NSMutableArray array];
                [_modelArray addObjectsFromArray:result];
            }else{
                [_modelArray addObjectsFromArray:result];
            }
            if (_modelArray.count == 0) {
                _tableView.hidden = YES;
            }
            [_tableView reloadData];
        }
            Failed:^(NSString *error) {
            [self endRefresh];
            NSLog(@"%@",error);
        }];
}

-(void)creatTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 16, WINDOW_WIDTH, WINDOW_HEIGHT - 64 -44-16)];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = BACKGROUND_COLOR;
    __weak ShunFengDingdanJieVC *weakSelf = self;
    
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf loadData:NO];
    }];
    [_tableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf loadData:YES];
    }];
    [_tableView.header beginRefreshing];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-75, 200, 150, 150)];
    imageView.image = [UIImage imageNamed:@"garbage"];
    
    imageView.centerX = self.view.centerX;
    imageView.centerY = self.view.centerY - 64;
    UILabel *textLabel = [UILabel new];
    textLabel.textColor = [UIColor lightGrayColor];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.font = [UIFont systemFontOfSize:20];
    textLabel.text = @"暂无订单";
    [textLabel sizeToFit];
    textLabel.y = imageView.bottom + 16;
    textLabel.centerX = self.view.centerX;
    
    [self.view addSubview:imageView];
    [self.view addSubview:textLabel];
    
    [self.view addSubview:_tableView];
}

#pragma mark  TableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _modelArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
//section头部间距
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.5;
}
//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH - 20, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
//section底部间距
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH - 20, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     BiaoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
     if (!cell) {
         cell = [[[NSBundle mainBundle] loadNibNamed:@"BiaoTableViewCell" owner:nil options:nil] lastObject];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
         cell.backgroundColor = [UIColor whiteColor];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
     }
     ShunFengBiaoShi *model = _modelArray[indexPath.section];
     [cell setModel:model];
    //取消订单
      cell.Block = ^(int tag) {
          UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定取消吗？" message:@"取消订单将造成罚款损失" preferredStyle:UIAlertControllerStyleAlert];
          [self presentViewController:alert animated:YES completion:nil];
          [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
              [RequestManager refundReimburseWithrecId:model.recId success:^(NSMutableArray *result) {
                  [SVProgressHUD showSuccessWithStatus:@"取消成功"];
                  //刷新当前界面
                    [self refreshData];
              } Failed:^(NSString *error) {
                  [SVProgressHUD showErrorWithStatus:error];
              }];
              
          }]];
          [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
              NSLog(@"点击了取消按钮");
          }]];
      };
        return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 115*RATIO_HEIGHT;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        JieOrderDetailVC * VC = [[JieOrderDetailVC alloc]init];
        ShunFengBiaoShi *model =_modelArray[indexPath.section];
        VC.model = model;
        [self.navigationController pushViewController:VC animated:YES];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
        ShunFengBiaoShi *model = _modelArray[indexPath.section];
        [ExpressRequest sendWithParameters:nil MethodStr:[NSString stringWithFormat:@"%@downwind/task/deldeteDow?recId=%@&type=2",BaseUrl,model.recId] reqType:k_GET success:^(id object) {
            [_modelArray removeObjectAtIndex:indexPath.section];
            [_tableView reloadData];
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
        } failed:^(NSString *error) {
            [_tableView reloadData];
            [SVProgressHUD showErrorWithStatus:error];
        }];
}

- (void)refreshData{
    [_tableView.header beginRefreshing];
}

-(void)endRefresh{
    [_tableView.header endRefreshing];
    [_tableView.footer endRefreshing];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
