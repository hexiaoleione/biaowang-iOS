//
//  AddressDetailViewController.m
//  Express
//
//  Created by 张宾 on 15/7/28.
//  Copyright (c) 2015年 SCHT. All rights reserved.
//

#import "AddressDetailViewController.h"
#import "MainHeader.h"
#import "NSStringAdditions.h"
#import "UIViewController+show.h"
#import "Masonry.h"
#import "CityViewController.h"

@interface AddressDetailViewController ()<UITextFieldDelegate,BMKGeoCodeSearchDelegate>
{
    UITextField *_titleField;
    UITextField *_nameField;
    UITextField *_phoneField;
    UITextField *_areaField;
    UITextField *_detailAddressField;
    
    UILabel *_areaSelectLabel;
    UISwitch *_defaultSwitch;
    Address *_addressToAdd;
    
    UIScrollView *_backScrollView;
    
    NSString *_townName;
    NSString *_cityName;
    
    BMKGeoCodeSearchOption *_option;
    BMKGeoCodeSearch *_searcher;
}

@end

@implementation AddressDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configNavgationBar];
    
    [self configSubviews];
    _addressToAdd = [[Address alloc]init];
    _searcher  = [[BMKGeoCodeSearch alloc]init];
    _searcher.delegate = self;
    //如果是修改，就填充数据
    if(_isModify)
        [self updateViewData];
    _defaultSwitch.hidden = YES;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)configSubviews {
    
    _backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, -64, WINDOW_WIDTH, WINDOW_HEIGHT)];
    _backScrollView.contentSize = CGSizeMake(WINDOW_WIDTH, WINDOW_HEIGHT+100);
    
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, -50, WINDOW_WIDTH, WINDOW_HEIGHT+150)];
    [_backScrollView addSubview:contentView];
    
    
    [self.view addSubview:_backScrollView];
    
    
//第一行标签
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"地址标签";
    titleLabel.font = [UIFont fontWithName:@"ArialMT" size:14.0];
    [contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(5+64);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(80);
    }];
    
    
    
    _titleField = [[UITextField alloc]init];
    _titleField.delegate = self;
    _titleField.borderStyle = UITextBorderStyleRoundedRect;
    _titleField.placeholder = @"家\\公司";
    _titleField.font = [UIFont fontWithName:@"ArialMT" size:14.0];
    [contentView addSubview:_titleField];
    [_titleField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel.mas_right).with.offset(5);
        make.right.equalTo(self.view).with.offset(-30);
        make.height.equalTo(titleLabel);
        make.top.equalTo(titleLabel);
    }];
//第二行
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"姓    名:";
    nameLabel.font = [UIFont fontWithName:@"ArialMT" size:14.0];
    [contentView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.and.height.equalTo(titleLabel);
        make.top.equalTo(titleLabel.mas_bottom).with.offset(5);
    }];
    
    _nameField = [[UITextField alloc]init];
    _nameField.delegate = self;
    _nameField.font = [UIFont fontWithName:@"ArialMT" size:14.0];
    _nameField.borderStyle = UITextBorderStyleRoundedRect;
    [contentView addSubview:_nameField];
    [_nameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.and.height.equalTo(_titleField);
        make.top.equalTo(_titleField.mas_bottom).with.offset(10);
    }];
//第三行
    UILabel *phoneLabel = [[UILabel alloc]init];
    phoneLabel.text = @"手机号";
    phoneLabel.font = [UIFont fontWithName:@"ArialMT" size:14.0];
    [contentView addSubview:phoneLabel];
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.and.height.equalTo(titleLabel);
        make.top.equalTo(nameLabel.mas_bottom).with.offset(10);
    }];
    
    _phoneField = [[UITextField alloc]init];
    _phoneField.delegate = self;
    _phoneField.font = [UIFont fontWithName:@"ArialMT" size:14.0];
    _phoneField.keyboardType = UIKeyboardTypeNumberPad;
    _phoneField.borderStyle = UITextBorderStyleRoundedRect;
    [contentView addSubview:_phoneField];
    [_phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.and.height.equalTo(_nameField);
        make.top.equalTo(_nameField.mas_bottom).with.offset(10);
    }];
