//
//  ShunFengBiaoViewController.m
//  iwant
//
//  Created by 公司 on 2017/2/7.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "ShunFengBiaoViewController.h"
#import "MainHeader.h"
#import "ShunFengBiaoShi.h"
#import "CargodetailsViewController.h"
#import "UserNameViewController.h"
#import "LCFAlertView.h"
#import "BiaoshiTableViewCell.h"
#import "ShunFengBiaoTableViewCell.h"
#import "NothingBGView.h"
#import "ScreenView.h"

@interface ShunFengBiaoViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tableView;
    
    int _pageNo;
    NSMutableArray *_modelArray;
    
    LCFAlertView *_alertView;
    
    UIButton * cancelBtn;
    NSString * _carType; //筛选车型
    NothingBGView *_bgv;
    
    ScreenView * _shaixuanView; //智能筛选
    NSString * _distanceMin;
    NSString * _distanceMax;
    NSString * _priceMin;
    NSString * _priceMax;
    NSString * _weightMin;
    NSString * _weightMax;
}
@end

@implementation ShunFengBiaoViewController

-(void)viewWillAppear:(BOOL)animated{
    [_tableView.header beginRefreshing];
    _carType =@"else";
    _distanceMin = @"";
    _distanceMax = @"";
    _priceMin = @"";
    _priceMax = @"";
    _weightMin = @"";
    _weightMax = @"";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _pageNo = 1;
    
    self.view.backgroundColor = BACKGROUND_COLOR;
    UIButton * shaixuanBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    shaixuanBtn .frame = CGRectMake(SCREEN_WIDTH -100, 0, 100, 40);
    [shaixuanBtn setTitle:@"智能筛选>>" forState:UIControlStateNormal];
    [shaixuanBtn addTarget:self action:@selector(shaixuanCarType:) forControlEvents:UIControlEventTouchUpInside];
    [shaixuanBtn setTitleColor:[UIColor grayColor]forState:UIControlStateNormal];
//    [self.view addSubview:shaixuanBtn];
    [self creatTableView];
    
    _bgv = [[NothingBGView alloc] initWithFrame:CGRectMake(0, 44, WINDOW_WIDTH, WINDOW_HEIGHT)];
    _bgv.textLabel.text = @"暂无数据";
    _bgv.hidden = YES;
    [self.view addSubview:_bgv];

}
-(void)creatTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(8, 0, WINDOW_WIDTH-16, WINDOW_HEIGHT-64-44) style:UITableViewStyleGrouped];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    __weak ShunFengBiaoViewController *weakSelf = self;
    
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf loadData:NO];
    }];
    [_tableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf loadData:YES];
    }];
    [_tableView.header beginRefreshing];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
}

-(void)loadData:(BOOL)isAdd
{
    if (!isAdd) {
        _pageNo = 1;
    }else{
        _pageNo++;
    }
    NSString *URLStr = [NSString stringWithFormat:@"%@%@?%@=%@&%@=%@&%@=%@&distanceMin=%@&distanceMax=%@&priceMin=%@&priceMax=%@&weightMin=%@&weightMax=%@",BaseUrl,API_DOWNWIND_TASK_DRIVERFIND_DOWNWINDTASK,k_USER_ID,[UserManager getDefaultUser].userId,k_PAGE_NO,[NSString stringWithFormat:@"%d",_pageNo],k_PAGE_SIEZ,@"10",_distanceMin,_distanceMax,_priceMin,_priceMax,_weightMin,_weightMax];

    [ExpressRequest sendWithParameters:nil MethodStr:URLStr reqType:k_GET success:^(id object) {
        NSMutableArray *proArray = [NSMutableArray array];
        NSArray *dataArray = [(NSDictionary*)object objectForKey:@"data"];
        for (NSDictionary *dic in dataArray) {
            ShunFengBiaoShi *model = [[ShunFengBiaoShi alloc]initWithJsonDict:dic];
            [proArray addObject:model];
        }
        
        [self endRefresh];
        if (_pageNo == 1) {
            _modelArray = [NSMutableArray array];
            [_modelArray addObjectsFromArray:proArray];
        }else{
            [_modelArray addObjectsFromArray:proArray];
        }
        
        if (_modelArray.count == 0)
        {
            _tableView.footer.hidden = YES;
            _bgv.hidden = NO;
        }else{
            _tableView.footer.hidden  = NO;
            _bgv.hidden = YES;
        }

        [_tableView reloadData];
    } failed:^(NSString *error) {
        [self endRefresh];
        [SVProgressHUD showErrorWithStatus:error];
    }];
    
}
-(void)endRefresh{
    [_tableView.header endRefreshing];
    [_tableView.footer endRefreshing];
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
    return 8;
}
//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH - 20, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
//section底部间距
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8;
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 44, WINDOW_WIDTH - 20, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShunFengBiaoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ShunFengBiaoTableViewCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }

    ShunFengBiaoShi *model = _modelArray[indexPath.section];
    if (model.limitTime && [model.limitTime isEqualToString:@""]) {
    
    }
    cell.layer.cornerRadius = 8.0;
    cell.layer.masksToBounds = YES;
    [cell setModel:model];
    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 175;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
