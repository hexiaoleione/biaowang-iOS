//
//  forgetPassWardViewController.m
//  chuanke
//
//  Created by mj on 15/11/30.
//  Copyright © 2015年 jinzelu. All rights reserved.
//

#import "forgetPassWardViewController.h"
#import "newPassWardViewController.h"
#import "MMZCViewController.h"
#import "MainHeader.h"


@interface forgetPassWardViewController ()
{
    UIView *bgView;
    //UITextField *phone;
    UITextField *code;
    UINavigationBar *customNavigationBar;
    UIButton *yzButton;
}

@property(nonatomic, copy) NSString *oUserPhoneNum;
@property(assign, nonatomic) NSInteger timeCount;
@property(strong, nonatomic) NSTimer *timer;
//验证码
@property(copy, nonatomic) NSString *smsId;
@property (nonatomic, strong) UITextField *phone;
@end

@implementation forgetPassWardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = COLOR_MainColor;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    self.title=@"找回密码1/2";
    self.view.backgroundColor=[UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(clickaddBtn)];
    [addBtn setImage:[UIImage imageNamed:@"nav_back"]];
    addBtn.tintColor=[UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:addBtn];
    
    [self createTextFields];
    
}

-(void)clickaddBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createTextFields
{
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(30, 16, self.view.frame.size.width-90, 30)];
    label.text=@"请输入您的手机号码";
    label.textColor=[UIColor grayColor];
    label.textAlignment=NSTextAlignmentLeft;
    label.font=[UIFont systemFontOfSize:13];
    
    [self.view addSubview:label];
    
    
    CGRect frame=[UIScreen mainScreen].bounds;
    bgView=[[UIView alloc]initWithFrame:CGRectMake(10, 55, frame.size.width-20, 100)];
    bgView.layer.cornerRadius=3.0;
    bgView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bgView];
    
    _phone=[self createTextFielfFrame:CGRectMake(100, 10, 200, 30) font:[UIFont systemFontOfSize:14] placeholder:@"11位手机号"];
    _phone.clearButtonMode = UITextFieldViewModeWhileEditing;
    _phone.keyboardType=UIKeyboardTypeNumberPad;
    
    code=[self createTextFielfFrame:CGRectMake(100, 60, 90, 30) font:[UIFont systemFontOfSize:14]  placeholder:@"4位数字" ];
    code.clearButtonMode = UITextFieldViewModeWhileEditing;
    code.secureTextEntry=YES;
    code.keyboardType=UIKeyboardTypeNumberPad;
    
    
    UILabel *phonelabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 12, 50, 25)];
    phonelabel.text=@"手机号";
    phonelabel.textColor=[UIColor blackColor];
    phonelabel.textAlignment=NSTextAlignmentLeft;
    phonelabel.font=[UIFont systemFontOfSize:14];
    
    UILabel *codelabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 62, 50, 25)];
    codelabel.text=@"验证码";
    codelabel.textColor=[UIColor blackColor];
    codelabel.textAlignment=NSTextAlignmentLeft;
    codelabel.font=[UIFont systemFontOfSize:14];
    
    
    yzButton=[[UIButton alloc]initWithFrame:CGRectMake(bgView.frame.size.width-100-20, 62, 110, 30)];
    [yzButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [yzButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    yzButton.titleLabel.font=[UIFont systemFontOfSize:13];
    [yzButton addTarget:self action:@selector(getValidCode:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:yzButton];
    
    UIImageView *line1=[self createImageViewFrame:CGRectMake(20, 50, bgView.frame.size.width-40, 1) imageName:nil color:[UIColor colorWithRed:180/255.0f green:180/255.0f blue:180/255.0f alpha:.3]];
    
    UIButton *landBtn=[self createButtonFrame:CGRectMake(10, bgView.frame.size.height+bgView.frame.origin.y+30,self.view.frame.size.width-20, 37) backImageName:nil title:@"下一步" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:17] target:self action:@selector(landClick)];
    landBtn.backgroundColor=COLOR_MainColor;
    landBtn.layer.cornerRadius=5.0f;
    
    
    [bgView addSubview:_phone];
    [bgView addSubview:code];
    
    [bgView addSubview:phonelabel];
    [bgView addSubview:codelabel];
    [bgView addSubview:line1];
    [self.view addSubview:landBtn];
    
}

- (void)getValidCode:(UIButton *)sender
{
    if ([_phone.text isEqualToString:@""])
    {
        [SVProgressHUD showInfoWithStatus:@"亲,请输入手机号码"];
        return;
    }
    else if (_phone.text.length <11)
    {
        [SVProgressHUD showInfoWithStatus:@"您输入的手机号码格式不正确"];
        return;
    }
    if (!sender.userInteractionEnabled) {
        return;
    }
    [RequestManager forgetSMSCodeMobile:_phone.text success:^(NSString *reslut) {
        _smsId = [NSString stringWithFormat:@"%@",reslut];
        _oUserPhoneNum =_phone.text;
    } Failed:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:error];
    }];
    
    sender.userInteractionEnabled = NO;
    self.timeCount = 180;
