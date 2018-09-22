//
//  MygoodsViewController.m
//  iwant
//
//  Created by pro on 16/4/29.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "MygoodsViewController.h"
#import "MainHeader.h"
#import "RequestManager.h"
#import "GoodsTableViewCell.h"
#import "LogisticsTrackingViewController.h"
#import "UserManager.h"

#define BACKGROUND_COLOR [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0]
#define WYScreenW [UIScreen mainScreen].bounds.size.width
#define WYScreenH [UIScreen mainScreen].bounds.size.height

#define ROTIO  WINDOW_HEIGHT/736.0

@interface MygoodsViewController ()<UITableViewDataSource,UITableViewDelegate,GoodsTableViewCellDelegate>
{
    int _pageNo;

    UITableView *_tableView;
    
    NSMutableArray *_modelArray;

}
@end

@implementation MygoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _pageNo = 1;
    [self CreatTableView];



}

-(void)loadData:(BOOL)isAdd
{
    if (!isAdd) {
        _pageNo = 1;
    }else{
        _pageNo++;
    }
    
    
    [RequestManager GetHuozhuTaskWithuserId:[UserManager getDefaultUser].userId pageNo:[NSString stringWithFormat:@"%d",_pageNo] pageSize:@"5" Success:^(NSArray *result) {
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


-(void)CreatTableView
{
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, WINDOW_WIDTH, WINDOW_HEIGHT -  100)];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = BACKGROUND_COLOR;
    __weak MygoodsViewController *weakSelf = self;
    
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf loadData:NO];
    }];
    [_tableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf loadData:YES];
    }];
    [_tableView.header beginRefreshing];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
   
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(WYScreenW/2-75, 200, 150, 150)];
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
    return 10;
}
//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH - 20, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
//section底部间距
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH - 20, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"GoodsTableViewCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    ShunFeng *model = _modelArray[indexPath.section];
    
    [cell setModel:model];
    cell.delegate  = self;
    cell.a = indexPath.section;

    UIImage *ima = [UIImage imageNamed:@"shunfen_bg"];
    cell.backgroundColor = BACKGROUND_COLOR;
    UIImageView *imageview = [[UIImageView alloc]initWithImage:ima];
    cell.backgroundView = imageview;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 145;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LogisticsTrackingViewController *VC = [LogisticsTrackingViewController new];
    
    
    ShunFeng *model = _modelArray[indexPath.section];
    VC.model = model;
 //  NSLog(@"%@_+_+_+_+",model.status);
    
    if ([model.status isEqualToString:@"1"]||[model.status isEqualToString:@"8"] || [model.status isEqualToString:@"9"]) {
        NSLog(@"待接镖，不能看镖件详情,但是可以查看自己填的信息");
    }
    
    else
    {
        [self.navigationController pushViewController:VC animated:YES];
    }
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
    
    ShunFeng *model = _modelArray[indexPath.section];
   /*
    顺风 删除订单    路径downwind/task/deldeteDow     请求GET    参数  Integer recId,Integer type
    type  = 1 用户删除   type  = 2  镖师删除
    */
    [ExpressRequest sendWithParameters:nil MethodStr:[NSString stringWithFormat:@"%@downwind/task/deldeteDow?recId=%@&type=1",BaseUrl,model.recId] reqType:k_GET success:^(id object) {
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

-(void)cancel:(UIButton *)button AtIndexPath:(NSInteger)path
{
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定取消？" preferredStyle:UIAlertControllerStyleAlert];
    
    
    [self presentViewController:alert animated:YES completion:nil];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        NSLog(@"点击了确定按钮");
        
            ShunFeng *model = _modelArray[path];
        
            [RequestManager cancelDownWindtaskWithrecId:model.recId success:^(NSMutableArray *result) {
                [SVProgressHUD showSuccessWithStatus:@"该订单已取消,快递费已退回钱包余额"];
        
                [self loadData:NO];
            } Failed:^(NSString *error) {
        
                [SVProgressHUD showErrorWithStatus:error];
                
            }];

        
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        NSLog(@"点击了取消按钮");
        
    }]];
    
    
    
    
    
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
