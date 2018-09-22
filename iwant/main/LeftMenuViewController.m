//
//  LeftMenuViewController.m
//  BiaoWang
//
//  Created by 公司 on 2017/5/26.
//  Copyright © 2017年 LCF. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "MainHeader.h"
#import "HomeViewController.h"
#import "PersonalWealthVC.h"
#import "RoleExplainVC.h"
#import "FeedBackViewController.h"
#import "OperationRuleVC.h"
#import "AboutViewController.h"
#import "ActivityNewVC.h"
#import "SignInVC.h"
#import "MyMessageViewController.h"
#import "MyFaViewController.h" //我的发单
#import "MyJieViewController.h"//我的接单
#import "OtherPayViewController.h" //我的代付
#import "changeInfoViewController.h"
#import "ScanViewController.h"
#import "ShareViewController.h"

@interface LeftMenuViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UIButton * headerImgView;
    UILabel  *  _phoneL;
    UIButton * _signOutBtn;
    UITableView * _tableview;
}
@property (nonatomic, strong) NSArray *iconArray;
@property (nonatomic, strong) NSArray *titleArray;


@end

@implementation LeftMenuViewController

- (NSArray *)iconArray {
    if (!_iconArray) {
        self.iconArray = [NSArray arrayWithObjects:
                          @"left_btn_scan",
                          @"left_btn_yuE",
                          @"left_btn_jie",
                          @"left_btn_fa",
                          @"left_btn_daifu",
                          @"left_btn_Authentication",
                          @"left_btn_lipei",
                          @"left_btn_operation",
                          @"left_btn_about", nil];
    }
    return _iconArray;
}

- (NSArray *)titleArray {
    if (!_titleArray) {
        self.titleArray = [NSArray arrayWithObjects:@"加盟商扫码登录",@"账户余额",@"我的接单",@"我的发单",@"代付记录",@"角色认证",@"我要理赔",@"操作指南",@"关于", nil];
    }
    return _titleArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0x222231);
    [self setupContentView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(islogin) name:ISLOGIN object:nil];
}

- (void)setupContentView {
    UIView * view =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100*RATIO_HEIGHT)];
    view.backgroundColor = UIColorFromRGB(0x2d2d42);
    headerImgView = [[UIButton alloc]init];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@",[UserManager getDefaultUser].headPath];
    [headerImgView sd_setBackgroundImageWithURL:[NSURL URLWithString:urlStr] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"headerView"]];
    
    headerImgView.left = 20*RATIO_WIDTH;
    headerImgView.height = 50 *RATIO_WIDTH;
    headerImgView.width = 50 * RATIO_WIDTH;
    headerImgView.centerY = view.centerY;
    headerImgView.layer.cornerRadius = headerImgView.height/2;
    headerImgView.layer.masksToBounds = YES;
    
    [headerImgView addTarget:self action:@selector(headerViewBtn) forControlEvents:UIControlEventTouchUpInside];
    
    _phoneL = [[UILabel alloc]init];
    _phoneL.left = headerImgView.right +15 *RATIO_WIDTH;
    _phoneL.centerY = headerImgView.centerY;
    _phoneL.font = FONT(15, YES);
    _phoneL.textColor = [UIColor whiteColor];
    if ([UserManager getDefaultUser].userId) {
        if ([UserManager getDefaultUser].userName.length !=0 ) {
            _phoneL.text =[UserManager getDefaultUser].userName;
        }else{
            _phoneL.text =[UserManager getDefaultUser].mobile;
        }
    }
    [_phoneL sizeToFit];

    [self.view addSubview:view];
    [view addSubview:headerImgView];
    [view addSubview:_phoneL];
    
    UIButton * shareBtn = [[UIButton alloc]init];
    [shareBtn setImage:[UIImage imageNamed:@"shareImg"] forState:UIControlStateNormal];
    shareBtn.size = CGSizeMake(40, 40);
    shareBtn.centerY = _phoneL.centerY;

    shareBtn.left = 280 - shareBtn.width-20*RATIO_WIDTH;
    [shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareBtn];
    
   _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0,view.bottom+ 20 *RATIO_HEIGHT, MMDrawerLeftWidth, 40 * RATIO_HEIGHT * self.titleArray.count) style:UITableViewStylePlain];
    _tableview.delegate  = self;
    _tableview.dataSource = self;
    _tableview.scrollEnabled = NO;
    _tableview.backgroundColor = [UIColor clearColor];
    _tableview.separatorStyle = NO;
    [self.view addSubview:_tableview];
    
    _signOutBtn = [[UIButton alloc]init];
    _signOutBtn.frame = CGRectMake(22 * RATIO_WIDTH, SCREEN_HEIGHT-44 -35, MMDrawerLeftWidth - 22 * RATIO_WIDTH, 44);
    [_signOutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    _signOutBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _signOutBtn.titleLabel.font = FONT(15, NO);
    [_signOutBtn addTarget:self action:@selector(signOutBtn) forControlEvents:UIControlEventTouchUpInside];
    [_signOutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:_signOutBtn];
}

