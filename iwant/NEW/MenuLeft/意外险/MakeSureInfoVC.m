//
//  MakeSureInfoVC.m
//  iwant
//
//  Created by 公司 on 2017/11/6.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "MakeSureInfoVC.h"
#import "EcoinWebViewController.h"
@interface MakeSureInfoVC ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *idCardTextField;

@end

@implementation MakeSureInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCostomeTitle:@"意外险"];
    self.view.backgroundColor = UIColorFromRGB(0xebebeb);
    [self configNavgationBtn];
    self.userNameTextField.text = [UserManager getDefaultUser].userName;
    self.idCardTextField.text = [UserManager getDefaultUser].idCard;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configNavgationBtn {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(shuoMing)
     forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 80, 30);
    [button setTitle:@"说明" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = menuButton;
}

-(void)shuoMing{
    EcoinWebViewController * vc = [[EcoinWebViewController alloc]init];
    vc.web_type = WEB_AccidentInsurance;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)sureBuyBtn:(UIButton *)sender {
    if (self.userNameTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请填写真实的姓名"];
        return;
    }
    if (self.idCardTextField.text.length != 18) {
        [SVProgressHUD showErrorWithStatus:@"请填写正确的身份证号"];
        return;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"购买后保险将在5-7个工作日内生效，生效后开始扣费。" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *update = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString * urlStr =[NSString stringWithFormat:@"%@driver/driveSafe?userId=%@&ifBuyInsure=1&userName=%@&idCard=%@",BaseUrl,[UserManager getDefaultUser].userId,self.userNameTextField.text,self.idCardTextField.text];
        urlStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)urlStr, nil, nil, kCFStringEncodingUTF8));
        [SVProgressHUD show];
        [ExpressRequest sendWithParameters:nil MethodStr:urlStr reqType:k_GET success:^(id object) {
            [SVProgressHUD dismiss];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        } failed:^(NSString *error) {
            [SVProgressHUD showErrorWithStatus:error];
        }];
        
    }];
    [alert addAction:cancle];
    [alert addAction:update];
    [[Utils getCurrentVC] presentViewController:alert animated:YES completion:nil];
}


@end
