//
//  SearchResultViewController.m
//  Express
//
//  Created by 张宾 on 15/8/26.
//  Copyright (c) 2015年 SCHT. All rights reserved.
//

#import "SearchResultViewController.h"
#import "MainHeader.h"
@interface SearchResultViewController ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>
{
    UITableView *_tableView;
    UIImageView *_companyView;
    UILabel *_companyNameLabel;
    
    NSArray *_resultArray;
    
    UIWebView *_webview;
    UIView *titleView ;
    NSMutableArray *_urlArray;
}
@end

@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"查询结果";
    self.view.backgroundColor = [UIColor whiteColor];
    [self configNavgationBar];
    [self configHtmlView];
    _urlArray = [NSMutableArray array];
//    [self configSubview];
//
//    if ([_jsonDic objectForKey:@"resultStr"]) {
//        [self configHtmlView];
//    }
//    else {
//        [self configTableview];
//        [self parseJson];
//    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
}
- (void)parseJson
{
    if (_jsonDic) {
        _resultArray = [_jsonDic objectForKey:@"data"];
    }
}

- (void)configHtmlView
{
    _webview = [[UIWebView alloc]initWithFrame:CGRectMake(0,-64-5, self.view.frame.size.width, self.view.frame.size.height+130)];
    _webview.scrollView.bounces=NO;
    titleView.backgroundColor = [UIColor whiteColor];
    _webview.delegate = self;
//    NSURL *url = [NSURL URLWithString:[_jsonDic objectForKey:@"resultStr"]];
//    NSURLRequest *request  = [NSURLRequest requestWithURL:url];
    
    NSURL *requesrUrl = [NSURL URLWithString:[_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request  = [NSURLRequest requestWithURL:requesrUrl];
    [self.view addSubview:_webview];

    [_webview loadRequest:request];
    
    
//    NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=self.view.frame.size.width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\""];
//    [_webview stringByEvaluatingJavaScriptFromString:meta];
}

#pragma mark -- WebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *url = request.URL.absoluteString;
    NSRange range = [url rangeOfString:@"kuaidi"];
    NSRange range1 = [url rangeOfString:@"u.momzs"];
    NSRange range2 = [url rangeOfString:@"ads"];
    NSRange range3 = [url rangeOfString:@"about:blank"];
    NSRange range4 = [url rangeOfString:@"tel:"];
    
    if (range4.length != 0) {
        return YES;
    }
    if (range.length != 0 && range1.length == 0 && range2.length == 0 && range3.length == 0) {
        [_urlArray addObject:url];
        return YES;
    }else{
        return NO;
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
//                NSString *js = @"alert(\"没积分,你对换个大JB啊\");";
//                NSString *souseCode =[_webview stringByEvaluatingJavaScriptFromString:js];
//                NSLog(@"网页源代码：%@",souseCode);
//                [_webview stringByEvaluatingJavaScriptFromString:js];
//    NSString *js = @"var d = document.getElementByClassName(\"footer-docs smart-footer\");window.onload=function(){d.parentNode.removeChild(d);}";
    
//    NSString *js =@"jQuery(document).ready(function($) { $('.ui-footer-fixed').hidden();});";
//    NSString *js =@"var d = document.getElementByClassName(\"footer-docs\");var ele1 = d[0];alert(ele1);ele1.innerHTML = \"222345678\";";
    NSString *js =@"var d = document.getElementByClassName(\"footer-docs\");var ele1 = d[0];ele1.innerHTML = \"222345678\";alert(ele1);";
    
    [_webview stringByEvaluatingJavaScriptFromString:js];
}




/*
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //is js insert
    if (![[_webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"typeof window.%@ == 'object'", kBridgeName]] isEqualToString:@"true"]) {
        //get class method dynamically
        unsigned int methodCount = 0;
        Method *methods = class_copyMethodList([self class], &methodCount);
        NSMutableString *methodList = [NSMutableString string];
        for (int i=0; i<methodCount; i++) {
            NSString *methodName = [NSString stringWithCString:sel_getName(method_getName(methods[i])) encoding:NSUTF8StringEncoding];
            [methodList appendString:@"\""];
            [methodList appendString:[methodName stringByReplacingOccurrencesOfString:@":" withString:@""]];
            [methodList appendString:@"\","];
        }
        if (methodList.length>0) {
            [methodList deleteCharactersInRange:NSMakeRange(methodList.length-1, 1)];
        }
        
        NSBundle *bundle = _resourceBundle ? _resourceBundle : [NSBundle mainBundle];
        NSString *filePath = [bundle pathForResource:@"WebViewJsBridge" ofType:@"js"];
        NSString *js = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:js, methodList]];
    }
    
    __strong typeof(_webViewDelegate) strongDelegate = _webViewDelegate;
    if (strongDelegate && [strongDelegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [strongDelegate webViewDidFinishLoad:webView];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (webView != _webView) { return YES; }
    NSURL *url = [request URL];
    __strong typeof(_webViewDelegate) strongDelegate = _webViewDelegate;
    
    NSString *requestString = [[request URL] absoluteString];
    if ([requestString hasPrefix:kCustomProtocolScheme]) {
        NSArray *components = [[url absoluteString] componentsSeparatedByString:@":"];
        
        NSString *function = (NSString*)[components objectAtIndex:1];
        NSString *argsAsString = [(NSString*)[components objectAtIndex:2]
                                  stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSData *argsData = [argsAsString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *argsDic = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:argsData options:kNilOptions error:NULL];
        //convert js array to objc array
        NSMutableArray *args = [NSMutableArray array];
        for (int i=0; i<[argsDic count]; i++) {
            [args addObject:[argsDic objectForKey:[NSString stringWithFormat:@"%d", i]]];
        }
        //ignore warning
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        SEL selector = NSSelectorFromString([args count]>0?[function stringByAppendingString:@":"]:function);
        if ([self respondsToSelector:selector]) {
            [self performSelector:selector withObject:args];
        }
        return NO;
    } else if (strongDelegate && [strongDelegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        return [strongDelegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    } else {
        return YES;
    }
}
*/

- (void)configTableview
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.mas_equalTo(45);
        make.bottom.equalTo(self.view);
    }];
}

