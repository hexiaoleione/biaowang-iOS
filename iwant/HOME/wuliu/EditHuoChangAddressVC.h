//
//  EditHuoChangAddressVC.h
//  iwant
//
//  Created by 公司 on 2017/1/6.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "BaseViewController.h"
#import "HuoChangModel.h"
@interface EditHuoChangAddressVC : BaseViewController


@property (weak, nonatomic) IBOutlet UITextField *searchTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *detailAdressTextField;
@property (weak, nonatomic) IBOutlet UILabel *localAdress;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UISwitch *switchDefault;



@property (nonatomic,strong)HuoChangModel * model;

@property (nonatomic,strong) NSString * detailAddress;
@property (nonatomic,strong) NSString * locationAddress;
@property (nonatomic,strong) NSString * la;
@property (nonatomic,strong) NSString * lo;
@property (nonatomic,strong) NSString * cityCode;

@end
