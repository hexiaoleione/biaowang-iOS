//
//  MywindViewController.m
//  iwant
//
//  Created by pro on 16/4/29.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "MywindViewController.h"
#import "MyBiaoViewController.h"
#import "MygoodsViewController.h"
#import "UserNameViewController.h"
#import "RequestConfig.h"
#import "MainHeader.h"
#define  WGiveWidth(WIDTH) WIDTH * [UIScreen mainScreen].bounds.size.width/320.0
#define  WGiveHeight(HEIGHT) HEIGHT * [UIScreen mainScreen].bounds.size.height/568.0
#define WYScreenW [UIScreen mainScreen].bounds.size.width

@interface MywindViewController (){
    UILabel *_timeLabel;
    UILabel *_fromLabel;
    UILabel *_toLabel;
    UIButton *_cancleBtn;
    NSString *_recId;
    UIView *_MyXingCheng;
}

@property (strong, nonatomic)  MygoodsViewController*MygoodsVC;
@property (strong, nonatomic) MyBiaoViewController *MyBiaoVC;
@property (strong, nonatomic) UIButton *lastBtn;
@property (strong, nonatomic) UIButton *secondBtn;
@property (strong, nonatomic) UIButton *firstBtn;

@end

@implementation MywindViewController
{
    UIImageView *barView;
    UIButton *_btn;
    BOOL btnClick;
}

-(void)viewWillAppear:(BOOL)animated{
        [super viewWillAppear:animated];
    [self reFresh];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configNavgationBar];
    [self _initChildVC];
    [self _initToolBar];
    if (_tag  == 1) {
         [self btnClick:self.lastBtn];
    }else{
        [self btnClick:self.firstBtn];
    }
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reFresh) name:REFRESH object:nil];
    
}
- (void)reFresh{
    [_MyBiaoVC refreshData];
    [_MygoodsVC refreshData];
}
- (void)_initToolBar{
    
    barView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, 40)];
    barView.userInteractionEnabled = YES;
    barView.contentMode = UIViewContentModeScaleAspectFill;
    barView.clipsToBounds = YES;
    [barView setImage:[UIImage imageNamed:@"sun_map_bg"]];
    [self.view addSubview:barView];
    
    [barView addSubview:[self creatbarBtnWithTitle:@"我 发 的 货" FrameX:(WINDOW_WIDTH / 2 *0) btntag:0]];
    [barView addSubview:[self creatbarBtnWithTitle:@"我 接 的 镖" FrameX:(WINDOW_WIDTH / 2 *1 ) btntag:1]];
}

- (void)_initChildVC{
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgbgbgbg"]];
    img.frame = CGRectMake(WYScreenW/2-75, 200, 150, 150);
    img.centerX = self.view.centerX;
    img.centerY = self.view.centerY - 64;
    [self.view addSubview:img];
    
    UILabel *label  = [UILabel new];
    label.font = [UIFont systemFontOfSize:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor lightGrayColor];
    label.text = @"暂无数据";
    [label sizeToFit];
    label.y = img.bottom + 10;
    label.centerX = self.view.centerX;
    
    [self.view addSubview:label];
    
    _MyXingCheng = [[UIView alloc]initWithFrame:self.view.bounds];
    _MyXingCheng.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_MyXingCheng];
    
    [self showOwnWind];
    
    _MygoodsVC = [[MygoodsViewController alloc]init];
    [self addChildViewController:_MygoodsVC];
    [self.view addSubview:_MygoodsVC.view];
    
    _MyBiaoVC = [[MyBiaoViewController alloc]init];
    [self addChildViewController:_MyBiaoVC];
    [self.view addSubview:_MyBiaoVC.view];
    
}

- (UIButton *)creatbarBtnWithTitle:(NSString *)title FrameX:(CGFloat)x btntag:(NSInteger)tag{
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(x, 0, WINDOW_WIDTH / 2, 40)];
    [btn setBackgroundColor:[UIColor clearColor]];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    btn.tag = tag;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (tag == 0) {
        self.firstBtn = btn;
    }else if(tag == 1){
        self.lastBtn = btn;
    }else{
        self.secondBtn = btn;
    }
    
    return btn;
}

