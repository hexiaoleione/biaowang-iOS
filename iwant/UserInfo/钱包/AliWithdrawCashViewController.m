//
//  AliWithdrawCashViewController.m
//  e发快递员
//
//  Created by pro on 15/12/25.
//  Copyright © 2015年 pro. All rights reserved.
//
#import "AliWithdrawCashViewController.h"
#import "SVProgressHUD.h"
#import "RequestManager.h"
#import "UserManager.h"
#import "WalletViewController.h"
#import "myBlance.h"
#import "MTTouchIdTool.h"
#import "enterPwdView.h"
#import "MyMD5.h"
#import "LDInputView.h"
#import "FindPwdNameViewController.h"
#import "MoneyRuleWebVC.h" //提现规则说明的webView

#define WINDOW_WIDTH    [[UIScreen mainScreen] bounds].size.width
#define WINDOW_HEIGHT   [[UIScreen mainScreen] bounds].size.height

#define COLOR_LIGHT_BLUE    [UIColor colorWithRed:0 green:161.0/225.0 blue:212.0/225.0 alpha:1]
#define BACKGROUND_COLOR            [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0]

@interface AliWithdrawCashViewController ()<UITextFieldDelegate,enterPwdViewDeleget>
{
    //提现
    UILabel      *_ali_NumeberLabel;
    UILabel      *_ali_NameLabel;
    UILabel      *_ali_MoneyLabel;
    UILabel      *_shenhe_MoneyLabel;//正在审核资金
    NSString     *_waitMoney;//审核资金
    
    UILabel *_withdrawableMoney;
    
    UITextField  *_ali_NumberField;
    UITextField  *_ali_NameTextField;
    UITextField *_aliMoneyTextFiled;
    UIButton     *_ali_MakeSureBtn;
    NSString *_firstPassWord;//第一次输入的密码，可以是设置密码第一次，也可以是转账的时候输入的
    
}
@property (strong, nonatomic)  enterPwdView *passWordView;
@property (nonatomic, strong) NSArray *dataArray;


@end

@implementation AliWithdrawCashViewController
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loaddata];
    [self NavgationBar];
    [self configGetView];
    /*
    if (![UserManager getDefaultUser].payPassword || [[UserManager getDefaultUser].payPassword  isEqualToString:@""]) {
        [self showPassWord:@"第一次使用请设置您的转账提现密码"];
    }
     */
//    [self showPassWord:@"第一次使用请设置转账密码"];
        [self fillFiled];

}

- (void)fillFiled{
    [SVProgressHUD show];
    [RequestManager getWithDrawDefaultWithUserId:[UserManager getDefaultUser].userId
                                         success:^(NSDictionary *result) {
                                             [SVProgressHUD dismiss];
                                             _ali_NameTextField .text= result[@"aliPayNickName"];
                                             _ali_NumberField .text= result[@"aliPayAccount"];
                                         } Failed:^(NSString *error) {
                                             [SVProgressHUD showErrorWithStatus:error];
                                         }];
}

-(void)loaddata
{
    [RequestManager GetAliWithdrawMoneyWithuserId:[UserManager getDefaultUser].userId Success:^(id object)
     {
         
         myBlance *model =object;
         if (model.withdrawableMoney.doubleValue == 0) {
             _withdrawableMoney.text = @"0";
         }else{
             _withdrawableMoney.text = [NSString stringWithFormat:@"%0.2lf",[model.withdrawableMoney doubleValue]];
         }
         if (model.waitMoney.doubleValue == 0) {
             _shenhe_MoneyLabel.text =[NSString stringWithFormat:@"正在审核资金：0"];
         }else{
             _shenhe_MoneyLabel.text = [NSString stringWithFormat:@"正在审核资金：%0.2lf",[model.waitMoney doubleValue]];
         }
     }
     
    Failed:^(NSString *error) {
        
     }];
}

