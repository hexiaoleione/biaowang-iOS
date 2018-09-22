//
//  WeiJiaoFeiVC.m
//  iwant
//
//  Created by 公司 on 2017/2/24.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "WeiJiaoFeiVC.h"
#import "NothingBGView.h"
#import "Logist.h"
#import "WeiJiaoFeiCell.h"
#import "FindGoodsTableViewCell.h"
#import "WeiJiaoFeiPay.h"
#import "WechatPayHeader.h"
#import "WXPayManager.h"
#import "AlipayHeader.h"
#import "jiaoFeiDetailViewController.h"

@interface WeiJiaoFeiVC ()<UITableViewDelegate,UITableViewDataSource>
{
    int _pageNo;
    NothingBGView *_bgv;
    
    UILabel * _totolL;//合计
    UIButton * _oneKeyBtn; //一键缴费
    NSArray * _dicArr;
    
    WeiJiaoFeiPay * _jiaofeiPay;
    Logist * _model;
    
    NSInteger _payType;

}

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,copy) NSString * recId;
@end

@implementation WeiJiaoFeiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setCostomeTitle:@"未缴费订单"];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configSubviews];
    [self.tableView.header beginRefreshing];

}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = BACKGROUND_COLOR;
        __weak WeiJiaoFeiVC *weakSelf = self;
        [_tableView addLegendHeaderWithRefreshingBlock:^{
            [weakSelf loadData:NO];
        }];
    }
    return _tableView;
}
#pragma mark - MJ刷新
-(void)loadData:(BOOL)isAdd
{
    if (!isAdd) {// 下拉
        _pageNo = 1;
    }else{ // 上拉
        _pageNo = 1;
    }
    [ExpressRequest sendWithParameters:nil MethodStr:[NSString stringWithFormat:@"%@quotation/waitPayList?userId=%@",BaseUrl,[UserManager getDefaultUser].userId] reqType:k_GET success:^(id object) {
        _dicArr = [object valueForKey:@"data"];
        _totolL.text = [NSString stringWithFormat:@"%ld单",_dicArr.count];
        if (_pageNo == 1) {
            if (_dicArr.count == 0) {
                _bgv.hidden = NO;
            }else{
                _bgv.hidden = YES;
            }
            self.dataArray = [NSMutableArray array];
        }
        for (NSDictionary *dic in _dicArr) {
            Logist *model = [[Logist alloc] initWithJsonDict:dic];
            [self.dataArray addObject:model];
        }
        [_tableView reloadData];
        [_tableView.header endRefreshing];
    } failed:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
        [_tableView.header endRefreshing];
    }];
    
}
- (void)configSubviews{
    _bgv = [[NothingBGView alloc] initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT - 64 -44)];
    _bgv.textLabel.text = @"您没有未缴费订单";
    _bgv.hidden = YES;
    [self.view addSubview:_bgv];
    [self.view addSubview:self.tableView];
    
    UIView * view = [[UIView alloc]init];
    view.frame = CGRectMake(0, SCREEN_HEIGHT-64-64, SCREEN_WIDTH, 64);
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    UILabel * label = [[UILabel alloc]init];
    label.text = @"合计：";
    label.font = [UIFont systemFontOfSize:15];
    label.x = SCREEN_WIDTH/5;
    label.y = 22;
    [label sizeToFit];
    
    _totolL = [[UILabel alloc]init];
    _totolL.x = label.right +4;
    _totolL.y = label.y;
    _totolL.textColor = COLOR_MainColor;
    _totolL.font = [UIFont systemFontOfSize:16];
    _totolL.size = CGSizeMake(100, 18);

    
    _oneKeyBtn = [[UIButton alloc]init];
    _oneKeyBtn.frame = CGRectMake(SCREEN_WIDTH - 35 - 80, 10, 100, 40);
    _oneKeyBtn.layer.cornerRadius = 8;
    _oneKeyBtn.layer.masksToBounds = YES;
    [_oneKeyBtn setTitle:@"一键缴费" forState:UIControlStateNormal];
    _oneKeyBtn.backgroundColor = COLOR_MainColor;
    [_oneKeyBtn addTarget:self action:@selector(onePay) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:label];
    [view addSubview:_totolL];
    [view addSubview:_oneKeyBtn];
}

