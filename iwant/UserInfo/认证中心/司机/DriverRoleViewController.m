//
//  DriverRoleViewController.m
//  iwant
//
//  Created by dongba on 16/9/6.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "DriverRoleViewController.h"
#import "YMHeaderView.h"
#import "DriverInfoView.h"
#import "CourierCerIdCardView.h"
#import "Masonry.h"

@interface DriverRoleViewController ()<YMHeaderViewDelegate,CourierCerIdCardDelegate>{
    DriverInfoView *_filedView;
    NSString *_url;
}


@end

@implementation DriverRoleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCostomeTitle:@"个人"];
    [self confitSubViews];
    // Do any additional setup after loading the view.
    self.view.clipsToBounds = YES;
}

- (void)confitSubViews{
    
    UIView * contView = [[UIView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:contView];
    
    
    self.drivingLicenceView = [[UIView alloc] init];
    _drivingLicenceView.frame = CGRectMake(WINDOW_WIDTH-120, 0, WINDOW_WIDTH, self.view.bounds.size.height);
    [contView addSubview:_drivingLicenceView];
    
    
    self.courierCerIdCardViewController = [[CourierCerIdCardView alloc] init];
    self.courierCerIdCardViewController.view.frame = self.view.bounds;
    _courierCerIdCardViewController.view.x = 0;
    _courierCerIdCardViewController.delegate = self;
    [contView addSubview:_courierCerIdCardViewController.view];
    [self addChildViewController:_courierCerIdCardViewController];
    
    
    YMHeaderView *imageView = [[YMHeaderView alloc]initWithFrame:CGRectMake(0, 0, 200, 150)];
    imageView.layer.cornerRadius = 10;
    imageView.delagate = self;
    imageView.image = [UIImage imageNamed:@"personJsz"];
    imageView.centerX = _drivingLicenceView.centerX;
    imageView.top = 30;
    [_drivingLicenceView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_drivingLicenceView);
        make.centerX.equalTo(_drivingLicenceView);
        make.width.equalTo(@200);
        make.height.equalTo(@150);
    }];
    
    UILabel *driverLabel = [self creatLabel:@"*请上传有效的驾驶证图片，并保证信息的可见性"];
    [driverLabel sizeToFit];
    driverLabel.top = imageView.bottom + 15;
    driverLabel.centerX = _drivingLicenceView.centerX;
    [_drivingLicenceView addSubview:driverLabel];
    [driverLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_drivingLicenceView);
        make.top.equalTo(imageView.mas_bottom).with.offset(15);
    }];
    
    
    _filedView = [[[NSBundle mainBundle] loadNibNamed:@"DriverInfo" owner:nil options:nil] lastObject];
    [_filedView sizeToFit];
    _filedView.top = driverLabel.bottom + 15;
    _filedView.centerX = _drivingLicenceView.centerX;
    [_drivingLicenceView addSubview:_filedView];
    [_filedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_drivingLicenceView);
        make.top.equalTo(driverLabel.mas_bottom).with.offset(15);
        make.height.equalTo(@160);
        make.width.equalTo(_drivingLicenceView).with.offset(-20);
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:COLOR_ORANGE_DEFOUT];
    btn.layer.cornerRadius = 10;
    btn.size = CGSizeMake(160, 50);
    btn.top = _filedView.bottom + 30;
    btn.centerX = _drivingLicenceView.centerX;
    [btn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [_drivingLicenceView addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_drivingLicenceView);
        make.top.equalTo(_filedView.mas_bottom).with.offset(15);
        make.width.equalTo(_drivingLicenceView).with.offset(-160);
    }];
    
    UIButton *upBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [upBtn setTitle:@"上一步" forState:UIControlStateNormal];
    [upBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [upBtn setBackgroundColor:COLOR_ORANGE_DEFOUT];
    upBtn.layer.cornerRadius = 10;
    upBtn.size = CGSizeMake(160, 50);
    upBtn.top = _filedView.bottom + 30;
    upBtn.centerX = _drivingLicenceView.centerX;
    [upBtn addTarget:self action:@selector(upBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_drivingLicenceView addSubview:upBtn];
    [upBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_drivingLicenceView);
        make.top.equalTo(btn.mas_bottom).with.offset(15);
        make.width.equalTo(_drivingLicenceView).with.offset(-160);
    }];
    
}

