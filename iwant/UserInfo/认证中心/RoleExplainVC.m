//
//  RoleExplainVC.m
//  iwant
//
//  Created by 公司 on 2017/2/27.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "RoleExplainVC.h"
#import "UserNameViewController.h"
#import "LogistRoleViewController.h"
#import "WuLiuDriverViewController.h"
#import "RoleExplainView.h"
#import "CompanyRoleFirstViewController.h"
#import "SpecialDriverViewController.h"
#import "MerchantVC.h"
@interface RoleExplainVC (){
    NSInteger _selectedBtnTag;
    RoleExplainView * _biaoshiView;
    RoleExplainView * _specialCarView;
    RoleExplainView * _driverView;
    RoleExplainView * _companyView;
}

@end

@implementation RoleExplainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.viewOne.layer.borderWidth = 1.0;
    self.viewOne.layer.borderColor = COLOR_MainColor.CGColor;
    self.viewOne.layer.cornerRadius = 8;
    self.viewOne.layer.masksToBounds = YES;
    self.viewThree.layer.borderWidth = 1.0;
    self.viewThree.layer.borderColor = COLOR_MainColor.CGColor;
    self.viewThree.layer.cornerRadius = 8;
    self.viewThree.layer.masksToBounds = YES;
    self.viewFour.layer.borderWidth = 1.0;
    self.viewFour.layer.borderColor = COLOR_MainColor.CGColor;
    self.viewFour.layer.cornerRadius = 8;
    self.viewFour.layer.masksToBounds = YES;
    self.viewTwo.layer.borderWidth = 1.0;
    self.viewTwo.layer.borderColor = COLOR_MainColor.CGColor;
    self.viewTwo.layer.cornerRadius = 8;
    self.viewTwo.layer.masksToBounds = YES;
    self.viewFive.layer.borderWidth = 1.0;
    self.viewFive.layer.borderColor = COLOR_MainColor.CGColor;
    self.viewFive.layer.cornerRadius = 8;
    self.viewFive.layer.masksToBounds = YES;
    
    
    self.viewOneConstraint.constant = 75*RATIO_HEIGHT;
    self.viewTwoConstrainr.constant = 75*RATIO_HEIGHT;
    self.viewThreeConstraint.constant = 75* RATIO_HEIGHT;
    self.viewFourConstraint.constant =75* RATIO_HEIGHT;
    self.fiveViewConstraint.constant = 75*RATIO_HEIGHT;
    self.heightConstraint.constant = 55* RATIO_HEIGHT;
    self.topNoticeConstraint.constant = 16* RATIO_HEIGHT;
    if (SCREEN_WIDTH == 320) {
        self.heightConstraint.constant = 36;
    }
    self.noticeLabel.font = FONT(16, NO);

    [self setCostomeTitle:@"角色认证"];
    if (_isRegist) {
        self.leftBtn.hidden = NO;
        self.rightBtn.hidden = NO;
        self.centerBtn.hidden = YES;
        self.topDistanceConstraint.constant = 26;
        self.navigationItem.leftBarButtonItem= [UIBarButtonItem new];
        self.navigationItem.hidesBackButton = YES;
    }
}

- (IBAction)selectBtn:(UIButton *)sender {
    switch (sender.tag) {
        case 0:{
            [self.imgOne setImage:[UIImage imageNamed:@"xuanzhongLmg"]];
            [self.imgTwo setImage:[UIImage imageNamed:@"yuanLmg"]];
            [self.imgThree setImage:[UIImage imageNamed:@"yuanLmg"]];
            [self.imgFour setImage:[UIImage imageNamed:@"yuanLmg"]];
            [self.imgFive setImage:[UIImage imageNamed:@"yuanLmg"]];

            _selectedBtnTag = sender.tag+1;
            _biaoshiView = [[[NSBundle mainBundle] loadNibNamed:@"RoleExplainView" owner:nil options:nil]lastObject];
            _biaoshiView.titleLabel.text = @"镖师是做什么的？";
            _biaoshiView.detailLabel.text =@"顺路捎货、赚大钱。";
            [_biaoshiView show];
        }
            break;
        case 1:{
            [self.imgOne setImage:[UIImage imageNamed:@"yuanLmg"]];
            [self.imgTwo setImage:[UIImage imageNamed:@"xuanzhongLmg"]];
            [self.imgThree setImage:[UIImage imageNamed:@"yuanLmg"]];
            [self.imgFour setImage:[UIImage imageNamed:@"yuanLmg"]];
            [self.imgFive setImage:[UIImage imageNamed:@"yuanLmg"]];

            _selectedBtnTag = sender.tag+1;
            _driverView = [[[NSBundle mainBundle] loadNibNamed:@"RoleExplainView" owner:nil options:nil]lastObject];
            _driverView.titleLabel.text = @"认证大货司机有什么好处？";
            _driverView.detailLabel.text = @"随时随地在线接单，增加业务量，避免空返。";
            [_driverView show];
        }
            break;
        case 2:{
            [self.imgOne setImage:[UIImage imageNamed:@"yuanLmg"]];
            [self.imgTwo setImage:[UIImage imageNamed:@"yuanLmg"]];
            [self.imgThree setImage:[UIImage imageNamed:@"xuanzhongLmg"]];
            [self.imgFour setImage:[UIImage imageNamed:@"yuanLmg"]];
            [self.imgFive setImage:[UIImage imageNamed:@"yuanLmg"]];

            _selectedBtnTag = sender.tag+1;
            _companyView = [[[NSBundle mainBundle] loadNibNamed:@"RoleExplainView" owner:nil options:nil]lastObject];
            _companyView.titleLabel.text = @"认证物流公司有什么好处？";
            _companyView.detailLabel.text = @"随时随地在线接单，增加业务量，避免空返。";
            [_companyView show];
        }
            break;
        case 3:{
            [self.imgOne setImage:[UIImage imageNamed:@"yuanLmg"]];
            [self.imgTwo setImage:[UIImage imageNamed:@"yuanLmg"]];
            [self.imgThree setImage:[UIImage imageNamed:@"yuanLmg"]];
            [self.imgFour setImage:[UIImage imageNamed:@"xuanzhongLmg"]];
            [self.imgFive setImage:[UIImage imageNamed:@"yuanLmg"]];

            _selectedBtnTag = sender.tag+1;
        }
            break;
        case 4:{
            [self.imgOne setImage:[UIImage imageNamed:@"yuanLmg"]];
            [self.imgTwo setImage:[UIImage imageNamed:@"yuanLmg"]];
            [self.imgThree setImage:[UIImage imageNamed:@"yuanLmg"]];
            [self.imgFour setImage:[UIImage imageNamed:@"yuanLmg"]];
            [self.imgFive setImage:[UIImage imageNamed:@"xuanzhongLmg"]];
            _selectedBtnTag = sender.tag+1;
        }
            break;

        default:
            break;
    }
}

