//
//  JZKBWebViewController.m
//  ACMR
//
//  Created by hehuimin on 16/7/20.
//  Copyright © 2016年 何會敏. All rights reserved.
//

#import "PRHomeWebViewController.h"
#import <WebKit/WebKit.h>

@interface PRHomeWebViewController ()<WKUIDelegate,WKScriptMessageHandler,WKNavigationDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) CALayer *progresslayer;

@end

@implementation PRHomeWebViewController


- (WKWebView *)webView {
    if (!_webView) {
        //进行配置控制器
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        //实例化对象
        configuration.userContentController = [WKUserContentController new];
        
        [configuration.userContentController addScriptMessageHandler:self name:@"methodsName"];//用户反馈
       
        configuration.suppressesIncrementalRendering = YES;
        WKPreferences *preferences = [WKPreferences new];
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        configuration.preferences = preferences;
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)configuration:configuration ];
        _webView.backgroundColor = [UIColor whiteColor];
        
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        
        [self.view addSubview:_webView];
    }
    return _webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
//    if ([self.urlString hasPrefix:@"https://www"] || [self.urlString hasPrefix:@"http://www"]|| [self.urlString hasPrefix:@"http"]||[self.urlString hasPrefix:@"https"]) {
//
//    }else if ([self.urlString hasPrefix:@"www."]) {
//
//        self.urlString = [NSString stringWithFormat:@"https://%@",self.urlString];
//
//    }else {
//
//        self.urlString = [NSString stringWithFormat:@"https://www.%@",self.urlString];
//
//    }
   

//    NSLog(@"self.urlString======%@",self.urlString);
    [self createNav];
    
    [self webView];

    NSMutableURLRequest * urlReuqest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:@"http://www.efamax.com/mobile/sanchuan/sanchuan.html"] cachePolicy:1 timeoutInterval:60.0f];
    [_webView loadRequest:urlReuqest];
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    UIView *progress = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 2)];
    progress.backgroundColor = [UIColor clearColor];
    [self.view addSubview:progress];
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, 0, 2);
    layer.backgroundColor = [UIColor redColor].CGColor;
    [progress.layer addSublayer:layer];
    self.progresslayer = layer;
   
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}
-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
//    if (isFirstEnter==NO) {
//        [self.webView reload];
//    }
}


#pragma mark - WKNavigationDelegate


- (void)createNav {
    self.view.backgroundColor = [UIColor whiteColor];
    [self setCostomeTitle:@"镖师培训题"];

//    [self setTitleView:self.titleString];
//    [self.backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progresslayer.opacity = 1;
        //不要让进度条倒着走...有时候goback会出现这种情况
        if ([change[@"new"] floatValue] < [change[@"old"] floatValue]) {
            return;
        }
        self.progresslayer.frame = CGRectMake(0, 0, self.view.bounds.size.width * [change[@"new"] floatValue], 2);
        if ([change[@"new"] floatValue] == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progresslayer.opacity = 0;
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progresslayer.frame = CGRectMake(0, 0, 0, 2);
            });
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

//- (void)dealloc{
////    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
//}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示"  message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认"  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }])];
    
    completionHandler();
    [self presentViewController:alertController animated:YES completion:nil];

}
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    //    DLOG(@"msg = %@ frmae = %@",message,frame);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示"  message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消"  style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认"  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成"  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];

}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    
    NSLog(@"name=====%@,body=====%@",message.name,message.body);

    if ([message.name containsString:@"methodsName"]) {
      
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UserManager getDefaultUser].userId,@"answerDriverId",@"100",@"answerScore",nil];
        [ExpressRequest sendWithParameters:dic MethodStr:API_DT_AnswerResult reqType:k_POST success:^(id object) {
           
            [SVProgressHUD showSuccessWithStatus:@"恭喜您通过培训"];
            [self performSelector:@selector(back) withObject:nil afterDelay:1];
            
            
        } failed:^(NSString *error) {
       [SVProgressHUD showErrorWithStatus:error];
        
        }];
    }
       
    
    
    
}
-(void)back {
  [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)backBtnClick:(id)sender {

    if ([self.webView canGoBack]) {
        [self.webView goBack];
    } else {
        [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
        [self.webView loadHTMLString:@"" baseURL:nil];
        [self.webView stopLoading];
        [self.webView setNavigationDelegate:nil];
        [self.webView removeFromSuperview];
        [self setWebView:nil];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}



#pragma mark - WKNavigationDelegate
//开始加载
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
//    [MBProgressHUD showMessag:FGGetStringWithKey(@"加载中") toView:self.view];
}
//加载成功
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
   
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
//    NSLog(@"access_token_=======%@",[SLUserDefaults objectForKey:access_token_]);

}

-(void)payClick {
    
    
}
//请重新加载
-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
//    [MBProgressHUD showError:FGGetStringWithKey(@"请重新加载") toView:self.view];
    
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
//    [MBProgressHUD showError:FGGetStringWithKey(@"请重新加载") toView:self.view];
    [webView stopLoading];
    
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        
        NSURLCredential *card = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
        
        completionHandler(NSURLSessionAuthChallengeUseCredential,card);
        
    }}

/**
 *  alertview的代理方法
 */
- (void)alertView:(UIAlertView *)alertView1 clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
   
    
}




@end