- (void)submit{
    
    if (![self checkPrem]) {
        return;
    }
    
    
    NSDictionary *dic = @{@"matImageUrl":_url,
                          @"carType":_filedView.carType.text,
                          @"carNumber":_filedView.carNo.text,
                          @"driverNumber":_filedView.driverNo.text,
                          @"quaCertificate":_filedView.quaCertificate.text,
                          @"userId":[UserManager getDefaultUser].userId};
    
    [self.dictInfo setValuesForKeysWithDictionary:dic];
//    [self.dictInfo setObject:@"matImageUrl" forKey:_url];
//    [self.dictInfo setObject:@"carType" forKey:_filedView.carType.text];
//    [self.dictInfo setObject:@"carNumber" forKey:_filedView.carNo.text];
//    [self.dictInfo setObject:@"driverNumber" forKey:_filedView.driverNo.text];
//    [self.dictInfo setObject:@"quaCertificate" forKey:_filedView.quaCertificate.text];
    
    [ExpressRequest sendWithParameters:self.dictInfo
                             MethodStr:@"logistics/register/person"
                               reqType:k_POST
                               success:^(id object) {
                                   
                                   [SVProgressHUD showSuccessWithStatus:[object valueForKey:@"message"]];
                                   [self.navigationController popViewControllerAnimated:YES];
                               } failed:^(NSString *error) {
                                   [SVProgressHUD showErrorWithStatus:error];
                               }];
}

- (BOOL)checkPrem{
    if (_url.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请先上传驾驶证图片"];
        return NO;
    }
    
    if (_filedView.carType.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择车辆类型"];
        return NO;
    }
    if (_filedView.carNo.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请填写车牌号"];
        return NO;
    }
    if (_filedView.carType.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请填写驾驶证号"];
        return NO;
    }
    if (_filedView.carType.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请填写从业资格证号"];
        return NO;
    }
    
    
    
    
    return YES;
    
}

- (UILabel *)creatLabel:(NSString *)text{
    UILabel *label  = [UILabel new];
    //    NSMutableAttributedString * str = [[NSMutableAttributedString alloc]initWithString:text attributes:@{NSKernAttributeName:@(0.)}];
    //    //设置某写字体的颜色
    //    //NSForegroundColorAttributeName 设置字体颜色
    //    NSRange blueRange = NSMakeRange([[str string] rangeOfString:@"*"].location, [[str string] rangeOfString:@"*"].length);
    //    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:blueRange];
    //    [label setAttributedText:str];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor redColor];
    label.text = text;
    
    return label;
}

//上传图片
-(void)headerView:(YMHeaderView *)headerView didSelectWithImage:(UIImage *)image{
    [SVProgressHUD show];
    NSDictionary *dic = @{k_USER_ID:[UserManager getDefaultUser].userId,k_FILE_NAME:@"驾驶证.png"};
    NSDictionary *fileDic = @{@"data":image,@"fileName":@"驾驶证.png"};
    [ExpressRequest sendWithParameters:dic MethodStr:@"file/driverLicense"
                               fileDic:fileDic
                               success:^(id object) {
                                   _url = [([object objectForKey:@"data"][0]) valueForKey:@"filePath"];
                                   [SVProgressHUD showSuccessWithStatus:@"上传成功"];
                                   
                               } failed:^(NSString *error) {
                                   [SVProgressHUD showErrorWithStatus:error];
                               }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) courierCerIdCardHasUpdate{
    [UIView animateWithDuration:0.25 animations:^{
        _courierCerIdCardViewController.view.x = -WINDOW_WIDTH;
        _drivingLicenceView.x = 0;
    }];
    self.dictInfo =[NSMutableDictionary dictionaryWithDictionary:_courierCerIdCardViewController.dict];

}
-(void) upBtnAction{
    [UIView animateWithDuration:0.25 animations:^{
        _courierCerIdCardViewController.view.x = 0;
        _drivingLicenceView.x = WINDOW_WIDTH;
    }];
}
@end
