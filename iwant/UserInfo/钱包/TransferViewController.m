//
//  TransferViewController.m
//  iwant
//
//  Created by pro on 16/4/4.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "TransferViewController.h"
#import "SVProgressHUD.h"
#import "RequestManager.h"
#import "UserManager.h"
#import "WalletViewController.h"
#import "myBlance.h"
#import "UIViewController+show.h"
#import "MTTouchIdTool.h"
#import "enterPwdView.h"
#import "MyMD5.h"
#import "LDInputView.h"
#import "FindPwdNameViewController.h"
#import "MoneyRuleWebVC.h"//提现规则说明的webView

#define WINDOW_WIDTH    [[UIScreen mainScreen] bounds].size.width
#define WINDOW_HEIGHT   [[UIScreen mainScreen] bounds].size.height

#define COLOR_LIGHT_BLUE    [UIColor colorWithRed:0 green:161.0/225.0 blue:212.0/225.0 alpha:1]
#define BACKGROUND_COLOR            [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0]

@interface TransferViewController ()<UITextFieldDelegate,enterPwdViewDeleget>

{
    
    //提现
    UILabel      *_PhoneNumeberLabel;
    UILabel      *_MoneyLabel;
    
    UILabel   *_TransferableMoney;
    
    UITextField  *_PhoneNumberField;
    UITextField  *_MoneyTextFiled;
    UIButton     *_ali_MakeSureBtn;
    
    UILabel      *_shenhe_MoneyLabel;//正在审核资金
    
    NSString *_firstPassWord;//第一次输入的密码，可以是设置密码第一次，也可以是转账的时候输入的

    
    
    
}

@property (strong, nonatomic)  enterPwdView *passWordView;

@end

@implementation TransferViewController

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loaddata];
    [self configNavgationBar];
    [self configGetView];
//    if (![UserManager getDefaultUser].payPassword || [[UserManager getDefaultUser].payPassword  isEqualToString:@""]) {
//        [self showPassWord:@"第一次使用请设置您的转账提现密码"];
//    }
    
    
//    if (![UserManager getDefaultUser].payPassword || [[UserManager getDefaultUser].payPassword  isEqualToString:@""]) {
//        LDInputView *view = [[LDInputView alloc]initWithSettingTitle:@"第一次使用请设置您的转账提现密码" frame:self.view.bounds];
//        view.settingPassWordBlock = ^(NSString *pwd){
//            [SVProgressHUD show];
//            [RequestManager SavepaypasswordWithuserId:[UserManager getDefaultUser].userId payPassword:pwd deviceId:nil success:^(NSString *reslut) {
//                [SVProgressHUD showSuccessWithStatus:@"密码设置成功"];
//            } Failed:^(NSString *error) {
//                [SVProgressHUD showErrorWithStatus:error];
//            } ];
//        };
//        [self.view addSubview:view];
//    }
    
//    [self showPassWord:@"第一次使用请设置体现转账密码"];

}

-(void)loaddata
{
    [RequestManager getTranfermoneyWithuserId:[UserManager getDefaultUser].userId Success:^(id object) {
        
        myBlance *model =object;
        
        if (model.transferableMoney.doubleValue == 0) {
             _TransferableMoney.text = @"0";
        }
     _TransferableMoney.text = [NSString stringWithFormat:@"%0.2lf",[model.transferableMoney doubleValue]];
        
        NSLog(@"+++++++++++++++++%@",model.transferableMoney);
        
        NSLog(@"===================%@",object);
        _shenhe_MoneyLabel.text = [NSString stringWithFormat:@"正在审核资金%0.2lf",[model.waitMoney doubleValue]];
        
    } Failed:^(NSString *error) {
        
    }];
}