#pragma mark  TableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return  self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
//section头部间距
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.5;
}
//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH - 20, 1)];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}
//section底部间距
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH - 20, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WeiJiaoFeiCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"WeiJiaoFeiCell" owner:nil options:nil] lastObject];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;//设置cell点击效果
    }
    NSMutableArray *arr = self.dataArray;
    _model = arr[indexPath.section];
    self.recId = _model.recId;
    [cell setModel:_model];
    __weak WeiJiaoFeiVC * weakSelf = self;
    cell.block = ^(id sender){
        NSLog(@"弹出支付的界面！！！！！");
        _jiaofeiPay =[[[NSBundle mainBundle] loadNibNamed:@"WeiJiaoFeiPay" owner:self options:nil] lastObject];
        _jiaofeiPay.moneyLabel.text = [NSString stringWithFormat:@"%@元",_model.playMoneyMin];
        [_jiaofeiPay show];
        _jiaofeiPay.block = ^(NSInteger tag){
            [weakSelf payBtnWithTag:tag];
        };
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 135;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    jiaoFeiDetailViewController * vc =[[jiaoFeiDetailViewController alloc]init];
    _model = self.dataArray[indexPath.section];
    vc.recId =_model.recId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -----  分单支付
-(void)payBtnWithTag:(NSInteger)tag{
    __weak WeiJiaoFeiVC * weakSelf = self;
    switch (tag) {
        case 0:{
            _payType = 1;
            _jiaofeiPay.moneyLabel.text = [NSString stringWithFormat:@"%@元",_model.playMoneyMin];
        }
            break;
        case 1:{
            _payType = 2;
            _jiaofeiPay.moneyLabel.text = [NSString stringWithFormat:@"%@元",_model.playMoneyMax];
        }
            break;
        case 2:{
            _payType = 3;
            _jiaofeiPay.moneyLabel.text = [NSString stringWithFormat:@"%@元",_model.playMoneyMax];
        }
            break;
        case 3:{
            [weakSelf paySure];
        }
            break;
        default:
            break;
    }
}

//确定我要付款了
-(void)paySure{
    switch (_payType) {
        case 0:{
            [SVProgressHUD showErrorWithStatus:@"请先选择支付方式"];
        }
            break;
        case 1:
            NSLog(@"余额");
            _payType = 0;
            [self payYue];
            break;
        case 2:
            _payType = 0;
            [self wxPay];
            NSLog(@"微信");
            break;
        case 3:
            _payType = 0;
            [self zhifubaoPay];
            NSLog(@"支付宝");
            break;
        default:
            break;
    }
}


//余额支付的情况
-(void)payYue{
    
    // 物流公司报价余额支付
    [SVProgressHUD show];
    
    NSString * str = [NSString stringWithFormat:@"%@quotation/balancePay?userId=%@&billCode=%@&counterFee=%@",BaseUrl,[UserManager getDefaultUser].userId ,_model.billCode,_model.playMoneyMin];
    [ExpressRequest sendWithParameters:nil MethodStr:str reqType:k_GET success:^(id object) {
        [SVProgressHUD showSuccessWithStatus:[object valueForKey:@"message"]];
        [_jiaofeiPay removeFromSuperview];
        [self notice];
    } failed:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
}

//微信支付
-(void)wxPay{
    NSLog(@"物流公司报价微信支付平台使用费");
    [SVProgressHUD show];
    NSString *newBillCode = [NSString stringWithFormat:@"%@B%@",_model.billCode,[UserManager getDefaultUser].userId];
    NSString *URLStr = [NSString stringWithFormat:@"%@logistics/task/pay/wechat/pre?billCode=%@&price=%@&type=2",BaseUrl,newBillCode,_model.playMoneyMax];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notice) name:WECHAT_BACK_WL object:nil];
    [ExpressRequest sendWithParameters:nil MethodStr:URLStr
                               reqType:k_GET
                               success:^(id object) {
                                   NSDictionary *preDic = [object objectForKey:ARG_DATA][0];
                                   [SVProgressHUD dismiss];
                                   
                                   PayReq* req = [[PayReq alloc] init];
                                   req.partnerId           = [preDic valueForKey:@"partnerId"];
                                   req.prepayId            = [preDic valueForKey:@"prepayid"];
                                   req.nonceStr            = [preDic valueForKey:@"nonceStr"];
                                   req.timeStamp           = [[preDic valueForKey:@"timestamp"] intValue];
                                   req.package             = [preDic valueForKey:@"package_"];
                                   req.sign                = [preDic valueForKey:@"sign"];
                                   [WXApi sendReq:req];
                                   WXPayManager *wxManager = [WXPayManager shareManager];
                                   wxManager.billCode = newBillCode;
                                   [_jiaofeiPay removeFromSuperview];
                                   
                               }
                                failed:^(NSString *error) {
                                    [SVProgressHUD showErrorWithStatus:error];
                                }];
}

