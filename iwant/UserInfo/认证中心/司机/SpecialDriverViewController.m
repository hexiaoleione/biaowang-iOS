//
//  WuLiuDriverViewController.m
//  iwant
//
//  Created by 公司 on 2016/12/29.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "SpecialDriverViewController.h"
#import "YMHeaderView.h"
//按比例获取高度
#define  WGiveHeight(HEIGHT) HEIGHT * [UIScreen mainScreen].bounds.size.height/667.0
//按比例获取宽度
#define  WGiveWidth(WIDTH) WIDTH * [UIScreen mainScreen].bounds.size.width/375.0

@interface SpecialDriverViewController ()<YMHeaderViewDelegate>{
    UIScrollView *_scrollView;
    UITextField * _nameTextField;
    UITextField * _idCardTextField;
    
}
@property(nonatomic,copy) NSString *driverLicensePath; //驾驶证
@property(nonatomic,copy) NSString *getDrivingLicensePath; //行驶证
@property(nonatomic,copy) NSString *getCarNumberPath; //车牌号

@property (nonatomic,strong)YMHeaderView * driverLicense; //驾驶证照片
@property (nonatomic,strong)YMHeaderView * getDrivingLicense; //行驶证照片
@property (nonatomic,strong)YMHeaderView * getCarNumber;//车牌号照片

/*
 private Integer recId;          //主键
 private String idCardPath;//认证时的驾驶证照片url
 private String checkName;//认证时的姓名
 private String checkIdCard;//认证时的身份证号
 private String bossPhone;
 
 private String carNumberUrl;//车牌号
 private String drivingLicense;;//行驶证
 private String status;//个人用户状态  0->正在审核  1->审核通过 2->拒绝  3->禁用 4
 private Integer userId;
 private Double latitude;//纬度
 private Double longitude;//经度
 */

@end

@implementation SpecialDriverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self setCostomeTitle:@"冷链车司机认证"];
    [self creatUI];
}

-(void)creatUI{
    _scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    _scrollView.contentSize = CGSizeMake(WINDOW_WIDTH, WGiveHeight(920.0));
    if (SCREEN_WIDTH == 320) {
        _scrollView.contentSize = CGSizeMake(WINDOW_WIDTH, WGiveHeight(920)+20);
    }
    [self.view addSubview:_scrollView];
    
    _driverLicense =[[YMHeaderView alloc]initWithFrame:CGRectMake(WGiveWidth(44),WGiveHeight(20), SCREEN_WIDTH-WGiveWidth(44)*2,WGiveHeight(200))];
    _driverLicense.image = [UIImage imageNamed:@"驾驶证"];
    _driverLicense.layer.cornerRadius = 5;
    _driverLicense.tag = 0;
    _driverLicense.delagate = self;
    [_scrollView addSubview:_driverLicense];
    
    _getDrivingLicense =[[YMHeaderView alloc]initWithFrame:CGRectMake(WGiveWidth(44), _driverLicense.bottom+10, SCREEN_WIDTH-WGiveWidth(44)*2,WGiveHeight(200))];
    _getDrivingLicense.image = [UIImage imageNamed:@"行驶证"];
    _getDrivingLicense.layer.cornerRadius = 5;
    _getDrivingLicense.tag = 1;
    _getDrivingLicense.delagate = self;
    [_scrollView addSubview:_getDrivingLicense];
    
    _getCarNumber =[[YMHeaderView alloc]initWithFrame:CGRectMake(WGiveWidth(44), _getDrivingLicense.bottom+10, SCREEN_WIDTH-WGiveWidth(44)*2,WGiveHeight(200))];
    _getCarNumber.image = [UIImage imageNamed:@"车牌"];
    _getCarNumber.tag = 2;
    _getCarNumber.layer.cornerRadius = 5;
    _getCarNumber.delagate = self;
    [_scrollView addSubview:_getCarNumber];
    
    UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,_getCarNumber.bottom +20, WGiveHeight(72), 16)];
    nameLabel.font = FONT(14, NO);
    nameLabel.text = @"姓     名：";
    nameLabel.left = 10;
    [_scrollView addSubview:nameLabel];
    

    _nameTextField = [[UITextField alloc]initWithFrame:CGRectMake( nameLabel.right+5, _getCarNumber.bottom+10,SCREEN_WIDTH-(nameLabel.right+5+WGiveWidth(20)), WGiveWidth(44))];
    _nameTextField.layer.cornerRadius = 5.0;
    _nameTextField.clipsToBounds = YES;
    _nameTextField.placeholder = @"请输入真实姓名";
    _nameTextField.backgroundColor = [UIColor whiteColor];
    _nameTextField.textAlignment = NSTextAlignmentCenter;
    [_scrollView addSubview:_nameTextField];
    
    
    UILabel * idCardLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,_nameTextField.bottom +20, WGiveHeight(72), 16)];
    idCardLabel.font = FONT(14, NO);
    idCardLabel.text = @"身份证号：";
    [_scrollView addSubview:idCardLabel];
    
    _idCardTextField = [[UITextField alloc]initWithFrame:CGRectMake(idCardLabel.right+5, _nameTextField.bottom + 10, SCREEN_WIDTH - (idCardLabel.right+ 5 +WGiveWidth(20)),WGiveWidth(44))];
    _idCardTextField.layer.cornerRadius = 5.0;
    _idCardTextField.clipsToBounds = YES;
    _idCardTextField.placeholder=@"请输入身份证号";
    _idCardTextField.textAlignment = NSTextAlignmentCenter;
    _idCardTextField.backgroundColor =[UIColor whiteColor];
    [_scrollView addSubview:_idCardTextField];
    
    
    UILabel * noticeLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, _idCardTextField.bottom +5, SCREEN_WIDTH-10, 16)];
    noticeLabel.textAlignment =NSTextAlignmentCenter;
    noticeLabel.textColor = [UIColor redColor];
    noticeLabel.font = FONT(12, NO);
    if (SCREEN_WIDTH == 375) {
        noticeLabel.font = [UIFont systemFontOfSize:11];
    }
    noticeLabel.text = @"温馨提示：根据公安部物流寄送实名制要求,请输入真实姓名和身份证号码";
    [_scrollView addSubview:noticeLabel];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:COLOR_MainColor];
    btn.layer.cornerRadius = 10;
    btn.size = CGSizeMake(160, 35);
    btn.top = noticeLabel.bottom + 15;
    btn.centerX = _scrollView.centerX;
    [_scrollView addSubview:btn];
    [btn addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
}