#pragma mark -----分享按钮
-(void)shareBtnClick{
    if ((![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) || (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) ) {
        [SVProgressHUD showInfoWithStatus:@"暂不能使用此功能"];
        return;
    }
    //其实我也不知道为啥要这样推出  因为不这样推出的话呢 他就崩了
    MMDrawerController *drawerVC = (MMDrawerController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [[UINavigationBar appearance] setTranslucent:NO];
    UINavigationController *cen = (UINavigationController *)drawerVC.centerViewController;
    [drawerVC closeDrawerAnimated:NO completion:nil];
    ShareViewController * shareVC =[[ShareViewController alloc]init];
    [cen pushViewController:shareVC animated:YES];
}

-(void)headerViewBtn{
    //其实我也不知道为啥要这样推出  因为不这样推出的话呢 他就崩了
    MMDrawerController *drawerVC = (MMDrawerController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [[UINavigationBar appearance] setTranslucent:NO];
    UINavigationController *cen = (UINavigationController *)drawerVC.centerViewController;
    [drawerVC closeDrawerAnimated:NO completion:nil];
    
    changeInfoViewController * VC =[[changeInfoViewController alloc]init];
    [cen pushViewController:VC animated:YES];
}

#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *ID = @"cell";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font =FONT(16, NO);
    cell.textLabel.text = self.titleArray[indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.imageView.image = [UIImage imageNamed:self.iconArray[indexPath.row]];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor =UIColorFromRGB(0x2d2d42);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40 * RATIO_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MMDrawerController *drawerVC = (MMDrawerController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [[UINavigationBar appearance] setTranslucent:NO];
    UINavigationController *cen = (UINavigationController *)drawerVC.centerViewController;
    [drawerVC closeDrawerAnimated:NO completion:nil];
    if (indexPath.row == 0) {
        NSLog(@"扫码登录");
        ScanViewController *scanLogin = [[ScanViewController alloc]init];
        scanLogin.isChoice = YES;
        scanLogin.returnCodeBlock = ^(NSString *code){
        [SVProgressHUD showWithStatus:@"代理登录中"];
        NSDictionary *dic =@{@"codeId":code,@"idCard":[UserManager getDefaultUser].idCard};
        [ExpressRequest sendWithParameters:dic MethodStr:@"system/agentNew/scanLogin" reqType:k_POST success:^(id object) {
        [SVProgressHUD showSuccessWithStatus:[object valueForKey:@"message"]];
        } failed:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
        }];
       };
    [cen presentViewController:scanLogin animated:YES completion:nil];
    }else if (indexPath.row == 1) {
        //账户余额
        PersonalWealthVC * personalWealthVC = [[PersonalWealthVC alloc]init];
        [cen  pushViewController:personalWealthVC animated:YES];
    }else if(indexPath.row == 2){
        //我的接单
        MyJieViewController  * vc =[[MyJieViewController alloc]init];
        [cen pushViewController:vc animated:YES];
    }else if(indexPath.row == 3){
        //我的发单
        MyFaViewController * vc =[[MyFaViewController alloc]init];
        [cen pushViewController:vc animated:YES];
    }else if(indexPath.row == 4){
        //代付记录
        OtherPayViewController * vc = [[OtherPayViewController alloc]init];
        [cen pushViewController:vc animated:YES];
    }else if(indexPath.row == 5){
        //角色认证
        RoleExplainVC * vc = [[RoleExplainVC alloc]init];
        [cen pushViewController:vc animated:YES];
    }else if(indexPath.row == 6){
        //我要理赔 95509
        [Utils callAction:@"4006095509"];
    }else if(indexPath.row == 7){
        //操作指南
        OperationRuleVC * vc = [[OperationRuleVC alloc]init];
        [cen pushViewController:vc animated:YES];
    }else{
        //关于
        AboutViewController * vc =[[AboutViewController alloc]init];
       [cen pushViewController:vc animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
#pragma mark -- 消息条数
-(void)loadData
{
    //获取未读消息数
    NSString *Url = [NSString stringWithFormat:@"%@%@?%@=%@",BaseUrl,API_GET_UNREAD_MSG,k_USER_ID,[UserManager getDefaultUser].userId];
    [ExpressRequest sendWithParameters:nil
                             MethodStr:Url
                               reqType:k_GET
                               success:^(id object) {
                                   int errCode = [[NSString stringWithFormat:@"%@",[object valueForKey:@"errCode"]] intValue];
                                   if (errCode) {
                                       [self setNavi:1];
                                   }else{
                                       [self setNavi:0];
                                   }
                               }
                                failed:^(NSString *error) {
                                    [self setNavi:0];
                                }];
}
- (void)setNavi:(int)tag{
    if (tag == 0) {
        self.iconArray = [NSArray arrayWithObjects:
                          @"left_btn_scan",
                          @"left_btn_yuE",
                          @"left_btn_jie",
                          @"left_btn_fa",
                          @"left_btn_daifu",
                          @"left_btn_Authentication",
                          @"left_btn_lipei",
                          @"left_btn_operation",
                          @"left_btn_about", nil];
        [_tableview reloadData];
    }else{
        self.iconArray = [NSArray arrayWithObjects:
                          @"left_btn_scan",
                          @"left_btn_yuE",
                          @"left_btn_jie",
                          @"left_btn_fa",
                          @"left_btn_daifu",
                          @"left_btn_Authentication",
                          @"left_btn_lipei",
                          @"left_btn_operation",
                          @"left_btn_about", nil];
        [_tableview reloadData];
    }
}

#pragma mark ---- 按钮点击事件
-(void)signOutBtn{
    //退出登录
     MMDrawerController *drawerVC = (MMDrawerController *)[UIApplication sharedApplication].keyWindow.rootViewController;
       [PXAlertView showAlertWithTitle:nil message:@"确认要退出登录吗？" cancelTitle:@"取消" otherTitle:@"确认" completion:^(BOOL cancelled, NSInteger buttonIndex) {
           if (!cancelled) {
               [drawerVC closeDrawerAnimated:NO completion:nil];
               [[NSNotificationCenter defaultCenter] postNotificationName:ISLOGOUT object:nil];
               [JPUSHService setTags:[NSSet set] alias:@"" fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                   NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags , iAlias);
               }];
              
               [UserManager removeDefaultUser];
               /*
               //需要处理一下，避免不强制更新的时候重复弹框
               [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ifShow"];
               [[NSUserDefaults standardUserDefaults] synchronize];
                */
            }
    }];
}

-(void)islogin{
    _phoneL.left = headerImgView.right +15 *RATIO_WIDTH;
    _phoneL.centerY = headerImgView.centerY;
    _phoneL.font = FONT(15, YES);
    _phoneL.textColor = [UIColor whiteColor];
    if ([UserManager getDefaultUser].userName.length !=0 ) {
        _phoneL.text =[UserManager getDefaultUser].userName;
    }else{
        _phoneL.text =[UserManager getDefaultUser].mobile;
    }
    [_phoneL sizeToFit];
    NSString *urlStr = [NSString stringWithFormat:@"%@",[UserManager getDefaultUser].headPath];
    [headerImgView sd_setBackgroundImageWithURL:[NSURL URLWithString:urlStr] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"headerView"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