#pragma 判断普通用户的话就直接点击跳转认证镖师页面 
    if ([UserManager getDefaultUser].userType == 1) {
        UINib *nib = [UINib nibWithNibName:@"LCFAlertView" bundle:nil];
        _alertView = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
        _alertView.frame = [UIScreen mainScreen].bounds;
        [_alertView.goToRZ addTarget:self action:@selector(goToRZ:) forControlEvents:UIControlEventTouchUpInside];
        [_alertView.IKnow addTarget:self action:@selector(IKnow:) forControlEvents:UIControlEventTouchUpInside];
        [[UIApplication sharedApplication].keyWindow addSubview:_alertView];
        
        return;
    }
    
    ShunFengBiaoShi *model =_modelArray[indexPath.section];
    if ([model.status intValue] !=1) {
        [SVProgressHUD showInfoWithStatus:@"该 单 已 被 抢"];
        return;
    }
    
    //镖师
    CargodetailsViewController *VC = [[CargodetailsViewController alloc]init];
    VC.model = model;
    [self.navigationController pushViewController:VC animated:YES];
}
-(void)goToRZ:(UIButton *)btn{
    UserNameViewController *userVC = [UserNameViewController new];
    userVC.courentbtnTag = 2;
    [self.navigationController pushViewController:userVC animated:YES];
    [_alertView removeFromSuperview];
}
-(void)IKnow:(UIButton *)btn{
    [_alertView removeFromSuperview];
}

#pragma mark ------- 筛选车型  //智能筛选
-(void)shaixuanCarType:(UIButton *)sender{
    _shaixuanView = [[[NSBundle mainBundle] loadNibNamed:@"ScreenView" owner:self options:nil] lastObject];
    _shaixuanView.shaixuanView.layer.borderColor = COLOR_ORANGE_DEFOUT.CGColor;
    _shaixuanView.shaixuanView.layer.borderWidth = 0.5;
    _shaixuanView.shaixuanView.layer.cornerRadius = 6;
    _shaixuanView.shaixuanView.layer.masksToBounds = YES;
    [_shaixuanView showShaiXuanView];
    __weak ShunFengBiaoViewController * weakSelf = self;
    _shaixuanView.shaixuanBlock =^(){
        [weakSelf sureScreenBtnClick];
    };
}

#pragma mark --按钮筛选

-(void)sureScreenBtnClick{
    _distanceMin = _shaixuanView.distanceTextfieldMin.text;
    _distanceMax = _shaixuanView.distanceTextfieldMax.text;
    _priceMin = _shaixuanView.MoneyTextFieldMin.text;
    _priceMax = _shaixuanView.MoneyTextFieldMax.text;
    _weightMin = _shaixuanView.weightTextFieldMin.text;
    _weightMax = _shaixuanView.weightTextFieldMax.text;
    [_tableView.header beginRefreshing];
    [_shaixuanView removeFromSuperview];
}
-(void)btnClick:(UIButton *)btn{
    [cancelBtn removeFromSuperview];
    switch (btn.tag) {
        case 0:
            _carType = @"smallMinibus";
            [_tableView.header beginRefreshing];
            break;
        case 1:
            _carType = @"middleMinibus";
            [_tableView.header beginRefreshing];
            break;
        case 2:
            _carType = @"smallTruck";
            [_tableView.header beginRefreshing];
            break;
        case 3:
            _carType = @"middleTruck";
            [_tableView.header beginRefreshing];
            break;
        case 4:
            _carType = @"else";
            [_tableView.header beginRefreshing];
            break;
        default:
            break;
    }
}

-(void)cancelBtnClick:(UIButton *)sender{
    [cancelBtn removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
