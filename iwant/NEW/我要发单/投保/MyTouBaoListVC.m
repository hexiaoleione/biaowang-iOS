//
//  MyTouBaoListVC.m
//  iwant
//
//  Created by 公司 on 2017/10/12.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "MyTouBaoListVC.h"
#import "NothingBGView.h"
#import "MainHeader.h"
#import "Logist.h"
#import "BaoDanCell.h"
#import "BaoDanDetailVC.h"
#import "RechargeViewController.h"
@interface MyTouBaoListVC ()<UITableViewDelegate,UITableViewDataSource>{
    int _pageNo;
    NothingBGView *_bgv;
}

@property (strong, nonatomic)  UITableView *tableView;
@property (strong, nonatomic)  NSMutableArray *dataArray;

@end

@implementation MyTouBaoListVC
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,16, SCREEN_WIDTH, WINDOW_HEIGHT-64-40*RATIO_HEIGHT-1-16) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        __weak MyTouBaoListVC *weakSelf = self;
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

-(void)viewWillAppear:(BOOL)animated{
    [self.tableView.header beginRefreshing];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _pageNo = 1;
    [self.view addSubview:self.tableView];
    _bgv = [[NothingBGView alloc] initWithFrame:_tableView.frame];
    _bgv.textLabel.text = @"暂无数据";
    _bgv.hidden = YES;
    [self.view addSubview:_bgv];
}
-(void)beginRefresh{
  [self.tableView.header beginRefreshing];
}

#pragma mark - MJ刷新
-(void)loadData:(BOOL)isAdd
{
    if (!isAdd) {// 下拉
        _pageNo = 1;
    }else{ // 上拉
        _pageNo++;
    }
    [ExpressRequest sendWithParameters:nil MethodStr:[NSString stringWithFormat:@"%@logistics/task/insureList?userId=%@&pageSize=10&&pageNo=%d",BaseUrl,[UserManager getDefaultUser].userId,_pageNo] reqType:k_GET success:^(id object) {
        NSArray *dicArr = [object valueForKey:@"data"];
        if (_pageNo == 1) {
            if (dicArr.count == 0) {
                _bgv.hidden = NO;
                self.tableView.footer.hidden = YES;
            }else{
                _bgv.hidden = YES;
                self.tableView.footer.hidden = NO;
            }
            self.dataArray = [NSMutableArray array];
        }
        for (NSDictionary *dic in dicArr) {
            Logist *model = [[Logist alloc] initWithJsonDict:dic];
            [self.dataArray addObject:model];
        }
        [_tableView reloadData];
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
    } failed:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
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
    return 0;
}
//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 0)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
//section底部间距
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20,0)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaoDanCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if(!cell){
      cell = [[[NSBundle mainBundle] loadNibNamed:@"BaoDanCell" owner:nil options:nil] firstObject];
    }
    Logist *model = _dataArray[indexPath.section];
    [cell setModel:model];
    cell.Block = ^(NSInteger tag) {
        if (tag == 11) {
            //待付款
//            NSLog(@"待付款");
            UIAlertController *alertTwo = [UIAlertController alertControllerWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"此单保费%@元",model.insureCost] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancleTwo = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            UIAlertAction *updateTwo = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self payInsureCostByYueWithRecId:model.recId];
            }];
            [alertTwo addAction:cancleTwo];
            [alertTwo addAction:updateTwo];
            [self presentViewController:alertTwo animated:YES completion:nil];
        }else{
            //已生效  下载保单
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.pdfURL]];
        }
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    Logist *model = _dataArray[indexPath.section];
    BaoDanDetailVC * vc = [[BaoDanDetailVC alloc]init];
    vc.recId = model.recId;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)payInsureCostByYueWithRecId:(NSString *)recId{
    [SVProgressHUD show];
    [ExpressRequest sendWithParameters:nil MethodStr:[NSString stringWithFormat:@"%@logistics/task/payInsure?recId=%@",BaseUrl,recId]reqType:k_GET success:^(id object) {
        [SVProgressHUD showSuccessWithStatus:@"支付成功"];
        [_tableView.header beginRefreshing];
    } failed:^(NSString *error) {
        int errCode = [[[NSUserDefaults standardUserDefaults] objectForKey:@"errCode"] intValue];
        if (errCode == -3)
        {
            [SVProgressHUD dismiss];
            HHAlertView *alert = [[HHAlertView alloc]initWithTitle:nil detailText:error cancelButtonTitle:@"取消" otherButtonTitles:@[@"去充值"]];
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
}

@end