- (void)configSubview
{
    
    titleView = [[UIView alloc]init];
    titleView.backgroundColor = _tableView.backgroundColor;
    [self.view addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.top.mas_equalTo(64);
        make.height.mas_equalTo(80);
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = [_jsonDic objectForKey:@"company"];
    titleLabel.font = [UIFont systemFontOfSize:18];
    [titleView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(100);
        make.top.mas_equalTo(5);
        make.height.mas_equalTo(40);
        make.right.mas_equalTo(0);
    }];
    
    UILabel *numberLabel = [[UILabel alloc]init];
    numberLabel.text = [_jsonDic objectForKey:@"expCode"];
    numberLabel.font = [UIFont systemFontOfSize:16];
    [titleView addSubview:numberLabel];
    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(100);
        make.top.mas_equalTo(40);
        make.height.mas_equalTo(40);
        make.right.mas_equalTo(0);
    }];
    
    UIImageView *titleImageView =[[UIImageView alloc]init];
    [titleView addSubview:titleImageView];
    titleImageView.image = [UIImage imageNamed:[_jsonDic objectForKey:@"nameWord"]];
    if (!titleImageView.image) {
        titleImageView.image = [UIImage imageNamed:@"no_company.jpg"];
    }
    [titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.mas_equalTo(10);
        make.height.and.width.mas_equalTo(60);
    }];

}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _resultArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"ResultCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    for (UIView *subview in cell.contentView.subviews)
    {
        [subview removeFromSuperview];
    }
    
    NSDictionary *dic = [_resultArray objectAtIndex:indexPath.row];
    NSLog(@"%@",[dic objectForKey:@"context"]);
    UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(80, 0, 20, 60)];
    if(indexPath.row==_resultArray.count-1) {
        imageView.image = [UIImage imageNamed:@"status_start"];
    }
    else if (indexPath.row == 0) {
        imageView.image = [UIImage imageNamed:@"status_end"];
    }
    else {
        imageView.image = [UIImage imageNamed:@"status_moving"];
    }
    
    [cell.contentView addSubview:imageView];
    
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 90, 60)];
    timeLabel.text = [dic objectForKey:@"time"];
    timeLabel.numberOfLines = 2;
    timeLabel.font = [UIFont systemFontOfSize:12];
    timeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    timeLabel.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:timeLabel];
    
    
    UILabel *contextLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, 220, 60)];
    contextLabel.numberOfLines = 2;
    contextLabel.lineBreakMode = NSLineBreakByCharWrapping;
    contextLabel.text = [dic objectForKey:@"context"];
    contextLabel.font = [UIFont systemFontOfSize:12];
    [cell.contentView addSubview:contextLabel];

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



#pragma mark - navBar
- (void)configNavgationBar {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 60)];
    label.textColor = [UIColor whiteColor];
    label.text = @"查询结果";
    label.textAlignment = 1;
    self.navigationItem.titleView = label;
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(backToMenuView)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

- (void)backToMenuView
{
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
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