-(void)headerView:(YMHeaderView *)headerView didSelectWithImage:(UIImage *)image{
    [SVProgressHUD showWithStatus:@"正在上传"];
    NSDictionary *dic = @{k_USER_ID:[UserManager getDefaultUser].userId,k_FILE_NAME:@"specialDriver.png"};
    NSDictionary *fileDic = @{@"data":image,@"fileName":@"specialDriver.png"};
    
    NSString *api;
    switch (headerView.tag) {
        case 0:
            api = @"file/driverLicense";
            break;
        case 1:
            api = @"file/getDrivingLicense";
            break;
        case 2:
            api = @"file/getCarNumber";
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
                                           self.driverLicensePath = [([object objectForKey:@"data"][0]) valueForKey:@"filePath"];
                                           break;
                                       case 1:
                                           self.getDrivingLicensePath = [([object objectForKey:@"data"][0]) valueForKey:@"filePath"];
                                           break;
                                       case 2:
                                           self.getCarNumberPath = [([object objectForKey:@"data"][0]) valueForKey:@"filePath"];
                                           break;
                                       default:
                                           break;
                                   }
                               } failed:^(NSString *error) {
                                   [SVProgressHUD showErrorWithStatus:error];
                               }];
}

-(void)submit:(UIButton *)sender{
    if (![self checkPrem]) {
        return;
    }
    NSDictionary *dic =@{@"idCardPath":self.driverLicensePath,
                         @"drivingLicense":self.getDrivingLicensePath,
                         @"carNumberUrl":self.getCarNumberPath,
                         @"checkName":_nameTextField.text,
                         @"checkIdCard":_idCardTextField.text,
                         @"userId":[UserManager getDefaultUser].userId,
                         @"carType":@"cold"
                         };
    [SVProgressHUD show];
    [ExpressRequest sendWithParameters:dic
                             MethodStr:@"logistics/register/person"
                               reqType:k_POST
                               success:^(id object) {
                                   [SVProgressHUD dismiss];
                                   if (_isRegist) {
                                       [self dismissViewControllerAnimated:YES completion:nil];
                                   }
                                   [SVProgressHUD showSuccessWithStatus:[object valueForKey:@"message"]];
                                   [self.navigationController popToRootViewControllerAnimated:YES];
                                   
                               } failed:^(NSString *error) {
                                   [SVProgressHUD showErrorWithStatus:error];
                               }];
}

- (BOOL)checkPrem{
    if (_driverLicensePath.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请先上传驾驶证图片"];
        return NO;
    }
    if (_getDrivingLicensePath.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请先上传行驶证图片"];
        return NO;
    }
    if (_getCarNumberPath.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请先上传车牌号图片"];
        return NO;
    }
    if (_nameTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入真实姓名"];
        return NO;
    }
    if (_idCardTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入身份证号码"];
        return NO;
    }
    if (_idCardTextField.text.length != 18) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的身份证号码"];
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
