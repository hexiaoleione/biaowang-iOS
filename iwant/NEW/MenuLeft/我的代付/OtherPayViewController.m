
//
//  OtherPayViewController.m
//  iwant
//
//  Created by 公司 on 2017/6/17.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "OtherPayViewController.h"
#import "MainHeader.h"
#import "OtherPayTableViewCell.h"
#import "ShunFeng.h"
#import "RechargeViewController.h"
@interface OtherPayViewController ()<UITableViewDelegate,UITableViewDataSource>{
    int _pageNo;
    UITableView * _tableView;
    NSMutableArray * _modelArray;
}

@end

@implementation OtherPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setCostomeTitle:@"我的代付"];
    _pageNo = 1;
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
    NSString * urlStr = [NSString stringWithFormat:@"%@downwind/task/replacePay?userId=%@&pageNo=%d&pageSize=10",BaseUrl,[UserManager getDefaultUser].userId,_pageNo];
    [ExpressRequest sendWithParameters:nil MethodStr:urlStr reqType:k_GET success:^(id object) {
        NSArray * result = [object objectForKey:@"data"];
        [self endRefresh];
        if (_pageNo == 1) {
            if (result.count == 0) {
                _tableView.hidden = YES;
            }else{
                _tableView.hidden = NO;
            }
            _modelArray = [[NSMutableArray alloc]init];
        }
        for (NSDictionary * dic in result) {
            ShunFeng *model = [[ShunFeng alloc] initWithJsonDict:dic];
            [_modelArray addObject:model];
        }
        [_tableView reloadData];
        [self endRefresh];
    } failed:^(NSString *error) {
        [self endRefresh];
    }];
}

-(void)creatTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT -64) style:UITableViewStyleGrouped];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = NO;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    __weak OtherPayViewController *weakSelf = self;
    
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
    OtherPayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"OtherPayTableViewCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    ShunFeng * model =_modelArray[indexPath.section];
    [cell setViewWithModel:model];
    cell.Block = ^{
      //余额支付  呵呵哒
        [SVProgressHUD show];
        [RequestManager payByyueBillCode:model.billCode
                                 matName:@""
                                 matType:@""
                            insuranceFee:@""
                             insureMoney:@""
                            needPayMoney:model.transferMoney
                               shipMoney:@""
                            userCouponId:@""
                                  weight:@""
                                  userId:[UserManager getDefaultUser].userId
                                 success:^(id object) {
                                     [SVProgressHUD dismiss];
                                     [SVProgressHUD showSuccessWithStatus:@"支付成功"];
                                     [_tableView.header beginRefreshing];
//                                     [self goHome];
                                 } Failed:^(NSString *error) {
                                     int errCode = [[[NSUserDefaults standardUserDefaults] objectForKey:@"errCode"] intValue];
                                     if (errCode == -2)
                                     {
                                         [SVProgressHUD dismiss];
                                         HHAlertView *alert = [[HHAlertView alloc]initWithTitle:nil detailText:error cancelButtonTitle:@"更换支付方式" otherButtonTitles:@[@"去充值"]];
                                         alert.mode = HHAlertViewModeWarning;
                                         [alert showWithBlock:^(NSInteger index) {
                                             if(index != 0){
                                                 [self.navigationController pushViewController:[[RechargeViewController alloc]init] animated:YES];
                                             }
                                         }];
                                     }else{
                                         [SVProgressHUD showErrorWithStatus:error];
                                     }
                                 }];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
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