- (IBAction)goToRenzheng:(UIButton *)sender {
    switch (_selectedBtnTag) {
        case 0:{
            [SVProgressHUD showErrorWithStatus:@"请先选择要认证的角色类型"];
            }
            break;
        case 1:{
            //判断快递员是否已经认证,认证了快递员，就具有表示资格，不需要认证
            if ([UserManager getDefaultUser].userType == 3) {
                [SVProgressHUD showInfoWithStatus:@"您已通过镖师审核"];
                return;
            }
            if ([UserManager getDefaultUser].userType == 2) {
                [SVProgressHUD showInfoWithStatus:@"您已通过快递员审核，已经具备了镖师资格"];
                return;
            }
            UserNameViewController *VC = [[UserNameViewController alloc]init];
            VC.courentbtnTag = 2;
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case 2:{
            if ([[UserManager getDefaultUser].wlid intValue] == 1) {
                
                [SVProgressHUD showInfoWithStatus:@"您已经认证物流公司"];
                return;
            }
            if ([[UserManager getDefaultUser].wlid intValue] == 2) {
                
                [SVProgressHUD showInfoWithStatus:@"您已经认证大货司机"];
                return;
            }
            if ([[UserManager getDefaultUser].wlid intValue] == 3) {
                //禁用啦
                [SVProgressHUD showInfoWithStatus:@"您已被禁用，请联系我们(Biaowang_app@163.com)"];
                return;
            }
            if ([[UserManager getDefaultUser].wlid intValue] == 4) {
                //冷链
                [SVProgressHUD showInfoWithStatus:@"您已经认证冷链车司机"];
                return;
            }
            WuLiuDriverViewController * VC = [[WuLiuDriverViewController alloc]init];
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case 3:{
            if ([[UserManager getDefaultUser].wlid intValue] == 1) {
                [SVProgressHUD showInfoWithStatus:@"您已经认证物流公司"];
                return;
            }
            if ([[UserManager getDefaultUser].wlid intValue] == 2) {
                
                [SVProgressHUD showInfoWithStatus:@"您已经认证大货司机"];
                return;
            }
            if ([[UserManager getDefaultUser].wlid intValue] == 3) {
                //禁用啦
                [SVProgressHUD showInfoWithStatus:@"您已被禁用，请联系我们(Biaowang_app@163.com)"];
                return;
            }
            if ([[UserManager getDefaultUser].wlid intValue] == 4) {
                //禁用啦
                [SVProgressHUD showInfoWithStatus:@"您已经认证冷链车司机"];
                return;
            }
            LogistRoleViewController *VC = [[LogistRoleViewController alloc]init];
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case 4:{
            
            if ([[UserManager getDefaultUser].wlid intValue] == 4) {
                //禁用啦
                [SVProgressHUD showInfoWithStatus:@"您已经认证冷链车司机"];
                return;
            }
           //冷链车
            if ([[UserManager getDefaultUser].wlid intValue] == 3) {
                //禁用啦
                [SVProgressHUD showInfoWithStatus:@"您已被禁用，请联系我们(Biaowang_app@163.com)"];
                return;
            }
            SpecialDriverViewController * vc = [[SpecialDriverViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 5:{
            //认证商户
            MerchantVC * vc = [[MerchantVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;

        default:
            break;
    }
}
#pragma mark ------ 从注册页面跳转过来 左--暂不认证   右--去认证
- (IBAction)leftBtnClick:(UIButton *)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:ISLOGIN object:nil];
}

//注册界面跳转过来的  然后去认证
- (IBAction)rightBtnClickRenzheng:(UIButton *)sender {
   
    switch (_selectedBtnTag) {
        case 0:{
            [SVProgressHUD showErrorWithStatus:@"请先选择要认证的角色类型"];
        }
            break;
        case 1:{
            UserNameViewController *VC = [[UserNameViewController alloc]init];
            VC.courentbtnTag = 2;
            VC.isRegist = YES;
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case 2:{
            WuLiuDriverViewController * VC = [[WuLiuDriverViewController alloc]init];
            VC.isRegist = YES;
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case 3:{
            LogistRoleViewController *VC = [[LogistRoleViewController alloc]init];
            VC.isRegist = YES;
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case 4:{
            //冷链车的啊a
            SpecialDriverViewController * vc = [[SpecialDriverViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 5:{
            //认证商户
            MerchantVC * vc = [[MerchantVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
