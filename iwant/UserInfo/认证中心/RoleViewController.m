//
//  RoleViewController.m
//  iwant
//
//  Created by pro on 16/5/30.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "RoleViewController.h"
#import "RealnameViewController.h"
#import "UserNameViewController.h"
#import "YLGIFImage.h"
#import "MainHeader.h"
#import "EcoinWebViewController.h"
#import "LogistRoleViewController.h"
#import "DriverRoleViewController.h"
#import "WuLiuDriverViewController.h" //物流司机

#define ScreenW                [[UIScreen mainScreen] bounds].size.width
#define ScreenH               [[UIScreen mainScreen] bounds].size.height
#define BACKGROUND_COLOR            [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0]

//按比例获取高度
#define  WGiveHeight(HEIGHT) HEIGHT * [UIScreen mainScreen].bounds.size.height/568.0

//按比例获取宽度
#define  WGiveWidth(WIDTH) WIDTH * [UIScreen mainScreen].bounds.size.width/320.0

#define FONT(A,IFBOLD)                IFBOLD ? [UIFont boldSystemFontOfSize:WINDOW_WIDTH > 320 ? A : A/1.3]: [UIFont systemFontOfSize:WINDOW_WIDTH > 320 ? A : A/1.3]

#define COLOR_ORANGE_DEFOUT         COLOR_(250, 112, 36, 1)
@interface RoleViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
    
    UIView *_TopView;
    
    UIButton *_firstbtn;
    UIButton *_seconbtn;
    UIButton *_thirdbtn;
    UIButton *_fourbtn;
    UIButton *_fivebtn;
    
    UIButton *_courentbtn;//当前按钮
    
    UILabel *_label;
    UIButton *_nextbtn;
    
    //数据源
    NSMutableArray *_menuBasicArray;
    //tableView
    UITableView *_meunTableView;
    
}

@end

@implementation RoleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavgationBar];
    [self CreatSubViews];
    
    _menuBasicArray = [NSMutableArray arrayWithObjects:@"顺风镖师",@"快递员", @"物流公司",@"货运司机", nil];
}
#pragma mark- 界面UI
-(void)CreatSubViews
{
    
    _TopView = [[UIView alloc]initWithFrame:CGRectMake(15, WGiveHeight(20), ScreenW-30, 199)];
    _TopView.layer.cornerRadius = 10;
    
    _TopView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_TopView];
    
    _meunTableView = [[UITableView alloc]initWithFrame:_TopView.frame  style:UITableViewStylePlain];
    _meunTableView.dataSource = self;
    _meunTableView.delegate = self;
    _meunTableView.layer.cornerRadius = 10;
    
    _meunTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _meunTableView.scrollEnabled = NO;
    
    [self.view addSubview:_meunTableView];
    
    
    
    _label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_TopView.frame)+5, ScreenW, 30)];
    
    _label.textAlignment = NSTextAlignmentCenter;
    _label.font = [UIFont systemFontOfSize:13];
    _label.textColor = [UIColor grayColor];
    [self.view addSubview:_label];
    //
    //    _firstbtn = [self CreatBtnWithimage:@"ture2_bar"SelectImage:@"ture_bar"Highlightedimage:@"ture1_bar" X:ScreenW-100 Y:0 W:50 H:50 tag:1];
    _seconbtn = [self CreatBtnWithimage:@"ture2_bar" SelectImage:@"ture_bar" Highlightedimage:@"ture1_bar" X:ScreenW-100 Y:0 W:50 H:50 tag:1];
    _thirdbtn =[self CreatBtnWithimage:@"ture2_bar" SelectImage:@"ture_bar" Highlightedimage:@"ture1_bar" X:ScreenW-100 Y:50 W:50 H:50 tag:2];
    _fourbtn = [self CreatBtnWithimage:@"ture2_bar" SelectImage:@"ture_bar" Highlightedimage:@"ture1_bar" X:ScreenW-100 Y:100 W:50 H:50 tag:3];
    _fivebtn = [self CreatBtnWithimage:@"ture2_bar" SelectImage:@"ture_bar" Highlightedimage:@"ture1_bar" X:ScreenW-100 Y:150 W:50 H:50 tag:4];
    
    
    //确认按钮
    _nextbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _nextbtn.backgroundColor = [UIColor orangeColor];
    _nextbtn.frame = CGRectMake((ScreenW/2 -WGiveWidth(75)), CGRectGetMaxY(_label.frame) +WGiveHeight(20), WGiveWidth(150), WGiveHeight(35));
    [_nextbtn setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextbtn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    _nextbtn.layer.cornerRadius = 5;
    
    [self.view addSubview:_nextbtn];

    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, WINDOW_HEIGHT - 64 - WINDOW_WIDTH *0.20, WINDOW_WIDTH, WINDOW_WIDTH *0.25)];
    webView.userInteractionEnabled = NO;
    [self.view addSubview:webView];
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"zhaunche1" ofType:@"gif"]];
    [webView loadData:data MIMEType:@"image/gif" textEncodingName:@"UTF-8" baseURL:nil];
    //    webView.backgroundColor = [UIColor clearColor];
    //    webView.opaque = YES;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(goToWeb) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = webView.frame;
    [self.view addSubview:btn];
    
    
    
}

