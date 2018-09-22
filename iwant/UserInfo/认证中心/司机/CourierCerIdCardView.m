//
//  CourierCerIdCardView.m
//  iwant
//
//  Created by hehai on 16/11/8.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#define ROTIO  WINDOW_HEIGHT/736.0
//按比例获取高度
#define  WGiveHeight(HEIGHT) HEIGHT * [UIScreen mainScreen].bounds.size.height/568.0
//按比例获取宽度
#define  WGiveWidth(WIDTH) WIDTH * [UIScreen mainScreen].bounds.size.width/320.0
#define WINDOW_WIDTH    [[UIScreen mainScreen] bounds].size.width
#define WINDOW_HEIGHT   [[UIScreen mainScreen] bounds].size.height
#define COLOR_APP_BASIC_BK   [UIColor colorWithWhite:1 alpha:1] //===tablecell 背景色

#import "CourierCerIdCardView.h"
#import "YMHeaderView.h"
#import "Masonry.h"
#import "MainHeader.h"
#import "RealnameView.h"
#import "RealnameViewController.h"
#import "DriverRoleViewController.h"

@interface CourierCerIdCardView()
<
UITextFieldDelegate,
UIScrollViewDelegate,
YMHeaderViewDelegate
>
{
    UIImage *sourceImage;
    NSString *_filePath;
    BOOL _isUpdate;
}

@property (nonatomic, strong) YMHeaderView *picView;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *idCarNumLabel;
@property (nonatomic, strong) UILabel *noteLabel;
@property (nonatomic, strong) UITextField *userNameField;
@property (nonatomic, strong) UITextField *idCarNumField;
@property (nonatomic, strong) UIButton *passBtn;
@property (nonatomic, strong) UILabel * despLabel;//请点击此处上传身份证照片
@end

@implementation CourierCerIdCardView


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.view setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
        [self.view addSubview:self.picView];
        [self.view addSubview:self.userNameLabel];
        [self.view addSubview:self.userNameField];
        [self.view addSubview:self.idCarNumLabel];
        [self.view addSubview:self.idCarNumField];
        [self.view addSubview:self.noteLabel];
        [self.view addSubview:self.despLabel];
        [self.view addSubview:self.passBtn];
    }
    return self;
}

-(YMHeaderView *)picView{
    if (!_picView) {
        _picView = [[YMHeaderView alloc]initWithFrame:CGRectMake(WINDOW_WIDTH/2 -WGiveWidth(75), 10, WGiveWidth(200), WGiveHeight(150))];
        _picView.centerX = self.view.centerX;
        _picView.backgroundColor = [UIColor grayColor];
        _picView.layer.cornerRadius = 25;
        _picView.delagate = self;
        [_picView sd_setImageWithURL:[NSURL URLWithString:[UserManager getDefaultUser].idCardPath]
                    placeholderImage:[UIImage imageNamed:@"lizi"]];
        _picView.delagate = self;
    }
    return _picView;
}

-(UILabel *)despLabel{
    if (!_despLabel) {
        _despLabel = [[UILabel alloc]init];
        _despLabel.frame = CGRectMake(0, CGRectGetMaxY(_picView.frame)+20, WINDOW_WIDTH, 20);
        _despLabel.backgroundColor =  [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
        _despLabel.textColor = [UIColor orangeColor];
        _despLabel.font = FONT(12, NO);
        _despLabel.text = @"请点击此处上传身份证照片";
        _despLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _despLabel;
}

-(UILabel *)userNameLabel{
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc] init];
        _userNameLabel.frame = CGRectMake(WGiveWidth(20), WGiveHeight(150)+60, WGiveWidth(60), WGiveHeight(43));
        _userNameLabel.text = @"姓   名:";
        [_userNameLabel setFont:[UIFont fontWithName:@"ArialMT" size:14.0]];
    }
    return _userNameLabel;
}
-(UILabel *)idCarNumLabel{
    if (!_idCarNumLabel) {
        _idCarNumLabel = [[UILabel alloc] init];
        _idCarNumLabel.frame = CGRectMake(WGiveWidth(20), CGRectGetMaxY(_userNameField.frame)+WGiveHeight(30), WGiveWidth(60), WGiveHeight(43));
        _idCarNumLabel.text =@"身份证号:";
        [_idCarNumLabel setFont:[UIFont fontWithName:@"ArialMT" size:14.0]];
    }
    return _idCarNumLabel;
}

