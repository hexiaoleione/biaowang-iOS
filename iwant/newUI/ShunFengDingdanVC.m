//
//  ShunFengDingdanVC.m
//  iwant
//
//  Created by 公司 on 2017/2/20.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "ShunFengDingdanVC.h"
#import "MainHeader.h"
#import "LogisticsTrackingViewController.h"
#import "BiaoTableViewCell.h"
#import "ShunFengBiaoShi.h"
#import "OperationViewController.h"
#import "HuoZhuSFTaskTableViewCell.h"
#import "MyFaDetailViewController.h"

#import "WXApi.h"
#import "AlipayHeader.h"
#import "WXPayManager.h"
#import "RechargeViewController.h"
#import "PayView.h"
#import "CouponViewController.h"
#import "CouponTableViewCell.h"

#import "LCFPayViewConstroller.h"  //新支付界面

@interface ShunFengDingdanVC ()<UITableViewDelegate,UITableViewDataSource,SFTaskTableViewCellDelegate>{

    UIImageView * _touyingImg;
    int _pageNo;
    UITableView * _tableView;
    NSMutableArray * _modelArray;
    
    //现金券
    NSString *_couponId;
    int _payType;//1-余额 2-微信 3-支付宝
    PayView *_payView;
    
    NSString *_transferMoney;//需要支付（没扣除现金券之前）的总费用
    NSString * _premium;  //保额
    NSString *_insuerCost;  //投保金额
    
    NSString * _billCode;
    NSString * _recId;
    
     UITextField * _otherPhonetextField; //代付人手机号
     NSString * _needPayMoney;

}
@property (strong, nonatomic)  UITableView *couponTableView;
@property (strong, nonatomic)  NSMutableArray *couponArray;

@end

@implementation ShunFengDingdanVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshData];
}

#pragma mark ----lazyLoad
//现金券列表
-(UITableView *)couponTableView{
    if (!_couponTableView) {
        
        _couponTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH - 90,WINDOW_WIDTH == 320 ? 40 : 60 ) style:UITableViewStylePlain];
        _couponTableView.tag = 1;
        _couponTableView.delegate = self;
        _couponTableView.dataSource = self;
        _couponTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _couponTableView.backgroundColor = [UIColor whiteColor];
    }
    return _couponTableView;
}

-(NSMutableArray *)couponArray{
    if (!_couponArray) {
        _couponArray = [NSMutableArray array];
    }
    return _couponArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    _pageNo = 1;
    _touyingImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"yinying"]];
    _touyingImg.frame = CGRectMake(0,  8, SCREEN_WIDTH, 8);
    [self.view addSubview:_touyingImg];
    [self creatTableView];
}

-(void)loadData:(BOOL)isAdd
{
    if (!isAdd) {
        _pageNo = 1;
    }else{
        _pageNo++;
    }
    _tableView.hidden = NO;

        [RequestManager GetHuozhuShuFengTaskWithuserId:[UserManager getDefaultUser].userId pageNo:[NSString stringWithFormat:@"%d",_pageNo] pageSize:@"5" Success:^(NSArray *result) {
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
                NSLog(@"%@",error);
        }];
}