#pragma mark -- 提现
- (void)configGetView{
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,  WINDOW_WIDTH, WINDOW_HEIGHT *0.2)];
    headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headView];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10, WINDOW_HEIGHT *0.2, WINDOW_WIDTH-20, 0.5)];
    [line setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:line];
    
    //可提现钱数
    UILabel *balanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, WINDOW_WIDTH, 30)];
    balanceLabel.text = @"可提现余额（元）";
    balanceLabel.textColor = [UIColor blackColor];
    balanceLabel.font = [UIFont systemFontOfSize:15];
    balanceLabel.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:balanceLabel];
    
    
    //可提现money
    _withdrawableMoney =[[UILabel alloc]initWithFrame:CGRectMake(0, 30, WINDOW_WIDTH, WINDOW_HEIGHT *0.15)];
   _withdrawableMoney.text = @"0";
    _withdrawableMoney.textColor = [UIColor redColor];
    _withdrawableMoney.font = [UIFont systemFontOfSize:30];
    _withdrawableMoney.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:_withdrawableMoney];
   
    //正在审核资金：100
    _shenhe_MoneyLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, headView.bottom-40, SCREEN_WIDTH-20, 20)];
    _shenhe_MoneyLabel.textAlignment = NSTextAlignmentRight;
    if (SCREEN_WIDTH == 320) {
        _shenhe_MoneyLabel.y = headView.bottom-20;
        _shenhe_MoneyLabel.font = [UIFont systemFontOfSize:11];
    }else{
        _shenhe_MoneyLabel.font = [UIFont systemFontOfSize:12];
    }
    _shenhe_MoneyLabel.textColor = [UIColor grayColor];
    [headView addSubview:_shenhe_MoneyLabel];
    
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, headView.bottom-20, SCREEN_WIDTH-20, 20)];
    label.textColor = [UIColor redColor];
    label.font = FONT(12, NO);
    label.text = @"可提现金额:平台上获取的收入,其余金额只能在平台内消费。";
    [headView addSubview:label];
    
    _ali_NameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, WINDOW_HEIGHT *0.25, WINDOW_WIDTH  * 0.3, WINDOW_HEIGHT *0.07)];
    _ali_NameLabel.text = @"支付宝昵称";
    [_ali_NameLabel setFont:[UIFont fontWithName:@"ArialMT" size:14.0]];
    
    _ali_NumeberLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, WINDOW_HEIGHT *0.35, WINDOW_WIDTH, WINDOW_HEIGHT *0.07)];
    _ali_NumeberLabel.text = @"支付宝账号    ";
    [_ali_NumeberLabel setFont:[UIFont fontWithName:@"ArialMT" size:14.0]];
    
    _ali_MoneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, WINDOW_HEIGHT *0.45, WINDOW_WIDTH  * 0.3, WINDOW_HEIGHT *0.07)];
    _ali_MoneyLabel.text = @"提现金额";
    [_ali_MoneyLabel setFont:[UIFont fontWithName:@"ArialMT" size:14.0]];
    
    [self.view addSubview:_ali_NameLabel];
    [self.view addSubview:_ali_NumeberLabel];
    [self.view addSubview:_ali_MoneyLabel];
    
    
    // 支付宝昵称
    _ali_NameTextField = [[UITextField alloc]initWithFrame:CGRectMake(WINDOW_WIDTH  * 0.3, WINDOW_HEIGHT *0.25, WINDOW_WIDTH  * 0.65, WINDOW_HEIGHT *0.07)];
    _ali_NameTextField.delegate = self;
    _ali_NameTextField.placeholder = @"请输入支付宝昵称";
    _ali_NameTextField.borderStyle = UITextBorderStyleRoundedRect;
    
    _ali_NameTextField.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:_ali_NameTextField];
    
    
    
    //支付宝账号输入框
    _ali_NumberField = [[UITextField alloc]initWithFrame:CGRectMake(WINDOW_WIDTH  * 0.3, WINDOW_HEIGHT *0.35, WINDOW_WIDTH  * 0.65, WINDOW_HEIGHT *0.07)];
    _ali_NumberField.delegate = self;
    _ali_NumberField.placeholder = @"请输入支付宝账号";
    _ali_NumberField.borderStyle = UITextBorderStyleRoundedRect;
    
    _ali_NumberField.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:_ali_NumberField];
    
    //提现金额 输入框
    _aliMoneyTextFiled = [[UITextField alloc]initWithFrame:CGRectMake(WINDOW_WIDTH  * 0.3, WINDOW_HEIGHT *0.45, WINDOW_WIDTH  * 0.65, WINDOW_HEIGHT *0.07)];
    _aliMoneyTextFiled.textAlignment = NSTextAlignmentRight;
    _aliMoneyTextFiled.placeholder = @"请输入提现金额";
    _aliMoneyTextFiled.borderStyle = UITextBorderStyleRoundedRect;
    _aliMoneyTextFiled.keyboardType = UIKeyboardTypeDecimalPad;
    _aliMoneyTextFiled.delegate = self;
    [self.view addSubview:_aliMoneyTextFiled];
    
    
    //提现申请
    _ali_MakeSureBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, WINDOW_HEIGHT * 0.6, WINDOW_WIDTH/2, WINDOW_HEIGHT *0.07)];
    _ali_MakeSureBtn.centerX = WINDOW_WIDTH/2;
    _ali_MakeSureBtn.layer.borderColor =COLOR_MainColor.CGColor;
    _ali_MakeSureBtn.layer.borderWidth = 1.0f;
    _ali_MakeSureBtn.backgroundColor = COLOR_MainColor;
    _ali_MakeSureBtn.layer.cornerRadius = 5;
    [_ali_MakeSureBtn setTitle:@"提现申请" forState:UIControlStateNormal];
    [_ali_MakeSureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_ali_MakeSureBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_ali_MakeSureBtn];
}

