//
//  UserNameViewController.m
//  iwant
//
//  Created by pro on 16/3/8.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "UserNameViewController.h"
#import "YMHeaderView.h"
#import "Masonry.h"
#import "MainHeader.h"
#import "RealnameView.h"
#import "RealnameViewController.h"

#define ROTIO  WINDOW_HEIGHT/736.0
//按比例获取高度
#define  WGiveHeight(HEIGHT) HEIGHT * [UIScreen mainScreen].bounds.size.height/568.0

//按比例获取宽度
#define  WGiveWidth(WIDTH) WIDTH * [UIScreen mainScreen].bounds.size.width/320.0
#define WINDOW_WIDTH    [[UIScreen mainScreen] bounds].size.width
#define WINDOW_HEIGHT   [[UIScreen mainScreen] bounds].size.height
#define COLOR_APP_BASIC_BK   [UIColor colorWithWhite:1 alpha:1] //===tablecell 背景色

#define Start_X          WINDOW_WIDTH/4/4          // 第一个按钮的X坐标
#define Start_Y          32.0f     // 第一个按钮的Y坐标
#define Width_Space      WINDOW_WIDTH/4/4      // 2个按钮之间的横间距
#define Height_Space     16.0f     // 竖间距
#define Button_Height    30.0f    // 高
#define Button_Width    WINDOW_WIDTH/4 + 5    // 宽

@interface UserNameViewController ()<UITextFieldDelegate,UIScrollViewDelegate,YMHeaderViewDelegate>
{
    
    UIScrollView *_backScrollView;
    //车的类型
    UIButton * carTypeBtn;
    //提示选择车型
    UILabel * carTypeL;
    //车型字符串
    NSString * _carTypeStr;
    //当前选中btn
    UIButton * _currentBtn;
    //头像
    YMHeaderView *_headImageView;
    
    //姓名
    UILabel *_nameLabel;
    UITextField *_nameField;
    
    //身份证号
    UILabel *_idCardNumbereLabel;
    UITextField *_idCardNumbereField;
    
  //提示语
    UILabel *_regsiteInfoLabel;
    
    UIButton *_ChangeBtn;
    UIButton *_DoneBtn;
    
    //是否上传照片
    BOOL _isUpdate;
    NSString *_filePath;
    NSString *_midStr;//身份证号的星星代表的东西
}

@end

@implementation UserNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavgationBar];
    [self CreatView];
    [self fill];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
}
- (void)fill{
    if ([[UserManager getDefaultUser].realManAuth isEqualToString:@"Y"]) {
        _nameField.text = [UserManager getDefaultUser].userName;
//        _nameField.enabled = NO;
        _idCardNumbereField.text = [self codeStr:[UserManager getDefaultUser].idCard];
        _idCardNumbereField.text = [UserManager getDefaultUser].idCard;
//        _idCardNumbereField.enabled = NO;
    }
}
//把身份证加星
- (NSString *)codeStr:(NSString *)str{
    if ([[UserManager getDefaultUser].idCard isEqualToString:@""]) {
        return str;
    }
    NSString *pre = [[str substringFromIndex:0] substringToIndex:4];
    _midStr = [[str substringFromIndex:4] substringToIndex:10];
    NSString *tail = [[str substringFromIndex:14] substringToIndex:4];
    NSString *str_code = [NSString stringWithFormat:@"%@***********%@",pre,tail];
    
    return str_code;
}
//身份证去星号加密
- (NSString *)deCodeStr:(NSString *)str{
    NSString *pre = [[str substringFromIndex:0] substringToIndex:4];
    NSString *tail = [[str substringFromIndex:14] substringToIndex:4];
    
    NSString *str_code = [NSString stringWithFormat:@"%@%@%@",pre,_midStr,tail];
    return str_code;
}