- (void)btnClick:(UIButton *)btn{
    
    switch (btn.tag) {
        case 0:
        {
            

            _MygoodsVC.view.hidden = NO;
            _MyBiaoVC.view.hidden = YES;
            _MyXingCheng.hidden = YES;
            _lastBtn.selected = NO;
            _firstBtn.selected = YES;
            _secondBtn.selected = NO;
            
        }
            break;
        case 1:
        {

            //我的顺风 我是镖师列表
            if ([UserManager getDefaultUser].userType == 1 ) {
                HHAlertView *alertView = [[HHAlertView alloc]initWithTitle:@"温 馨 提 醒 ！" detailText:@"您还不是镖师，没有权限使用，是否去认证镖师" cancelButtonTitle:@"取消" otherButtonTitles:@[@"去认证"]];
                alertView.mode = HHAlertViewModeWarning;
                [alertView showWithBlock:^(NSInteger index) {
                    if (index != 0) {
                        UserNameViewController *userVC = [UserNameViewController new];
                        userVC.courentbtnTag = 2;
                        [self.navigationController pushViewController:userVC animated:YES];
                    }
                    
                }];
                return;
            }
            _MygoodsVC.view.hidden = YES;
            _MyBiaoVC.view.hidden = NO;
            _MyXingCheng.hidden = YES;
            _firstBtn.selected =NO;
            _lastBtn.selected = YES;
            _secondBtn.selected = NO;
          
        }
            break;

        case 2:
        {
            //我的顺风 我是镖师列表
            if ([UserManager getDefaultUser].userType == 1 ) {
                HHAlertView *alertView = [[HHAlertView alloc]initWithTitle:@"温 馨 提 醒 ！" detailText:@"您还不是镖师，没有权限使用，是否去认证镖师" cancelButtonTitle:@"取消" otherButtonTitles:@[@"去认证"]];
                alertView.mode = HHAlertViewModeWarning;
                [alertView showWithBlock:^(NSInteger index) {
                    if (index != 0) {
                        UserNameViewController *userVC = [UserNameViewController new];
                        userVC.courentbtnTag = 2;
                        [self.navigationController pushViewController:userVC animated:YES];
                    }
                    
                }];
                return;
            }
            
            _MygoodsVC.view.hidden = YES;
            _MyBiaoVC.view.hidden = YES;
            _lastBtn.selected =NO;
            _firstBtn.selected = NO;
            _secondBtn.selected = YES;
            [self reloaData];
            
        }
            break;
    }
    
//    self.firstBtn.selected = NO;
//    btn.selected = YES;
//    self.firstBtn = btn;
}

