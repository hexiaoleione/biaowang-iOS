//
//  CompanyRoleFirstViewController.m
//  iwant
//
//  Created by dongba on 16/9/6.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "CompanyRoleFirstViewController.h"
#import "YMHeaderView.h"
#import "LabelAndFieldView.h"
#import "LogistCompanyViewController.h"
@interface CompanyRoleFirstViewController ()<YMHeaderViewDelegate>{
    UIScrollView *_scrollView;
    LogistCompanyViewController *_netxVC;
    NSString *_url;
    NSString *_cityCode;
    NSString *_lon;
    NSString *_lat;
    YMHeaderView *imageView;
}

@property (strong, nonatomic)  LabelAndFieldView *conmpanyNameView;
@property (strong, nonatomic)  LabelAndFieldView *addressView;
@property (strong, nonatomic)  LabelAndFieldView *phoneView;
@property (strong, nonatomic)  LabelAndFieldView *numberView;


@property (strong, nonatomic)  LabelAndFieldView *lawerNameView;
@property (strong, nonatomic)  LabelAndFieldView *lawerIdCard;



@end

@implementation CompanyRoleFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCostomeTitle:@"物流公司注册"];
    [self configSubViews];
    [self addNextView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_isRegist) {
        _netxVC.isRegist = YES;
    }
}

- (void)configSubViews{
    
    _scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    _scrollView.contentSize = CGSizeMake(WINDOW_WIDTH, WINDOW_HEIGHT);
    if (WINDOW_HEIGHT <= 568) {
        _scrollView.contentSize = CGSizeMake(WINDOW_WIDTH, 670.0);

    }
    [self.view addSubview:_scrollView];
    
    imageView = [[YMHeaderView alloc]initWithFrame:CGRectMake(0, 0, 150, 150)];
    imageView.delagate = self;
    imageView.image = [UIImage imageNamed:@"companylogo"];
    imageView.layer.cornerRadius = 5;
    imageView.centerX = _scrollView.centerX;
    imageView.top = 30;
    [_scrollView addSubview:imageView];
    
    UILabel *driverLabel = [self creatLabel:@"请上传照片"];
    [driverLabel sizeToFit];
    driverLabel.top = imageView.bottom + 10;
    driverLabel.centerX = _scrollView.centerX;
    
    [_scrollView addSubview:driverLabel];
    
    _conmpanyNameView = [[[NSBundle mainBundle] loadNibNamed:@"LabelAndField" owner:nil options:nil] lastObject];
    [_conmpanyNameView.name setAttributedText:[self creatLabelText:@"*公司名称："]];
    [_conmpanyNameView sizeToFit];
    _conmpanyNameView.top = driverLabel.bottom + 30;
    _conmpanyNameView.centerX = _scrollView.centerX;
    [_scrollView addSubview:_conmpanyNameView];
    
    _addressView = [[[NSBundle mainBundle] loadNibNamed:@"LabelAndField" owner:nil options:nil] lastObject];
    
    [_addressView.name setAttributedText:[self creatLabelText:@"*公司地址："]];
    [_addressView sizeToFit];
    
    _addressView.centerX = _scrollView.centerX;
    _addressView.top = _conmpanyNameView.bottom + 15;
    [_scrollView addSubview:_addressView];

    _phoneView = [[[NSBundle mainBundle] loadNibNamed:@"LabelAndField" owner:nil options:nil] lastObject];
    [_phoneView.name setAttributedText:[self creatLabelText:@"*手机号码："]];
    [_phoneView sizeToFit];
    _phoneView.centerX = _scrollView.centerX;
     _phoneView.top = _addressView.bottom + 15;
    _phoneView.contentField.keyboardType =UIKeyboardTypeNumberPad;
    [_scrollView addSubview:_phoneView];
    
    
    _numberView = [[[NSBundle mainBundle] loadNibNamed:@"LabelAndField" owner:nil options:nil] lastObject];
    [_numberView.name setAttributedText:[self creatLabelText:@"*证件号码："]];
    _numberView.contentField.placeholder =@"填写营业执照注册号或统一社会信用代码";
    [_numberView.contentField setValue:[UIFont systemFontOfSize:11] forKeyPath:@"_placeholderLabel.font"];
    [_numberView sizeToFit];
    _numberView.centerX = _scrollView.centerX;
    _numberView.top = _phoneView.bottom + 15;
    [_scrollView addSubview:_numberView];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"<<下一步>>" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(nextView:) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 10;
    btn.size = CGSizeMake(160, 35);
    btn.top = _numberView.bottom + 15;
    btn.centerX = _scrollView.centerX;
    [_scrollView addSubview:btn];
}

