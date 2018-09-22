//
//  HuozhuViewController.m
//  iwant
//
//  Created by pro on 16/4/13.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "HuozhuViewController.h"
#import "MainHeader.h"
#import "ConsignorTableViewCell.h"
#import "SVProgressHUD.h"
#import "ConsignorTableViewCell.h"
#import "BiaoshiInfoViewController.h"
#import "ShunFeng.h"
//#import "ChatViewController.h"
#import "settinhHeaderViewController.h"

#define RATIO_H(A)                  WINDOW_HEIGHT/736.0 *(A)
#define WINDOW_WIDTH                [[UIScreen mainScreen] bounds].size.width
#define WINDOW_HEIGHT               [[UIScreen mainScreen] bounds].size.height

#define BACKGROUND_COLOR [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0]
#define WYScreenW [UIScreen mainScreen].bounds.size.width
#define WYScreenH [UIScreen mainScreen].bounds.size.height
#define ROTIO  WINDOW_HEIGHT/736.0

@interface HuozhuViewController ()<UITableViewDataSource,UITableViewDelegate,ConsignorTableViewCellDelegate,UIScrollViewDelegate>
{
    
    int _pageNo;
    UITableView *_tableView;
    
    
    NSMutableArray *_modelArray;
    NSString *_type;
    
    
}

@end

@implementation HuozhuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _pageNo = 1;
    _type = @"2";
    [self CreatTableView];
}
-(void)loadData:(BOOL)isAdd
{
    if (!isAdd) {
        _pageNo = 1;
    }else{
        _pageNo++;
    }
    
    
    [RequestManager getWindTripListWithuserId:[UserManager getDefaultUser].userId
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
                                          
            if (_modelArray.count == 0) {
                
                        _tableView.hidden = YES;
                
                                          }
                                          
                                          [_tableView reloadData];
        
    }
        Failed:^(NSString *error) {
            
            [self endRefresh];
            [SVProgressHUD showErrorWithStatus:error];
                                         
                                         
                                     }];
    
    
}

    
    
-(void)CreatTableView
{
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(15, 90, WINDOW_WIDTH - 30, WINDOW_HEIGHT -  154)];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    __weak HuozhuViewController *weakSelf = self;

    [_tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf loadData:NO];
    }];
    [_tableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf loadData:YES];
    }];
    [_tableView.header beginRefreshing];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 200 *ROTIO, WYScreenW, 100)];
    textLabel.text = @"附近暂无镖师行程";
    textLabel.font = [UIFont systemFontOfSize:30];//采用系统默认文字设置大小
    
    textLabel.textColor = [UIColor grayColor];
    textLabel.textAlignment = NSTextAlignmentCenter;
    
    
    [self.view addSubview:textLabel];

    
    [self.view addSubview:_tableView];
    
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,120,35)];
    btn.center = CGPointMake(WINDOW_WIDTH / 2, WINDOW_HEIGHT-120);
    btn.titleLabel.font = FONT(14,NO);
    [btn setBackgroundColor:[UIColor orangeColor]];
    [btn setTitle:@"发布顺路送" forState:UIControlStateNormal];
    btn.layer.cornerRadius = 10.0;
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [btn addTarget:self action:@selector(sendExpress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

}
-(void)sendExpress
{
    if (![[UserManager getDefaultUser].realManAuth isEqualToString:@"Y"]) {
        HHAlertView *alertView = [[HHAlertView alloc]initWithTitle:@"特 别 提 醒 ！" detailText:@"根据《中华人民共和国反恐怖主义法》规定，发快递须实名制，若您所填信息不真实或不完善，请尽快修改和完善，感谢您的配合。" cancelButtonTitle:@"取消" otherButtonTitles:@[@"去完善"]];
        alertView.mode = HHAlertViewModeWarning;
        [alertView showWithBlock:^(NSInteger index) {
            if (index != 0) {
                [self.navigationController pushViewController:[settinhHeaderViewController new] animated:YES];
            }
            
        }];
        return;
    }
//    
//    SendCityExpressViewController *VC = [[SendCityExpressViewController alloc]init];
//    [self.navigationController pushViewController:VC animated:YES];
    
}
-(void)Call:(UIButton *)button AtIndexPath:(NSInteger)path
{
    
    ShunFeng *model = _modelArray[path];
    NSLog(@"手机号%@",model.driverMobile);
    [Utils callAction:model.driverMobile];
    
//即时通讯
//    ChatViewController *chaVC=[[ChatViewController alloc]initWithConversationChatter:model.userId conversationType:eConversationTypeChat];
//    chaVC.title= model.userName;
//    [self.navigationController pushViewController:chaVC animated:YES];
    
}
-(void)location:(UIButton *)button AtIndexPath:(NSInteger)path
{
 
    ShunFeng *model = _modelArray[path];
    
    BiaoshiInfoViewController *vc = [[BiaoshiInfoViewController alloc]init];
    vc.userId = model.userId;
    [self.navigationController pushViewController:vc animated:YES];

    
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
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH - 20, 10)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConsignorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ConsignorTableViewCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    
    ShunFeng *model = _modelArray[indexPath.section];
    cell.a = indexPath.section;
    
    [cell setModel:model];
    
    cell.delegate =self;
    
    
    
    UIImage *ima = [UIImage imageNamed:@"bg_oo"];
    cell.backgroundColor = [UIColor whiteColor];
    UIImageView *imageview = [[UIImageView alloc]initWithImage:ima];
    cell.backgroundView = imageview;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.traficTool.image = [UIImage imageNamed:[NSString stringWithFormat:@"transportation_%@",model.transportationId]];
    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return RATIO_H(130);
    
}


- (void)gotoDetail{
    BiaoshiInfoViewController *vc = [[BiaoshiInfoViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)endRefresh{
    [_tableView.header endRefreshing];
    [_tableView.footer endRefreshing];
}

- (void)changePX:(int)type{
    _type = [NSString stringWithFormat:@"%d",type];
    [self loadData:NO];
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
@end
