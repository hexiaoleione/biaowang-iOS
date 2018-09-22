//
//  JieXSViewController.m
//  iwant
//
//  Created by 公司 on 2017/6/3.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "JieXSViewController.h"
#import "MainHeader.h"
#import "NothingBGView.h"
#import "ShunFengBiaoShi.h"
#import "JieXSCell.h"
#import "JieOrderDetailVC.h"
#import "RechargeViewController.h"
#import "mapNavViewController.h"
#import "RoleExplainVC.h"
#import "DepositVC.h"
#import "AccidentInsuranceVC.h"
@interface JieXSViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITableView * _tableView;
    UITextField * _searchTextField;
    UIImageView * _touyingImg;
    
    int _pageNo;
    NSMutableArray *_modelArray;
    NothingBGView *_bgv;
    
    NSString * _search;//搜索字段
}

@end

@implementation JieXSViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_tableView.header beginRefreshing];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (@available(iOS 11, *)) {
        //        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever; //iOS11 解决SafeArea的问题，同时能解决pop时上级页面scrollView抖动的问题
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
    }
    [self creatSearchBar];
    [self creatTableView];
    
    _bgv = [[NothingBGView alloc] initWithFrame:_tableView.frame];
    _bgv.textLabel.text = @"暂无数据";
    _bgv.hidden = YES;
    [self.view addSubview:_bgv];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)creatSearchBar{
    _search = @"";
    _searchTextField = [[UITextField alloc]init];
    _searchTextField.frame = CGRectMake(0, 9*RATIO_HEIGHT, SCREEN_WIDTH*2/3,32*RATIO_HEIGHT );
    _searchTextField.centerX = SCREEN_WIDTH/2;
    _searchTextField.background = [UIImage imageNamed:@"jie_search"];
    _searchTextField.clearButtonMode = UITextFieldViewModeAlways;
    _searchTextField.contentMode = UIViewContentModeCenter;
    _searchTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _searchTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _searchTextField.placeholder = @"搜索目的地";
    _searchTextField.textAlignment = NSTextAlignmentCenter;
    _searchTextField.delegate = self;
    _searchTextField.returnKeyType = UIReturnKeySearch;
    
    //搜索图标
    UIImageView *view = [[UIImageView alloc] init];
    view.image = [UIImage imageNamed:@""];
    view.frame = CGRectMake(0, 0, 35, 35);
    //左边搜索图标的模式
    view.contentMode = UIViewContentModeCenter;
    _searchTextField.leftView = view;
    //左边搜索图标总是显示
    _searchTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_searchTextField];
    
    _touyingImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"yinying"]];
    _touyingImg.frame = CGRectMake(0, _searchTextField.bottom + 14*RATIO_HEIGHT, SCREEN_WIDTH, 8);
    [self.view addSubview:_touyingImg];
}

-(void)creatTableView{
    if (Device_Is_iPhoneX) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _touyingImg.bottom, WINDOW_WIDTH, WINDOW_HEIGHT-88-34-44-_touyingImg.bottom-80) style:UITableViewStylePlain];
    }else{
       _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _touyingImg.bottom, WINDOW_WIDTH, WINDOW_HEIGHT-64-44-_touyingImg.bottom-80*RATIO_HEIGHT) style:UITableViewStylePlain];
    }
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    __weak JieXSViewController *weakSelf = self;
    
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf loadData:NO];
    }];
    [_tableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf loadData:YES];
    }];
    [_tableView.header beginRefreshing];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [_tableView  setSeparatorColor:UIColorFromRGB(0xc1c1fa)];  //设置分割线为紫色
    [self.view addSubview:_tableView];
}