//点击return 按钮 去掉
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)CreatView
{
    _backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, 1000)];
    _backScrollView.contentSize = CGSizeMake(WINDOW_WIDTH, 900);
    _backScrollView.delegate =self;
    _backScrollView.autoresizesSubviews = NO;
    _backScrollView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    _backScrollView.showsVerticalScrollIndicator = YES;
    
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, 1000)];
    
    contentView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    
    [_backScrollView addSubview:contentView];
    [self.view addSubview:_backScrollView];
    
    carTypeL = [[UILabel alloc]initWithFrame:CGRectMake(Start_X, 10, 200, 16)];
    carTypeL.font = [UIFont systemFontOfSize:15];
    carTypeL.textColor = [UIColor redColor];
    carTypeL.text =@"请先选择您的车型";
    [contentView addSubview:carTypeL];

    NSArray * titleArr = @[@"小货车",@"中货车",@"小面包",@"中面包",@"家用轿车",@"其他"];
      //选择车型再认证
    for (int i = 0 ; i < 6; i++) {
        NSInteger index = i % 3;
        NSInteger page = i / 3;
        // 圆角按钮
        carTypeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        carTypeBtn.tag = i;//这句话不写等于废了
        carTypeBtn.frame = CGRectMake(index * (Button_Width + Width_Space) + Start_X, page  * (Button_Height + Height_Space)+Start_Y, Button_Width, Button_Height);
        carTypeBtn.backgroundColor = [UIColor whiteColor];
        carTypeBtn.layer.cornerRadius = 8;
        carTypeBtn.layer.masksToBounds = YES;
        [carTypeBtn setImage:[[UIImage imageNamed:@"yuanLmg"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [carTypeBtn setTitle:titleArr[i] forState:UIControlStateNormal];
        carTypeBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [carTypeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        carTypeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 8, 0,Button_Width-Button_Height);
        carTypeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0 ,0, 0);
        [contentView addSubview:carTypeBtn];
        //如果不是认证镖师不需要选择车型
        if (self.courentbtnTag != 2) {
            carTypeBtn.hidden = YES;
        }
        
        //按钮点击方法
        [carTypeBtn addTarget:self action:@selector(carTypeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }

    _headImageView = [[YMHeaderView alloc]initWithFrame:CGRectMake(WINDOW_WIDTH/2 -WGiveWidth(75), Start_Y+ Height_Space + Button_Height*2 + 10, WGiveWidth(200), WGiveHeight(150))];
    _headImageView.centerX = self.view.centerX;
    _headImageView.backgroundColor = [UIColor grayColor];
    _headImageView.layer.cornerRadius = 25;
    _headImageView.delagate = self;
    if (self.courentbtnTag ==2) {
         [_headImageView sd_setImageWithURL:[NSURL URLWithString:[UserManager getDefaultUser].idCardPath] placeholderImage:[UIImage imageNamed:@"personJsz"]];
    }else{
     [_headImageView sd_setImageWithURL:[NSURL URLWithString:[UserManager getDefaultUser].idCardPath] placeholderImage:[UIImage imageNamed:@"lizi"]];
    }
    [contentView addSubview:_headImageView];
    if (self.courentbtnTag != 2) {
        _headImageView.y = 16;
        carTypeL.hidden = YES;
        carTypeBtn.hidden = YES;
    }

    _ChangeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_headImageView.frame)+10, WINDOW_WIDTH, WGiveHeight(30))];
    if (self.courentbtnTag == 2) {
        [_ChangeBtn setTitle:@"上传身份证或者驾照" forState:UIControlStateNormal];
    }else{
        [_ChangeBtn setTitle:@"请点击此处上传身份证照片" forState:UIControlStateNormal];
    }
    _ChangeBtn.titleLabel.font = [UIFont systemFontOfSize: 12.0];
    [_ChangeBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_ChangeBtn addTarget:self action:@selector(changeHeadImage) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:_ChangeBtn];

 //姓名
    _nameLabel =[[UILabel alloc]initWithFrame:CGRectMake(WGiveWidth(20), CGRectGetMaxY(_ChangeBtn.frame)+10, WGiveWidth(60), WGiveHeight(43))];
    _nameLabel.text =@"姓   名:";
    [_nameLabel setFont:[UIFont fontWithName:@"ArialMT" size:14.0]];
    [contentView addSubview:_nameLabel];


    _nameField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_nameLabel.frame), CGRectGetMaxY(_ChangeBtn.frame)+10, WINDOW_WIDTH-WGiveWidth(100), WGiveHeight(43))];
    _nameField.placeholder = @"请输入真实姓名";
    _nameField.layer.borderWidth = 0.0f;
    _nameField.layer.cornerRadius = 10;
    _nameField.textAlignment = NSTextAlignmentCenter;
    _nameField.borderStyle = UITextBorderStyleNone;
    _nameField.backgroundColor = [UIColor whiteColor];
    _nameField.delegate = self;
    [contentView addSubview:_nameField];

