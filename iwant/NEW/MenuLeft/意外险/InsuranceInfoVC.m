//
//  InsuranceInfoVC.m
//  iwant
//
//  Created by 公司 on 2017/11/8.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "InsuranceInfoVC.h"
#import "EcoinWebViewController.h"
@interface InsuranceInfoVC ()
@property (weak, nonatomic) IBOutlet UIButton *downBtnOne;
@property (weak, nonatomic) IBOutlet UIButton *donBtnTwo;
@property (weak, nonatomic) IBOutlet UIButton *noticingBtn;

@end

@implementation InsuranceInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCostomeTitle:@"意外险"];
    [self configNavgationBtn];
    if (_ifPass == 0 ||_ifPass == 1) {
        self.downBtnOne.hidden = YES;
        self.donBtnTwo.hidden = YES;
        self.noticingBtn.hidden = NO;
    }else{
        self.downBtnOne.hidden = NO;
        self.donBtnTwo.hidden = NO;
        self.noticingBtn.hidden = YES;
    }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)downBtnClick:(UIButton *)sender {
    if (sender.tag == 1) {
        //理赔须知
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.efamax.com/mobile/images/lipeixuzhi.pdf"]];
    }else{
        //理赔申请书
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.efamax.com/mobile/images/lipeishenqingshu.pdf"]];
    }
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