//    __weak forgetPassWardViewController *weakSelf = self;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reduceTime:) userInfo:sender repeats:YES];
    
   }

- (void)reduceTime:(NSTimer *)codeTimer {
    self.timeCount--;
    if (self.timeCount == 0) {
        [yzButton setTitle:@"重新获取验证码" forState:UIControlStateNormal];
        [yzButton setTitleColor:[UIColor colorWithRed:248/255.0f green:144/255.0f blue:34/255.0f alpha:1] forState:UIControlStateNormal];
        UIButton *info = codeTimer.userInfo;
        info.enabled = YES;
        yzButton.userInteractionEnabled = YES;
        [self.timer invalidate];
    } else {
        NSString *str = [NSString stringWithFormat:@"%lu秒后重新获取", self.timeCount];
        [yzButton setTitle:str forState:UIControlStateNormal];
        yzButton.userInteractionEnabled = NO;
        
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_phone resignFirstResponder];
    
}

-(UITextField *)createTextFielfFrame:(CGRect)frame font:(UIFont *)font placeholder:(NSString *)placeholder
{
    UITextField *textField=[[UITextField alloc]initWithFrame:frame];
    
    textField.font=font;
    
    textField.textColor=[UIColor grayColor];
    
    textField.borderStyle=UITextBorderStyleNone;
    
    textField.placeholder=placeholder;
    
    return textField;
}

-(UIImageView *)createImageViewFrame:(CGRect)frame imageName:(NSString *)imageName color:(UIColor *)color
{
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:frame];
    
    if (imageName)
    {
        imageView.image=[UIImage imageNamed:imageName];
    }
    if (color)
    {
        imageView.backgroundColor=color;
    }
    
    return imageView;
}

-(UIButton *)createButtonFrame:(CGRect)frame backImageName:(NSString *)imageName title:(NSString *)title titleColor:(UIColor *)color font:(UIFont *)font target:(id)target action:(SEL)action
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=frame;
    if (imageName)
    {
        [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    
    if (font)
    {
        btn.titleLabel.font=font;
    }
    
    if (title)
    {
        [btn setTitle:title forState:UIControlStateNormal];
    }
    if (color)
    {
        [btn setTitleColor:color forState:UIControlStateNormal];
    }
    if (target&&action)
    {
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return btn;
}

//验证码
-(void)landClick
{
    
    if ([_phone.text isEqualToString:@""])
    {
        [SVProgressHUD showInfoWithStatus:@"亲,请输入注册手机号码"];
        return;
    }
    else if (_phone.text.length <11)
    {
        [SVProgressHUD showInfoWithStatus:@"您输入的手机号码格式不正确"];
        return;
    }
    else if ([_phone.text isEqualToString:@""])
    {
        [SVProgressHUD showInfoWithStatus:@"亲,请输入密码"];
        return;
    }
  
    if (![code.text isEqualToString: _smsId]) {
        [SVProgressHUD showInfoWithStatus:@"验证码不正确，请重新填写!"];
        return;
    }
    newPassWardViewController *new=[[newPassWardViewController alloc]init];
    //赋值
    new.userPhone=_phone.text;
    [self.navigationController pushViewController:new animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
