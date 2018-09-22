//
//  MyUserCenterVC.m
//  iwant
//
//  Created by 公司 on 2017/2/23.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "MyUserCenterVC.h"
#import "changeInfoViewController.h"
#import "ScanViewController.h"
#import "PromoteViewController.h"
#import "RoleViewController.h"
#import "FeedBackViewController.h"
#import "AboutViewController.h"
#import "InforWebViewController.h"
#import "PersonalWealthVC.h"
#import "RoleExplainVC.h"
#import "ZYRatingView.h"
#import "MyMessageViewController.h"
#import "OperationRuleVC.h"

@interface MyUserCenterVC ()<UITableViewDelegate,UITableViewDataSource,RatingViewDelegate>
{
    UIButton * _headImgV;
    
    UITableView * _tableView;
    
    NSArray * _dataArr;
    
    UIImageView *_creditRankImg;
    ZYRatingView *_starsView;
    UILabel * _label; // 退出登录
}

@end

@implementation MyUserCenterVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString *urlStr = [NSString stringWithFormat:@"%@",[UserManager getDefaultUser].headPath];
    [_headImgV sd_setBackgroundImageWithURL:[NSURL URLWithString:urlStr] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"user-1"]];
    [self loadData];
}

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


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setCostomeTitle:@"个人中心"];
    self.view.backgroundColor = BACKGROUND_COLOR;
    _dataArr = @[@"个人财产",@"角色认证",@"意见反馈",@"我要理赔",@"操作指南",@"关于"];
    [self initSubViews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jpush:) name:ACTION_SYSTEM_MESSAGE object:nil];

    [self setRank:[UserManager getDefaultUser].userType];
    
    [self setNavi:0];

}

-(void)initSubViews{
 
    UIView * headView =[[UIView alloc]init];
    headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headView];
    
    headView.sd_layout
    .topEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(180*RATIO_HEIGHT);
    
    _headImgV = [UIButton buttonWithType:UIButtonTypeCustom];
    [_headImgV addTarget:self action:@selector(goUserVC:) forControlEvents:UIControlEventTouchUpInside];
    
    [headView addSubview:_headImgV];
    
    _headImgV.sd_layout
    .centerXEqualToView(headView)
    .topSpaceToView(headView,10*RATIO_HEIGHT)
    .widthIs(60*RATIO_HEIGHT)
    .heightIs(60*RATIO_HEIGHT);
    _headImgV.sd_cornerRadiusFromHeightRatio =@0.5;
    
    UILabel *userNameLabel = [UILabel new];
    userNameLabel.textAlignment = NSTextAlignmentCenter;
    userNameLabel.text = [UserManager getDefaultUser].userName.length? [UserManager getDefaultUser].userName : [UserManager getDefaultUser].mobile;
    userNameLabel.textColor = [UIColor blackColor];
    [headView addSubview:userNameLabel];
    
    userNameLabel.font = [UIFont systemFontOfSize:15];
    [userNameLabel sizeToFit];
    
    userNameLabel.sd_layout
    .centerXEqualToView(headView)
    .heightIs(25*RATIO_HEIGHT)
    .widthIs(userNameLabel.width)
    .topSpaceToView(_headImgV,8);
    
    //等级
    _creditRankImg = [[UIImageView alloc]init];
    [headView addSubview:_creditRankImg];
    _creditRankImg.sd_layout
    .leftSpaceToView(userNameLabel,5*RATIO_WIDTH)
    .heightRatioToView(userNameLabel,0.6)
    .centerYEqualToView(userNameLabel)
    .maxWidthIs(30*RATIO_HEIGHT);

    //评分
    _starsView = [[ZYRatingView alloc]initWithFrame:CGRectMake(0, 0, 20*RATIO_HEIGHT *4.5, 20*RATIO_HEIGHT)];
    [_starsView setImagesDeselected:@"nil" partlySelected:@"ban_pang" fullSelected:@"litter_pang" andDelegate:self];
    _starsView.userInteractionEnabled = NO;
    [headView addSubview: _starsView];
    
    _starsView.sd_layout
    .topSpaceToView(userNameLabel,2)
    .centerXEqualToView(headView)
    .widthIs(90)
    .heightIs(20);

    
    UIView * line = [[UIView alloc]init];
    line.backgroundColor = [UIColor lightGrayColor];
    [headView addSubview:line];
    
    line.sd_layout
    .centerXEqualToView(headView)
    .widthIs(1)
    .heightIs(30*RATIO_HEIGHT)
    .bottomSpaceToView(headView,20*RATIO_HEIGHT);
    
