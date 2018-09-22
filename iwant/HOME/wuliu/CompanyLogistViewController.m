//
//  CompanyLogistViewController.m
//  iwant
//
//  Created by dongba on 16/9/2.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "CompanyLogistViewController.h"
#import "GoodSourceTableViewCell.h"
#import "LogistUploadViewController.h"
#import "PwdInputField.h"
#import "LogistUploadViewController.h"
#import "OrderViewController.h"
#import "NothingBGView.h"
#import "companyMyWLTableViewCell.h"  //公司端  我的物流
#import "CompanyLookZBViewController.h"//公司查看中标
#import "HuoChangAdressVC.h"
#import "WeiJiaoFeiVC.h"
#import "jiaoFeiDetailViewController.h"
#import "TakeCargoDetailViewController.h"

@interface CompanyLogistViewController ()<UITableViewDelegate,UITableViewDataSource>{
    int _pageNo;
    NothingBGView *_bgv;
    PwdInputField *_pwdView;
    UIVisualEffectView *_visualEffectView;
    UIImageView * _touyingImg;
}

@property (copy, nonatomic)  NSString *recId;//弹出密码框所点击的那一单recid
@property (strong, nonatomic)  UITableView *tableView;

@property (strong, nonatomic)  NSMutableArray *dataArray;
@end

@implementation CompanyLogistViewController

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,16, WINDOW_WIDTH, WINDOW_HEIGHT-64 -100*RATIO_HEIGHT-40-16) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        __weak CompanyLogistViewController *weakSelf = self;
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView.header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSubviews];
    _pageNo = 1;
    _touyingImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"yinying"]];
    _touyingImg.frame = CGRectMake(0, 8, SCREEN_WIDTH, 8);
    [self.view addSubview:_touyingImg];
    [self creatBottomBtns];
}

-(void)creatBottomBtns{
    UIButton * huochangBtn =[[UIButton alloc]initWithFrame:CGRectMake(0, _tableView.bottom, SCREEN_WIDTH/2,100*RATIO_HEIGHT)];
    [huochangBtn addTarget:self action:@selector(GuanLihuoChang) forControlEvents:UIControlEventTouchUpInside];
    [huochangBtn setImage:[UIImage imageNamed:@"WL_huochang"] forState:UIControlStateNormal];
    [self.view addSubview:huochangBtn];
    UIButton * jiaofeiBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, _tableView.bottom, SCREEN_WIDTH/2,100*RATIO_HEIGHT)];
    [jiaofeiBtn addTarget:self action:@selector(jiaofeiBtn) forControlEvents:UIControlEventTouchUpInside];
    [jiaofeiBtn setImage:[UIImage imageNamed:@"WL_jiaofei"] forState:UIControlStateNormal];
    [self.view addSubview:jiaofeiBtn];
}

