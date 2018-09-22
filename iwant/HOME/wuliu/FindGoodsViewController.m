//
//  FindGoodsViewController.m
//  iwant
//
//  Created by 公司 on 2016/11/28.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "FindGoodsViewController.h"
#import "OrderViewController.h"
#import "MainHeader.h"
#import "Logist.h"
#import "NothingBGView.h"
#import "FindGoodsTableViewCell.h"
#import "ShaiXuanViewController.h"  //城市列表二级

@interface FindGoodsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
//    UIImageView *backImg;
    int _pageNo;
    int _areaPageNo;
    int _luxianPageNo;
    NothingBGView *_bgv;
    
    NSString * _type;//后台为了区分怎么筛选   附近  省  市
    NSString * _endPlaceCode;  //省市区的编码


}

@property (strong, nonatomic)  UITableView *tableView;
@property (strong, nonatomic)  NSMutableArray *dataArray;
@end

@implementation FindGoodsViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self setCostomeTitle:@"找货"];
    [self configSubviews];
    _type = @"1";
//    [self refreshData];
    
}
- (void)refreshData{
    [self.tableView.header beginRefreshing];
}

- (void)configSubviews{
    _bgv = [[NothingBGView alloc] initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT - 64)];
    _bgv.textLabel.text = @"暂无货源信息";
    _bgv.hidden = YES;
    [self.view addSubview:_bgv];
    
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [btn setImage:[UIImage imageNamed:@"Shape-244"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(shaixuan) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [self.view addSubview:self.tableView];
    
    
}

-(void)shaixuan{

    NSLog(@"筛选附近  目的地等  二级级列表样式 ");
    ShaiXuanViewController * selectVC = [[ShaiXuanViewController alloc]init];
    selectVC.shaixuanBlock = ^(NSString * endPlaceCode,NSString * type){
        _endPlaceCode = endPlaceCode;
        _type = type;
    };
    [self.navigationController pushViewController:selectVC animated:YES];
    
}

#pragma mark ---- 懒加载初始化
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(15, 5, WINDOW_WIDTH - 30, WINDOW_HEIGHT - 105) style:UITableViewStylePlain];
        _tableView.tag = 0;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.allowsSelection = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        __weak FindGoodsViewController *weakSelf = self;
        [_tableView addLegendHeaderWithRefreshingBlock:^{
            [weakSelf loadData:NO];
        }];
        [_tableView addLegendFooterWithRefreshingBlock:^{
            [weakSelf loadData:YES];
        }];
        
    }
    return _tableView;
}


-(NSArray *)dataArray{
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
    NSString *cityCode = [[NSUserDefaults standardUserDefaults] valueForKey:USER_CITY_CODE];
    [ExpressRequest sendWithParameters:nil
                             MethodStr:[NSString stringWithFormat:@"%@logistics/task/look/nearBy?userId=%@&startPlaceCityCode=%@&entPlaceCityCode=%@&type=%@&pageNo=%d&pageSize=20",BaseUrl,[UserManager getDefaultUser].userId,cityCode,_endPlaceCode,_type,_pageNo]
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

#pragma mark  TableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   
    return  self.dataArray.count;
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
    return 10;
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH - 20, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    FindGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FindGoodsTableViewCell" owner:nil options:nil] lastObject];
        cell.layer.cornerRadius = 10;
        cell.layer.borderWidth = 0.3;
        cell.layer.masksToBounds  = YES;
        cell.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    }
    NSMutableArray *arr = self.dataArray;
    Logist *model = arr[indexPath.section];
    cell.timeLabel.text =[NSString stringWithFormat:@"%@", model.publishTime];
    cell.distanceLabel.text = [NSString stringWithFormat:@"距离：%@km",model.distance];
    cell.goodsName.text = model.cargoName;
    cell.destinationLabel.text = model.entPlace;
    cell.weightLabel.text = model.cargoWeight;
    cell.squareLabel.text = [NSString stringWithFormat:@"%@方",model.cargoVolume];
    cell.quHuo.text = model.takeCargo?@"是":@"否";
    cell.songHuo.text = model.sendCargo ? @"是":@"否";
    
    if ([model.status intValue] == 1) {
        [cell.detailBtn setTitle:@"修改报价" forState:UIControlStateNormal];
    }else{
        [cell.detailBtn setTitle:@"报价" forState:UIControlStateNormal];
    }
    
    cell.block = ^(id sennder){
        OrderViewController * vc = [[OrderViewController alloc]init];
        vc.model = [[Logist alloc]init];
        
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
        
    };
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 185;
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
