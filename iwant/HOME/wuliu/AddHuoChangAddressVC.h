//
//  AddHuoChangAddressVC.h
//  iwant
//
//  Created by 公司 on 2017/1/5.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "BaseViewController.h"

@interface AddHuoChangAddressVC : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *searchTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *detailAdressTextField;
@property (weak, nonatomic) IBOutlet UILabel *localAdress;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;


@property (nonatomic,strong) NSString * la;
@property (nonatomic,strong) NSString * lo;
@property (nonatomic,strong) NSString * cityCode;


@end
