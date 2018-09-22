//
//  UserLogListViewController.m
//  iwant
//
//  Created by dongba on 16/8/25.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "UserLogListViewController.h"
#import "OfferViewController.h"
#import "Logist.h"
#import "NothingBGView.h"
#import "OrderDetailViewController.h"

#import "UserLogistTableViewCell.h" //cell
#import "FinishLookViewController.h" //完成之后查看详情
#import "LookMyDetailVC.h"
#import "InsureDetailVC.h"

@interface UserLogListViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>{
    int _pageNo;
    NothingBGView *_bgv;
    NSIndexPath * _indexPath;
    NSInteger _index;
    UIImageView *_touyingImg;
}

@property (strong, nonatomic)  UITableView *tableView;
@property (strong, nonatomic)  NSMutableArray *dataArray;

@end

@implementation UserLogListViewController

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 16, WINDOW_WIDTH, WINDOW_HEIGHT - 64-44-16) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.allowsSelection = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        __weak UserLogListViewController *weakSelf = self;
        [_tableView addLegendHeaderWithRefreshingBlock:^{
            [weakSelf loadData:NO];
        }];
        [_tableView addLegendFooterWithRefreshingBlock:^{
            [weakSelf loadData:YES];
        }];
        [_tableView.header beginRefreshing];
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
    [_tableView.header beginRefreshing];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSubviews];
    _touyingImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"yinying"]];
    _touyingImg.frame = CGRectMake(0,  8, SCREEN_WIDTH, 8);
    [self.view addSubview:_touyingImg];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:REFRESH_WULIU object:nil];
}

-(void)loadData:(BOOL)isAdd
{
    if (!isAdd) {
        _pageNo = 1;
    }else{
        _pageNo++;
    }
    _bgv.hidden = YES;
    NSString *URLStr = [NSString stringWithFormat:@"%@logistics/task/list?userId=%@&pageNo=%d&pageSize=20",BaseUrl,[UserManager getDefaultUser].userId,_pageNo];
    [ExpressRequest sendWithParameters:nil MethodStr:URLStr reqType:k_GET success:^(id object) {
            NSArray *dataArr = [object valueForKey:@"data"];
               if (_pageNo == 1) {
                      if (dataArr.count == 0) {
                        _tableView.footer.hidden = YES;
                        _bgv.hidden = NO;
                }
                self.dataArray = [NSMutableArray array];
                  for (NSDictionary *dic in dataArr) {
                   Logist *model = [[Logist alloc] initWithJsonDict:dic];
                  [self.dataArray addObject:model];
                  }
                }else{
                for (NSDictionary *dic in dataArr) {
                Logist *model = [[Logist alloc] initWithJsonDict:dic];
                [self.dataArray addObject:model];
                }
            }
            [_tableView reloadData];
            [_tableView.header endRefreshing];
            [_tableView.footer endRefreshing];
    }failed:^(NSString *error) {
       [SVProgressHUD showErrorWithStatus:error];
       [_tableView.header endRefreshing];
       [_tableView.footer endRefreshing];
    }];
}

- (void)configSubviews{
    _bgv = [[NothingBGView alloc] initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT - 64)];
    _bgv.textLabel.text = @"您还未发布货源，快去发一单吧";
    _bgv.hidden = YES;
    [self.view addSubview: _bgv];
    [self.view addSubview:self.tableView];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(backToMenuView)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}
-(void)backToMenuView{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)refresh{
    [self.tableView.header beginRefreshing];
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
    return 0.5;
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH - 20, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UserLogistTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if(!cell){
    
        cell = [[[NSBundle mainBundle] loadNibNamed:@"UserLogistTableViewCell" owner:nil options:nil] firstObject];
    }
    
    _index = indexPath.section;
    [self setCell:cell index:indexPath.section];
    cell.viewBg.layer.cornerRadius = 5;
    cell.contentView.backgroundColor = BACKGROUND_COLOR;
    cell.viewBg.backgroundColor  = [UIColor whiteColor];
    return cell;
}