//身份证
    _idCardNumbereLabel =[[UILabel alloc]initWithFrame:CGRectMake(WGiveWidth(20), CGRectGetMaxY(_nameField.frame)+WGiveHeight(20), WGiveWidth(60), WGiveHeight(43))];
    _idCardNumbereLabel.text =@"身份证号:";
    [_idCardNumbereLabel setFont:[UIFont fontWithName:@"ArialMT" size:14.0]];
    [contentView addSubview:_idCardNumbereLabel];


    _idCardNumbereField =  [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_idCardNumbereLabel.frame), CGRectGetMaxY(_nameField.frame)+WGiveHeight(20), WINDOW_WIDTH-WGiveWidth(100), WGiveHeight(43))];
    _idCardNumbereField.placeholder = @"请输入身份证号码";
    _idCardNumbereField.borderStyle = UITextBorderStyleNone;
    _idCardNumbereField.backgroundColor = [UIColor whiteColor];
    _idCardNumbereField.layer.borderWidth = 0.0f;
    _idCardNumbereField.layer.cornerRadius = 10;
    _idCardNumbereField.textAlignment = NSTextAlignmentCenter;
    _idCardNumbereField.delegate = self;
    [contentView addSubview:_idCardNumbereField];
  
   //提示语
    
        _regsiteInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_idCardNumbereField.frame)+20, WINDOW_WIDTH, WGiveHeight(20))];
        _regsiteInfoLabel.backgroundColor =  [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
        _regsiteInfoLabel.textColor = [UIColor redColor];
        _regsiteInfoLabel.font = FONT(12, NO);
        _regsiteInfoLabel.text = @"温馨提示：根据公安部发快递实名制要求,请输入真实姓名和身份证号";
        _regsiteInfoLabel.textAlignment = NSTextAlignmentCenter;
        [contentView addSubview:_regsiteInfoLabel];
    
        UILabel *label = [UILabel new];
        label.font = FONT(13, NO);
        label.textAlignment  = NSTextAlignmentCenter;
        label.textColor = [UIColor redColor];
        label.frame = CGRectMake(0, CGRectGetMaxY(_regsiteInfoLabel.frame), WINDOW_WIDTH, WGiveHeight(20));
        [self.view addSubview:label];
    
//确定
    
    _DoneBtn = [[UIButton alloc]initWithFrame:CGRectMake(WGiveHeight(30), CGRectGetMaxY(_regsiteInfoLabel.frame)+16, WINDOW_WIDTH - WGiveHeight(60), WGiveHeight(40))];
    
        if ((self.courentbtnTag == 2)) {
            [_DoneBtn setTitle:@"完成" forState:UIControlStateNormal];
            _DoneBtn.tag = 0;
        }
        else
        {
            _DoneBtn.tag = 1;
            NSLog(@"%d",self.courentbtnTag);
            [_DoneBtn setTitle:@"下一步" forState:UIControlStateNormal];
        }
    
    _DoneBtn.layer.borderWidth = 0.0f;
    [_DoneBtn setTintColor:[UIColor whiteColor]];
    _DoneBtn.backgroundColor = COLOR_MainColor;
    _DoneBtn.layer.cornerRadius =15;
    [_DoneBtn addTarget:self action:@selector(doneBtn) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:_DoneBtn];
}

-(void)nextBtn
{
    if (self.courentbtnTag == 2) {
        NSLog(@"镖师认证");
        RealnameViewController *VC = [[RealnameViewController alloc]init];
   
        [self.navigationController pushViewController:VC animated:YES];
        
    }
    else if (self.courentbtnTag == 3)
    {
        NSLog(@"快递员认证");
    }
    else if (self.courentbtnTag == 4)
    {
        NSLog(@"物流公司认证");
    }
}