//扫描
    
    UIButton * saomiaoBtn = [[UIButton alloc]init];
    [saomiaoBtn setBackgroundImage:[UIImage imageNamed:@"saomiaodengluLmg"] forState:UIControlStateNormal];
    [saomiaoBtn addTarget:self action:@selector(saomiaoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:saomiaoBtn];
    
    saomiaoBtn.sd_layout
    .centerXIs(SCREEN_WIDTH/4)
    .topSpaceToView(userNameLabel,20*RATIO_HEIGHT)
    .widthIs(25*RATIO_HEIGHT)
    .heightIs(25*RATIO_HEIGHT);

    UILabel * saomiaoLabel = [[UILabel alloc]init];
    saomiaoLabel.textAlignment = NSTextAlignmentCenter;
    saomiaoLabel.text = @"加盟商扫码登陆";
    saomiaoLabel.textColor = [UIColor lightGrayColor];
    [headView addSubview:saomiaoLabel];
    
    saomiaoLabel.font = [UIFont systemFontOfSize:13];
    [saomiaoLabel sizeToFit];
    
    saomiaoLabel.sd_layout
    .centerXEqualToView(saomiaoBtn)
    .heightIs(22*RATIO_HEIGHT)
    .widthIs(saomiaoLabel.width)
    .topSpaceToView(saomiaoBtn,4);
    
//分享
    UIButton * shareBtn = [[UIButton alloc]init];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"fenxiangLmg"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:shareBtn];
    
    shareBtn.sd_layout
    .centerXIs(SCREEN_WIDTH/4*3)
    .topSpaceToView(userNameLabel,20*RATIO_HEIGHT)
    .widthIs(25*RATIO_HEIGHT)
    .heightIs(25*RATIO_HEIGHT);

    
    UILabel * fenxiangLabel = [[UILabel alloc]init];
    fenxiangLabel.textAlignment = NSTextAlignmentCenter;
    fenxiangLabel.text = @"分享";
    fenxiangLabel.textColor = [UIColor lightGrayColor];
    [headView addSubview:fenxiangLabel];
    
    fenxiangLabel.font = [UIFont systemFontOfSize:13];
    [fenxiangLabel sizeToFit];
    
    fenxiangLabel.sd_layout
    .centerXEqualToView(shareBtn)
    .heightIs(20*RATIO_HEIGHT)
    .widthIs(fenxiangLabel.width)
    .topSpaceToView(shareBtn,4);

    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, headView.bottom , SCREEN_WIDTH, SCREEN_HEIGHT-64-headView.height) style:UITableViewStyleGrouped];
     [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;

}

#pragma mark -----扫描登录 分享 完善个人信息

- (void)goUserVC:(UIButton *)btn{
    //跳转完善个人信息
    changeInfoViewController * wanshanVC =[[changeInfoViewController alloc]init];
    [self.navigationController pushViewController:wanshanVC animated:YES];
}

-(void)saomiaoBtnClick{
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
    [self.navigationController presentViewController:scanLogin animated:YES completion:nil];
}

-(void)shareBtnClick{
    if ((![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) || (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) ) {
        [SVProgressHUD showInfoWithStatus:@"暂不能使用此功能"];
        return;
    }
    //分享页面
    UIViewController *vc = [[UIViewController alloc]init];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 60)];
    label.textColor = [UIColor whiteColor];
    label.text = @"分享";
    label.textAlignment = 1;
    vc.navigationItem.titleView = label;
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(backToMenuView)];
    vc.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    ShareView *share =   [[ShareView alloc]initWithFrame:vc.view.bounds];
    vc.view = share;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)backToMenuView{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ----- tableView   delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return _dataArr.count;
    }else{
        return 1;
    }
}
//section头部间距
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}
//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH - 20, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
//section底部间距
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15;
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH - 20, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}


- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50 *RATIO_HEIGHT;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * identifier = @"cell";
    UITableViewCell * cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    if (indexPath.section == 0) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = [_dataArr objectAtIndex:indexPath.row];
    }else{
        
        //给contentView添加一个uilabel,放到最中间
        if (_label == nil) {
            _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, cell.bounds.size.width, cell.bounds.size.height)];
            _label.font = [UIFont systemFontOfSize:18];
            _label.textColor = COLOR_ORANGE_DEFOUT;
            _label.textAlignment = NSTextAlignmentCenter;
            _label.centerX = SCREEN_WIDTH/2;
            _label.centerY = cell.bounds.size.height/2;
            _label.text = @"退出登录";
            [cell addSubview:_label];
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section==0) {
        if (indexPath.row == 0) {
           //个人财产
            NSLog(@"个人财产！~~~~~");
            PersonalWealthVC * personalWealthVC = [[PersonalWealthVC alloc]init];
            [self.navigationController  pushViewController:personalWealthVC animated:YES];
        }else if(indexPath.row == 1){
           //角色认证
            RoleExplainVC * vc = [[RoleExplainVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if(indexPath.row == 2){
            //意见反馈
            [self.navigationController pushViewController:[[FeedBackViewController alloc]init] animated:YES];
        }else if(indexPath.row == 3){
            //我要理赔 95509
            [Utils callAction:@"95509"];
        }else if(indexPath.row == 4){
            //操作指南
            OperationRuleVC * operationVC = [[OperationRuleVC alloc]init];
            [self.navigationController pushViewController:operationVC animated:YES];
        }else{
            //关于
            [self.navigationController pushViewController:[[AboutViewController alloc]init] animated:YES];
        }
    }else{
        //退出登录
        [PXAlertView showAlertWithTitle:nil message:@"确认要退出登录吗？" cancelTitle:@"取消" otherTitle:@"确认" completion:^(BOOL cancelled, NSInteger buttonIndex) {
            if (!cancelled) {
                self.tabBarController.selectedIndex = 0;
                [self.navigationController popToRootViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:ISLOGOUT object:nil];
                [JPUSHService setTags:[NSSet set] alias:@"" fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags , iAlias);
                }];
//                [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
//                    if (!error) {
//                        NSLog(@"退出成功");
//                    }
//                } onQueue:nil];
                [UserManager removeDefaultUser];
                NSLog(@"退出登录成功");
            }
        }];
    }
}

- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}


- (void)setRank:(int)userType{
    switch (userType) {
        case 1:
            //用户
        {
            //获取用户信用评分
            [RequestManager getuserCreditWithuserId:[UserManager getDefaultUser].userId success:^(id object) {
                NSString *str =  object[@"creditLV"];
                
                _creditRankImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"v%@",str]];
            }
             Failed:^(NSString *error) {
           }];
        }
            
            break;
        case 2:
            //快递员
        {
            [RequestManager getcouierSorceAndLVWithuserId:[UserManager getDefaultUser].userId success:^(NSDictionary *result) {
                
                [_starsView displayRating:[result[@"pickupScore"] doubleValue]*2];
                
                NSString *str =  result[@"allowanceLevel"];
                
                _creditRankImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"v%@",str]];
                
            } Failed:^(NSString *error) {
                
            }];
        }
            break;
            
        default:
            break;
    }
}

-(void)ratingChanged:(float)newRating{
    NSLog(@"评分");
}


#pragma mark -- 我的消息
- (void)MyMessage:(id)sender {
    
    MyMessageViewController *VC = [[MyMessageViewController alloc]init];
    
    [self.navigationController pushViewController:VC animated:YES];
    
    [sender clearBadge];
}


- (void)setNavi:(int)tag{
  
    UIButton *msgButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 33, 23)];
    [msgButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"info_%d",tag]] forState:UIControlStateNormal];
    [msgButton addTarget:self action:@selector(MyMessage:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:msgButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)jpush:(id)tag{
    UIBarButtonItem *btn = (UIBarButtonItem *)self.navigationItem.rightBarButtonItem;
    btn.badgeCenterOffset = CGPointMake(-8, 3);
    [btn showBadgeWithStyle:WBadgeStyleNew value:1 animationType:WBadgeAnimTypeScale];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