- (void)configGetView{
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,  WINDOW_WIDTH, WINDOW_HEIGHT *0.2)];
    headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headView];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10, WINDOW_HEIGHT *0.2, WINDOW_WIDTH-20, 0.5)];
    [line setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:line];
    
    //可提现钱数
    UILabel *balanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, WINDOW_WIDTH, 30)];
    balanceLabel.text = @"可转账金额（元）";
    balanceLabel.textColor = [UIColor blackColor];
    balanceLabel.font = [UIFont systemFontOfSize:15];
    balanceLabel.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:balanceLabel];
    
    
    //可提现money
    _TransferableMoney =[[UILabel alloc]initWithFrame:CGRectMake(0, 40, WINDOW_WIDTH, WINDOW_HEIGHT *0.15)];
    _TransferableMoney.textColor = [UIColor redColor];
    _TransferableMoney.font = [UIFont systemFontOfSize:30];
    _TransferableMoney.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:_TransferableMoney];
    
    //正在审核资金：100
    _shenhe_MoneyLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, headView.bottom-30, SCREEN_WIDTH-20, 20)];
    _shenhe_MoneyLabel.textAlignment = NSTextAlignmentRight;
    if (SCREEN_WIDTH == 320) {
        _shenhe_MoneyLabel.y = headView.bottom-20;
        _shenhe_MoneyLabel.font = [UIFont systemFontOfSize:11];
    }else{
        _shenhe_MoneyLabel.font = [UIFont systemFontOfSize:12];
    }
    _shenhe_MoneyLabel.textColor = [UIColor grayColor];
    [headView addSubview:_shenhe_MoneyLabel];

    
    
    _PhoneNumeberLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, WINDOW_HEIGHT *0.25, WINDOW_WIDTH, WINDOW_HEIGHT *0.07)];
    _PhoneNumeberLabel.text = @"收款人手机号    ";
    [_PhoneNumeberLabel setFont:[UIFont fontWithName:@"ArialMT" size:13.0]];
    
    
    
    _MoneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, WINDOW_HEIGHT *0.35, WINDOW_WIDTH  * 0.3, WINDOW_HEIGHT *0.07)];
    _MoneyLabel.text = @"转账金额";
    [_MoneyLabel setFont:[UIFont fontWithName:@"ArialMT" size:13.0]];
    
    [self.view addSubview:_PhoneNumeberLabel];
    [self.view addSubview:_MoneyLabel];
    
    
    //收款人手机号输入框
    _PhoneNumberField = [[UITextField alloc]initWithFrame:CGRectMake(WINDOW_WIDTH  * 0.3, WINDOW_HEIGHT *0.25, WINDOW_WIDTH  * 0.65, WINDOW_HEIGHT *0.07)];
    _PhoneNumberField.delegate = self;
    _PhoneNumberField.placeholder = @"请输入收款人手机号";
    _PhoneNumberField.borderStyle = UITextBorderStyleRoundedRect;
    
    _PhoneNumberField.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_PhoneNumberField];
    
    // btn
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(WINDOW_WIDTH  * 0.85, WINDOW_HEIGHT *0.25, WINDOW_WIDTH  * 0.1, WINDOW_HEIGHT *0.07)];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [rightBtn addTarget:self action:@selector(goToAddressBook) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setImage:[UIImage imageNamed:@"Fa_mailList"] forState:UIControlStateNormal];
    [self.view addSubview:rightBtn];

    
    
    
    //请输入转账金额 输入框
    _MoneyTextFiled = [[UITextField alloc]initWithFrame:CGRectMake(WINDOW_WIDTH  * 0.3, WINDOW_HEIGHT *0.35, WINDOW_WIDTH  * 0.65, WINDOW_HEIGHT *0.07)];
    _MoneyTextFiled.textAlignment = NSTextAlignmentLeft;
    _MoneyTextFiled.placeholder = @"请输入转账金额";
    _MoneyTextFiled.borderStyle = UITextBorderStyleRoundedRect;
    _MoneyTextFiled.keyboardType = UIKeyboardTypeDecimalPad;
    _MoneyTextFiled.delegate = self;
    [self.view addSubview:_MoneyTextFiled];
    
    //提现申请
    _ali_MakeSureBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, WINDOW_HEIGHT * 0.5, WINDOW_WIDTH/2, WINDOW_HEIGHT *0.07)];
    _ali_MakeSureBtn.centerX = WINDOW_WIDTH/2;
    _ali_MakeSureBtn.layer.borderColor =COLOR_MainColor.CGColor;
    _ali_MakeSureBtn.layer.borderWidth = 1.0f;
    _ali_MakeSureBtn.backgroundColor = COLOR_MainColor;
    _ali_MakeSureBtn.layer.cornerRadius = 10;
    [_ali_MakeSureBtn setTitle:@"确认转账" forState:UIControlStateNormal];
    [_ali_MakeSureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_ali_MakeSureBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_ali_MakeSureBtn];
}
#pragma mark- 联系人列表
- (void)goToAddressBook{
    //通讯录
    [Contacts judgeAddressBookPowerWithUIViewController:self contactsBlock:^(NSString *name, NSString *phoneNumber) {
       _PhoneNumberField.text = phoneNumber;
    }];
}
//转账
-(void)submit{
    
    if ([_PhoneNumberField.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请填写收款人手机号" ];
        return;
    }
    else if (_PhoneNumberField.text.length !=11)
    {
        [SVProgressHUD showErrorWithStatus:@"手机号格式不正确" ];

        return;
    }
    
    if ([_MoneyTextFiled.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"转账金额不能为空" ];
        return;
    }
    else if(_MoneyTextFiled.text.doubleValue <= 0  )
    {
        [SVProgressHUD showErrorWithStatus:@"转账金额不能为0" ];
        return;
    }
    else if(_MoneyTextFiled.text.doubleValue >_TransferableMoney.text.doubleValue)
    {
        [SVProgressHUD showErrorWithStatus:@"您没有这么多可转账哦" ];
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
                                                
                                                NSLog(@"用户选择输入密码");
                                                [self showPassWord:nil];
                                                break;
                                                
                                            }
                                            case LAErrorTouchIDNotAvailable:
                                            {
                                                
                                                NSLog(@"设备不支持");
                                                [self showPassWord:nil];
                                                break;
                                            }
                                                
                                            default:
                                            {
                                                [self showPassWord:nil];
                                                NSLog(@"其他情况");
                                                
                                                break;
                                            }
                                                
                                        }
                                    }];
}