- (void)setCell:(UserLogistTableViewCell*)cell index:(NSInteger )index{
    Logist *model = _dataArray[index];
    cell.goodsName.text = model.cargoName;

    cell.goodsWeight.text =[NSString stringWithFormat:@"%@",model.cargoWeight];
    cell.countLabel.text =[NSString stringWithFormat:@"%@件", model.cargoSize];
    cell.endAdress.text = model.entPlace;
    cell.receiverName.text = [NSString stringWithFormat:@"%@",model.takeName];
    cell.telNum.text = [NSString stringWithFormat:@"%@",model.takeMobile];
    cell.publicTime.text = [NSString stringWithFormat:@"%@",model.publishTime];
        
    [cell.statusImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"status_%d",[model.status intValue]]]];
    
    if (model.quotationNumber.length > 0) {
        cell.baojiaShu.text = [NSString stringWithFormat:@"+%@",model.quotationNumber];
    }
    
    switch ([model.status intValue]) {
        /*    0 已发布(还没有支付手续费),
              1 已报价,  (物流公司)
              2 已支付,  （支付用户）
              3 已接货,
              4 已送达, 
              5 已评价  
              6 用户已支付发布时的手续费
              7 非担保交易
              8 用户已选择,未支付报价费
              9  非担保交易 交易时间超过24小时 默认已完成,用户无法再操作
              10 点击投保后 未填写投保信息,为废单 
              11  填写投保信息后  未支付
              12  已支付投保费
*/
        case 0:
            
            break;
        case 1:
            
            break;
        case 2:
            cell.cancelBtn.hidden = YES;
            cell.detailBtn.hidden = YES;
            cell.publicTime.hidden = YES;
            cell.baojiaShu.hidden = YES;
            cell.baojiaImageView.hidden = YES;
            cell.finishBtn.hidden = NO;
            break;
        case 3:
            cell.cancelBtn.hidden = YES;
            cell.detailBtn.hidden = YES;
            cell.baojiaShu.hidden = YES;
            cell.baojiaImageView.hidden = YES;
            cell.finishBtn.hidden = NO;

            break;
        case 4:
            cell.cancelBtn.hidden = YES;
            cell.detailBtn.hidden = YES;
            cell.baojiaShu.hidden = YES;
            cell.baojiaImageView.hidden = YES;
            cell.finishBtn.hidden = NO;

            break;
        case 5:
            cell.cancelBtn.hidden = YES;
            cell.detailBtn.hidden = YES;
            cell.baojiaShu.hidden = YES;
            cell.finishBtn.hidden = NO;

            break;
        case 6:
//             [cell.statusImageView setImage:[UIImage imageNamed:@"status_6"]];
            break;
        case 7:
          
            cell.cancelBtn.hidden = YES;
            cell.detailBtn.hidden = YES;
            cell.baojiaShu.hidden = YES;
            cell.baojiaImageView.hidden = YES;
            cell.finishBtn.hidden = NO;
            [cell.finishBtn setImage:[UIImage imageNamed:@"WL_danbaojiaoyi"] forState:0];

            break;
        case 8:
            [cell.cancelBtn setImage:[UIImage imageNamed:@"WL_xianxiajiaoyi"] forState:0];
            [cell.detailBtn setImage:[UIImage imageNamed:@"WL_danbaojiaoyi"] forState:0];
            cell.baojiaShu.hidden = YES;
            cell.baojiaImageView.hidden = YES;
            break;
        case 9:
            cell.cancelBtn.hidden = YES;
            cell.detailBtn.hidden = YES;
            cell.baojiaShu.hidden = YES;
            cell.baojiaImageView.hidden = YES;
            cell.finishBtn.hidden = NO;
            break;
        case 11:
            cell.cancelBtn.hidden = YES;
            cell.detailBtn.hidden = YES;
            cell.baojiaShu.hidden = YES;
            cell.baojiaImageView.hidden = YES;
            cell.finishBtn.hidden = NO;
            [cell.finishBtn setImage:[UIImage imageNamed:@"WL_fukuan"] forState:0];
            break;
        case 12:
            cell.cancelBtn.hidden = YES;
            cell.detailBtn.hidden = YES;
            cell.baojiaShu.hidden = YES;
            cell.baojiaImageView.hidden = YES;
            cell.finishBtn.hidden = YES;
            break;
        default:
            break;
    }
    
    cell.block = ^(UIButton *sender){
        switch (sender.tag) {
            case 0:
            {
                if ([model.status intValue] == 8)  {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确认要选择线下交易吗" preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"点错了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    UIAlertAction *suerAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        NSLog(@"确认选择线下交易");
                        NSString *str = [NSString stringWithFormat:@"%@logistics/task/pay/balance?userId=%@&WLBId=%@&whether=0&warrant=0&transferMoney=0",BaseUrl,model.userToId,model.recId];
                                [SVProgressHUD show];
                        [ExpressRequest sendWithParameters:nil MethodStr:str reqType:k_GET success:^(id object) {
                            [SVProgressHUD dismiss];
                            [SVProgressHUD showSuccessWithStatus:[object objectForKey:@"message"]];
                            [_tableView.header beginRefreshing];
                        } failed:^(NSString *error) {
                            [SVProgressHUD showErrorWithStatus:error];
                        }];
                    }];
                    [alert addAction:cancelAction];
                    [alert addAction:suerAction];
                    [self presentViewController:alert animated:YES completion:nil];

                }else if([model.status intValue] == 0){
                    
                     //取消发布货源
                     UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确认要取消发布该货源" preferredStyle:UIAlertControllerStyleAlert];
                     
                     UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"点错了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                     
                     }];
                     UIAlertAction *suerAction = [UIAlertAction actionWithTitle:@"取消发布" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                     
                     Logist *model = _dataArray[index];
                     [SVProgressHUD show];
                     [ExpressRequest sendWithParameters:nil MethodStr:[NSString stringWithFormat:@"%@logistics/task/deleteLog?recId=%@&reason=1",BaseUrl,model.recId] reqType:k_GET success:^(id object) {
                     [SVProgressHUD dismiss];
                     [SVProgressHUD showSuccessWithStatus:[object valueForKey:@"message"]];
                     [_dataArray removeObjectAtIndex:index];
                     [_tableView reloadData];
                     } failed:^(NSString *error) {
                     [SVProgressHUD showErrorWithStatus:error];
                     }];
                     
                     }];
                     [alert addAction:cancelAction];
                     [alert addAction:suerAction];
                     [self presentViewController:alert animated:YES completion:nil];
                }
                else{
                    _index = index;
                    NSString *  desption =@"取消发布";
                    NSString *  detail=@"确认要取消发布该货源";
                    UIAlertView*alert = [[UIAlertView alloc]initWithTitle:desption
                                                                  message:detail
                                                                 delegate:self
                                                        cancelButtonTitle:@"我点错了"
                                                        otherButtonTitles:@"用户自愿取消",@"物流公司要求取消",nil];
                    [alert show];

                }
            }
                break;
                
            case 1:
            {
                //支付完成跳转那个完成详情  status==2  8 就选它了  还未支付
                if ([model.status intValue] == 2 || [model.status intValue] == 8) {
                    FinishLookViewController * finishVC = [[FinishLookViewController alloc]init];
                    finishVC.recId = model.recId;
                    [self.navigationController pushViewController:finishVC animated:YES];
                }else{
                    OfferViewController *offerVC = [OfferViewController new];
                    offerVC.wlbID = model.recId;
                    offerVC.model = model;
                    [self.navigationController pushViewController:offerVC animated:YES];
                }
            }
                break;
            case 2:
            {
                //中间的按妞
                if ([model.status intValue] == 11 ||[model.status intValue] == 12) {
                    UIAlertController *alertTwo = [UIAlertController alertControllerWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"此单保费%@元",model.insureCost] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancleTwo = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    }];
                    UIAlertAction *updateTwo = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self payInsureCostByYueWithRecId:model.recId];
                    }];
                    [alertTwo addAction:cancleTwo];
                    [alertTwo addAction:updateTwo];
                    [self presentViewController:alertTwo animated:YES completion:nil];
                }else{
                   FinishLookViewController * finishVC = [[FinishLookViewController alloc]init];
                   finishVC.recId = model.recId;
                   [self.navigationController pushViewController:finishVC animated:YES];
              }
            }
                break;
            case 11:{
                //只查看自己的发布详情呢！ 点击整个cell的背景按钮
                if ([model.status intValue] == 11 ||[model.status intValue] == 12) {
                    InsureDetailVC * vc = [[InsureDetailVC alloc]init];
                    vc.recId = model.recId;
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                  LookMyDetailVC * vc =[[LookMyDetailVC alloc]init];
                  vc.recId = model.recId;
                  [self.navigationController pushViewController:vc animated:YES];
                }
            }
                break;
            default:
                break;
        }
    };
}
-(void)payInsureCostByYueWithRecId:(NSString *)recId{
    [SVProgressHUD show];
    [ExpressRequest sendWithParameters:nil MethodStr:[NSString stringWithFormat:@"%@logistics/task/payInsure?recId=%@",BaseUrl,recId]reqType:k_GET success:^(id object) {
        [SVProgressHUD showSuccessWithStatus:@"支付成功"];
        [_tableView.header beginRefreshing];
    } failed:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 220;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //删除记录
    //取消发布货源
    _index = indexPath.section;
    Logist *model = _dataArray[indexPath.section];
    int status =[model.status intValue];
    NSString * desption;
    NSString * detail;
    if (status ==3 || status == 4||status == 5 ||status == 7||status == 9) {
         desption =@"确认删除";
         detail=@"确认要删除该订单记录";
         UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:detail preferredStyle:UIAlertControllerStyleAlert];
         UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"点错了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
         
         }];
         
         UIAlertAction *suerAction = [UIAlertAction actionWithTitle:desption style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         
         if (status == 3) {
         [SVProgressHUD showErrorWithStatus:@"您的货物还未送达,不可删除该订单记录"];
         }else{
         [SVProgressHUD show];
         [ExpressRequest sendWithParameters:nil MethodStr:[NSString stringWithFormat:@"%@logistics/task/deleteLog?recId=%@&reason=3",BaseUrl,model.recId] reqType:k_GET success:^(id object) {
         [SVProgressHUD dismiss];
         [_dataArray removeObjectAtIndex:indexPath.section];
         [_tableView reloadData];
         } failed:^(NSString *error) {
         [SVProgressHUD showErrorWithStatus:error];
         }];
         
         }
         }];
         [alert addAction:cancelAction];
         [alert addAction:suerAction];
         [self presentViewController:alert animated:YES completion:nil];

    }else if(status == 0){
        //取消发布货源
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确认要取消发布该货源" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"点错了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *suerAction = [UIAlertAction actionWithTitle:@"取消发布" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [SVProgressHUD show];
            [ExpressRequest sendWithParameters:nil MethodStr:[NSString stringWithFormat:@"%@logistics/task/deleteLog?recId=%@&reason=1",BaseUrl,model.recId] reqType:k_GET success:^(id object) {
                [SVProgressHUD dismiss];
                [SVProgressHUD showSuccessWithStatus:[object valueForKey:@"message"]];
                [_dataArray removeObjectAtIndex:indexPath.section];
                [_tableView reloadData];
            } failed:^(NSString *error) {
                [SVProgressHUD showErrorWithStatus:error];
            }];
            
        }];
        [alert addAction:cancelAction];
        [alert addAction:suerAction];
        [self presentViewController:alert animated:YES completion:nil];
    
    }else{
         desption =@"取消发布";
         detail=@"确认要取消发布该货源";
        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:desption
                                                      message:detail
                                                     delegate:self
                                            cancelButtonTitle:@"我点错了"
                                            otherButtonTitles:@"用户自愿取消",@"物流公司要求取消",nil];
        [alert show];
    
   }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    Logist * model = _dataArray[_index];
    switch (buttonIndex) {
        case 0:
            break;
        case 1:{
            [SVProgressHUD show];
            [ExpressRequest sendWithParameters:nil MethodStr:[NSString stringWithFormat:@"%@logistics/task/deleteLog?recId=%@&reason=1",BaseUrl,model.recId] reqType:k_GET success:^(id object) {
                [SVProgressHUD dismiss];
                [_dataArray removeObjectAtIndex:_index];
                [_tableView reloadData];
            } failed:^(NSString *error) {
                [SVProgressHUD showErrorWithStatus:error];
            }];

        }
            break;
        case 2:{
            [SVProgressHUD show];
            [ExpressRequest sendWithParameters:nil MethodStr:[NSString stringWithFormat:@"%@logistics/task/deleteLog?recId=%@&reason=2",BaseUrl,model.recId] reqType:k_GET success:^(id object) {
                [SVProgressHUD dismiss];
                [_dataArray removeObjectAtIndex:_index];
                [_tableView reloadData];
            } failed:^(NSString *error) {
                [SVProgressHUD showErrorWithStatus:error];
            }];
        }
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
