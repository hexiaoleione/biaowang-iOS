//
//  InforWebViewController.m
//  e发快递（测试）
//
//  Created by pro on 15/9/28.
//  Copyright (c) 2015年 pro. All rights reserved.
//

#import "InforWebViewController.h"
#import "MainHeader.h"
@interface InforWebViewController ()<UIWebViewDelegate>

@property (nonatomic, weak) UIActivityIndicatorView * activityView;

@end

@implementation InforWebViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0x222231)];
    self.navigationController.navigationBar.translucent = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self configNavgationBar];
    
    UIWebView *webview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT - 64)];
    webview.delegate = self;
    NSString *str = nil;
    NSString *title = nil;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    switch (_info_type) {
        case INFO_APP_INTRODUCE:

            str = [NSString stringWithFormat:@"http://www.efamax.com/mobile_document/about/productCustomer.html?%@",strDate];
            title = @"功能介绍";
            break;
        case INFO_COMPANY:

            str = [NSString stringWithFormat:@"http://www.efamax.com/mobile_document/about/company.html?%@",strDate];
            title = @"公司介绍";
            break;
            
        case INFO_LAW:

            str = [NSString stringWithFormat:@"http://www.efamax.com/mobile_document/law/user.html?%@",strDate];
            title = @"法律声明及条款";
            break;
        case INFO_AD_WEB:
            
            str = _adUrl;
            title = _adName;
            break;
        case INFO_ZHONGCHOU:
//            [self setNavbar];
            str = [NSString stringWithFormat:@"http://www.efamax.com/stockholder.html?%@",strDate];
            title = _adName;
            break;
            
         case INFO_RULE:
            str = [NSString stringWithFormat:@"http://www.efamax.com/mobile/userWalletHelp.html?%@",strDate];
            title = @"收益说明";
            break;
        case INFO_USERER_RULE:
            str = [NSString stringWithFormat:@"http://www.efamax.com/mobile/manual/userManual.html?%@",strDate];
            title = @"用户发单手册";
            break;
        case INFO_DRIVER_RULE:
            str = [NSString stringWithFormat:@"http://www.efamax.com/mobile/manual/diverManual.html?%@",strDate];
            title = @"镖师接单手册";
            break;
        case INFO_WULIU_RULE:
            str = [NSString stringWithFormat:@"http://www.efamax.com/mobile/manual/logDiverManual.html?%@",strDate];
            title = @"物流接单手册";
            break;
        case INFO_ELSE_RULE:
            str = [NSString stringWithFormat:@"http://www.efamax.com/mobile/manual/else.html?%@",strDate];
            title = @"其他功能";
            break;
        case INFO_VIDEO:
            str = [NSString stringWithFormat:@"http://www.efamax.com/mobile/manual/videoList.html?%@",strDate];
            title = @"操作视频";
            break;
        case INFO_SCOUPON_RULE:
            str = [NSString stringWithFormat:@"http://www.efamax.com/mobile/explain/couponExplain.html?%@",strDate];
            title = @"现金券说明";
            break;
        case INFO_RECHARGE_RULE:
            str = [NSString stringWithFormat:@"http://www.efamax.com/mobile/explain/rechargeExplain.html?%@",strDate];
            title = @"充值说明";
            break;
        case WEB_WL_insure:{
            str = [NSString stringWithFormat:@"http://www.efamax.com/mobile/manual/inSureRuleAndroid.html?%@",strDate];
            title = @"投保协议";
        }
            break;

        default:
            break;
    }
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 60)];
    label.textColor = [UIColor whiteColor];
    label.text = title;
    label.textAlignment = 1;
    self.navigationItem.titleView = label;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:str]];
    
    [webview loadRequest:request];
    
    [self.view addSubview:webview];
    
    //activityView
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityView.center = self.view.center;
    [activityView startAnimating];
    self.activityView = activityView;
    [self.view addSubview:activityView];
    if (self.navigationController.navigationBar.translucent == YES) {
        webview.height += 64;
    }

    // Do any additional setup after loading the view.
}

-(void)setNavbar{
    self.navigationController.navigationBar.hidden = YES;
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];

    statusBarView.backgroundColor=[UIColor orangeColor];

    [self.view addSubview:statusBarView];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
//    webview.size = CGSizeMake(WINDOW_WIDTH, WINDOW_HEIGHT);
}


#pragma mark - bar
- (void)configNavgationBar {
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(backToMenuView)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
}

- (void)backToMenuView
{
//    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}
#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    self.activityView.hidden = YES;
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