//第四行
    UILabel *areaLabel = [[UILabel alloc]init];
    areaLabel.text = @"所属区域";
    areaLabel.font = [UIFont fontWithName:@"ArialMT" size:14.0];
    [contentView addSubview:areaLabel];
    [areaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.and.height.equalTo(titleLabel);
        make.top.equalTo(phoneLabel.mas_bottom).with.offset(10);
    }];
    
    
    
    _areaSelectLabel = [[UILabel alloc]init];
    _areaSelectLabel.text = @"点击选择";
    _areaSelectLabel.font = [UIFont fontWithName:@"ArialMT" size:14.0];
    [contentView addSubview:_areaSelectLabel];
    [_areaSelectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.and.height.equalTo(_phoneField);
        make.top.equalTo(_phoneField.mas_bottom).with.offset(10);
    }];
    _areaSelectLabel.userInteractionEnabled = YES;
    
    
    
    UITapGestureRecognizer *tapG =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(seletArea)];
    [_areaSelectLabel  addGestureRecognizer:tapG];
    
    UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"go"]];
    imageV.frame = CGRectMake(WINDOW_WIDTH - 160, 10, 20, 25);
    [_areaSelectLabel addSubview:imageV];
    
    


    
  /*
    _areaField = [[UITextField alloc]init];
    _areaField.delegate = self;
    _areaField.placeholder = @"点击选择";
    _areaField.enabled = NO;
    UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nav_back"]];
    _areaField.rightView = imageV;
    _areaField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:_areaField];
    
    UITapGestureRecognizer *tapG =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(seletArea)];
    [_areaField  addGestureRecognizer:tapG];
    _areaField.userInteractionEnabled = YES;
    [_areaField addTarget:self action:@selector(seletArea) forControlEvents:UIControlEventTouchUpInside];
    [_areaField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.and.height.equalTo(_phoneField);
        make.top.equalTo(_phoneField.mas_bottom).with.offset(5);
    }];
    */
    
//第五行
    UILabel *detailLabel = [[UILabel alloc]init];
    detailLabel.text = @"详细地址";
    detailLabel.font = [UIFont fontWithName:@"ArialMT" size:14.0];
    [contentView addSubview:detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.and.height.equalTo(titleLabel);
        make.top.equalTo(areaLabel.mas_bottom).with.offset(10);
    }];
    
    _detailAddressField = [[UITextField alloc]init];
    _detailAddressField.delegate = self;
    _detailAddressField.font = [UIFont fontWithName:@"ArialMT" size:14.0];
    _detailAddressField.borderStyle = UITextBorderStyleRoundedRect;
    [contentView addSubview:_detailAddressField];
    [_detailAddressField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.and.height.equalTo(_areaSelectLabel);
        make.top.equalTo(_areaSelectLabel.mas_bottom).with.offset(10);
    }];
    
    /*
    UIButton *mapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [mapBtn setImage:[UIImage imageNamed:@"amap_start"] forState:UIControlStateNormal];
    [mapBtn addTarget:self action:@selector(selectHotMap) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:mapBtn];
    
    [mapBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-5);
        make.top.equalTo(_areaSelectLabel.mas_bottom).with.offset(5);
        make.width.and.height.mas_equalTo(50);
    }];
    */
//第六行
    UILabel *defaultLabel = [[UILabel alloc]init];
//    defaultLabel.text = @"默认地址";
    [contentView addSubview:defaultLabel];
    [defaultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.and.height.equalTo(titleLabel);
        make.top.equalTo(detailLabel.mas_bottom).with.offset(10);
    }];

    
    _defaultSwitch = [[UISwitch alloc]init];
    _defaultSwitch.tintColor = [UIColor grayColor];
    _defaultSwitch.onTintColor = COLOR_ORANGE_DEFOUT;
