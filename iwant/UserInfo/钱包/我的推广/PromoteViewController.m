//
//  PromoteViewController.m
//  iwant
//
//  Created by pro on 16/5/27.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "PromoteViewController.h"
#import "PromotionalCourierTableViewCell.h"
#import "Promote.h"
#import "EcoinWebViewController.h"
#import "SDCycleScrollView.h"
#import "NothingBGView.h"

#define WINDOW_WIDTH                [[UIScreen mainScreen] bounds].size.width
#define WINDOW_HEIGHT               [[UIScreen mainScreen] bounds].size.height
static CGFloat headHeight = 44;
@interface PromoteViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>
{
    
    UIView *_chartview;
    
    UITableView *_tableView;
    
    NSMutableArray *_dataArr;
    
    UILabel *_bgLabel;
    
    NothingBGView *_bgv;
    
    NSString *_agentCount;
    
    NSString *_perAgentSum;
    
    NSInteger _pageSize;
}
@property (nonatomic ,assign) NSInteger pageNo;
@end

@implementation PromoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self CreatView];
    [self setCostomeTitle:@"人人代理"];
    [self initData];
    [self setRightItem];
}
-(void)setRightItem{
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"explain"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(goToNextView)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

-(void)goToNextView{
    
        EcoinWebViewController *vc = [[EcoinWebViewController alloc]init];
        vc.web_type = WEB_USER_RENREN;
        [self.navigationController pushViewController:vc animated:YES];
    

}
- (void)initData{
    _dataArr = [NSMutableArray array];
    _agentCount = @"0";
    _perAgentSum = @"0";
    _pageNo = 1;
    _pageSize = 2;
    // 获取推广人数
    NSString *userId = [UserManager  getDefaultUser].userId;
    [RequestManager getPerAgentCountWithUserId:userId success:^(NSString *reslut) {
        _agentCount = reslut;
        [_tableView reloadData];
    } Failed:^(NSString *error) {
        
    }];
    
    // 获取推广收入
    [RequestManager getUserBalanceWithUserId:userId success:^(NSString *reslut) {
        _perAgentSum = reslut;
        [_tableView reloadData];
    } Failed:^(NSString *error) {
    }];
    
    [RequestManager getMyunderUserId:userId pageNo:_pageNo pageSize:_pageSize Success:^(NSMutableArray *result) {
        if (result.count < 1) {
            _tableView.hidden = YES;
            //            _bgLabel.hidden = NO;
            _bgv.hidden = NO;
        }else{
            _dataArr = result;
            [_tableView reloadData];
            //            _bgLabel.hidden = YES;
            _bgv.hidden = YES;
            _tableView.hidden = NO;
        }
        _bgv.textLabel.text = @"您还没有推广收入\n一份耕耘，一份收获，努力越大，收获越多";
    } Failed:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
        _tableView.hidden = YES;
        _bgv.hidden = NO;
        _bgv.textLabel.text = error;
        //        _bgLabel.hidden = NO;
    }];
}

- (void)loadData{
    
    NSString *userId = [UserManager  getDefaultUser].userId;
    [RequestManager getMyunderUserId:userId pageNo:_pageNo pageSize:_pageSize Success:^(NSMutableArray *result) {
        [self endRefresh];
            [_dataArr addObjectsFromArray:result];
            [_tableView reloadData];
    } Failed:^(NSString *error) {
        [self endRefresh];
    }];
}

-(void)CreatView
{
    
//    [self.view addSubview:[self creatScrollView]];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, WINDOW_WIDTH - 20, WINDOW_HEIGHT -64) style:UITableViewStylePlain];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone; //隐藏线
    __weak typeof(self) weakSelf = self;
    [_tableView addLegendFooterWithRefreshingBlock:^{
        weakSelf.pageNo++;
        [weakSelf loadData];
    }];
    
    
    _bgLabel = [UILabel new];
    _bgLabel.textColor = [UIColor whiteColor];
    _bgLabel.text = @"一份耕耘，一份收获，努力越大，收获越多";
    [_bgLabel sizeToFit];
    _bgLabel.center = _tableView.center;
    _bgLabel.hidden = YES;
    
    [self.view addSubview:_bgLabel];
    [self.view addSubview:_tableView];
    
    _bgv = [[NothingBGView alloc] initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT - 64)];
    _bgv.textLabel.text = @"您还没有推广收入\n一份耕耘，一份收获，努力越大，收获越多";
    _bgv.textLabel.numberOfLines = 2;
    _bgv.hidden = YES;
    
    [self.view addSubview:_bgv];

    
}

