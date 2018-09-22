//
//  MoneyMingXiVC.m
//  iwant
//
//  Created by 公司 on 2017/2/28.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "MoneyMingXiVC.h"
#import "WalletTableViewCell.h"

@interface MoneyMingXiVC ()<UITableViewDelegate,UITableViewDataSource,WalletTableViewCellDelegate>
{
    int _pageNo;
    UITableView * _tableView;
    NSMutableArray *_modelArray;

}

@end

@implementation MoneyMingXiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setCostomeTitle:@"账单明细"];
    [self creatUI];
}


-(void)creatUI{
    
  _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)];
  _tableView.showsVerticalScrollIndicator = NO;
  _tableView.separatorStyle = NO;
  _tableView.delegate = self;
  _tableView.dataSource = self;
  __weak MoneyMingXiVC *weakSelf = self;
  [_tableView addLegendHeaderWithRefreshingBlock:^{
    [weakSelf loadData:NO];
  }];
  [_tableView addLegendFooterWithRefreshingBlock:^{
    [weakSelf loadData:YES];
  }];
  [_tableView.header beginRefreshing];
  [self.view addSubview:_tableView];
}


-(void)loadData:(BOOL)isAdd
{
    if (!isAdd) {
        _pageNo = 1;
    }else{
        _pageNo++;
    }
    [RequestManager walletHistoryWithuserId:[UserManager getDefaultUser].userId pageNo:[NSString stringWithFormat:@"%d",_pageNo] pageSize:@"20" Success:^(NSArray *result) {
        [self endRefresh];
        if (_pageNo == 1) {
            _modelArray = [NSMutableArray array];
            [_modelArray addObjectsFromArray:result];
        }else{
            [_modelArray addObjectsFromArray:result];
        }
        
        [_tableView reloadData];
        
    }
                                     Failed:^(NSString *error) {
                                         [self endRefresh];
                                         NSLog(@"%@",error);
                                         
                                         
                                     }];
}


#pragma mark  TableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _modelArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WalletTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"WalletTableViewCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    Wallet *model = _modelArray[indexPath.row];
    [cell configModel:model];
    cell.delegate =self;
    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
    
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
