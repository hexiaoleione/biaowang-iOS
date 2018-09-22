//
//  SearchExpressViewController.m
//  Express
//
//  Created by 张宾 on 15/7/15.
//  Copyright (c) 2015年 SCHT. All rights reserved.
//

#import "SearchExpressViewController.h"
#import "ScanViewController.h"
#import "ExpressCViewController.h"
#import "SearchResultViewController.h"
#import "MainHeader.h"
#import "AFHTTPRequestOperation.h"

@interface SearchExpressViewController ()<UIWebViewDelegate,UITextFieldDelegate>
{
    NSString *_expCompanyCode;
    ExpCompany *expCompany;
}
@property(nonatomic,strong)UITextField *searchField;
@property(nonatomic,strong)UIButton *btnScan;
@property(nonatomic,strong)UIButton *btnSearch;
@property(nonatomic,strong)UIButton *btnCp;
@property(nonatomic,strong)UIImageView *imageLogo;
@property(nonatomic,strong)UITextField *cpField;
@property(nonatomic,strong)UITextField *codeField;

@property(nonatomic,strong)UIWebView *webView;
@end

@implementation SearchExpressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor  = [UIColor whiteColor];
//    self.title = @"快递跟踪查询";
    
    [self configNavgationBar];
    [self createUI];

    
    NSLog(@"~~~~~~~~~~%@,%@",self.str1,self.str2);
    
    [self create];
    

}
- (void)create
{
    _cpField.text = self.str2;
    
    _codeField.text = self.str1;
    

}
-(void)createUI{
    UIImage *image = [UIImage imageNamed:@"ribbit"];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(64);
        make.height.mas_equalTo(image.size.height);
        make.width.mas_equalTo(image.size.width);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];

    _cpField = [[UITextField alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_cpField];
    _cpField.layer.borderColor = [UIColor grayColor].CGColor;
    _cpField.layer.borderWidth = 1.0f;
    _cpField.layer.cornerRadius = 5;
    _cpField.placeholder = @"请选择快递公司";
    _cpField.delegate = self;
//    _cpField.enabled = NO;
    [_cpField mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(200);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo (40);
    }];
    _codeField = [[UITextField alloc] initWithFrame:CGRectZero];
    _codeField.placeholder = @"请输入快递单号";
    [self.view addSubview:_codeField];
    _codeField.layer.borderColor = [UIColor grayColor].CGColor;
    _codeField.layer.borderWidth = 1.0f;
    _codeField.layer.cornerRadius = 5;
    _codeField.delegate = self;
    [_codeField mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(260);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo (40);
    }];
    _btnCp = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_btnCp];
    _btnCp.layer.borderWidth = 0.5f;
    _btnCp.layer.borderColor = [UIColor colorWithRed:0.48 green:0.67 blue:0.42 alpha:1].CGColor;
    [_btnCp setTitle:@"公司" forState:UIControlStateNormal];
    [_btnCp setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_btnCp setImage:[UIImage imageNamed:@"chooseCar"] forState:UIControlStateNormal];
    [_btnCp setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    [_btnCp addTarget:self action:@selector(showCP:) forControlEvents:UIControlEventTouchUpInside];
    [_btnCp mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(200);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo (40);
    }];
    
    _btnScan = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_btnScan];
    _btnScan.layer.borderColor = [UIColor colorWithRed:0.48 green:0.67 blue:0.42 alpha:1].CGColor;
    _btnScan.layer.borderWidth = 0.5f;
    [_btnScan setTitle:@"扫描" forState:UIControlStateNormal];
    [_btnScan setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_btnScan setImage:[UIImage imageNamed:@"scanCode"] forState:UIControlStateNormal];
    [_btnScan setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    [_btnScan addTarget:self action:@selector(showCode:) forControlEvents:UIControlEventTouchUpInside];
    [_btnScan mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(260);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo (40);
    }];
    _btnSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_btnSearch];
//    _btnSearch.layer.borderColor = [COLOR_LIGHT_BLUE CGColor];
//    _btnSearch.layer.borderWidth = 1.0f;
    _btnSearch.titleLabel.textColor = [UIColor whiteColor];
//    [_btnSearch setBackgroundImage:[UIImage imageNamed:@"btn_normal"] forState:UIControlStateNormal];
//    [_btnSearch setBackgroundImage:[UIImage imageNamed:@"btn_highlight"] forState:UIControlStateHighlighted];
    _btnSearch.backgroundColor = COLOR_ORANGE_DEFOUT;
    _btnSearch.layer.cornerRadius = 5;
    [_btnSearch setTitle:@"查  询" forState:UIControlStateNormal];
    [_btnSearch addTarget:self action:@selector(checkExpress) forControlEvents:UIControlEventTouchUpInside];
    [_btnSearch mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(340);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo (50);
    }];
    
}
#pragma mark- UIBUTTON EVENT
//点击公司按钮   响应事件
-(void)showCP:(UIButton *)btn{
    ExpressCViewController *company = [[ExpressCViewController alloc] init];
    
    //block  反向传值
    company.returnCompanyBlock = ^(ExpCompany *company){
        NSLog(@"company %@",company.expName);
        _cpField.text = company.expName;
        _expCompanyCode = company.expCode;
        expCompany = company;
    };
    
    //跳转 push
    [self.navigationController pushViewController:company animated:YES];
}

//扫描按钮  跳转
-(void)showCode:(UIButton *)btn{
    ScanViewController *scanview= [[ScanViewController alloc] init];
    scanview.returnCodeBlock = ^(NSString* code){
        _codeField.text = code;
    };
    [self presentViewController:scanview animated:YES completion:^{}];
}