-(void)creatTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 16, WINDOW_WIDTH, WINDOW_HEIGHT - 64 -44-16)];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tag = 0;
    //    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = BACKGROUND_COLOR;
    __weak ShunFengDingdanVC *weakSelf = self;
    
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf loadData:NO];
    }];
    [_tableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf loadData:YES];
    }];
    [_tableView.header beginRefreshing];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-75, 200, 150, 150)];
    imageView.image = [UIImage imageNamed:@"garbage"];
    imageView.centerX = self.view.centerX;
    imageView.centerY = self.view.centerY - 64;
    UILabel *textLabel = [UILabel new];
    textLabel.textColor = [UIColor lightGrayColor];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.font = [UIFont systemFontOfSize:20];
    textLabel.text = @"暂无订单";
    [textLabel sizeToFit];
    textLabel.y = imageView.bottom + 16;
    textLabel.centerX = self.view.centerX;
    
    [self.view addSubview:imageView];
    
    [self.view addSubview:textLabel];
    
    [self.view addSubview:_tableView];
    
}
#pragma mark  TableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == _tableView) {
         return _modelArray.count;
    }else{
        return 1;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 0) {
        return 1;
    }else{
        return  _couponArray.count;
    }
}
//section头部间距
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.5;
}
//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH - 20, 1)];
    view.backgroundColor = [UIColor clearColor];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 0) {
        HuoZhuSFTaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
        if (!cell) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"HuoZhuSFTaskTableViewCell" owner:nil options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        ShunFeng *model = _modelArray[indexPath.section];
        [cell setModel:model];
        cell.delegate  = self;
        cell.a = indexPath.section;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
        cell.Block = ^(int tag) {
            _transferMoney =[NSString stringWithFormat:@"%0.2f",[model.transferMoney doubleValue]];
            _insuerCost = [NSString stringWithFormat:@"%0.2f",[model.insureCost doubleValue]];
            _premium = [NSString stringWithFormat:@"%@",model.premium];
            _billCode = model.billCode;
            _recId = model.recId;
//            [self CreatPopView:model.transferMoney withModel:model];
            LCFPayViewConstroller * payVc = [[LCFPayViewConstroller alloc]init];
            payVc.payName = @"顺路送";
            payVc.model = model;
            [self.navigationController pushViewController:payVc animated:YES];
        };
        return cell;
    }else{
        CouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
        if (!cell) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CouponTableViewCell" owner:nil options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        Wallet *model = _couponArray[indexPath.row];
        [cell configModel:model];
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView) {
         return 160 * RATIO_HEIGHT;
    }else{
        return 30;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tableView) {
        LogisticsTrackingViewController *VC = [LogisticsTrackingViewController new];
        MyFaDetailViewController * detailVC = [[MyFaDetailViewController alloc]init];
        ShunFeng *model = _modelArray[indexPath.section];
        VC.model = model;
        detailVC.model = model;
       if ([model.status isEqualToString:@"0"]||[model.status isEqualToString:@"1"]||[model.status isEqualToString:@"6"]||[model.status isEqualToString:@"8"] || [model.status isEqualToString:@"9"]) {
            NSLog(@"待接镖，不能看镖件详情,但是可以查看自己填的信息");
            [self.navigationController pushViewController:detailVC animated:YES];
        }else
        {
            [self.navigationController pushViewController:VC animated:YES];
        }
    }else{
        
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView) {
        return UITableViewCellEditingStyleDelete;
    }else{
        return   UITableViewCellEditingStyleNone;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tableView) {
      ShunFeng *model = _modelArray[indexPath.section];
      /*
      顺风 删除订单    路径downwind/task/deldeteDow     请求GET    参数  Integer recId,Integer type
      type  = 1 用户删除   type  = 2  镖师删除
      */
    //删除 0 4 5  6  7  8
     [ExpressRequest sendWithParameters:nil MethodStr:[NSString stringWithFormat:@"%@downwind/task/deldeteDow?recId=%@&type=1",BaseUrl,model.recId] reqType:k_GET success:^(id object) {
        [_modelArray removeObjectAtIndex:indexPath.section];
        [_tableView reloadData];
        [SVProgressHUD showSuccessWithStatus:@"删除成功"];
     } failed:^(NSString *error) {
         [_tableView reloadData];
         [SVProgressHUD showErrorWithStatus:error];
      }];
    }else{
        NSLog(@"现金券的tableView");
    }
}

- (void)refreshData{
    [_tableView.header beginRefreshing];
}

-(void)cancel:(UIButton *)button AtIndexPath:(NSInteger)path
{
    ShunFeng *model = _modelArray[path];
    NSString * message = [[NSString alloc]init];
    if (!model.orderTime) {
        message = @"确认取消该订单吗？";
    }else{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //此处是24进制  必须要用那个大写啊HH
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
//    NSString *DateTime = [formatter stringFromDate:date];
//    NSLog(@"现在的时间-----%@",DateTime);

    NSDate *orderTime = [formatter dateFromString:model.orderTime];
//    NSString *orderTimeStr = [formatter stringFromDate:orderTime];
//    NSLog(@"镖师接单的时间————————%@",orderTimeStr);
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = nil;
  //  comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitMonth fromDate:orderTime];
    [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitMonth fromDate:orderTime];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setMinute:30];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:orderTime options:0];
//    NSString *lastDate = [formatter stringFromDate:newdate];
//    NSLog(@"镖师接单30分钟之后-------%@",lastDate);
    
    NSComparisonResult result = [newdate compare:date];
    if (result == NSOrderedSame) {
        NSLog(@"相等");
        message =@"确认取消该订单吗？";
    } else if (result == NSOrderedAscending) {
        NSLog(@"现在时间大");
        message =@"确认取消该订单吗？";
    } else if (result == NSOrderedDescending) {
        NSLog(@"小芳子给的时间大");
        message = @"因镖师已接镖，取消订单将造成罚款损失。";
    }
}
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定取消吗？" message:message preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了确定按钮");
        [RequestManager cancelDownWindtaskWithrecId:model.recId success:^(NSMutableArray *result) {
            [SVProgressHUD showSuccessWithStatus:[result valueForKey:@"message"]];
            [self loadData:NO];
        } Failed:^(NSString *error) {
            [SVProgressHUD showErrorWithStatus:error];
        }];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了取消按钮");
    }]];
}