-(void)zhifubaoPay{
    NSLog(@"物流公司报价支付宝支付");
    NSString *newBillCode = [NSString stringWithFormat:@"%@B%@",_model.billCode,[UserManager getDefaultUser].userId];
    [AlipayRequestConfig alipayWithPartner:kPartnerID seller:kSellerAccount tradeNO:newBillCode productName:@"镖王" productDescription:@"平台使用费" amount:_model.playMoneyMax notifyURL:kNotifyURL itBPay:@"30m" standbyCallback:^(NSDictionary *resultDic) {
        
        if ([[resultDic objectForKey:@"resultStatus"] integerValue]==9000) {
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"恭喜您支付成功%@元！",_model.playMoneyMax]];
            [self checkResultWithBillCode:newBillCode];
        }
        else {
            NSLog(@"%@",resultDic);
            [SVProgressHUD showErrorWithStatus:[resultDic objectForKey:@"memo"] ];
        }
    }];
    
    [_jiaofeiPay removeFromSuperview];
}

- (void)checkResultWithBillCode:(NSString *)billCode{
    [RequestManager getPayResultWithBillCode:billCode success:^(NSDictionary *result) {
        NSLog(@"%@",result);
        [self notice];
    } Failed:^(NSString *error) {
        [PXAlertView showAlertWithTitle:error];
    }];
}

- (void)notice{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];;
}


#pragma mark ----  一键缴费
-(void)onePay{
//    quotation/onePay  一键缴费     传物流公司的userId
//   quotation/oneKeyPay  一键缴费的余额支付     传物流公司的userId    money代缴费金额    count 单数
    [SVProgressHUD show];
    [ExpressRequest sendWithParameters:nil MethodStr:[NSString stringWithFormat:@"%@quotation/onePay?userId=%@",BaseUrl,[UserManager getDefaultUser].userId] reqType:k_GET success:^(id object) {
        [SVProgressHUD dismiss];
        NSArray * arr = [object valueForKey:@"data"];
        if ([arr[1] intValue]== 0) {
            [SVProgressHUD showErrorWithStatus:@"没有未交费镖件"];
            return ;
        }
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message: [NSString stringWithFormat:@"余额支付平台使用费%@元？",arr[1]] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
             [SVProgressHUD show];
             [ExpressRequest sendWithParameters:nil MethodStr:[NSString stringWithFormat:@"%@quotation/oneKeyPay?userId=%@&money=%@&count=%@",BaseUrl,[UserManager getDefaultUser].userId,arr[1],arr[0]] reqType:k_GET success:^(id object) {
                 [SVProgressHUD dismiss];
                 [self notice];
             } failed:^(NSString *error) {
                 [SVProgressHUD showErrorWithStatus:error];
             }];
        }];
        [alert addAction:cancelAction];
        [alert addAction:sureAction];
        [self presentViewController:alert animated:NO completion:nil];
        
    } failed:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