//    _defaultSwitch.onImage = [UIImage imageNamed:@"switch_on"];
//    _defaultSwitch.offImage = [UIImage imageNamed:@"switch_off"];
    [contentView addSubview:_defaultSwitch];
    [_defaultSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_detailAddressField);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(90);
        make.centerY.equalTo(defaultLabel);
    }];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [contentView addSubview:button];
    [button setTitle:@"确认修改" forState:UIControlStateNormal];
    button.layer.borderColor = [COLOR_ORANGE_DEFOUT CGColor];
    button.layer.borderWidth = 1.0f;
    [button setTintColor:[UIColor whiteColor]];
    button.backgroundColor = COLOR_ORANGE_DEFOUT;
    button.layer.cornerRadius = 15;
    [button addTarget:self action:@selector(saveAddress) forControlEvents:UIControlEventTouchUpInside];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_defaultSwitch.mas_bottom).with.offset(-10);
        make.left.mas_equalTo(WINDOW_WIDTH*0.5 - 50);
        make.right.mas_equalTo(-WINDOW_WIDTH*0.5 + 50);
        make.height.mas_equalTo(30);
    }];
    titleLabel.hidden = YES;
    _titleField.hidden = YES;
}

- (void)updateViewData
{
    _titleField.text = _addressToModify.addressTag;
    _nameField.text = _addressToModify.personName;
    _phoneField.text = _addressToModify.mobile;
    _areaSelectLabel.text = _addressToModify.areaName;
    _detailAddressField.text = _addressToModify.address;
    _defaultSwitch.on = _addressToModify.defaultAddress==1?YES:NO;
}



#pragma mark action

- (void)seletArea
{
    CityViewController *cityVC =[[CityViewController alloc]init];
    cityVC.returnTextBlock = ^(NSString *address,NSString *citycode,NSString *towncode,NSString *cityname,NSString *townname){
        _areaSelectLabel.text = address;
        _addressToAdd.cityCode = citycode;
        _addressToAdd.townCode = towncode;
        
        _cityName = cityname;
        _townName = townname;
        _addressToAdd.cityName = cityname;
    };
    [self.navigationController pushViewController:cityVC animated:YES];
}

- (void)saveAddress
{
    if ([_nameField.text isEqualToString:@""]||
        [_phoneField.text isEqualToString:@""]||
        [_areaSelectLabel.text isEqualToString:@"点击选择"]||
         [_detailAddressField.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请填写完整信息！"];
        return;
    }
    if (![_phoneField.text isValidPhoneNumber] )
    {
        [SVProgressHUD showErrorWithStatus:@"手机号码格式不正确！"];
        return;
    }
    
    _addressToAdd.addressTag = _titleField.text;
    _addressToAdd.personName = _nameField.text;
    _addressToAdd.mobile = _phoneField.text;
    _addressToAdd.areaName = _areaSelectLabel.text;

    _addressToAdd.address = _detailAddressField.text;
    _addressToAdd.defaultAddress = _defaultSwitch.on;
    _option = [[BMKGeoCodeSearchOption alloc]init];
    _option.city = _cityName;
    _option.address = _detailAddressField.text;
    _searcher = [[BMKGeoCodeSearch alloc]init];
    _searcher.delegate =self;
    
    BOOL isSearch = [_searcher geoCode:_option];
    if (isSearch) {
        NSLog(@"地理编码成功");
    }else{
        NSLog(@"地理编码失败");
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请确认地址信息无误" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"重新填写" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            self.view.frame = CGRectMake(0, 64, WINDOW_WIDTH, WINDOW_HEIGHT);
        }];

        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
             self.view.frame = CGRectMake(0, 64, WINDOW_WIDTH, WINDOW_HEIGHT);
            [SVProgressHUD showWithStatus:@"正在保存..."];
            if (_isModify) {
                [RequestManager changeAddressWithAddressId:[NSString stringWithFormat:@"%d",(int)_addressToModify.addressId]
                                                  cityCode:_addressToAdd.cityCode ? _addressToAdd.cityCode :_addressToModify.cityCode
                                                  cityName:_addressToAdd.cityName ? _addressToAdd.cityName :_addressToModify.cityName
                                                personName:_nameField.text
                                                    mobile:_phoneField.text
                                                  areaName:_areaSelectLabel.text
                                                   address:_detailAddressField.text
                                                  latitude:[[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCATION_LAT]
                                                 longitude:[[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCATION_LON]
                                                   success:^(NSMutableArray *result) {
                                                       [SVProgressHUD showSuccessWithStatus:@"修改成功"];
                                                       [self.navigationController popViewControllerAnimated:YES];
                                                   } Failed:^(NSString *error) {
                                                       [SVProgressHUD showErrorWithStatus:error];
                                                   }];
                return;
            }
            
            NSString *type;
            if (_isRecive) {
                type = @"T";
            }else{
                type = @"F";
            }
            
            [RequestManager addAddressWithUserId:[UserManager getDefaultUser].userId
                                     addressType:type
                                        cityCode:_addressToAdd.cityCode
                                        cityName:_cityName
                                      personName:_nameField.text
                                          mobile:_phoneField.text
                                        areaName:_areaSelectLabel.text
                                         address:_detailAddressField.text
                                        latitude:[[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCATION_LAT]
                                       longitude:[[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCATION_LON]
                                       ifDefault:[NSString stringWithFormat:@"%d",_defaultSwitch.on]
                                         success:^(NSMutableArray *result) {
                                             [SVProgressHUD dismiss];
                                             [self.navigationController  popViewControllerAnimated:YES];
                                         }
                                          Failed:^(NSString *error) {
                                              NSLog(@"%@",error);
                                              [SVProgressHUD showInfoWithStatus:error];
                                          }];
            
            
        }];
        [alert addAction:cancelAction];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:^{
            self.view.frame = CGRectMake(0, 30, WINDOW_WIDTH, WINDOW_HEIGHT);
        }];
        
    }
}