- (void)showOwnWind{
    
//    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(WGiveWidth(20), WGiveHeight(70), WGiveWidth(24), WGiveHeight(54))];
//    image.image = [UIImage imageNamed:@"zhuangtai_yuan"];
//    [_MyXingCheng addSubview:image];
    _timeLabel = [self CreatLabelWithtext:@"2016-6-20 8：00" textfont: FONT(18,NO) textcolor:[UIColor orangeColor]X:WGiveWidth(20) Y:WGiveHeight(40) W:WGiveWidth(200) H:WGiveHeight(30)];
    
    _fromLabel = [self CreatLabelWithtext:@"起始位置：北京市回龙观碧水庄园" textfont:FONT(14,NO)  textcolor:[UIColor blackColor] X:WGiveWidth(20) Y:WGiveHeight(70) W:WINDOW_WIDTH-40 H:WGiveHeight(25)];
    _toLabel = [self CreatLabelWithtext:@"目的地：北京市昌平区生命科学园" textfont:FONT(14,NO)  textcolor:[UIColor grayColor] X:WGiveWidth(20) Y:WGiveHeight(95) W:WINDOW_WIDTH-40 H:WGiveHeight(25)];
    _toLabel.numberOfLines = 0;
    
    _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancleBtn.frame = CGRectMake(WINDOW_WIDTH - WGiveWidth(80), WGiveWidth(40), WGiveWidth(80), WGiveHeight(30));
    _cancleBtn.titleLabel.font = FONT(18,NO);
    [_cancleBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [_cancleBtn setTitle:@"取消行程" forState:UIControlStateNormal];
    [_cancleBtn addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
    [_MyXingCheng addSubview:_cancleBtn];
    
    _MyXingCheng.hidden = YES;
    NSString *urlStr = [NSString stringWithFormat:@"%@%@?%@=%@",BaseUrl,API_DRIVER_ROUT,K_DRIVERID,[UserManager getDefaultUser].userId];
    [ExpressRequest sendWithParameters:nil
                             MethodStr:urlStr
                               reqType:k_GET
                               success:^(id object) {
                                   _MyXingCheng.hidden = NO;
                                   NSDictionary *dic = [object valueForKey:@"data"][0];
                                   _timeLabel.text =[NSString stringWithFormat:@"%@",dic[@"publishTime"]] ;
                                   _fromLabel.text = [NSString stringWithFormat:@"起始地：%@",dic[@"address"]];
                                   [_fromLabel sizeToFit];
                                   _toLabel.y = _fromLabel.bottom  +10;
                                   _toLabel.text = [NSString stringWithFormat:@"目的地：%@",dic[@"addressTo"]];
                                   [_toLabel sizeToFit];
                                   _recId = [NSString stringWithFormat:@"%@",dic[@"recId"]];
                               } failed:^(NSString *error) {
                                   _MyXingCheng.hidden = YES;
                                   
                               }];
}

- (void)reloaData{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@?%@=%@",BaseUrl,API_DRIVER_ROUT,K_DRIVERID,[UserManager getDefaultUser].userId];
    [ExpressRequest sendWithParameters:nil
                             MethodStr:urlStr
                               reqType:k_GET
                               success:^(id object) {
                                   _MyXingCheng.hidden = NO;
                                   NSDictionary *dic = [object valueForKey:@"data"][0];
                                   _timeLabel.text =[NSString stringWithFormat:@"起始地：%@",dic[@"publishTime"]] ;
                                   _fromLabel.text = [NSString stringWithFormat:@"%@",dic[@"address"]]; [_fromLabel sizeToFit];
                                   _toLabel.y = _fromLabel.bottom  +10;
                                   _toLabel.text = [NSString stringWithFormat:@"目的地：%@",dic[@"addressTo"]];
                                   [_toLabel sizeToFit];
                                   _recId = [NSString stringWithFormat:@"%@",dic[@"recId"]];
                               } failed:^(NSString *error) {
                                   _MyXingCheng.hidden = YES;
                                   
                               }];
}

-(UILabel *)CreatLabelWithtext:(NSString *)text textfont:(UIFont *)font textcolor:(UIColor *)textcolor X:(CGFloat)x Y:(CGFloat)y W:(CGFloat)w H:(CGFloat)h
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(x, y, w, h)];
    label.text = text;
    label.textColor=textcolor;
    label.font = font;
    
    [_MyXingCheng addSubview:label];
    
    return label;
    
}

- (void)cancle{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@?recId=%@",BaseUrl,API_DRIVER_BREAK,_recId];
    [SVProgressHUD show];
    [ExpressRequest sendWithParameters:nil MethodStr:urlStr reqType:k_GET success:^(id object) {
        [SVProgressHUD dismiss];
        _MyXingCheng.hidden = YES;
    } failed:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
}


- (void)configNavgationBar {
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 60)];
    label.textColor = [UIColor whiteColor];
    label.text = @"我的顺风";
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(backToMenuView)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    
}
- (void)backToMenuView{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
