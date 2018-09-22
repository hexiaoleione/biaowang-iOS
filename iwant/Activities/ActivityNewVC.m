//
//  ActivityNewVC.m
//  iwant
//
//  Created by 公司 on 2016/12/19.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "ActivityNewVC.h"
#import "ActivityModel.h"
#import "activityNewCell.h"
#import "ChouJiangViewController.h"
#import "SignInVC.h"
#import "SCouponVC.h"
#import "activityViewController.h"
#import "RechargeViewController.h"
@interface ActivityNewVC ()<UITableViewDelegate , UITableViewDataSource>

@property(nonatomic,strong)UITableView * tableView;
@property (nonatomic , strong) NSMutableArray *dataArray;

@end

@implementation ActivityNewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 60)];
    label.textColor = [UIColor whiteColor];
    label.text = @"活动";
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
    [self creatData];
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //禁用系统自带的分割线
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
- (NSMutableArray *)dataArray{
    if(!_dataArray){
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

-(void)creatData{
    [SVProgressHUD show];
    NSString *URLStr = [NSString stringWithFormat:@"%@%@",BaseUrl,API_ACTIVITY_RULE];
    [ExpressRequest sendWithParameters:nil MethodStr:URLStr reqType:k_GET success:^(id object) {
        [SVProgressHUD dismiss];
        NSArray * arr = [object objectForKey:@"data"];
        for (NSDictionary *dic in arr) {
            ActivityModel *model = [ActivityModel modelWithDic:dic];
            [self.dataArray addObject:model];
            [self.tableView reloadData];
        }
    } failed:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    } ];
}

#pragma mark -----delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return self.dataArray.count;
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
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH - 20, 5)];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}
//section底部间距
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH - 20, 5)];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150 * RATIO_HEIGHT;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifer = @"activityCell";
    activityNewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifer];
    if(!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"activityNewCell" owner:self options:nil]lastObject];
    }
    //点击有没有颜色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ActivityModel *model = self.dataArray[indexPath.section];
    [cell.activityImg sd_setImageWithURL:[NSURL URLWithString:model.imagesUrl]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ActivityModel *model = self.dataArray[indexPath.section];
    if ([model.activityUrlStatus intValue] == 0) {
        //web页面
        activityViewController * webVC = [[activityViewController alloc]init];
        webVC.urlStr = model.gotoUrl;
        [self.navigationController pushViewController:webVC animated:YES];
     }
    if([model.activityUrlStatus intValue] == 1){
        //领取现金券
        SCouponVC * LQVc = [[SCouponVC alloc]init];
        [self.navigationController pushViewController:LQVc animated:YES];
    }
    //签到
    if([model.activityUrlStatus intValue] == 2){
        //签到界面
        SignInVC * signVC = [[SignInVC alloc]init];
        [self.navigationController pushViewController:signVC animated:YES];
    }
    //抽奖
    if ([model.activityUrlStatus intValue] == 3) {
        ChouJiangViewController * chou = [[ChouJiangViewController alloc]init];
        [self.navigationController pushViewController:chou animated:YES];
    }
    //抽奖
    if ([model.activityUrlStatus intValue] == 4) {
        RechargeViewController * chou = [[RechargeViewController alloc]init];
        [self.navigationController pushViewController:chou animated:YES];
    }
}

@end
