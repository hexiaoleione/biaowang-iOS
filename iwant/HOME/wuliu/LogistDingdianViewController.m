//
//  LogistDingdianViewController.m
//  iwant
//
//  Created by dongba on 16/9/1.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "LogistDingdianViewController.h"
#import "LuxianTableViewCell.h"
#import "LogistAddLuxianView.h"
#import "CityViewController.h"
#import "MainHeader.h"
@interface LogistDingdianViewController ()<UITableViewDelegate,UITableViewDataSource>{
    LogistAddLuxianView *_selectView;
    NSString *_fromCityCode;
    NSString *_toCityCode;
    BOOL _isHiden;
}
@property (strong, nonatomic)  UITableView *tableView;

@property (strong, nonatomic)  NSMutableArray *dataArray;

@end

@implementation LogistDingdianViewController

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(15, 0, WINDOW_WIDTH - 30, WINDOW_HEIGHT - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCostomeTitle:@"关注的路线"];
    [self setDataArray];
    [self configSubviews];
}

- (void)configSubviews{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    _selectView = [[[NSBundle mainBundle] loadNibNamed:@"addLuxian" owner:nil options:nil] lastObject];
    
    _selectView.left = 0;
//    _selectView.top = WINDOW_HEIGHT - 200 - 64;
    _selectView.bottom = WINDOW_HEIGHT - 64;
    _selectView.width = WINDOW_WIDTH;
    _selectView.height = 400;
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideSelectView)];
    swipeUp.numberOfTouchesRequired = 1;
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    _selectView.touchView.userInteractionEnabled = YES;
    [_selectView.touchView addGestureRecognizer:swipeUp];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideSelectView)];
    [_selectView.touchView addGestureRecognizer:tap];
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideSelectView)];
    swipeDown.numberOfTouchesRequired = 1;
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    _selectView.touchView.userInteractionEnabled = YES;
    [_selectView.touchView addGestureRecognizer:swipeDown];
    
    __weak LogistDingdianViewController *weakSelf = self;
    _selectView.block = ^(NSInteger tag){
        [weakSelf selectCity:(tag)];
    };
    

    //阴影颜色
    _selectView.layer.shadowColor = [UIColor blackColor].CGColor;
    //阴影横向和纵向的偏移值
    _selectView.layer.shadowOffset = CGSizeMake(0, -5.0);
    //阴影透明度
    _selectView.layer.shadowOpacity = 0.45;
    //  阴影半径大小
    _selectView.layer.shadowRadius = 5.0;
    [self.view addSubview:_selectView];
}

- (void)selectCity:(NSInteger)tag{
    switch (tag) {
        case 0:
        {
            CityViewController *cityVC =[[CityViewController alloc]init];
            cityVC.returnTextBlock = ^(NSString *address,NSString *citycode,NSString *towncode,NSString *cityname,NSString *townname){
                _selectView.startLabel.text = [NSString stringWithFormat:@"%@",address];
                _fromCityCode = citycode;
            };
            [self.navigationController pushViewController:cityVC animated:YES];
            
        }
            
            break;
        case 1:
        {
            CityViewController *cityVC =[[CityViewController alloc]init];
            cityVC.returnTextBlock = ^(NSString *address,NSString *citycode,NSString *towncode,NSString *cityname,NSString *townname){
                _selectView.endLabel.text = [NSString stringWithFormat:@"%@",address];
                _toCityCode = citycode;
            };
            [self.navigationController pushViewController:cityVC animated:YES];
            
        }
            
            break;
        case 2:
        {//添加路线
            if (_fromCityCode.length == 0) {
                [SVProgressHUD showErrorWithStatus:@"请选择出发地区"];
                return;
            }
            if (_toCityCode.length == 0) {
                [SVProgressHUD showErrorWithStatus:@"请选择到达地区"];
                return;
            }
            
            NSDictionary *dic = @{@"userId":[UserManager getDefaultUser].userId,
                                  @"startPlace":_selectView.startLabel.text,
                                  @"entPlace":_selectView.endLabel.text,
                                  @"startPlaceCityCode":_fromCityCode,
                                  @"entPlaceCityCode":_toCityCode};
            [SVProgressHUD show];
            [ExpressRequest sendWithParameters:dic MethodStr:@"logistics/line/add" reqType:k_POST success:^(id object) {
                [SVProgressHUD showSuccessWithStatus:[object valueForKey:@"message"]];
                [self setDataArray];
            } failed:^(NSString *error) {
                [SVProgressHUD showErrorWithStatus:error];
            }];
            
        }
            
            break;
            
        default:
            break;
    }
}

- (void)setDataArray{
    [ExpressRequest sendWithParameters:nil MethodStr:[NSString stringWithFormat:@"%@logistics/line/list?userId=%@&pageSize=20&pageNo=1",BaseUrl,[UserManager getDefaultUser].userId] reqType:k_GET success:^(id object) {
        self.dataArray  = [NSMutableArray arrayWithArray:[object valueForKey:@"data"]];
        [_tableView reloadData];
    } failed:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
}

- (void)hideSelectView{
    if (_isHiden) {
        [UIView animateWithDuration:0.3 animations:^{
            _selectView.y -= 180;
        }];
        _isHiden = !_isHiden;
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            _selectView.y += 180;
        }];
        _isHiden = !_isHiden;
    }
    
}



#pragma mark  TableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 3;
    return self.dataArray.count;
    
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
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH - 20, 10)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
//section底部间距
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH - 20, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LuxianTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LuxianTableViewCell" owner:nil options:nil] lastObject];
        cell.backgroundColor = UIColorFromRGB(0xfafafa);
        cell.layer.borderColor = [COLOR_(203, 203, 203, 1) CGColor];
        cell.layer.borderWidth = 1.0;
        
    }
    
    NSDictionary *dic = self.dataArray[indexPath.section];
    cell.startLabel.text = [dic valueForKey:@"startPlace"];
    cell.endLabel.text = [dic valueForKey:@"entPlace"];
    cell.block = ^(id sender){
        [self.dataArray removeObjectAtIndex:indexPath.section];
        [self.tableView reloadData];
        
       [ExpressRequest sendWithParameters:nil MethodStr:[NSString stringWithFormat:@"logistics/line/delete/%@",[dic valueForKey:@"recId"]] reqType:k_PUT success:^(id object) {
           [SVProgressHUD showSuccessWithStatus:[object valueForKey:@"message"]];
       } failed:^(NSString *error) {
           [SVProgressHUD showErrorWithStatus:error];
       }];
    };
    
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 78;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    //    OfferViewController *offerVC = [OfferViewController new];
    //    [self.navigationController pushViewController:offerVC animated:YES];
    //    [self.navigationController popViewControllerAnimated:YES];
    
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