- (void)transfer{
    [SVProgressHUD showWithStatus:@"正在转账..."];
    
    [RequestManager TransferWithuserId:[UserManager getDefaultUser].userId mobileTo:_PhoneNumberField.text tradeMoney:_MoneyTextFiled.text  Success:^(id object) {
        
        [SVProgressHUD dismiss];
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示"message:@"转账成功"  delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        
        [alert setTag:1];
        
        // 显示
        
        [alert show];
        
    } Failed:^(NSString *error) {
        
        //        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示"message:error  delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];李冬勃
        //
        //                [alert setTag:2];
        //
        //                // 显示
        //
        //                [alert show];
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
        if (pwd == nil) {
            FindPwdNameViewController *findVC = [[FindPwdNameViewController alloc]init];
            [self.navigationController pushViewController:findVC animated:YES];
            return ;
        }
        if ([[MyMD5 md5:pwd] isEqualToString:[UserManager getDefaultUser].payPassword]) {
            [self transfer];
            [weakpwdView removeFromSuperview];
        }else{
            [SVProgressHUD showErrorWithStatus:@"密码输入有误"];
        }
    };
    [self.view addSubview:pwdView];
//     _passWordView = [[enterPwdView alloc]initWithFrame:self.view.bounds];
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
    if (pwd.length<6) {
        return;
    }
    //已经存有密码
    if ([UserManager getDefaultUser].payPassword && ![[UserManager getDefaultUser].payPassword isEqualToString:@""] ) {
        if ([[MyMD5 md5:pwd]isEqualToString:[UserManager getDefaultUser].payPassword]) {
            [_passWordView  clearPwd];
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
                [SVProgressHUD showErrorWithStatus:@"您两次输入的密码不一致，请重新设置体现转账密码"];
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



- (void)configNavgationBar {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 60)];
    label.textColor = [UIColor whiteColor];
    label.text = @"转账";
    label.textAlignment = 1;
    self.navigationItem.titleView = label;
    self.view.backgroundColor = [UIColor whiteColor];
    
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
-(void)goToRule{
    NSLog(@"转账规则说明界面！");
    MoneyRuleWebVC * webVc =[[MoneyRuleWebVC alloc]init];
    [self.navigationController pushViewController:webVc animated:YES];
}
- (void)backToMenuView
{
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