//提现
-(void)submit{
    
    if ([_ali_NameTextField.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请填写支付宝昵称" ];
        return;
    }
    if ([_ali_NumberField.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请填写支付宝账号" ];
        return;
    }
    if ([_aliMoneyTextFiled.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"提现金额不能为空" ];
        return;
    }
    else if(_aliMoneyTextFiled.text.doubleValue <= 0  )
    {
        [SVProgressHUD showErrorWithStatus:@"提现金额不能小于零" ];
        return;
    }
    else if(_aliMoneyTextFiled.text.doubleValue >_withdrawableMoney.text.doubleValue)
    {
        [SVProgressHUD showErrorWithStatus:@"您没有这么多可提现哦" ];
        return;
    }
    
    //调取Touch ID
      [self clickTouchID];
}
//调取Touch ID

- (void)clickTouchID
{
    [[MTTouchIdTool sharedInstance]evaluatePolicy:@"请验证已有指纹" fallbackTitle:@"输入密码" SuccesResult:^{
        NSLog(@"验证成功");
        [self transfer];
    }
    FailureResult:^(LAError result) {
        switch (result) {
            case LAErrorSystemCancel:
            {
                NSLog(@"切换到其他APP");

                break;
            }
            case LAErrorUserCancel:
            {
                NSLog(@"用户取消验证Touch ID");
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"确认要取消转账吗？" delegate:self cancelButtonTitle:@"输入密码" otherButtonTitles:@"确定", nil];
                alert.tag = 10;
                [alert show];
                
                break;
            }
            case LAErrorTouchIDNotEnrolled:
            {
                

                NSLog(@"TouchID is not enrolled");
                [self showPassWord:nil];
                break;
            }
            case LAErrorUserFallback:
            {
                NSLog(@"TouchID is not enrolled");
                [self showPassWord:nil];

                NSLog(@"用户选择输入密码");
                
                break;
            }
            default:
            {
                NSLog(@"TouchID is not enrolled");
                [self showPassWord:nil];
                NSLog(@"其他情况");
                
                break;
            }
                
        }
    }];
}

- (void)transfer{
    [SVProgressHUD showWithStatus:@"正在提现..."];
    
    [RequestManager AliWithdrawCashWithuserId:[UserManager getDefaultUser].userId applyMoney:_aliMoneyTextFiled.text aliPayNickName:_ali_NameTextField.text aliPayAccount:_ali_NumberField.text Success:^(id object) {
        
        [SVProgressHUD dismiss];
        
//     //提示提现的天数和收取得手续费
        NSString * message = [object valueForKey:@"message"];
        [PXAlertView showAlertWithTitle:@"温馨提示" message:message cancelTitle:@"确定" completion:nil];
        
        [ self .navigationController popViewControllerAnimated: YES ];

    } Failed:^(NSString *error) {
        
        [SVProgressHUD showErrorWithStatus:error];
    }];
}


- (void)showPassWord:(NSString *)title{
    
    
    if (![UserManager getDefaultUser].payPassword || [[UserManager getDefaultUser].payPassword  isEqualToString:@""]) {
        LDInputView *view = [[LDInputView alloc]initWithSettingTitle:@"第一次使用请设置您的转账提现密码" frame:self.view.bounds];
        view.settingPassWordBlock = ^(NSString *pwd){
            [SVProgressHUD show];
            [RequestManager SavepaypasswordWithuserId:[UserManager getDefaultUser].userId payPassword:pwd deviceId:nil success:^(NSString *reslut) {
                [SVProgressHUD showSuccessWithStatus:@"密码设置成功"];
            } Failed:^(NSString *error) {
                [SVProgressHUD showErrorWithStatus:error];
            } ];
        };
        [self.view addSubview:view];
        return;
    }

    
    
    LDInputView *pwdView = [[LDInputView alloc]initWithTitle:@"请输入密码" frame:self.view.bounds];
    __weak LDInputView *weakpwdView = pwdView;
    pwdView.passWordBlock = ^(NSString *pwd){
        //重置密码
        if (pwd == nil) {
            FindPwdNameViewController *findVC = [[FindPwdNameViewController alloc]init];
            [self.navigationController pushViewController:findVC animated:YES];
            return ;
        }
        if ([[MyMD5 md5:pwd] isEqualToString:[UserManager getDefaultUser].payPassword]) {
            [self transfer];
            [weakpwdView removeFromSuperview];
        }else{
            [SVProgressHUD showErrorWithStatus:@"输入的密码有误"];
        }
    };
    [self.view addSubview:pwdView];

//    _passWordView = [[enterPwdView alloc]initWithFrame:self.view.bounds];
//    if (![UserManager getDefaultUser].payPassword || [[UserManager getDefaultUser].payPassword  isEqualToString:@""]) {
//        title = @"第一次使用请设置您的转账提现密码";
//    }
//    if (title) {
//        [_passWordView titleName:title withMoneyText:nil];
//    }
//    _passWordView.deleget = self;
//    [self.view addSubview:_passWordView];
}

#pragma mark - passworddelegate
-(void)NetWorkingPost:(NSString *)pwd{
    NSLog(@"输入的密码为%@",pwd );
    if (pwd.length<6) {
        return;
    }
    //已经存有密码
    if ([UserManager getDefaultUser].payPassword && ![[UserManager getDefaultUser].payPassword isEqualToString:@""] ) {
        if ([[MyMD5 md5:pwd] isEqualToString:[UserManager getDefaultUser].payPassword]) {
            [_passWordView clearPwd];
            [_passWordView removeEnterView];
            [self transfer];
        }else{
            [_passWordView clearPwd];
            [SVProgressHUD showErrorWithStatus:@"密码不正确，请重新输入"];
        }
    }
    //没有密码设置密码
    else{
        [_passWordView titleName:@"请验证您输入的密码" withMoneyText:nil];
        //第一次，把密码存起来
        if (!_firstPassWord) {
            _firstPassWord = pwd;
            [_passWordView clearPwd];
        }
        //第二次，对比密码
        else{
            if (pwd == _firstPassWord) {
                //验证成功
                [SVProgressHUD show];
                _firstPassWord = nil;
                [RequestManager SavepaypasswordWithuserId:[UserManager getDefaultUser].userId
                                              payPassword:pwd
                                                 deviceId:nil
                                                  success:^(NSString *reslut) {
                                                      [SVProgressHUD showSuccessWithStatus:@"密码设置成功"];
                                                      [_passWordView clearPwd];
                                                      [_passWordView removeEnterView];
                                                  } Failed:^(NSString *error) {
                                                      [SVProgressHUD showErrorWithStatus:error];
                                                      [_passWordView clearPwd];
                                                      [_passWordView titleName:@"请重新设置密码" withMoneyText:nil];
                                                      _firstPassWord = nil;
                                                  }];

            }else{
                _firstPassWord = nil;
                [SVProgressHUD showErrorWithStatus:@"您两次输入的密码不一致，请重新设置提现转账密码"];
                [_passWordView clearPwd];
                [_passWordView titleName:@"第一次使用请设置您的转账提现密码" withMoneyText:nil];
                _firstPassWord =nil;
            }
        }
    }
}


#pragma mark -- alertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 1) {
        if (buttonIndex == 1) {
            
            NSLog(@"点击了取消按钮");
        }
        else {
            
            NSLog(@"点击了确定按钮");
            [ self .navigationController popToRootViewControllerAnimated: YES ];  //返回根控制器,即最开始的页面
        }
    }
    if (alertView.tag == 2) {
        if (buttonIndex == 1) {
            NSLog(@"点击了取消按钮");
        }
        else {
            NSLog(@"点击了确定按钮");
        }
    }
    
    else if (alertView.tag == 10){
        
        if (buttonIndex == 1) {
            NSLog(@"点击了取消按钮");
        }
        else {
            NSLog(@"点击了确定按钮");
            [self showPassWord:nil];
        }
    }
}

#pragma mark - bar
- (void)NavgationBar {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 60)];
    label.textColor = [UIColor whiteColor];
    label.text = @"支付宝提现";
    label.textAlignment = 1;
    self.navigationItem.titleView = label;
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(backToMenuView)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Question"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(goToRule)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;

}

- (void)backToMenuView
{
    //[self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)goToRule{
    NSLog(@"规则说明页面");
    MoneyRuleWebVC * webVc =[[MoneyRuleWebVC alloc]init];
    [self.navigationController pushViewController:webVc animated:YES];
}

//点击return 按钮 去掉
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
//触摸背景，关闭键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    UIView *view =(UIView *)[touch view];
    
    if (view == self.view) {
        
        [self.view endEditing:YES];
        
    }
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
