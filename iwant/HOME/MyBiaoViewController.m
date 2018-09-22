//
//  MyBiaoViewController.m
//  iwant
//
//  Created by pro on 16/4/29.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "MyBiaoViewController.h"
#import "MainHeader.h"
#import "BiaoTableViewCell.h"
#import "OperationViewController.h"
#import "BiaoshiInfoViewController.h"
#import "ShunFengBiaoShi.h"
#import "ConsignorTableViewCell.h"
//按比例获取高度
#define  WGiveHeight(HEIGHT) HEIGHT * [UIScreen mainScreen].bounds.size.height/568.0

//按比例获取宽度
#define  WGiveWidth(WIDTH) WIDTH * [UIScreen mainScreen].bounds.size.width/320.0
#define BACK_COLOR [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0]

#define WYScreenW [UIScreen mainScreen].bounds.size.width
#define WYScreenH [UIScreen mainScreen].bounds.size.height
#define ROTIO  WINDOW_HEIGHT/736.0

@interface MyBiaoViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    
    int _pageNo;
    
    UITableView *_tableView;
    
    NSMutableArray *_modelArray;
    
    UILabel *_timeLabel;
    UILabel *_fromLabel;
    UILabel *_toLabel;
    UIButton *_cancleBtn;
    NSString *_recId;
}

@end

@implementation MyBiaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _pageNo = 1;
//    [self showOwnWind];
    [self CreatTableView];
    
}
- (void)refreshData{
    [_tableView.header beginRefreshing];
}

- (void)showOwnWind{
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(WGiveWidth(20), WGiveHeight(70), WGiveWidth(24), WGiveHeight(54))];
    image.image = [UIImage imageNamed:@"zhuangtai_yuan"];
    [self.view addSubview:image];
    _timeLabel = [self CreatLabelWithtext:@"2016-6-20 8：00" textfont: FONT(18,NO) textcolor:[UIColor orangeColor]X:WGiveWidth(20) Y:WGiveHeight(40) W:WGiveWidth(200) H:WGiveHeight(30)];
    
    _fromLabel = [self CreatLabelWithtext:@"起始位置：北京市回龙观碧水庄园" textfont:FONT(14,NO)  textcolor:[UIColor blackColor] X:WGiveWidth(40) Y:WGiveHeight(70) W:WINDOW_WIDTH-40 H:WGiveHeight(25)];
    _toLabel = [self CreatLabelWithtext:@"目的地：北京市昌平区生命科学园" textfont:FONT(14,NO)  textcolor:[UIColor grayColor] X:WGiveWidth(40) Y:WGiveHeight(95) W:WINDOW_WIDTH-40 H:WGiveHeight(25)];
    
    _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancleBtn.frame = CGRectMake(WINDOW_WIDTH - WGiveWidth(80), WGiveWidth(40), WGiveWidth(80), WGiveHeight(30));
    _cancleBtn.titleLabel.font = FONT(18,NO);
    [_cancleBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [_cancleBtn setTitle:@"取消行程" forState:UIControlStateNormal];
    [_cancleBtn addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancleBtn];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@?%@=%@",BaseUrl,API_DRIVER_ROUT,K_DRIVERID,[UserManager getDefaultUser].userId];
    [ExpressRequest sendWithParameters:nil
                             MethodStr:urlStr
                               reqType:k_GET
                               success:^(id object) {
       NSDictionary *dic = [object valueForKey:@"data"][0];
       _timeLabel.text =[NSString stringWithFormat:@"%@",dic[@"publishTime"]] ;
       _fromLabel.text = [NSString stringWithFormat:@"%@",dic[@"address"]];
       _toLabel.text = [NSString stringWithFormat:@"%@",dic[@"addressTo"]];
       _recId = [NSString stringWithFormat:@"%@",dic[@"recId"]];
    } failed:^(NSString *error) {
        _timeLabel.height = 0;
        _fromLabel.height = 0;
        _toLabel.height = 0;
        _tableView.frame = CGRectMake(0,40, WINDOW_WIDTH, WINDOW_HEIGHT -  40);
        
    }];
}