-(void)doneBtn
{
    
    if (![_nameField.text isValidUserName]) {
        [SVProgressHUD showInfoWithStatus:@"请填写正确的姓名"];
        return;
    }
    if (![_idCardNumbereField.text isValidIDCardNumber]) {
        [SVProgressHUD showInfoWithStatus:@"请正确填写您的身份证号"];
        return;
    }
    if (_filePath == nil ) {
        [SVProgressHUD showInfoWithStatus:@"请上传您的证件照片"];
        return;
    }
//    NSString *idcard = _idCardNumbereField.text;
//    if (!_midStr) {
//        idcard = _idCardNumbereField.text;
//    }
//
    [SVProgressHUD showWithStatus:@"正在提交信息"];
    if (_courentbtnTag == 2) {
        if(_carTypeStr.length == 0 || [_carTypeStr isEqualToString:@""]){
            [SVProgressHUD showInfoWithStatus:@"请先选择您的车型"];
            return;
        }
        
        NSDictionary *dic = @{k_USER_ID:[UserManager getDefaultUser].userId,
                              A_CHECK_NAME:_nameField.text,
                              A_CHECK_IDCARD:_idCardNumbereField.text,
                              A_CHECK_PATH:_filePath,
                              A_CHECK_TYPE:@"2",
                              @"carType":_carTypeStr
                              };
        [[NSUserDefaults standardUserDefaults] setObject:_nameField.text forKey:@"linshiName"];
        [ExpressRequest sendWithParameters:dic
                                 MethodStr:API_COURIER_CHECK
                                   reqType:k_POST
                                   success:^(id object) {
                                       
                                    if (_isRegist) {
                                        [self dismissViewControllerAnimated:YES completion:nil];
                                    }
                                    [SVProgressHUD showSuccessWithStatus:@"申请成功,我们会在24小时内审核完毕"];
                                    [self.navigationController popToRootViewControllerAnimated:YES];
                                   }
                                    failed:^(NSString *error) {
                                        [SVProgressHUD showErrorWithStatus:error];
                                    }];

    }else{
        //快递员认证 分界面分开把信息传给后台
        NSDictionary *dic = @{k_USER_ID:[UserManager getDefaultUser].userId,
                              A_CHECK_NAME:_nameField.text,
                              A_CHECK_IDCARD:_idCardNumbereField.text,
                              A_CHECK_PATH:_filePath,
                              A_CHECK_TYPE:@"1",
                              @"carType":@"courier"
                              };
        [SVProgressHUD show];
        [ExpressRequest sendWithParameters:dic
                                 MethodStr:API_COURIER_CHECK
                                   reqType:k_POST
                                   success:^(id object) {
                                       [SVProgressHUD showSuccessWithStatus:@"上传信息成功"];
                                       [self goFillInfo];
                                   }
                                    failed:^(NSString *error) {
                                        [SVProgressHUD showErrorWithStatus:error];
                                    }];
    }
}

- (void)goFillInfo{
    //2-镖师认证 3-快递员认证
    switch (_courentbtnTag) {
        case 2:
        {
            RealnameViewController *VC = [RealnameViewController new];
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case 3:
        {
          
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - btn action

- (void)changeHeadImage
{
    [_headImageView imageTaped:nil];

}

-(void)headerView:(YMHeaderView *)headerView didSelectWithImage:(UIImage *)image{
    [SVProgressHUD show];
    [RequestManager uploadPictureWithUserId:[UserManager getDefaultUser].userId fileName:@"id_card.png" file:image Success:^(NSDictionary *result) {
         _filePath = [([result objectForKey:@"data"][0]) valueForKey:@"filePath"];
        _isUpdate = YES;
        [SVProgressHUD showSuccessWithStatus:@"上传成功"];
    } Failed:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
}
- (void)configNavgationBar {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 60)];
    label.textColor = [UIColor whiteColor];
    if (_courentbtnTag == 3) {
        label.text = @"快递员认证";
    }else{
        label.text = @"镖师认证";
    }
    
    label.textAlignment = NSTextAlignmentCenter;
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
    if (_isRegist) {
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:ISLOGIN object:nil];
        }];
    }
    [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark ----- 选择车型按钮点击
-(void)carTypeBtnClick:(UIButton *)sender{
    [_currentBtn setImage:[[UIImage imageNamed:@"yuanLmg"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    _currentBtn = sender;
    [sender setImage:[[UIImage imageNamed:@"xuanzhongLmg"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
/*
 //车型  smallTruck  小货车  middleTruck  中货车   smallMinibus  小面包
 // middleMinibus  中面包   car 家用轿车    else 其他车型
 */
    switch (sender.tag) {
        case 0:{
         _carTypeStr =@"smallTruck";

        }
            break;
        case 1:{
         _carTypeStr =@"middleTruck";
        }
            break;
        case 2:{
         _carTypeStr =@"smallMinibus";
        }
            break;
        case 3:{
         _carTypeStr =@"middleMinibus";
        }
            break;
        case 4:{
         _carTypeStr =@"car";
        }
            break;
        case 5:{
         _carTypeStr =@"else";
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
