//
//  RealnameViewController.m
//  iwant
//
//  Created by pro on 16/3/8.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "RealnameViewController.h"
#import "RealnameView.h"
#import "MainHeader.h"
@interface RealnameViewController ()


@property (strong, nonatomic)  RealnameView *subView;


@property (copy, nonatomic)  NSString *card;
@end

@implementation RealnameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavgationBar];
    _subView = [[RealnameView alloc]initWithFrame:self.view.bounds];
    __weak RealnameViewController *weakSelf = self;
    _subView.block = ^(int tag){
        self->_card = self->_subView.cardNoFiled.text;
        [weakSelf btnClick:tag];
    };
    
    [self.view addSubview:_subView];
    [_subView setName:[[NSUserDefaults standardUserDefaults] valueForKey:@"linshiName"]];
    
}

-(void)btnClick:(int)tag{
    switch (tag) {
        case 0:
            NSLog(@"姓名提示");
            break;
        case 1:
            NSLog(@"扫描银行卡");
            break;
        case 2:
        {
//            NSLog(@"下一步:%@%@",_name,_card);
//            if (!_card ||  _card.length == 0) {
//                [SVProgressHUD showErrorWithStatus:@"请正确填写您的银行卡号"];
//                return;
//            }
            [SVProgressHUD show];
            
//            [RequestManager uploadCreaditCardNoWithUserId:[NSString stringWithFormat:@"%@",[UserManager getDefaultUser].userId] bankCard:_card success:^(NSDictionary *result) {
//                NSString *message = [NSString stringWithFormat:@"%@",[(NSDictionary *)result valueForKey:@"message"]];
//                [SVProgressHUD showSuccessWithStatus:message];
//                [self.navigationController popToRootViewControllerAnimated:YES];
//            } Failed:^(NSString *error) {
//                [SVProgressHUD showErrorWithStatus:error];
//            }];
            NSDictionary *dic = @{A_CHECK_TYPE:_dic[A_CHECK_TYPE],
                                  @"bankCard":_card};
            [ExpressRequest sendWithParameters:dic
                                     MethodStr:API_COURIER_CHECK
                                       reqType:k_POST
                                       success:^(id object) {
                                           NSString *message = [NSString stringWithFormat:@"%@",[(NSDictionary *)object valueForKey:@"message"]];
                                           [SVProgressHUD showSuccessWithStatus:message];
                                           [self.navigationController popToRootViewControllerAnimated:YES];
                                       }
                                        failed:^(NSString *error) {
                                            [SVProgressHUD showErrorWithStatus:error];
                                        }];
        }
           
            break;
        default:
            break;
    }
}

- (void)configNavgationBar {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 60)];
    label.textColor = [UIColor whiteColor];
    label.text = @"添加银行卡";
    label.textAlignment = 1;
    self.navigationItem.titleView = label;

    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(backToMenuView)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    
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
