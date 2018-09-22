
//
//  SCouponVC.m
//  ProgressView
//
//  Created by Gary on 16/11/20.
//  Copyright © 2016年 jy. All rights reserved.
//

#import "SCouponVC.h"
#import  "ScoponCell.h"
#import "SCouponModel.h"
#import "InforWebViewController.h"
//按比例获取高度
#define  WGiveHeight(HEIGHT) HEIGHT * [UIScreen mainScreen].bounds.size.height/667.0

//按比例获取宽度
#define  WGiveWidth(WIDTH) WIDTH * [UIScreen mainScreen].bounds.size.width/375.0

@interface SCouponVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UIImageView * imageView;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataArr;

@end

@implementation SCouponVC

#pragma mark ------ 懒加载
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc]init];
    }
    return _dataArr;
}

-(UITableView *)tableView{
    if (!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(16, _imageView.bottom +10, SCREEN_WIDTH-32, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 60)];
    label.textColor = [UIColor whiteColor];
    label.text = @"领取现金券";
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(explain) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 40, 30);
    [button setTitle:@"说明" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = menuButton;
    [self configWebView];
    [self.view addSubview:self.tableView];
    [self creatData];
 }

- (void)configWebView{
    
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(WGiveWidth(0), WGiveWidth(0) ,WINDOW_WIDTH - WGiveWidth(0),WGiveHeight(150))];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:@"http://www.efamax.com/mobile/activityListImg/quan.png"]];
    [self.view addSubview:_imageView];
}

//奖励说明
-(void)explain{
    InforWebViewController * webVC =[[InforWebViewController alloc]init];
    webVC.info_type = INFO_SCOUPON_RULE;
    [self.navigationController pushViewController:webVC animated:YES];
}

-(void)creatData{
    [SVProgressHUD show];
    //获取现金券列表
    NSString * urlStr =[NSString stringWithFormat:@"%@coupon/getReceiveList?userId=%@",BaseUrl,[UserManager getDefaultUser].userId];
    [ExpressRequest sendWithParameters:nil MethodStr:urlStr reqType:k_GET success:^(id object){
        
        NSMutableArray *proArray = [NSMutableArray array];
        NSArray *dataArray = [(NSDictionary*)object objectForKey:@"data"];
        for (NSDictionary *dic in dataArray) {
            [SVProgressHUD dismiss];
            SCouponModel *model = [[SCouponModel alloc]initWithJsonDict:dic];
            [proArray addObject:model];
        }
        [self.dataArr addObjectsFromArray:proArray];
        [_tableView reloadData];
    } failed:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
}

#pragma mark ------uitableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  1;
}
//section头部间距
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}
//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH - 20, 5)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
//section底部间距
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH - 20, 5)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  64;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ScoponCell * cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
         cell = [[[NSBundle mainBundle] loadNibNamed:@"ScoponCell" owner:nil options:nil] lastObject];
         cell.selectionStyle =UITableViewCellSelectionStyleNone;
    }
    SCouponModel * model = _dataArr[indexPath.section];
    cell.couponName.text = model.money;
    cell.couponFrom.text = model.couponFrom;
    [self setBtnStatus:model.couponCount btn:cell.ReceiveBtn withLabel:cell.countLabel withCell:cell];
    cell.Block = ^(){
        [self clickDataWithConditionId:model.conditionId];
    };
    return cell;
}

-(void)clickDataWithConditionId:(NSString *)conditionId{
    //领取优惠券按钮接口
    NSString * urlStr =[NSString stringWithFormat:@"%@coupon/receiveCoupon?userId=%@&conditionId=%@",BaseUrl,[UserManager getDefaultUser].userId,conditionId];
    [ExpressRequest sendWithParameters:nil MethodStr:urlStr reqType:k_GET success:^(id object) {
        //保持实时更新
        [_dataArr removeAllObjects];
        [self creatData];
        [SVProgressHUD showSuccessWithStatus:[object objectForKey:@"message"]];
    } failed:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
}

-(void) setBtnStatus:(NSString *)str btn:(UIButton *)btn withLabel:(UILabel *)label withCell:(UITableViewCell *)cell{
    if ([str intValue] == 0) {
        label.text = @"领取*0";
    }else{
        label.text = [NSString stringWithFormat:@"领取* %@",str];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