-(void)endRefresh{
    [_tableView.header endRefreshing];
    [_tableView.footer endRefreshing];
}

- (UIView *)creatScrollView{
    NSArray *imagesURLStrings = @[
                                  @"http://www.efamax.com/images/manhua/shunfeng_01.png",
                                  @"http://www.efamax.com/images/manhua/shunfeng_02.png",
                                  @"http://www.efamax.com/images/manhua/shunfeng_03.png",
                                  @"http://www.efamax.com/images/manhua/shunfeng_04.png"
                                  ];
    // 网络加载 --- 创建自定义图片的pageControlDot的图片轮播器
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, WINDOW_WIDTH - 20, (WINDOW_WIDTH - 10)*543/700) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    cycleScrollView.autoScrollTimeInterval = 5.0;
    cycleScrollView.pageControlBottomOffset = 10;
    cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"pageControlCurrentDot"];
    cycleScrollView.pageDotImage = [UIImage imageNamed:@"pageControlDot"];
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    cycleScrollView.imageURLStringsGroup = imagesURLStrings;
    return cycleScrollView;
}

#pragma mark  TableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
            
        default:
            return _dataArr.count;
            break;
    }
    return _dataArr.count;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section != 0) {
        UIView *headerView = [UIView new];
        headerView.frame = CGRectMake(0, 0, tableView.width, headHeight);
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, tableView.width, 44)];
        label.backgroundColor = [UIColor whiteColor];
        label.textColor = COLOR_ORANGE_DEFOUT;
        label.textAlignment = NSTextAlignmentCenter;
//        label.text = @"推广收益(仅顺风)";
        label.text =[NSString stringWithFormat:@"推广收益(仅顺风):%.2f元",[_perAgentSum doubleValue]];
        label.font = [UIFont systemFontOfSize:18];
        label.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:label];
        
        UIView *line1 = [UIView new];
        line1.backgroundColor = [UIColor lightGrayColor];
        line1.frame = CGRectMake(0, label.bottom, tableView.width, 1);
        [headerView addSubview:line1];
//
//        
//        
//        UILabel *number = [UILabel new];
//        number.frame = CGRectMake(0, label.bottom + 10, tableView.width/2, 30);
//        number.text = [NSString stringWithFormat:@"推广人数：%@人",_agentCount];
//        number.textAlignment = NSTextAlignmentCenter;
//
//        [headerView addSubview:number];
//        
//        UIView *line2 = [UIView new];
//        line2.backgroundColor = BACKGROUND_COLOR;
//        line2.frame = CGRectMake(tableView.centerX-0.5, label.bottom + 10, 1, 30);
//        [headerView addSubview:line2];
//        number.right = line2.x - 20;
//        
//        UILabel *money = [UILabel new];
//        money.frame = CGRectMake(line2.right, label.bottom + 10, tableView.width/2, 30);
//        money.text = [NSString stringWithFormat:@"推广收入：%@元",_perAgentSum];
//        money.textAlignment = NSTextAlignmentCenter;
//        [headerView addSubview:money];
//        
//        UIView *line3 = [UIView new];
//        line3.backgroundColor = BACKGROUND_COLOR;
//        line3.frame = CGRectMake(0, label.bottom + 50, tableView.width, 1);
//        [headerView addSubview:line3];
//        
        
        return headerView;
        
        
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section != 0) {
        return headHeight;
    }
    
    return 5.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.frame = CGRectMake(0, 0, WINDOW_WIDTH, 10);
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }
    return 1.;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PromotionalCourierTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PromotionalCourierTableViewCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    if (indexPath.section == 0) {
         [cell addSubview:[self creatScrollView]];
    }else{
        Promote *model = _dataArr[indexPath.row];
        [cell configModel:model];
       
    }
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return (WINDOW_WIDTH - 10)*543/700;
            break;
            
        default:
            return 70;
            break;
    }
    return 70;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    
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