-(UILabel *)noteLabel{
    if (!_noteLabel) {
        _noteLabel = [[UILabel alloc] init];
        _noteLabel.frame = CGRectMake(0, CGRectGetMaxY(_idCarNumField.frame)+20, WINDOW_WIDTH, WGiveHeight(20));
        _noteLabel.backgroundColor =  [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
        _noteLabel.textColor = [UIColor orangeColor];
        _noteLabel.font = FONT(12, NO);
        _noteLabel.text = @"温馨提示：根据公安部物流寄送实名制要求,请输入真实姓名和身份证号";
        _noteLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _noteLabel;
}
-(UITextField *)userNameField{
    if (!_userNameField) {
        _userNameField = [[UITextField alloc] init];
        _userNameField.frame = CGRectMake(CGRectGetMaxX(_userNameLabel.frame), WGiveHeight(150)+60, WINDOW_WIDTH-WGiveWidth(100), WGiveHeight(43));
        _userNameField.placeholder = @"请输入真实姓名";
        _userNameField.text = [UserManager getDefaultUser].userName;
        _userNameField.layer.borderWidth = 0.0f;
        _userNameField.layer.cornerRadius = 10;
        _userNameField.textAlignment = NSTextAlignmentCenter;
        _userNameField.borderStyle = UITextBorderStyleNone;
        _userNameField.backgroundColor = [UIColor whiteColor];
        _userNameField.delegate = self;
    }
    return _userNameField;
}
-(UITextField *)idCarNumField{
    if (!_idCarNumField) {
        _idCarNumField = [[UITextField alloc] init];
        _idCarNumField.frame = CGRectMake(CGRectGetMaxX(_idCarNumLabel.frame), CGRectGetMaxY(_userNameField.frame)+WGiveHeight(30), WINDOW_WIDTH-WGiveWidth(100), WGiveHeight(43));
        _idCarNumField.placeholder = @"请输入身份证号码";
        _idCarNumField.text = [self codeStr:[UserManager getDefaultUser].idCard];
        _idCarNumField.borderStyle = UITextBorderStyleNone;
        _idCarNumField.backgroundColor = [UIColor whiteColor];
        _idCarNumField.layer.borderWidth = 0.0f;
        _idCarNumField.layer.cornerRadius = 10;
        _idCarNumField.textAlignment = NSTextAlignmentCenter;
        _idCarNumField.delegate = self;
    }
    return _idCarNumField;
}
-(UIButton *)passBtn{
    if (!_passBtn) {
        _passBtn = [[UIButton alloc] init];
        _passBtn.frame = CGRectMake(80, CGRectGetMaxY(_noteLabel.frame)+30, WINDOW_WIDTH -160, WGiveHeight(40));
         [_passBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_passBtn setTintColor:[UIColor whiteColor]];
        _passBtn.backgroundColor = [UIColor orangeColor];
        _passBtn.layer.cornerRadius =15;
        [_passBtn addTarget:self action:@selector(passBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _passBtn;
}

#pragma makr - UITextField Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - YMHeaderView Delegate
- (void)headerView:(YMHeaderView *)headerView didSelectWithImage:(UIImage *)image{
    sourceImage = image;
    [SVProgressHUD show];
    [RequestManager uploadPictureWithUserId:[UserManager getDefaultUser].userId fileName:@"id_card.png" file:image Success:^(NSDictionary *result) {
        _filePath = [([result objectForKey:@"data"][0]) valueForKey:@"filePath"];
        _isUpdate = YES;
        [SVProgressHUD showSuccessWithStatus:@"上传成功"];
    } Failed:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];

}

- (NSString *)codeStr:(NSString *)str{
    if ([[UserManager getDefaultUser].idCard isEqualToString:@""]) {
        return str;
    }
    NSString *pre = [[str substringFromIndex:0] substringToIndex:4];
    NSString *tail = [[str substringFromIndex:14] substringToIndex:4];
    NSString *str_code = [NSString stringWithFormat:@"%@***********%@",pre,tail];
    
    return str_code;
}
-(void)passBtnAction{
    if (sourceImage == nil) {
        [SVProgressHUD showInfoWithStatus:@"请上传您的身份证照片"];
        return;
    }
    if ([_userNameField.text isEmpty]) {
        [SVProgressHUD showInfoWithStatus:@"请填写正确的姓名"];
        return;
    }
    if ([_idCarNumField.text isEmpty]) {
        [SVProgressHUD showInfoWithStatus:@"请正确填写您的身份证号"];
        return;
    }
    
    if (!_isUpdate) {
        [SVProgressHUD showInfoWithStatus:@"请等待照片上传完成"];
        return;
    }
    
    
    NSString *idCardStr = [[UserManager getDefaultUser].idCard isEmpty] ?_idCarNumField.text:[UserManager getDefaultUser].idCard;
    NSString *userNameStr = _userNameField.text;
    
    self.dict = @{k_USER_ID:[UserManager getDefaultUser].userId,
                          A_CHECK_NAME:userNameStr,
                          A_CHECK_IDCARD:idCardStr,
                          A_CHECK_PATH:_filePath,
                          A_CHECK_TYPE:@"2"
                          };
    
    [_delegate courierCerIdCardHasUpdate];    
}
@end