#pragma mark - MJ刷新
-(void)loadData:(BOOL)isAdd
{
    if (!isAdd) {// 下拉
        _pageNo = 1;
    }else{ // 上拉
        _pageNo++;
    }
    [ExpressRequest sendWithParameters:nil MethodStr:[NSString stringWithFormat:@"%@logistics/task/find?userId=%@&pageSize=20&&pageNo=%d",BaseUrl,[UserManager getDefaultUser].userId,_pageNo] reqType:k_GET success:^(id object) {
        NSArray *dicArr = [object valueForKey:@"data"];
        if (_pageNo == 1) {
            if (dicArr.count == 0) {
                _bgv.hidden = NO;
                self.tableView.footer.hidden = YES;
            }else{
                _bgv.hidden = YES;
                self.tableView.footer.hidden = NO;
            }
            self.dataArray = [NSMutableArray array];
        }
        for (NSDictionary *dic in dicArr) {
            Logist *model = [[Logist alloc] initWithJsonDict:dic];
            [self.dataArray addObject:model];
        }
        [_tableView reloadData];
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
    } failed:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
    }];
}
- (void)configSubviews{
    _bgv = [[NothingBGView alloc] initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT - 64)];
    _bgv.textLabel.text = @"还没有货主委托您发物流哦";
    _bgv.hidden = YES;
    [self.view addSubview:_bgv];
    [self.view addSubview:self.tableView];

    //密码框
    _visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    _visualEffectView.frame = self.view.bounds;
    _visualEffectView.alpha = 0.4;
    [self.view addSubview:_visualEffectView];
    _visualEffectView.hidden = YES;
    _pwdView = [[[NSBundle mainBundle] loadNibNamed:@"PwdInputField" owner:nil options:nil] lastObject];
    _pwdView.backgroundColor = [UIColor clearColor];
    _pwdView.y = WINDOW_HEIGHT;
    _pwdView.width = WINDOW_WIDTH;
    _pwdView.height = 400;
    [self.view addSubview:_pwdView];
    __weak CompanyLogistViewController *weakSelf = self;
    _pwdView.block = ^(id sender){
        if ([sender isKindOfClass:[UIButton class]]) {
            UIButton *btn = sender;
            if (btn.tag==0) {
                //关闭按钮
                [weakSelf closePwd];
            }else{
                //重新发送短信
                [SVProgressHUD show];
                [ExpressRequest sendWithParameters:nil MethodStr:[NSString stringWithFormat:@"%@logistics/task/arrive?recId=%@",BaseUrl,weakSelf.recId] reqType:k_GET success:^(id object) {
                [SVProgressHUD showSuccessWithStatus:[object valueForKey:@"message"]];
                } failed:^(NSString *error) {
                [SVProgressHUD showErrorWithStatus:error];
            }];
            }
        }else{
            //密码输入完成
            [weakSelf checkPwd];
        }
    };
}
#pragma mark ----- 管理货场 未缴费镖件
-(void)GuanLihuoChang{
    HuoChangAdressVC * vc= [[HuoChangAdressVC alloc]init];
    vc.isGuanLI = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)jiaofeiBtn{
    WeiJiaoFeiVC * weijiaofeiVC =[[WeiJiaoFeiVC alloc]init];
    [self.navigationController pushViewController:weijiaofeiVC animated:YES];
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
    return 0;
}
//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH - 20, 0)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
//section底部间距
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH - 20,0)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    companyMyWLTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"companyMyWLTableViewCell" owner:nil options:nil] lastObject];
        Logist *model = self.dataArray[indexPath.section];
        [cell setViewsWithModel:model];
        cell.block = ^(id sender){
            UIButton *btn = sender;
            switch (btn.tag) {
                    
                case 0:{
                    //已报价
                }
                    break;
                case 1:
                {
                    CompanyLookZBViewController * lookVC = [[CompanyLookZBViewController alloc]init];
                    lookVC.recId = model.recId;
                    [self.navigationController pushViewController:lookVC animated:YES];
                }
                    break;
                case 2:
                {
                    //发货前拍照片
                    TakeCargoDetailViewController * vc = [[TakeCargoDetailViewController alloc]init];
//                    LogistUploadViewController *vc = [[LogistUploadViewController alloc] init];
                    vc.model = self.dataArray[indexPath.section];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 3:
                {//货物到达，输密码完成物流
                    _recId = model.recId;
                    if ([model.status intValue]==3) {
                        [self showPwd];
                    }else if ([model.status intValue]==4){
                        [SVProgressHUD showInfoWithStatus:@"您已完成该单物流"];
                    }else{
                        [SVProgressHUD showInfoWithStatus:@"您到达目的地之后才能使用"];
                    }
                }
                    break;
                default:
                    break;
            }
        };
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 190*RATIO_HEIGHT;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    jiaoFeiDetailViewController * vc =[[jiaoFeiDetailViewController alloc]init];
    vc.ifJustLook = YES;
    Logist *model = self.dataArray[indexPath.section];
    vc.recId = model.recId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showPwd{
    _visualEffectView.hidden = NO;
    [UIView animateWithDuration:.8 delay:0 usingSpringWithDamping:.5 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
        _pwdView.y = 64;
    } completion:^(BOOL finished) {
        [_pwdView.field becomeFirstResponder];
    }];
}

- (void)closePwd{
    _visualEffectView.hidden = YES;
    [_pwdView.field resignFirstResponder];
    [UIView animateWithDuration:.8 delay:0 usingSpringWithDamping:.5 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
        _pwdView.y -= WINDOW_HEIGHT;
    } completion:^(BOOL finished) {
        for (UIImageView *img in _pwdView.imageVs) {
            img.image = [UIImage imageNamed: @""];
            
        }
        _pwdView.field.text = nil;
    }];
}

- (void)checkPwd{
    [SVProgressHUD show];
    [ExpressRequest sendWithParameters:nil MethodStr:[NSString stringWithFormat:@"%@logistics/task/check?recId=%@&dealPassword=%@",BaseUrl,_recId,_pwdView.field.text] reqType:k_GET success:^(id object) {
        [SVProgressHUD showSuccessWithStatus:[object valueForKey:@"message"]];
        [self done];
    } failed:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
}

- (void)done{
     [self closePwd];
    [self.tableView.header beginRefreshing];
}

@end
