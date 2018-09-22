//
//  EcoinWebViewController.m
//  e发快递（测试）
//
//  Created by dongba on 15/11/11.
//  Copyright © 2015年 pro. All rights reserved.
//

#import "EcoinWebViewController.h"
#import "SVProgressHUD.h"
#import "UserManager.h"
#import "MainHeader.h"
#import "UserNameViewController.h"

@interface EcoinWebViewController ()<UIWebViewDelegate>
{
    UIWebView *_webView;
    NSInteger _eCoin_Need;
}

@property (nonatomic, weak) UIActivityIndicatorView * activityView;

@end

@implementation EcoinWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configNavi];
    [self configWebView];
    //activityView
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityView.center = self.view.center;
    [activityView startAnimating];
    self.activityView = activityView;
    [self.view addSubview:activityView];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:YES animated:YES];
}
- (void)configWebView {
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)];
    NSString *urlStr = nil;
    NSString *title;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHH"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *strDateSecond = [dateFormatter stringFromDate:[NSDate date]];
    switch (self.web_type) {
        case WEB_BIAOSHI_HELP:
        {
            urlStr = [NSString stringWithFormat:@"http://www.efamax.com/zhuandiculler.html?%@",strDate];
            title = @"镖师认证说明";
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
            [_webView loadRequest:request];
            [_webView setScalesPageToFit:NO];
            [self.view addSubview:_webView];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setBackgroundColor:COLOR_(90, 207, 248, 1)];
            [btn setTitle:@"我要成为镖师" forState:UIControlStateNormal];
            btn.size = CGSizeMake(120, 40);
            btn.y = WINDOW_HEIGHT - 120;
            btn.layer.cornerRadius = 10;
            btn.centerX = self.view.centerX;
            [self.view addSubview:btn];
            [btn addTarget:self action:@selector(nextVC) forControlEvents:UIControlEventTouchUpInside];
            if ([UserManager getDefaultUser].userType != 1) {
                btn.hidden = YES;
            }
        }
         break;
        case WEB_EXPLAIN:
        {
            urlStr = [NSString stringWithFormat:@"http://www.efamax.com/mobile_document/ecoin/rewardCourierEcoin.html?%@",strDate];
            title = @"积分说明";
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
            [_webView loadRequest:request];
            [_webView setScalesPageToFit:NO];
            [self.view addSubview:_webView];
            _webView.delegate = self;
        }
            break;
        case WEB_HELP:{
            urlStr  = [NSString stringWithFormat:@"http://www.efamax.com/introduction/postman.html?%@",strDate];
            title = @"使用说明";
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
            [_webView loadRequest:request];
            [_webView setScalesPageToFit:NO];
            [self.view addSubview:_webView];
            _webView.delegate = self;
        }
            break;
        case WEB_LUCK_RULE:{
            urlStr = [NSString stringWithFormat:@"http://www.efamax.com/mobile/luckyDrawRule.html?%@",strDate];
            title = @"抽奖规则";
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
            [_webView loadRequest:request];
            [_webView setScalesPageToFit:NO];
            [self.view addSubview:_webView];
            _webView.delegate = self;
        }
            break;
        case WEB_COURIER_EXPLNE:{
//            urlStr = [NSString stringWithFormat:@"http://www.efamax.com/mobile/courier_useInstructions.html?%@",strDateSecond];
            urlStr = [NSString stringWithFormat:@"http://www.efamax.com/mobile/weixin/Attract_investment.html?%@",strDateSecond];
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
            [_webView loadRequest:request];
            [_webView setScalesPageToFit:NO];
            [self.view addSubview:_webView];
            _webView.delegate = self;
        }
            break;
        case WEB_USER_RENREN:{
            title = @"人人代理详解问答";
            urlStr = [NSString stringWithFormat:@"http://www.efamax.com/mobile/Everyone_promotion.html?%@",strDateSecond];
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
            [_webView loadRequest:request];
            [_webView setScalesPageToFit:NO];
            [self.view addSubview:_webView];
            _webView.delegate = self;
        }
            break;
        case WEB_USER_EXPLANE:{
            urlStr = [NSString stringWithFormat:@"http://www.efamax.com/mobile/rules.html?%@",strDate];
            title = @"优惠政策";
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
            [_webView loadRequest:request];
            [_webView setScalesPageToFit:NO];
            [self.view addSubview:_webView];
            _webView.delegate = self;
        }
            break;
        case WEB_USER_HELP:{
            urlStr = [NSString stringWithFormat:@"http://www.efamax.com/mobile/user_rules.html?%@",strDate];
            title = @"使用说明";
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
            [_webView loadRequest:request];
            [_webView setScalesPageToFit:NO];
            [self.view addSubview:_webView];
            _webView.delegate = self;
        }
            break;
        case WEB_SHOPPING_MALL:
        {
            title = @"积分商城";
            _webView.delegate = self;

            urlStr = [NSString stringWithFormat:@"http://www.efamax.com/express/ebshop/ecoin.html?%@",strDate];
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
            [_webView loadRequest:request];
            [_webView setScalesPageToFit:NO];
            [self.view addSubview:_webView];
//            //加载本地html
//            _webView.delegate = (id)self;
//            NSString *path = [[NSBundle mainBundle] pathForResource:@"ecoin.html" ofType:nil];
//            [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath: path]]];
//            [self.view addSubview:_webView];
            
            [self.navigationController setToolbarHidden:NO animated:YES];
            
            
            UIBarButtonItem *one = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(backToIndex)];
            UIBarButtonItem *two = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:nil action:nil];
            UIBarButtonItem *three = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:nil action:nil];
           
            UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            [self setToolbarItems:[NSArray arrayWithObjects:flexItem, one, flexItem, two, flexItem, three, flexItem,  nil]];
        }
            break;
        case WEB_WALLET_HELP:
        {
            title = @"收益说明";
            _webView.delegate = self;
            
            urlStr = [NSString stringWithFormat:@"http://www.efamax.com/mobile/balance_iwant.html?%@",strDate];
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
            [_webView loadRequest:request];
            [_webView setScalesPageToFit:NO];
            [self.view addSubview:_webView];
        
            [self.navigationController setToolbarHidden:NO animated:YES];
            
            
            UIBarButtonItem *one = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(backToIndex)];
            UIBarButtonItem *two = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:nil action:nil];
            UIBarButtonItem *three = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:nil action:nil];
            
            UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            [self setToolbarItems:[NSArray arrayWithObjects:flexItem, one, flexItem, two, flexItem, three, flexItem,  nil]];
        }
            break;
        case WEB_insureWL:{
            urlStr = [NSString stringWithFormat:@"http://www.efamax.com/mobile/InsureWL.html?%@",strDate];
            title = @"物流模块投保声明";
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
            [_webView loadRequest:request];
            [_webView setScalesPageToFit:NO];
            [self.view addSubview:_webView];
            _webView.delegate = self;
        
        }
            break;
        case WEB_insureSF:{
            urlStr = [NSString stringWithFormat:@"%@?%@",self.insureUrl,strDate];
            title = @"投保声明";
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
            [_webView loadRequest:request];
            [_webView setScalesPageToFit:NO];
            [self.view addSubview:_webView];
            _webView.delegate = self;

        }
            break;
        case WEB_BiaoShiReward:{
            urlStr = [NSString stringWithFormat:@"http://www.efamax.com/mobile/explain/driverExplain.html?%@",strDate];
            title = @"说明";
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
            [_webView loadRequest:request];
            [_webView setScalesPageToFit:NO];
            [self.view addSubview:_webView];
            _webView.delegate = self;
        }
            break;
        case WEB_LOGIN_Reward:{
            urlStr = [NSString stringWithFormat:@"http://www.efamax.com/mobile/explain/loginReward.html?%@",strDate];
            title = @"说明";
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
            [_webView loadRequest:request];
            [_webView setScalesPageToFit:NO];
            [self.view addSubview:_webView];
            _webView.delegate = self;
        }
            break;
        case WEB_Deposit:{
            urlStr = [NSString stringWithFormat:@"http://www.efamax.com/mobile/explain/marginExplain.html?%@",strDate];
            title = @"保证金说明";
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
            [_webView loadRequest:request];
            [_webView setScalesPageToFit:NO];
            [self.view addSubview:_webView];
            _webView.delegate = self;
        }
            break;
        case WEB_AccidentInsurance:{
            urlStr = [NSString stringWithFormat:@"http://www.efamax.com/mobile/explain/driverSafeExplainIos.html?%@",strDate];
            title = @"说明";
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
            [_webView loadRequest:request];
            [_webView setScalesPageToFit:NO];
            [self.view addSubview:_webView];
            _webView.delegate = self;
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
    
}