#pragma mark - text field delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
//    if (textField == _areaField||textField==_detailAddressField) {
//        [self moveViewUp];
//    }
//    if (textField == _phoneField) {
//        [self moveViewDown];
//    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    [self moveViewDown];

    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    return YES;
}

#pragma mark - view animation

- (void)moveViewUp
{
    [_backScrollView setContentOffset:CGPointMake(0, 80) animated:YES];
}

- (void)moveViewDown
{
    [_backScrollView setContentOffset:CGPointMake(0, -64) animated:YES];
}

#pragma mark- 地理编码
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    NSString *type;
    if (_isRecive) {
        type = @"T";
    }else{
         type = @"F";
    }
    [SVProgressHUD showWithStatus:@"正在保存..."];
    if (_isModify) {
        [RequestManager changeAddressWithAddressId:[NSString stringWithFormat:@"%d",(int)_addressToModify.addressId]
                                          cityCode:_addressToAdd.cityCode ? _addressToAdd.cityCode :_addressToModify.cityCode
                                          cityName:_addressToAdd.cityName ? _addressToAdd.cityName :_addressToModify.cityName
                                        personName:_nameField.text
                                            mobile:_phoneField.text
                                          areaName:_areaSelectLabel.text
                                           address:_detailAddressField.text
                                          latitude:[NSString stringWithFormat:@"%f",result.location.latitude]
                                         longitude:[NSString stringWithFormat:@"%f",result.location.longitude]
                                           success:^(NSMutableArray *result) {
                                               [SVProgressHUD showSuccessWithStatus:@"修改成功"];
                                               [self.navigationController popViewControllerAnimated:YES];
                                           } Failed:^(NSString *error) {
                                               [SVProgressHUD showErrorWithStatus:error];
                                           }];
        return;
    }
    
    [RequestManager addAddressWithUserId:[UserManager getDefaultUser].userId
                             addressType:type
                                cityCode:_addressToAdd.cityCode
                                cityName:_cityName
                              personName:_nameField.text
                                  mobile:_phoneField.text
                                areaName:_areaSelectLabel.text
                                 address:_detailAddressField.text
                                latitude:[NSString stringWithFormat:@"%f",result.location.latitude]
                               longitude:[NSString stringWithFormat:@"%f",result.location.longitude]
                               ifDefault:[NSString stringWithFormat:@"%d",_defaultSwitch.on]
                                 success:^(NSMutableArray *result) {
                                     [SVProgressHUD dismiss];
                                     [self.navigationController  popViewControllerAnimated:YES];
                                 }
                                  Failed:^(NSString *error) {
                                      NSLog(@"%@",error);
                                      [SVProgressHUD showInfoWithStatus:error];
                                  }];
}

#pragma mark - bar
- (void)configNavgationBar {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 60)];
    label.textColor = [UIColor whiteColor];
    label.text = @"常用地址编辑";
    label.textAlignment = 1;
    self.navigationItem.titleView = label;
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

@end
