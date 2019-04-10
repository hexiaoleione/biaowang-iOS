//
//  MerchantVC.m
//  iwant
//
//  Created by 公司 on 2017/9/8.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "MerchantVC.h"
#import "YMHeaderView.h"
#import "CityViewController.h"
@interface MerchantVC ()<YMHeaderViewDelegate>{

    NSString *_url_1;
    NSString *_url_2;
    NSString *_url_3;
    NSString * _cityCode;
}

@property (weak, nonatomic) IBOutlet YMHeaderView *imgOne;
@property (weak, nonatomic) IBOutlet YMHeaderView *imgTwo;
@property (weak, nonatomic) IBOutlet YMHeaderView *imgThree;

@property (weak, nonatomic) IBOutlet UILabel *cityL;
@property (weak, nonatomic) IBOutlet UILabel *addressl;
@property (weak, nonatomic) IBOutlet UILabel *shopNameL;
@property (weak, nonatomic) IBOutlet UILabel *idCardL;
@property (weak, nonatomic) IBOutlet UILabel *recommendPhoneL;
@property (weak, nonatomic) IBOutlet UILabel *imageL;

@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UITextField *detailTextField;
@property (weak, nonatomic) IBOutlet UITextField *shopNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *cardNumberTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDistanceConstraint;
@property (weak, nonatomic) IBOutlet UITextField *recommendPhoneTextField;

@property (weak, nonatomic) IBOutlet UILabel *ruleOne;
@property (weak, nonatomic) IBOutlet UILabel *ruleTwo;
@property (weak, nonatomic) IBOutlet UILabel *ruleThree;
@property (weak, nonatomic) IBOutlet UILabel *noticeL;

@end

@implementation MerchantVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCostomeTitle:@"认证商户"];
    self.topDistanceConstraint.constant = 32 * RATIO_HEIGHT;
    self.cityTextField.font = FONT(14, NO);
    self.detailTextField.font =FONT(14, NO);
    self.shopNameTextField.font =FONT(14, NO);
    self.cardNumberTextField.font =FONT(14, NO);
    self.recommendPhoneTextField.font = FONT(14, NO);
    self.noticeL.font = FONT(13, NO);
    self.ruleOne.font = FONT(13, NO);
    self.ruleTwo.font = FONT(13, NO);
    self.ruleThree.font = FONT(13, NO);
    self.cityL.font = FONT(15, NO);
    self.addressl.font = FONT(15, NO);
    self.shopNameL.font = FONT(15, NO);
    self.idCardL.font = FONT(15, NO);
    self.recommendPhoneL.font = FONT(15, NO);
    self.imageL.font = FONT(15, NO);

    
    self.imgOne.image = [UIImage imageNamed:@"WL_cargoImg"];
    self.imgTwo.image = [UIImage imageNamed:@"WL_cargoImg"];
    self.imgThree.image = [UIImage imageNamed:@"WL_cargoImg"];

    _imgOne.delagate =self;
    _imgTwo.delagate =self;
    _imgThree.delagate =self;
    _imgThree.layer.cornerRadius =0;
    _imgTwo.layer.cornerRadius =0;
    _imgOne.layer.cornerRadius =0;
    
    
}


#pragma mark  ---YMHeader  Delegate
- (void)headerView:(YMHeaderView *)headerView didSelectWithImage:(UIImage *)image{
    [SVProgressHUD showWithStatus:@"正在上传"];
    NSDictionary *dic = @{k_USER_ID:[UserManager getDefaultUser].userId,k_FILE_NAME:@"matImg.png"};
    NSDictionary *fileDic = @{@"data":image,@"fileName":@"matImg.png.png"};
    
    NSString *api;
    switch (headerView.tag) {
        case 0:
            api = @"file/shopDoor";
            break;
        case 1:
            api = @"file/shopLicense";
            break;
        case 2:
            api = @"file/shopIdCard";
            break;
            
        default:
            break;
    }
    [ExpressRequest sendWithParameters:dic MethodStr:api
                               fileDic:fileDic
                               success:^(id object) {
                                   [SVProgressHUD showSuccessWithStatus:@"上传成功"];
                                   switch (headerView.tag) {
                                       case 0:
                                           self->_url_1 = [([object objectForKey:@"data"][0]) valueForKey:@"filePath"];
                                           break;
                                       case 1:
                                           self->_url_2 = [([object objectForKey:@"data"][0]) valueForKey:@"filePath"];
                                           break;
                                       case 2:
                                           self->_url_3 = [([object objectForKey:@"data"][0]) valueForKey:@"filePath"];
                                           break;
                                       default:
                                           break;
                                   }
                               } failed:^(NSString *error) {
                                   [SVProgressHUD showErrorWithStatus:error];
                               }];
}

- (IBAction)cityBtnClick:(UIButton *)sender {
    CityViewController * vc = [[CityViewController alloc]init];
    vc.returnTextBlock = ^(NSString *address, NSString *citycode, NSString *towncode, NSString *cityname, NSString *townname) {
        self.cityTextField.text = [NSString stringWithFormat:@"%@",address];
        self->_cityCode = citycode;
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark --- 确认提交
- (IBAction)makeSureSubmit:(UIButton *)sender {
    if (self.cityTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择所在城市"];
        return;
    }
    if (self.detailTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请填写具体的地址"];
        return;
    }
    if (self.shopNameTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请填写真实的店铺名称"];
        return;
    }

    if (_url_1.length == 0||_url_2.length == 0||_url_3.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请上传照片"];
        return;
    }

    if (self.cardNumberTextField.text.length != 18) {
        [SVProgressHUD showErrorWithStatus:@"请填写正确的店主身份证号"];
        return;
    }
//    if (self.recommendPhoneTextField.text.length !=0 && self.recommendPhoneTextField.text.length !=11) {
//        [SVProgressHUD showErrorWithStatus:@"请填写正确的推荐人手机号"];
//        return;
//    }

    NSDictionary * dic = @{@"userId":[UserManager getDefaultUser].userId,
                           @"latitude":[[[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCATION_LAT] stringValue]
                           ,@"longitude":[[[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCATION_LON] stringValue],
                           @"site":self.cityTextField.text,
                           @"address":self.detailTextField.text,
                           @"shopName":self.shopNameTextField.text,
                           @"inviteMobile":self.recommendPhoneTextField.text ?self.recommendPhoneTextField.text:@"",
                           @"cityCode":_cityCode ?_cityCode:@"",
                           @"shopDoorURL":_url_1,
                           @"shopLicenseURL":_url_2,
                           @"shopIdCardURL":_url_3,
                           @"idCard":self.cardNumberTextField.text
                           };
   
   [ExpressRequest  sendWithParameters:dic MethodStr:@"check/addChapman" reqType:k_POST success:^(id object) {
       NSString * message = [object valueForKey:@"message"];
       [SVProgressHUD showSuccessWithStatus:message];
       [self.navigationController popToRootViewControllerAnimated:YES];
    } failed:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