-(void)endRefresh{
    [_tableView.header endRefreshing];
    [_tableView.footer endRefreshing];
}
#pragma mark -得到当前时间date
- (NSDate *)getCurrentTime{
    //2017-04-24 08:57:29
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *dateTime=[formatter stringFromDate:[NSDate date]];
    NSDate *date = [formatter dateFromString:dateTime];
    return date;
}

- (int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    NSLog(@"oneDay : %@, anotherDay : %@", oneDay, anotherDay);
    if (result == NSOrderedDescending) {
        //在指定时间前面 过了指定时间 过期
        NSLog(@"oneDay  is in the future");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //没过指定时间 没过期
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //刚好时间一样.
    //NSLog(@"Both dates are the same");
    return 0;
}

#pragma mark -------我的发单调支付界面
-(void)CreatPopView:(NSString *)money withModel:(ShunFeng *)model
{
    _couponId = @"";
    _payType = 0;
    
    NSString *yunfei = [NSString stringWithFormat:@"%0.2f",([_transferMoney doubleValue] - [_insuerCost doubleValue])];
    
    _payView = [[[NSBundle mainBundle] loadNibNamed:@"PayView" owner:nil options:nil] lastObject];
    NSString * distance =[NSString stringWithFormat:@"%0.2f", [model.distance floatValue]/1000];
    [_payView setModel:[NSArray arrayWithObjects:@"顺路送",[NSString stringWithFormat:@"%@ 元",yunfei],[NSString stringWithFormat:@"%@元(保额：%@元)",_insuerCost,_premium],[NSString stringWithFormat:@"%@",_transferMoney],distance,nil]];
    __weak PayView *weakPayView = _payView;
    _payView.width = WINDOW_WIDTH;
    _payView.tag = 0;
    if (model.ifReplaceMoney) {
        _payView.daishouHuokuanL.hidden = NO;
        _payView.replaceMoneyLabel.hidden = NO;
        _payView.replaceMoneyLabel.text =[NSString stringWithFormat:@"%@元", model.replaceMoney];
    }else{
        _payView.daishouHuokuanL.hidden = YES;
        _payView.replaceMoneyLabel.hidden = YES;
    }
    //保存找人代付的userId 区分是否找人代付款过
    if (model.replaceUserId.length !=0) {
        _payView.daifuLabel.hidden = YES;
        _payView.daifuSwitch.hidden = YES;
    }
    
    if ([model.whether isEqualToString:@"N"]) {
        _payView.insureLable.hidden = YES;
        _payView.insuerMoney.hidden = YES;
        _payView.topDiatanceConstraint.constant =0;
    }else{
        _payView.insureLable.hidden = NO;
        _payView.insuerMoney.hidden = NO;
        _payView.topDiatanceConstraint.constant =15;
    }
    
    _payView.block = ^(NSInteger tag){
        
        switch (tag) {
            case 0:
            {
                if (!weakPayView.couponSwitch.isOn) {
                    _couponId = @"";
                    [weakPayView setModel:[NSArray arrayWithObjects:@"顺路送",[NSString stringWithFormat:@"%@元",yunfei],[NSString stringWithFormat:@"%@元(保额：%@元)",_insuerCost,_premium],[NSString stringWithFormat:@"%@",_transferMoney],distance,nil]];
                    _couponArray = nil;
                    [self.couponTableView reloadData];
                    weakPayView.weixinBtn.enabled = YES;
                    weakPayView.alipayBtn.enabled = YES;
                    weakPayView.yueBtn.selected = NO;
                }else{
                    weakPayView.hidden = YES;
                    weakPayView.btn.hidden = YES;
                    weakPayView.overlayView.hidden = YES;
                    CouponViewController *couVC = [[CouponViewController alloc]init];
                    couVC.isPay = YES;
                    couVC.needMoney = _transferMoney;
                    couVC.billcode = model.billCode;
                    couVC.shunfengBlock = ^(NSString *couponName,NSMutableArray *_selectArray){
                        //选取了现金券
                        if (![couponName isEqualToString:@""] && ![couponName isEqualToString:@"&"]) {
                            weakPayView.couponSwitch.on = YES;
                            [weakPayView.table addSubview:self.couponTableView];
                            _couponArray = _selectArray;
                            [self.couponTableView reloadData];
                            _couponId = [NSString stringWithFormat:@"%@",couponName];
                            _payType = 1;
                            weakPayView.weixinBtn.enabled = YES;
                            weakPayView.alipayBtn.enabled = YES;
                            weakPayView.weixinBtn.selected = NO;
                            weakPayView.alipayBtn.selected = NO;
                            weakPayView.yueBtn.selected = YES;
                        }else{
                            //进到现金券界面 ，为选取现金券
                            weakPayView.couponSwitch.on = NO;
                            _couponArray = nil;
                            [self.couponTableView reloadData];
                            _couponId = @"";
                            weakPayView.weixinBtn.enabled = YES;
                            weakPayView.alipayBtn.enabled = YES;
                        }
                        
                        weakPayView.hidden = NO;
                        weakPayView.hidden = NO;
                        weakPayView.overlayView.hidden = NO;
                        [weakPayView reloadDataWithCoupon:_selectArray];
                    };
                    [self.navigationController pushViewController:couVC animated:YES];
                }
            }
                break;
            case 1:
            {
                _payType = 1;
            }
                break;
            case 2:
            {
                _payType = 2;
            }
                break;
            case 3:
            {
                _payType = 3;
            }
                break;
            case 4:
            {
                [self tapBtn:_payType withModel:model];
            }
                break;
            case 5:{
                [self findOtherPay];
            }
                break;
            case 666:{
                //这时候需要支付的金额是0
                weakPayView.weixinBtn.enabled = NO;
                weakPayView.alipayBtn.enabled = NO;
                weakPayView.weixinBtn.selected = NO;
                weakPayView.alipayBtn.selected = NO;
                weakPayView.yueBtn.selected = YES;
            }
            default:
                break;
        }
    };
    _payView.needPayBlock = ^(double needPayMoney) {
        if (!weakPayView.couponSwitch.isOn) {
            //未选择现金券不需要操作
        }else{
            //三方支付 选择了现金券的时候
            _needPayMoney = [NSString stringWithFormat:@"%.2f",needPayMoney];
        }
    };
    [_payView show];
}
#pragma mark ------ 付款方式  找人代付
-(void)findOtherPay{
    [_payView dismiss];
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"请输入代付人手机号" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (_otherPhonetextField.text.length != 11) {
            [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
            return;
        }
        NSString * urlStr = [NSString stringWithFormat:@"%@downwind/task/replace?recId=%@&mobile=%@",BaseUrl,_recId,_otherPhonetextField.text];
        [ExpressRequest sendWithParameters:nil MethodStr:urlStr reqType:k_GET success:^(id object) {
            NSString * message = [object valueForKey:@"message"];
            [SVProgressHUD showSuccessWithStatus:message];
            [self.navigationController popToRootViewControllerAnimated:YES];
        } failed:^(NSString *error) {
            [SVProgressHUD showErrorWithStatus:error];
        }];
    }];
    
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入代付人手机号";
        _otherPhonetextField = textField;
        textField.keyboardType = UIKeyboardTypePhonePad;
    }];
    [alertVC addAction:cancle];
    [alertVC addAction:sure];
    [[Utils getCurrentVC] presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark ------ 付款方式   自己支付
- (void)tapBtn:(int)tag withModel:(ShunFeng *)model{
    if (tag == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择支付方式"];
        return;
    }

    //余额支付  三方支付均可使用现金券
    [ExpressRequest sendWithParameters:nil MethodStr:[NSString stringWithFormat:@"%@downwind/task/coupon?recId=%@&userCouponId=%@",BaseUrl,_recId,_couponId ? _couponId : @""]reqType:k_GET success:^(id object) {

    switch (tag) {
        case 1:
        {
            NSLog(@"余额支付");
            HHAlertView *alert = [[HHAlertView alloc]initWithTitle:nil detailText:@"确认使用余额支付？" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"]];
            alert.mode = HHAlertViewModeWarning;
            [alert showWithBlock:^(NSInteger index) {
                if (index != 0) {
                    [SVProgressHUD show];
                    [RequestManager payByyueBillCode:model.billCode
                                             matName:@""
                                             matType:@""
                                        insuranceFee:@""
                                         insureMoney:@""
                                        needPayMoney:_transferMoney
                                           shipMoney:@""
                                        userCouponId:_couponId ? _couponId : @""
                                              weight:@""
                                              userId:[UserManager getDefaultUser].userId
                                             success:^(id object) {
                                                 [SVProgressHUD showSuccessWithStatus:@"支付成功"];
                                                 [self goHome];
                                             } Failed:^(NSString *error) {
                                                 
                                                 int errCode = [[[NSUserDefaults standardUserDefaults] objectForKey:@"errCode"] intValue];
                                                 if (errCode == -2)
                                                 {
                                                     [SVProgressHUD dismiss];
                                                     HHAlertView *alert = [[HHAlertView alloc]initWithTitle:nil detailText:error cancelButtonTitle:@"更换支付方式" otherButtonTitles:@[@"去充值"]];
                                                     alert.mode = HHAlertViewModeWarning;
                                                     [alert showWithBlock:^(NSInteger index) {
                                                         if(index != 0){
                                                             [self.navigationController pushViewController:[[RechargeViewController alloc]init] animated:YES];
                                                         }
                                                     }];
                                                 }else{
                                                     [SVProgressHUD showErrorWithStatus:error];
                                                 }
                                             }];
                }
            }];
        }
            break;
        case 2:
        {
//            if (_couponId && _couponId.length > 0) {
//                [SVProgressHUD showErrorWithStatus:@"现金券仅限余额支付使用!"];
//                return;
//            }
            NSLog(@"微信支付");
            [SVProgressHUD show];
            [RequestManager getWXPreWithBillCode:model.billCode
                                         matName:@"" matType:@"" insuranceFee:@""insureMoney:@""needPayMoney:_transferMoney shipMoney:@"" weight:@""
                                         success:^(NSDictionary *object) {
                                             NSLog(@"%@",object);
                                             [SVProgressHUD dismiss];
                                             PayReq* req = [[PayReq alloc] init];
                                             req.partnerId           = [object valueForKey:@"partnerId"];
                                             req.prepayId            = [object valueForKey:@"prepayid"];
                                             req.nonceStr            = [object valueForKey:@"nonceStr"];
                                             req.timeStamp           = [[object valueForKey:@"timestamp"] intValue];
                                             req.package             = [object valueForKey:@"package_"];
                                             req.sign                = [object valueForKey:@"sign"];
                                             [WXApi sendReq:req];
                                             WXPayManager *wxManager = [WXPayManager shareManager];
                                             wxManager.billCode = model.billCode;
                                         } Failed:^(NSString *error) {
                                             [SVProgressHUD showErrorWithStatus:error];
                                         }];
        }
            break;
        case 3:
        {
//            if (_couponId && _couponId.length > 0) {
//                [SVProgressHUD showErrorWithStatus:@"现金券仅限余额支付使用!"];
//                return;
//            }
            
            NSString * moneyAliPay ;
            if (!_payView.couponSwitch.isOn) {
                //未选择现金券不需要操作
                moneyAliPay = _transferMoney;
            }else{
                //三方支付 选择了现金券的时候
                moneyAliPay = _needPayMoney;
            }

            NSLog(@"支付宝支付");
            [AlipayRequestConfig alipayWithPartner:kPartnerID seller:kSellerAccount tradeNO:model.billCode productName:@"镖王" productDescription: @"顺路送" amount:moneyAliPay notifyURL:kNotifyURL itBPay:@"30m" standbyCallback:^(NSDictionary *resultDic)
             {
                 if ([[resultDic objectForKey:@"resultStatus"] integerValue]==9000) {
                     [SVProgressHUD showSuccessWithStatus:@"支付成功"];
                     [self checkResult];
                 }
                 else {
                     [SVProgressHUD showErrorWithStatus:[resultDic objectForKey:@"memo"] ];
                 }
             }];
        }
            break;
      }
        
    } failed:^(NSString *error) {
        [SVProgressHUD showWithStatus:error];
    }];
}

- (void)checkResult{
    [RequestManager getPayResultWithBillCode:_billCode success:^(NSDictionary *result) {
        NSLog(@"%@",result);
        [self goHome];
        
    } Failed:^(NSString *error) {
        [PXAlertView showAlertWithTitle:error];
    }];
}

#pragma mark ---- 支付成功后刷新界面
- (void)goHome{
    _payType = 0;
    [_payView dismiss];
    
    [_tableView.header beginRefreshing];

//    [self.navigationController popToRootViewControllerAnimated:YES];

    //给推送 附近的镖师正忙
    [ExpressRequest sendWithParameters:nil MethodStr:[NSString stringWithFormat:@"%@downwind/task/afterPublish?recId=%@",BaseUrl,_recId] reqType:k_GET success:^(id object) {
        
    } failed:^(NSString *error) {
        int errCode = [[[NSUserDefaults standardUserDefaults] objectForKey:@"errCode"] intValue];
        if (errCode == -2){
            [SVProgressHUD showInfoWithStatus:error];
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
