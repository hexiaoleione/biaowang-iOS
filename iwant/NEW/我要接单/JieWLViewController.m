//
//  JieWLViewController.m
//  iwant
//
//  Created by 公司 on 2017/6/5.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "JieWLViewController.h"
#import "MainHeader.h"
#import "NothingBGView.h"
#import "Logist.h"
#import "JieWLCell.h"
#import "OrderViewController.h"
#import "RoleExplainVC.h"
#import "BaoJiaViewController.h"


@interface JieWLViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITextField * _searchTextField;
    UIImageView * _touyingImg;
    int _pageNo;
    NothingBGView *_bgv;
    NSString * _search;
}
@property (strong, nonatomic)  UITableView *tableView;
@property (strong, nonatomic)  NSMutableArray *dataArray;
@end

@implementation JieWLViewController

#pragma mark ----懒加载
-(NSArray *)dataArray{
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
    // Do any additional setup after loading the view.
    
    [self creatSearchBar];
    [self creatTableView];
    _bgv = [[NothingBGView alloc] initWithFrame:_tableView.frame];
    _bgv.textLabel.numberOfLines = 0;
    _bgv.textLabel.font = [UIFont systemFontOfSize:15.f];
    _bgv.textLabel.text = @"您来晚了，订单已被别的镖师抢走，继续加油！";
    _bgv.hidden = YES;
    [self.view addSubview:_bgv];
}
-(void)creatSearchBar{
    _search =@"";
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
    __weak JieWLViewController *weakSelf = self;
    
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
    NSString *cityCode = [[NSUserDefaults standardUserDefaults] valueForKey:USER_CITY_CODE];
    NSString * URLStr =[NSString stringWithFormat:@"%@logistics/task/look/nearBy?userId=%@&startPlaceCityCode=%@&search=%@&pageNo=%d&pageSize=20",BaseUrl,[UserManager getDefaultUser].userId,cityCode,_search,_pageNo];
    URLStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)URLStr, nil, nil, kCFStringEncodingUTF8));

    [ExpressRequest sendWithParameters:nil
                             MethodStr:URLStr
                               reqType:k_GET
                               success:^(id object) {
                                   NSArray *arr = [object valueForKey:@"data"];
                                   if (self->_pageNo == 1) {
                                       self.dataArray  = [NSMutableArray array];
                                       if (arr.count == 0 ) {
                                           self->_tableView.footer.hidden = YES;
                                           self->_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                                           self->_bgv.hidden = NO;
                                       }else{
                                           self->_tableView.footer.hidden  = NO;
                                           self->_tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                                           [self->_tableView  setSeparatorColor:UIColorFromRGB(0xc1c1fa)];  //设置分割线为紫色
                                           self->_bgv.hidden = YES;
                                       }
                                   }
                                   for (NSDictionary *dic in arr) {
                                       Logist *model = [[Logist alloc] initWithJsonDict:dic];
                                       
                                       [self.dataArray addObject:model];
                                       
                                   }
                                   [self->_tableView reloadData];
                                   
                                   [self->_tableView.header endRefreshing];
                                   [self->_tableView.footer endRefreshing];
                               }
                                failed:^(NSString *error) {
                                    [self->_tableView.header endRefreshing];
                                    [self->_tableView.footer endRefreshing];
                                }];
}

#pragma mark  TableViewDelegate
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    
//    return  self.dataArray.count;
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
////section头部间距
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 0.01;
//}
////section头部视图
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH - 20, 1)];
//    view.backgroundColor = [UIColor whiteColor];
//    return view;
//}
////section底部间距
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 5;
//}
////section底部视图
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH - 20, 1)];
//    view.backgroundColor = [UIColor clearColor];
//    return view;
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JieWLCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JieWLCell" owner:nil options:nil] lastObject];
    }
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    Logist *model = self.dataArray[indexPath.row];
    [cell setModel:model];
    cell.Block = ^(int tag) {
        if ( [[UserManager getDefaultUser].wlid intValue] == 0) {
            HHAlertView *alert = [[HHAlertView alloc]initWithTitle:nil detailText:@"您还不是物流公司或大货司机，快去认证吧！" cancelButtonTitle:@"暂不认证" otherButtonTitles:@[@"立即认证"]];
            alert.mode = HHAlertViewModeWarning;
            [alert showWithBlock:^(NSInteger index) {
                if(index != 0){
                [self.navigationController pushViewController:[[RoleExplainVC alloc]init] animated:YES];
                }
            }];
            return;
        }else{
            //公司报价
//          OrderViewController * vc = [[OrderViewController alloc]init];
            BaoJiaViewController * vc =[[BaoJiaViewController alloc]init];
            vc.model = [[Logist alloc]init];
            vc.model = model;
            [self.navigationController pushViewController:vc animated:YES];
        }
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 190*RATIO_HEIGHT;
}

#pragma mark ----textField的delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    //开始编辑时触发，文本字段将成为first responder
    _searchTextField.textAlignment = NSTextAlignmentLeft;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    NSLog(@"要在这里给后台传请求然后刷新数据源-----%@",_searchTextField.text);
    _search =_searchTextField.text;
    [_tableView.header beginRefreshing];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