-(UILabel *)CreatLabelWithtext:(NSString *)text textfont:(UIFont *)font textcolor:(UIColor *)textcolor X:(CGFloat)x Y:(CGFloat)y W:(CGFloat)w H:(CGFloat)h
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(x, y, w, h)];
    label.text = text;
    label.textColor=textcolor;
    label.font = font;
    
    [self.view addSubview:label];
    
    return label;
    
}

-(void)loadData:(BOOL)isAdd
{
    if (!isAdd) {
        _pageNo = 1;
    }else{
        _pageNo++;
    }
    
    
    [RequestManager GetBiaoShiTaskRouteWithuserId:[UserManager getDefaultUser].userId pageNo:[NSString stringWithFormat:@"%d",_pageNo] pageSize:@"5" Success:^(NSArray *result) {
        [self endRefresh];
        if (_pageNo == 1) {
            _modelArray = [NSMutableArray array];
            [_modelArray addObjectsFromArray:result];
        }else{
            [_modelArray addObjectsFromArray:result];
        }
//        if (_modelArray.count == 0) {
//            _tableView.hidden = YES;
//        }
//        
        [_tableView reloadData];
        
    }
        Failed:^(NSString *error) {
         [self endRefresh];
         NSLog(@"%@",error);
     }];
    
    
}



-(void)CreatTableView
{
    CGFloat y;
    if (_toLabel.height != 0) {
        y =_toLabel.bottom;
    }else{
        y = 40;
    }
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,y, WINDOW_WIDTH, WINDOW_HEIGHT -  y - 64)];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    __weak MyBiaoViewController *weakSelf = self;
    
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf loadData:NO];
    }];
    [_tableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf loadData:YES];
    }];
    [_tableView.header beginRefreshing];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(WYScreenW/2-75, 200, 150, 150)];
//    imageView.image = [UIImage imageNamed:@"bgbgbgbg"];
//    
//    
//    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 350 *ROTIO, WYScreenW, 100)];
//    textLabel.text = @"暂无订单";
//    textLabel.font = [UIFont systemFontOfSize:20];//采用系统默认文字设置大小
//    
//    textLabel.textColor = [UIColor grayColor];
//    textLabel.textAlignment = NSTextAlignmentCenter;
//    
//    
//    [self.view addSubview:imageView];
//    
//    [self.view addSubview:textLabel];


    //    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _tableView.backgroundColor = [UIColor whiteColor];
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
    return 5;
}
//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH - 20, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
//section底部间距
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
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

        cell.backgroundColor = BACK_COLOR;

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    ShunFengBiaoShi *model = _modelArray[indexPath.section];
    
    [cell setModel:model];
    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OperationViewController *VC = [[OperationViewController alloc]init];
    ShunFengBiaoShi *model =_modelArray[indexPath.section];
     VC.model = model;
    
    [self.navigationController pushViewController:VC animated:YES];
}
- (void)gotoDetail{

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
    /*
     顺风 删除订单    路径downwind/task/deldeteDow     请求GET    参数  Integer recId,Integer type
     type  = 1 用户删除   type  = 2  镖师删除
     */
    [ExpressRequest sendWithParameters:nil MethodStr:[NSString stringWithFormat:@"%@downwind/task/deldeteDow?recId=%@&type=2",BaseUrl,model.recId] reqType:k_GET success:^(id object) {
        [_modelArray removeObjectAtIndex:indexPath.section];
        [_tableView reloadData];
        [SVProgressHUD showSuccessWithStatus:@"删除成功"];
    } failed:^(NSString *error) {
        [_tableView reloadData];
        [SVProgressHUD showErrorWithStatus:error];
    }];
    
}


-(void)endRefresh{
    [_tableView.header endRefreshing];
    [_tableView.footer endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancle{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@?recId=%@",BaseUrl,API_DRIVER_BREAK,_recId];
    [SVProgressHUD show];
    [ExpressRequest sendWithParameters:nil MethodStr:urlStr reqType:k_GET success:^(id object) {
    [SVProgressHUD dismiss];
        _tableView.frame = CGRectMake(0,40, WINDOW_WIDTH, WINDOW_HEIGHT -  40);
    } failed:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
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
