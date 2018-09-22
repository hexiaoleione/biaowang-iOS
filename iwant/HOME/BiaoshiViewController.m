//
//  BiaoshiViewController.m
//  iwant
//
//  Created by pro 16/4/13.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "BiaoshiViewController.h"
#import "SVProgressHUD.h"
#import "BiaoshiTableViewCell.h"
#import "MainHeader.h"
#import "BiaoshiTableViewCell.h"
#import "SendWindTripViewController.h"
#import "CargodetailsViewController.h"
#import "UserNameViewController.h"
#import "LCFAlertView.h"
#define RATIO_H(A)               (WINDOW_HEIGHT-64.0)/(736.0- 64.0)*A

#define BACKGROUND_COLOR [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0]
#define WYScreenW [UIScreen mainScreen].bounds.size.width
#define WYScreenH [UIScreen mainScreen].bounds.size.height

#define ROTIO  WINDOW_HEIGHT/736.0

@interface BiaoshiViewController ()<UITableViewDataSource,UITableViewDelegate,BiaoshiTableViewCellDelegate>
{
    
    int _pageNo;
    UITableView *_tableView;
    
    
    NSMutableArray *_modelArray;
    
    NSString *_type;

    LCFAlertView *_alertView;
    
}

@end

@implementation BiaoshiViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   [_tableView.header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _pageNo = 1;
    _type = @"2";
    self.view.backgroundColor = [UIColor whiteColor];
    [self CreatTableView];
    
}

-(void)loadData:(BOOL)isAdd
{
    if (!isAdd) {
        _pageNo = 1;
    }else{
        _pageNo++;
    }
    if (_sendType == 1) {
        NSString *URLStr = [NSString stringWithFormat:@"%@%@?%@=%@&%@=%@&%@=%@&sortType=%@",BaseUrl,API_PUBLISH_LimitTime,k_USER_ID,[UserManager getDefaultUser].userId,k_PAGE_NO,[NSString stringWithFormat:@"%d",_pageNo],k_PAGE_SIEZ,@"10",_type];
        
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
                _tableView.hidden = YES;
                
            }
            
            [_tableView reloadData];
        } failed:^(NSString *error) {
            [self endRefresh];
            [SVProgressHUD showErrorWithStatus:error];
        }];
        
        
    }else{
        [RequestManager getWindExpressListWithuserId:[UserManager getDefaultUser].userId
                                              pageNo:[NSString stringWithFormat:@"%d",_pageNo]
                                            pageSize:@"10"
                                            sortType:_type
                                             Success:^(NSArray *result) {
                                                 [self endRefresh];
                                                 if (_pageNo == 1) {
                                                     _modelArray = [NSMutableArray array];
                                                     [_modelArray addObjectsFromArray:result];
                                                 }else{
                                                     [_modelArray addObjectsFromArray:result];
                                                 }
                                                 
                                                 if (_modelArray.count == 0)
                                                 {
                                                     _tableView.hidden = YES;
                                                     
                                                 }
                                                 
                                                 [_tableView reloadData];                                                 
                                                 
                                             }
                                              Failed:^(NSString *error) {
                                                  
                                                  [self endRefresh];
                                                  [SVProgressHUD showErrorWithStatus:error];
                                                  
                                                  
                                              }];
    }
}


-(void)CreatTableView
{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(WYScreenW/2-75, 200, 150, 150)];
    imageView.centerX = self.view.centerX;
    imageView.centerY = self.view.centerY - 64;
    imageView.image = [UIImage imageNamed:@"garbage"];
    
    
    UILabel *textLabel = [UILabel new];
    textLabel.textColor = [UIColor lightGrayColor];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.font = [UIFont systemFontOfSize:20];//采用系统默认文字设置大小
    textLabel.text = @"暂无订单";
    [textLabel sizeToFit];
    
    textLabel.y = imageView.bottom + 10;
    textLabel.centerX = self.view.centerX;
    
    
    
    [self.view addSubview:imageView];
    
    [self.view addSubview:textLabel];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(15, 90, WINDOW_WIDTH - 30, WINDOW_HEIGHT -  150)];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableFooterView = nil;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    __weak BiaoshiViewController *weakSelf = self;
    
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf loadData:NO];
    }];
    [_tableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf loadData:YES];
    }];
    [_tableView.header beginRefreshing];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    

    