- (void)goToWeb{
    EcoinWebViewController *web = [[EcoinWebViewController alloc]init];
    web.web_type = WEB_BIAOSHI_HELP;
    [self.navigationController pushViewController:web animated:YES];
}
-(void)next
{
    switch (_courentbtn.tag)
    {
        case 0:{
            NSLog(@"选中普通用户");
            
            //判断用户是否已经实名
            if ([[UserManager getDefaultUser].realManAuth isEqualToString:@"Y"]) {
                [SVProgressHUD showInfoWithStatus:@"已经审核成功"];
                return;
            }
            UserNameViewController *VC = [[UserNameViewController alloc]init];
            VC.courentbtnTag = (int)_courentbtn.tag;
            
            [self.navigationController pushViewController:VC animated:YES];
            break;
            
        }
        case 1:
        {
            //判断快递员是否已经认证,认证了快递员，就具有表示资格，不需要认证
            if ([UserManager getDefaultUser].userType == 3) {
                [SVProgressHUD showInfoWithStatus:@"您已通过镖师审核"];
                return;
            }
            if ([UserManager getDefaultUser].userType == 2) {
                [SVProgressHUD showInfoWithStatus:@"您已通过快递员审核，已经具备了镖师资格"];
                return;
            }
            
            UserNameViewController *VC = [[UserNameViewController alloc]init];
            VC.courentbtnTag = (int)_courentbtn.tag+1;
            
            [self.navigationController pushViewController:VC animated:YES];
            NSLog(@"选中镖师");
            break;
            
        }
        case 2:
        {
            //判断快递员是否已经认证
            if ([UserManager getDefaultUser].userType == 2) {
                [SVProgressHUD showInfoWithStatus:@"您已通过快递员审核"];
                return;
            }
            
            UserNameViewController *VC = [[UserNameViewController alloc]init];
            VC.courentbtnTag = (int)_courentbtn.tag +1;
            
            [self.navigationController pushViewController:VC animated:YES];
            NSLog(@"%d-=-=-=-=",VC.courentbtnTag);
            
            NSLog(@"选中快递员");
            break;
        }
            
        case 3:
        {
            if ([[UserManager getDefaultUser].wlid intValue] == 1) {
                
                [SVProgressHUD showInfoWithStatus:@"您已经认证物流公司"];
                return;
            }
            if ([[UserManager getDefaultUser].wlid intValue] == 2) {
                
                [SVProgressHUD showInfoWithStatus:@"您已经认证货运司机"];
                return;
            }
            if ([[UserManager getDefaultUser].wlid intValue] == 3) {
                //禁用啦
                [SVProgressHUD showInfoWithStatus:@"您已被禁用，请联系我们(Biaowang_app@163.com)"];
                return;
            }

            LogistRoleViewController *VC = [[LogistRoleViewController alloc]init];
            [self.navigationController pushViewController:VC animated:YES];
            NSLog(@"选中物流公司");
            break;
            
        }
        case 4:
        {
            if ([[UserManager getDefaultUser].wlid intValue] == 1) {
                
                [SVProgressHUD showInfoWithStatus:@"您已经认证物流公司"];
                return;
            }
            if ([[UserManager getDefaultUser].wlid intValue] == 2) {
                
                [SVProgressHUD showInfoWithStatus:@"您已经认证货运司机"];
                return;
            }
            if ([[UserManager getDefaultUser].wlid intValue] == 3) {
                //禁用啦
                [SVProgressHUD showInfoWithStatus:@"您已被禁用，请联系我们(Biaowang_app@163.com)"];
                return;
            }

            WuLiuDriverViewController * VC = [[WuLiuDriverViewController alloc]init];
            [self.navigationController pushViewController:VC animated:YES];
        }
            
    }
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
//tableView行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _menuBasicArray.count;
}

