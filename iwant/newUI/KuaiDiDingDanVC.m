//
//  KuaiDiDingDanVC.m
//  iwant
//
//  Created by 公司 on 2017/2/22.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "KuaiDiDingDanVC.h"
#import "MyKuaiDICell.h"
#import "MainHeader.h"
#import "Package.h"
#import "TaobaoExpDetailViewController.h"
@interface KuaiDiDingDanVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    int _pageNo;
    NSMutableArray * _modelArray;
}

@end

@implementation KuaiDiDingDanVC

-(void)viewWillAppear:(BOOL)animated{
    [_tableView.header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _pageNo = 1;
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self creatTableView];

}

-(void)creatTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(16, 0, WINDOW_WIDTH-32, WINDOW_HEIGHT -  110 -44)];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = BACKGROUND_COLOR;
    __weak KuaiDiDingDanVC *weakSelf = self;
    
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

-(void)loadData:(BOOL)isAdd
{
    if (!isAdd) {
        _pageNo = 1;
    }else{
        _pageNo++;
    }
    _tableView.hidden = NO;
    [RequestManager getExpListWithUserId:[UserManager getDefaultUser].userId
                                  pageNo:_pageNo
                                pageSize:@"20"
            success:^(NSMutableArray *result) {
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
                    [self endRefresh];
                } Failed:^(NSString *error) {
                    [SVProgressHUD showErrorWithStatus:error];
                    [self endRefresh];
              }];
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
        MyKuaiDICell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
        if (!cell) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MyKuaiDICell" owner:nil options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    Package * model = [[Package alloc]initWithJsonDict:_modelArray[indexPath.section]];
    cell.timeLabel.text = model.publishTime;
    cell.courierLabel.text = [NSString stringWithFormat:@"快递员：%@",model.courierName];
    cell.statusLabel.text = model.statusName;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView cellForRowAtIndexPath:indexPath];
    Package *model = [[Package alloc]initWithJsonDict:_modelArray[indexPath.section]];
    TaobaoExpDetailViewController *VC =[TaobaoExpDetailViewController new];
    VC.model = model;
    [self.navigationController pushViewController:VC animated:YES];

}
-(void)endRefresh{
    
    [_tableView.header endRefreshing];
    [_tableView.footer endRefreshing];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TRUE;
}
//删除cell
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return UITableViewCellEditingStyleDelete;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Package *model = [[Package alloc]initWithJsonDict:_modelArray[indexPath.section]];
    
    if ([model.status integerValue] == 3) {
        return  @"取消";
        
    }
    if ([model.status integerValue] == 4) {
        return  @"取消";
        
    }
    else{
        return  @"删除";
    }
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"我的发布，删除");
    
    Package *model = [[Package alloc]initWithJsonDict:_modelArray[indexPath.section]];
    
    [RequestManager DeleteExpressWithbillCode:model.billCode Success:^{
        if ([model.status integerValue] == 3)
        {
            [SVProgressHUD showSuccessWithStatus:@"取消成功"];}
        
        else if ([model.status integerValue] == 4) {
            
            [SVProgressHUD showSuccessWithStatus:@"取消成功"];
        }
        else {
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
        }
        
        [_modelArray removeObjectAtIndex:indexPath.section];
        [_tableView reloadData];
    }
        Failed:^(NSString *error) {
            [SVProgressHUD showErrorWithStatus:error];
        }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
