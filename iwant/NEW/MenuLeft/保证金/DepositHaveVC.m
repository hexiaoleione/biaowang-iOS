//
//  DepositHaveVC.m
//  iwant
//
//  Created by 公司 on 2017/9/20.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "DepositHaveVC.h"
#import "EcoinWebViewController.h"
@interface DepositHaveVC ()
@property (weak, nonatomic) IBOutlet UILabel *noticeL;
@property (weak, nonatomic) IBOutlet UILabel *moneyL;
@property (weak, nonatomic) IBOutlet UILabel *noticeTwo;


@property (weak, nonatomic) IBOutlet UILabel *AlNameL;
@property (weak, nonatomic) IBOutlet UILabel *phoneL;
@property (weak, nonatomic) IBOutlet UITextField *AlNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@end
// 镖师押金     0 默认      1    已充值    2  退款中   3  已退款

@implementation DepositHaveVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCostomeTitle:@"保证金"];
    [self initUI];
}

-(void)initUI{
    [self configNavgationBtn];
    if (self.status == 1) {
        self.noticeL.text = @"已交保证金";
        self.moneyL.text = [NSString stringWithFormat:@"¥%@元",self.money];
    }
    if (self.status == 2) {
        self.noticeL.text = @"退款中";
        self.btn.userInteractionEnabled = NO;
        self.moneyL.text = [NSString stringWithFormat:@"¥%@元",self.money];
        [self.btn setImage:[UIImage imageNamed:@"Ya_tuiZhong"] forState:UIControlStateNormal];
    }
}
- (void)configNavgationBtn {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(yajinShuoMing)
     forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 80, 30);
    [button setTitle:@"保证金说明" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = menuButton;
}

//保证金说明
-(void)yajinShuoMing{
    EcoinWebViewController * vc = [[EcoinWebViewController alloc]init];
    vc.web_type = WEB_Deposit;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)yajinShuoMing:(UIButton *)sender {
    EcoinWebViewController * vc = [[EcoinWebViewController alloc]init];
    vc.web_type = WEB_Deposit;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnClick:(UIButton *)sender {
        self.AlNameL.hidden = NO;
        self.AlNameTextField.hidden = NO;
        self.phoneL.hidden = NO;
        self.phoneTextField.hidden = NO;
        sender.hidden = YES;
        self.submitBtn.hidden = NO;
}

#pragma mark ---申请退款
- (IBAction)submitBtnClick:(UIButton *)sender {
    if (self.AlNameTextField.text.length == 0) {
      [SVProgressHUD showErrorWithStatus:@"请输入支付宝昵称"];
      return;
    }
    if (self.phoneTextField.text.length == 0) {
      [SVProgressHUD showErrorWithStatus:@"请输入支付宝账号"];
      return;
    }
    
    NSDictionary *dic = @{k_USER_ID:[UserManager getDefaultUser].userId,
                          K_applyMoney:self.money,
                          K_aliPayNickName:self.AlNameTextField.text,
                          K_aliPayAccount:self.phoneTextField.text};
    [SVProgressHUD show];
    [ExpressRequest sendWithParameters:dic MethodStr:@"driver/driverRefund" reqType:k_POST success:^(id object) {
        [SVProgressHUD dismiss];
        [self.navigationController popViewControllerAnimated:YES];
    } failed:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
}

-(void)creatUI{
    UILabel * labelOne = [[UILabel alloc]init];
    labelOne.textColor =[UIColor lightGrayColor];
    labelOne.text = @"保证金金额";
    [self.view addSubview:labelOne];
    
    UILabel * labelTwo = [[UILabel alloc]init];
    labelTwo.text =@"¥300元";
    labelTwo.font = FONT(24, NO);
    [self.view addSubview:labelTwo];
    
    UILabel * labelThree = [[UILabel alloc]init];
    labelThree.text =@"保证金随心退，安全无忧";
    labelThree.font = FONT(16, NO);
    [self.view addSubview:labelThree];
    
    UIImageView * imgOne = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"weixin"]];
    UIImageView * imgTwo =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"zhifubao"]];
    
    [self.view addSubview:imgOne];
    [self.view addSubview:imgTwo];
    
    UIView * line = [[UIView alloc]init];
    line.backgroundColor =[UIColor lightGrayColor];
    
    
    labelOne.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(self.view, 16);
    
    labelTwo.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(labelOne, 32);
    
    labelThree.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(labelTwo, 20);
    
    imgOne.sd_layout
    .leftSpaceToView(self.view, 20)
    .topSpaceToView(labelThree, 36*RATIO_HEIGHT);
    
    line.sd_layout
    .topSpaceToView(imgOne, 10)
    .widthIs(SCREEN_WIDTH)
    .heightIs(1);
    
    imgTwo.sd_layout
    .leftSpaceToView(self.view, 20)
    .topSpaceToView(line, 10);

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
