//
//  HuoChangAdressVC.m
//  iwant
//
//  Created by 公司 on 2017/1/3.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "HuoChangAdressVC.h"
#import "HuoChangAdressCell.h"
#import "HuoChangModel.h"
#import "AddHuoChangAddressVC.h"
#import "OrderViewController.h"
#import "EditHuoChangAddressVC.h"
#import "NothingBGView.h"
@interface HuoChangAdressVC ()<UITableViewDelegate,UITableViewDataSource>
{
    int _pageNo; //页数
    NothingBGView *_bgv;

}

@property (strong, nonatomic)  UITableView *tableView;

@property (strong, nonatomic)  NSMutableArray *dataArray;

@end

@implementation HuoChangAdressVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView.header beginRefreshing];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setCostomeTitle:@"选择货场地址"];
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self.view addSubview:self.tableView];
    
    _bgv = [[NothingBGView alloc] initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT - 64-70)];
    _bgv.textLabel.text = @"您还没有货场地址";
    _bgv.hidden = YES;
    [self.view addSubview:_bgv];
    
    UIButton * addBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [addBtn setBackgroundImage:[UIImage imageNamed:@"addBtnImg"] forState:UIControlStateNormal];
    addBtn.y = _tableView.bottom+15;
    addBtn.size = CGSizeMake(100, 30);
    addBtn.centerX = SCREEN_WIDTH/2;
    [self.view addSubview:addBtn];
    
    [addBtn addTarget:self action:@selector(addNewBtn) forControlEvents:UIControlEventTouchUpInside];
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 8, WINDOW_WIDTH, WINDOW_HEIGHT - 64-70) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //由物流管理界面跳转  取消cell的点击事件
        if (_isGuanLI) {
           _tableView.allowsSelection = NO;
        }
        _tableView.backgroundColor = [UIColor clearColor];
        __weak HuoChangAdressVC *weakSelf = self;
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

-(void)loadData:(BOOL)isAdd
{
    if (!isAdd) {
        _pageNo = 1;
    }else{
        _pageNo++;
    }
    
    NSString *URLStr = [NSString stringWithFormat:@"%@%@?userId=%@&pageNo=%d&pageSize=20",BaseUrl,API_WL_HUOCHANG_LIST,[UserManager getDefaultUser].userId,_pageNo];
    [ExpressRequest sendWithParameters:nil
                             MethodStr:URLStr
                               reqType:k_GET
                               success:^(id object) {
                                   NSArray *dataArr = [object valueForKey:@"data"];
                                   
                                   if (_pageNo == 1) {
                                       if (dataArr.count == 0) {
                                           _bgv.hidden = NO;
                                           _tableView.footer.hidden = YES;
                                       }else{
                                           _bgv.hidden = YES;
                                           _tableView.footer.hidden = NO;
                                       }
                                       
                                       self.dataArray = [NSMutableArray array];
                                       for (NSDictionary *dic in dataArr) {
                                           HuoChangModel * model = [[HuoChangModel alloc]initWithJsonDict:dic];
                                           [self.dataArray addObject:model];
                                       }
                                       
                                   }else{
                                       for (NSDictionary *dic in dataArr) {
                                           HuoChangModel * model = [[HuoChangModel alloc]initWithJsonDict:dic];
                                           [self.dataArray addObject:model];
                                       }
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
#pragma mark  TableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
//section头部间距
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH - 20, 1)];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}
//section底部间距
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8;
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH - 20, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
//赋值cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HuoChangAdressCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if(!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HuoChangAdressCell" owner:nil options:nil] firstObject];
    }
    [self setCell:cell index:indexPath.section];
    return cell;
}

- (void)setCell:(HuoChangAdressCell*)cell index:(NSInteger )index{
    HuoChangModel * model = _dataArray[index];
    cell.locationAddress.text = model.locationAddress;
    cell.detailAdress.text = model.address;
    if (model.ifDefault) {
        [cell.setDefaultBtn setImage:[UIImage imageNamed:@"defaultDone"] forState:UIControlStateNormal];
    }
    //0 编辑   1设置默认    2 删除
    cell.block = ^(UIButton *sender){
        switch (sender.tag) {
            case 0:{
                EditHuoChangAddressVC * vc =[[EditHuoChangAddressVC alloc]init];
                vc.model = model;
                [self.navigationController pushViewController:vc animated:YES];

            }
                break;
            case 1:{
                NSDictionary * dic = @{@"userId":[UserManager getDefaultUser].userId,
                                       @"recId":model.recId,
                                       @"locationAddress":model.locationAddress,
                                       @"address":model.address,
                                       @"cityCode":model.cityCode,
                                       @"longitude":model.longitude,
                                       @"latitude":model.latitude,
                                       @"ifDefault":@"1",
                                       @"ifDelete":@"0"};
           [ExpressRequest sendWithParameters:dic MethodStr:API_WL_HUOCHANG_DELECT reqType:k_POST success:^(id object) {
            [cell.setDefaultBtn setImage:[UIImage imageNamed:@"defaultDone"] forState:UIControlStateNormal];
               [_tableView reloadData];
               [self.tableView.header beginRefreshing];


           } failed:^(NSString *error) {
               [SVProgressHUD showErrorWithStatus:error];
           }];
               
            }
                break;
            case 2:{
                NSDictionary * dic = @{@"userId":[UserManager getDefaultUser].userId,
                                       @"recId":model.recId,
                                       @"locationAddress":model.locationAddress,
                                       @"address":model.address,
                                       @"cityCode":model.cityCode,
                                       @"longitude":model.longitude,
                                       @"latitude":model.latitude,
                                       @"ifDefault":model.ifDefault?@"1":@"0",
                                       @"ifDelete":@"1"};
                [ExpressRequest sendWithParameters:dic MethodStr:API_WL_HUOCHANG_DELECT reqType:k_POST success:^(id object) {
                    [_dataArray removeObjectAtIndex:index];
                    [_tableView reloadData];

                } failed:^(NSString *error) {
                    [SVProgressHUD showErrorWithStatus:error];
                }];

            }
                break;
            default:
                break;
        }
    };

}

//cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
    
}
//点击cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//给报价界面传值
    HuoChangModel * model =_dataArray[indexPath.section];
    if (_block) {
        _block(model);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addNewBtn{
    AddHuoChangAddressVC * addVC = [[AddHuoChangAddressVC alloc]init];
    [self.navigationController pushViewController:addVC animated:YES];
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