-(void)loadData:(BOOL)isAdd
{
    if (!isAdd) {
        _pageNo = 1;
    }else{
        _pageNo++;
    }
    NSString *URLStr = [NSString stringWithFormat:@"%@%@?%@=%@&%@=%@&%@=%@&search=%@",BaseUrl,API_PUBLISH_LimitTime,k_USER_ID,[UserManager getDefaultUser].userId,k_PAGE_NO,[NSString stringWithFormat:@"%d",_pageNo],k_PAGE_SIEZ,@"10",_search];
    URLStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)URLStr, nil, nil, kCFStringEncodingUTF8));

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
            _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            _bgv.hidden = NO;
        }else{
            _tableView.footer.hidden  = NO;
            _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            [_tableView  setSeparatorColor:UIColorFromRGB(0xc1c1fa)];  //设置分割线为紫色
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JieXSCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JieXSCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    ShunFengBiaoShi *model = _modelArray[indexPath.row];
    [cell setModel:model];
    cell.Block = ^(int tag) {
        switch (tag) {
            case 0:{
                //弹出了地图导航
                NSLog(@"规划路线了");
                mapNavViewController * vc = [[mapNavViewController alloc]init];
                vc.model = model;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 1:{
                //我要接单
                if ( [UserManager getDefaultUser].userType == 1 ) {
                    HHAlertView *alert = [[HHAlertView alloc]initWithTitle:nil detailText:@"您还不是镖师，快去认证吧！" cancelButtonTitle:@"暂不认证" otherButtonTitles:@[@"立即认证"]];
                    alert.mode = HHAlertViewModeWarning;
                    [alert showWithBlock:^(NSInteger index) {
                        if(index != 0){
                            [self.navigationController pushViewController:[[RoleExplainVC alloc]init] animated:YES];
                        }
                    }];
                    return;
                }
                
                NSString * messageStr;
                if (model.ifReplaceMoney && model.replaceMoney.length >0 && ![model.replaceMoney isEqualToString:@""]) {
                    messageStr = @"此订单为代收款订单，接镖后将冻结您账户相应金额，待收款成功后，冻结金额会支付给发货人。请务必在用户要求时间内到达";
                }else{
                    messageStr = @"请务必在用户要求时间内到达";
                }
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:messageStr preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                UIAlertAction *update = [UIAlertAction actionWithTitle:@"确认接单" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [SVProgressHUD show];
                    [RequestManager biaoshiqiangdanWithuserId:[UserManager getDefaultUser].userId recId:model.recId success:^(NSMutableArray *result) {
                        [SVProgressHUD dismiss];
                        // 2假单  -2 真单被抢走
                        NSInteger  errCode = [[result valueForKey:@"errCode"] integerValue];
                        NSString * message = [result valueForKey:@"message"];
                        if (errCode == 0) {
                            UIAlertController *alertTwo = [UIAlertController alertControllerWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"%@请您选择继续接单或查看详情",message] preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *cancleTwo = [UIAlertAction actionWithTitle:@"继续接单" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                
                                [_tableView.header beginRefreshing];
                            }];
                            UIAlertAction *updateTwo = [UIAlertAction actionWithTitle:@"查看详情" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                JieOrderDetailVC * vc= [[JieOrderDetailVC alloc]init];
                                //已被抢代取件
                                model.status = @"2";
                                vc.model = model;
                                [self.navigationController pushViewController:vc animated:YES];
                                NSLog(@"查看详情跳转界面!");
                            }];
                            [alertTwo addAction:cancleTwo];
                            [alertTwo addAction:updateTwo];
                            [self presentViewController:alertTwo animated:YES completion:nil];
                            
                        }else if (errCode == 2||errCode == -2) {
                            NSLog(@"真假单被抢");
                        }else if(errCode == 4){
                            //钱不够
                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
                            
                            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                            }];
                            UIAlertAction *suerAction = [UIAlertAction actionWithTitle:@"去充值" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                RechargeViewController * vc = [[RechargeViewController alloc]init];
                                [self.navigationController pushViewController:vc animated:YES];
                            }];
                            [alert addAction:cancelAction];
                            [alert addAction:suerAction];
                            [self presentViewController:alert animated:YES completion:nil];
                        }else if(errCode == -4){
                            NSLog(@"需要跳转意外险界面呢");
                            AccidentInsuranceVC * vc = [[AccidentInsuranceVC alloc]init];
                            [self.navigationController pushViewController:vc animated:YES];
                        }else if(errCode == -6){
                            //押金不够去充值
                            [SVProgressHUD show];
                            NSString * urlStr = [NSString stringWithFormat:@"%@driver/driverMoney?userId=%@",BaseUrl,[UserManager getDefaultUser].userId];
                            [ExpressRequest sendWithParameters:nil MethodStr:urlStr reqType:k_GET success:^(id object) {
                                NSDictionary * dict = [object valueForKey:@"data"][0];
                               // NSInteger driverMoney = [[dict objectForKey:@"driverMoney"] integerValue];
                                NSString * money =[[dict objectForKey:@"money"] stringValue];
                                HHAlertView *alert = [[HHAlertView alloc]initWithTitle:nil detailText:message cancelButtonTitle:@"取消" otherButtonTitles:@[@"立即前往"]];
                                alert.mode = HHAlertViewModeWarning;
                                [alert showWithBlock:^(NSInteger index) {
                                    if(index != 0){
                                        DepositVC * vc = [[DepositVC alloc]init];
                                        vc.money = money;
                                        [self.navigationController pushViewController:vc  animated:YES];
                                    }
                                }];
                            } failed:^(NSString *error) {
                                [SVProgressHUD showErrorWithStatus:error];
                            }];
                        }else{
                            NSLog(@"其他~~");
                        }
                    }
                        Failed:^(NSString *error)
                     {
                         [SVProgressHUD showErrorWithStatus:error];
                     }];
                }];
                
                [alert addAction:cancle];
                [alert addAction:update];
                [[Utils getCurrentVC] presentViewController:alert animated:YES completion:nil];
            }
                break;
            default:
                break;
        }
    };

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return RATIO_HEIGHT*275;
}
#pragma mark ----textField的delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    //开始编辑时触发，文本字段将成为first responder
    _searchTextField.textAlignment = NSTextAlignmentLeft;
}

/*
 - (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
 //返回BOOL值，指定是否允许文本字段结束编辑，当编辑结束，文本字段会让出first responder
 
 //要想在用户结束编辑时阻止文本字段消失，可以返回NO
 
 //这对一些文本字段必须始终保持活跃状态的程序很有用，比如即时消息
 
 return NO;
}
 - (void)textFieldDidEndEditing:(UITextField *)textField{
 
 } 
 //- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason NS_AVAILABLE_IOS(10_0); // if implemented, called in place of textFieldDidEndEditing:
 //
 - (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
 //当用户使用自动更正功能，把输入的文字修改为推荐的文字时，就会调用这个方法。
 
 //这对于想要加入撤销选项的应用程序特别有用
 
 //可以跟踪字段内所做的最后一次修改，也可以对所有编辑做日志记录,用作审计用途。
 
 //要防止文字被改变可以返回NO
 
 //这个方法的参数中有一个NSRange对象，指明了被改变文字的位置，建议修改的文本也在其中
 
 return YES;
 
 } // return NO to not change text
 //
 - (BOOL)textFieldShouldClear:(UITextField *)textField{
 //返回一个BOOL值指明是否允许根据用户请求清除内容
 
 //可以设置在特定条件下才允许清除内容
 return YES;
 }  
 */

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    NSLog(@"要在这里给后台传请求然后刷新数据源111%@111111111111  ",_searchTextField.text);
    _search =_searchTextField.text;
    [_tableView.header beginRefreshing];
    return YES;
}


@end