- (void)addNextView{
    __weak CompanyRoleFirstViewController *weakSelf = self;
    _netxVC = [[LogistCompanyViewController alloc]init];
    if (_isRegist) {
        _netxVC.isRegist = YES;
    }
    _netxVC.block = ^(UIButton *btn){
        switch (btn.tag) {
            case 1:{
                [weakSelf submit];
            }
               
                break;
            case 2:
            {
                [weakSelf beforeView:btn];
            }
                
                break;
            default:
                break;
        }
        
    };
    [self addChildViewController: _netxVC];
    _netxVC.view.x = WINDOW_WIDTH;
    [self.view addSubview:_netxVC.view];
    
}

- (void)nextView:(UIButton *)btn{
    if (_numberView.contentField.text.length !=18) {
        [SVProgressHUD showErrorWithStatus:@"请填写正确的营业执照注册号或统一社会信用代码"];
        return;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.view.width = WINDOW_WIDTH *2;
        self.view.x = -WINDOW_WIDTH;
    }];
    
}

- (void)beforeView:(UIButton *)btn{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.width = WINDOW_WIDTH;
        self.view.x = 0;
    }];
}
//上传图片
- (void)headerView:(YMHeaderView *)headerView didSelectWithImage:(UIImage *)image{
    [SVProgressHUD show];
    NSDictionary *dic = @{k_USER_ID:[UserManager getDefaultUser].userId,k_FILE_NAME:@"公司logo.png"};
    NSDictionary *fileDic = @{@"data":image,@"fileName":@"公司logo.png"};
    [ExpressRequest sendWithParameters:dic MethodStr:@"file/company"
                               fileDic:fileDic
                               success:^(id object) {
                                   [SVProgressHUD showSuccessWithStatus:@"上传成功"];
                                   _url = [([object objectForKey:@"data"][0]) valueForKey:@"filePath"];
                                   
                               } failed:^(NSString *error) {
                                   imageView.image = [UIImage imageNamed:@"companylogo"];
                                   [SVProgressHUD showErrorWithStatus:error];
                               }];
}

- (void)submit{
    if (![self checkPrem]) {
        return;
    }
    [SVProgressHUD show];
    NSDictionary *dic = @{@"comLogoUrl":_url?_url:@"",
                          @"address":_addressView.contentField.text,
                          @"companyName":_conmpanyNameView.contentField.text,
                          @"bossName":@"",
                          @"bossPhone":_phoneView.contentField.text,
                          @"idCard":@"",
                          @"businessLicense":_numberView.contentField.text,
                          @"idCardOpenPath":_netxVC.idCardOpenPath,
                          @"idCardObversePath":_netxVC.idCardObversePath,
                          @"businessLicensePath":_netxVC.businessLicensePath,
                          @"userId":[UserManager getDefaultUser].userId};
    [ExpressRequest sendWithParameters:dic
                             MethodStr:@"logistics/register/company"
                               reqType:k_POST
                               success:^(id object) {
                                   
                                   if (_isRegist) {
                                       [self dismissViewControllerAnimated:YES completion:nil];
                                   }
                                   
                                   [self.navigationController popToRootViewControllerAnimated:YES];
                                   [SVProgressHUD showSuccessWithStatus:[object valueForKey:@"message"]];

                                   
                               } failed:^(NSString *error) {
                                   [SVProgressHUD showErrorWithStatus:error];
                               }];
}


- (UILabel *)creatLabel:(NSString *)text{
    UILabel *label  = [UILabel new];
        NSMutableAttributedString * str = [[NSMutableAttributedString alloc]initWithString:text attributes:@{NSKernAttributeName:@(0.)}];
        //设置某写字体的颜色
        //NSForegroundColorAttributeName 设置字体颜色
        NSRange blueRange = NSMakeRange([[str string] rangeOfString:@"*"].location, [[str string] rangeOfString:@"*"].length);
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:blueRange];
        [label setAttributedText:str];
    label.font = [UIFont systemFontOfSize:14];
    
    
    return label;
}

-(NSMutableAttributedString *)creatLabelText:(NSString *)text{
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc]initWithString:text attributes:@{NSKernAttributeName:@(0.)}];
    //设置某写字体的颜色
    //NSForegroundColorAttributeName 设置字体颜色
    NSRange blueRange = NSMakeRange([[str string] rangeOfString:@"*"].location, [[str string] rangeOfString:@"*"].length);
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:blueRange];
    return str;
}


- (BOOL)checkPrem{
    if (_conmpanyNameView.contentField.text.length == 0 ) {
        [SVProgressHUD showErrorWithStatus:@"请填写物流公司名称"];
        return NO;
    }
    if (_addressView.contentField.text.length == 0 ) {
        [SVProgressHUD showErrorWithStatus:@"请选择物流公司地址"];
        return NO;
    }
    if (_phoneView.contentField.text.length != 11 ) {
        [SVProgressHUD showErrorWithStatus:@"请填写正确的手机号码"];
        return NO;
    }
    if (_netxVC.idCardOpenPath.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请上传法人身份证正面"];
        return NO;
    }
    if (_netxVC.idCardObversePath.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请上传法人身份证反面"];
        return NO;
    }
    if (_netxVC.businessLicensePath.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请上传公司营业执照"];
        return NO;
    }

    return YES;
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