//    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,120,35)];
//    btn.center = CGPointMake(WINDOW_WIDTH / 2, WINDOW_HEIGHT-120);
//    btn.titleLabel.font = FONT(14,NO);
//    [btn setBackgroundColor:[UIColor orangeColor]];
//    [btn setTitle:@"发布顺路送" forState:UIControlStateNormal];
//    btn.layer.cornerRadius = 10.0;
//    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//    [btn addTarget:self action:@selector(sendWind) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn];
    
    
}
//发布顺风专递
- (void)sendWind{
    
}
//发布顺风行程
-(void)sendTrip
{
//    [SVProgressHUD showSuccessWithStatus:@"发布顺风行程"];
    SendWindTripViewController *VC =  [[SendWindTripViewController alloc]init];
    
    [self.navigationController pushViewController:VC animated:YES];
    
    
    
}
-(void)Call:(UIButton *)button AtIndexPath:(NSInteger)path
{
    
    [SVProgressHUD showSuccessWithStatus:@"拨打电话给货主"];
     ShunFengBiaoShi *model = _modelArray[path];
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.mobile]];
    
}
-(void)location:(UIButton *)button AtIndexPath:(NSInteger)path
{
    
    
    [SVProgressHUD showSuccessWithStatus:@"查看货主位置"];
    
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
    BiaoshiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BiaoshiTableViewCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    ShunFengBiaoShi *model = _modelArray[indexPath.section];
    cell.a = indexPath.section;
    if (model.limitTime && [model.limitTime isEqualToString:@""]) {
        
    }
    UIImage *ima = [UIImage imageNamed:@"bg_oo"];
    cell.backgroundColor = [UIColor whiteColor];
    UIImageView *imageview = [[UIImageView alloc]initWithImage:ima];
    cell.backgroundView = imageview;

    [cell setModel:model];
    cell.delegate = self;
    
   
    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
#pragma 判断普通用户的话就直接点击跳转认证镖师页面
     if ([UserManager getDefaultUser].userType == 1) {
//        HHAlertView *alertView = [[HHAlertView alloc]initWithTitle:@"" detailText:@"亲，成为镖师就可以接单了，快去认证吧！" cancelButtonTitle:@"我知道了" otherButtonTitles:@[@"去认证"]];
////         alertView.mode = HHAlertViewModeWarning;
//         alertView.mode = HHAlertViewModeDefault;
//         [alertView showWithBlock:^(NSInteger index) {
//         if (index != 0) {
//          UserNameViewController *userVC = [UserNameViewController new];
//                userVC.courentbtnTag = 2;
//          [self.navigationController pushViewController:userVC animated:YES];
//              }
//            }];
         UINib *nib = [UINib nibWithNibName:@"LCFAlertView" bundle:nil];
         _alertView = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
          _alertView.frame = [UIScreen mainScreen].bounds;
         [_alertView.goToRZ addTarget:self action:@selector(goToRZ:) forControlEvents:UIControlEventTouchUpInside];
         [_alertView.IKnow addTarget:self action:@selector(IKnow:) forControlEvents:UIControlEventTouchUpInside];
         [[UIApplication sharedApplication].keyWindow addSubview:_alertView];
         
        return;
       }
//镖师
    CargodetailsViewController *VC = [[CargodetailsViewController alloc]init];
    
    ShunFengBiaoShi *model =_modelArray[indexPath.section];
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

-(void)endRefresh{
    [_tableView.header endRefreshing];
    [_tableView.footer endRefreshing];
}

//#pragma mark--scrollViewDelegate
//
//-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//    CGPoint point=scrollView.contentOffset;
//    NSLog(@"停止拖拽,根据拖拽程度判断是否要加载数据");
//    if (point.y > 20) {
//        [self loadData:YES];
//    }
//}

//1距离
//2出发时间
//3好评度
- (void)changePX:(int)type{
    _type = [NSString stringWithFormat:@"%d",type];
    [self loadData:NO];
}

@end