//创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MeunCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = [_menuBasicArray objectAtIndex:indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    [cell.textLabel setHighlightedTextColor:[UIColor orangeColor]];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
            
        case 0: {
            
            [_seconbtn setImage:[UIImage imageNamed:@"ture_bar"] forState:UIControlStateNormal];
            [_thirdbtn setImage:[UIImage imageNamed:@"ture2_bar"] forState:UIControlStateNormal];
            [_fourbtn setImage:[UIImage imageNamed:@"ture2_bar"] forState:UIControlStateNormal];
            [_fivebtn setImage:[UIImage imageNamed:@"ture2_bar"] forState:UIControlStateNormal];
            _courentbtn=_seconbtn;
            break;
        }
            
        case 1: {
            
            [_seconbtn setImage:[UIImage imageNamed:@"ture2_bar"] forState:UIControlStateNormal];
            [_thirdbtn setImage:[UIImage imageNamed:@"ture_bar"] forState:UIControlStateNormal];
            [_fourbtn setImage:[UIImage imageNamed:@"ture2_bar"] forState:UIControlStateNormal];
            [_fivebtn setImage:[UIImage imageNamed:@"ture2_bar"] forState:UIControlStateNormal];
            _courentbtn=_thirdbtn;
            NSLog(@"快递员3");
            
            break;
        }
            //
        case 2:{
            
            [_seconbtn setImage:[UIImage imageNamed:@"ture2_bar"] forState:UIControlStateNormal];
            [_thirdbtn setImage:[UIImage imageNamed:@"ture2_bar"] forState:UIControlStateNormal];
            [_fourbtn setImage:[UIImage imageNamed:@"ture_bar"] forState:UIControlStateNormal];
            [_fivebtn setImage:[UIImage imageNamed:@"ture2_bar"] forState:UIControlStateNormal];
            _courentbtn=_fourbtn;
            break;
        }
         case 3:{
            
           [_firstbtn setImage:[UIImage imageNamed:@"ture2_bar"] forState:UIControlStateNormal];
           [_seconbtn setImage:[UIImage imageNamed:@"ture2_bar"] forState:UIControlStateNormal];
           [_thirdbtn setImage:[UIImage imageNamed:@"ture2_bar"] forState:UIControlStateNormal];
           [_fourbtn setImage:[UIImage imageNamed:@"ture2_bar"] forState:UIControlStateNormal];
           [_fivebtn setImage:[UIImage imageNamed:@"ture_bar"] forState:UIControlStateNormal];
           _courentbtn=_fivebtn;
            
            break;
        }
        default:
            break;
    }
}



-(UIButton *)CreatBtnWithimage:(NSString *)image  SelectImage:(NSString *)selectimage  Highlightedimage:(NSString *)Highlightedimage X:(CGFloat)x Y:(CGFloat)y W:(CGFloat)w H:(CGFloat)h tag:(int)tag
{
    
    // btn
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(x, y, w, h)];
    btn.tag = tag;
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    //    [btn addTarget:self action:@selector(Clicktag :) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:selectimage] forState:UIControlStateSelected];
    [btn setImage:[UIImage imageNamed:Highlightedimage] forState:UIControlStateHighlighted];
    [_meunTableView addSubview:btn];
    
    return btn;
    
}

- (void)configNavgationBar {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 60)];
    label.textColor = [UIColor whiteColor];
    label.text = @"角色认证";
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
    
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(backToMenuView)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    
}

- (void)backToMenuView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