#pragma mark -- UIwebView



-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSLog(@"webView加载的网络请求  %@",request.URL);
//    [request.URL.absoluteString hasPrefix:@"scht://?"];
    //真正的url地址
    NSString *url = request.URL.absoluteString;
    //范围
    NSRange range = [url rangeOfString:@"scht://?"];
    if (range.location != NSNotFound) {
        NSUInteger loc = range.location +range.length;
        _eCoin_Need = [[url substringFromIndex:loc] intValue];
        NSString *message = [NSString stringWithFormat: @"是否要兑换快递券？\n%li - %li",(long)[UserManager getDefaultUser].ecoin,(long)_eCoin_Need];
        //积分足够兑换
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"友情提示" message: message preferredStyle:0];
        UIAlertAction *actionN = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *actionY = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"要扣积分咯");
        }];
        [alert addAction:actionN];
        [alert addAction:actionY];
        //积分不够兑换
        UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"友情提示" message:@"您的积分不足，要多多积攒哦！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        
        if (_eCoin_Need > [UserManager getDefaultUser].ecoin) {
            [alertV show];
        }else{
            [self presentViewController:alert animated:YES completion:^{
                nil;
            }];
        }

        return NO;
    }else{
       if ([url containsString:@"next://"]){
            //做你想要的操作
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.efamax.com/mobile/images/agreement.doc"]];
        }
    return YES;
    }
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
        self.activityView.hidden = YES;
    
    if (self.web_type == WEB_SHOPPING_MALL) {

    }
}


- (void)configNavi{
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)backToIndex{
    NSString *urlStr = @"http://www.efamax.com:8888/ebshop/ecoin.html";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [_webView loadRequest:request];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)nextVC{

    UserNameViewController *userVC = [UserNameViewController new];
    userVC.courentbtnTag = 2;
    [self.navigationController pushViewController:userVC animated:YES];
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