//查询的点击方法
- (void)checkExpress
{
    //http://api.kuaidi100.com/api?id=[]&com=[]&nu=[]&valicode=[]&show=[0|1|2|3]&muti=[0|1]&order=[desc|asc]
    //d58d480ad0726dfd
    //http://m.kuaidi100.com/index_all.html?type=[快递公司编码]&postid=[快递单号]&callbackurl=[点击"返回"跳转的地址]
    
    if ([_cpField.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请选择快递公司"];

        return;
    }
    if ([_codeField.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入单号"];
        return;
    }
    [self setWebView];
/*****************快递100老的接口******************************/
    
//    [SVProgressHUD showWithStatus:@"正在查询..."];
        
//    NSArray *otherArray = @[@"ems",@"emsguoji",@"shentong",@"shunfeng",@"youzhengguonei",@"youzhengguoji",@"yuantong",@"yunda",@"zhongtong"];
//    
//    for (NSString *object in otherArray)
//    {
//#warning expCompany做什么的？？？？
//        
//        if ([expCompany.nameWord isEqualToString:object]) {
//            
//            [self checkExpressMethodHtml];
//            
//            return;
//
//        }
//    }
//    
//    
//    [self checkExpressMethodJson];
/*******************************************************/
    
//    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
//    self.webView.delegate = self;
    
}
-(void)setWebView{
    SearchResultViewController *resultVC = [[SearchResultViewController alloc]init];
    resultVC.url = [NSString stringWithFormat:@"http://m.kuaidi100.com/index_all.html?type=%@&postid=%@",_cpField.text,_codeField.text];
    [self.navigationController pushViewController:resultVC animated:YES];
}

- (void)checkExpressMethodHtml
{
    [SVProgressHUD showWithStatus:@"请稍等..."];
    
    NSString *str=[NSString stringWithFormat:@"http://www.kuaidi100.com/applyurl?key=d58d480ad0726dfd&com=%@&nu=%@",expCompany.nameWord,_codeField.text];
    
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(responseObject)
        {
            NSString *resultStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            SearchResultViewController *resultVC = [[SearchResultViewController alloc]init];
            
            resultVC.jsonDic = [NSMutableDictionary dictionary];
            [resultVC.jsonDic setObject:_cpField.text forKey:@"company"];
            [resultVC.jsonDic setObject:expCompany.nameWord forKey:@"nameWord"];
            [resultVC.jsonDic setObject:_codeField.text forKey:@"expCode"];
            [resultVC.jsonDic setObject:resultStr forKey:@"resultStr"];
            
            [SVProgressHUD dismiss];
            [self.navigationController pushViewController:resultVC animated:YES];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"查询失败！"];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"查询失败！"];
        
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
}

- (void)checkExpressMethodJson
{
    [SVProgressHUD showWithStatus:@"请稍等..."];
    //    NSString *str=[NSString stringWithFormat:@"http://m.kuaidi100.com/index_all.html?type=%@&postid=%@&callbackurl=0",_expCompanyCode,_codeField.text];
    NSString *str=[NSString stringWithFormat:@"http://api.kuaidi100.com/api?id=d58d480ad0726dfd&com=%@&nu=%@&valicode=0&show=0&muti=1&order=desc",expCompany.nameWord,_codeField.text];
    
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *respondDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        /*
         //text code
         NSString *txtPath = [[NSBundle mainBundle]  pathForResource:@"jsonStr" ofType:@"txt"];
         //    将txt到string对象中，编码类型为NSUTF8StringEncoding
         NSData *data= [[NSData alloc]initWithContentsOfFile:txtPath];
         //    NSString *string = [[NSString  alloc] initWithContentsOfFile:txtPath encoding:NSUTF8StringEncoding error:nil];
         NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
         
         SearchResultViewController *resultVC = [[SearchResultViewController alloc]init];
         
         resultVC.jsonDic = [NSMutableDictionary dictionaryWithDictionary:dic];
         [resultVC.jsonDic setObject:_cpField.text forKey:@"company"];
         [resultVC.jsonDic setObject:expCompany.nameWord forKey:@"nameWord"];
         [resultVC.jsonDic setObject:_codeField.text forKey:@"expCode"];
         [self.navigationController pushViewController:resultVC animated:YES];
         return ;
         */
        if([[respondDic objectForKey:@"message"]isEqualToString:@"ok"])
        {
            SearchResultViewController *resultVC = [[SearchResultViewController alloc]init];
            resultVC.jsonDic = [NSMutableDictionary dictionaryWithDictionary:respondDic];
            [resultVC.jsonDic setObject:_cpField.text forKey:@"company"];
            [resultVC.jsonDic setObject:expCompany.nameWord forKey:@"nameWord"];
            [resultVC.jsonDic setObject:_codeField.text forKey:@"expCode"];
            
            [SVProgressHUD dismiss];
            [self.navigationController pushViewController:resultVC animated:YES];
            
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:[respondDic objectForKey:@"message"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"查询失败！"];
        
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.view addSubview:self.webView];
}

#pragma mark --text delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //点击return取消第一响应者  收回键盘
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _cpField) { //选择公司
        
        //取消第一响应者
        [textField resignFirstResponder];
        
        //调用公司按钮的方法
        [self showCP:nil];

    }
}

#pragma mark -- bar
- (void)configNavgationBar {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 60)];
    label.textColor = [UIColor whiteColor];
    label.text = @"快递跟踪查询";
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
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
