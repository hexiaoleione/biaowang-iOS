//
//  FindPwdNameViewController.m
//  iwant
//
//  Created by dongba on 16/6/8.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "FindPwdNameViewController.h"
#import "MyMD5.h"
#import "changeInfoViewController.h"
@interface FindPwdNameViewController (){
     UIView * bgViewOne;
     UIView *bgViewTwo;
     UITextField * _smsCodeTextField; //验证码
     UITextField *codeFirst;  //密码
     UITextField *codeAgain;  //密码
    UIButton * smsCodeBtn;
}
@property(assign, nonatomic) NSInteger timeCount;
@property(strong, nonatomic) NSTimer *timer;
@property (nonatomic,copy)NSString * smsCode; //验证码
@end

@implementation FindPwdNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCostomeTitle:@"重置密码"];
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self initSubViews];
}

- (void)initSubViews{
     CGRect frame=[UIScreen mainScreen].bounds;
    bgViewOne = [[UIView alloc]initWithFrame:CGRectMake(16, 30, frame.size.width-32, 50)];
    bgViewOne.layer.cornerRadius = 3.0;
    bgViewOne.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgViewOne];
    UILabel *codeLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, 100, 50)];
    codeLabel.text=@"请输入验证码";
    codeLabel.textColor= UIColorFromRGB(0x666666);
    codeLabel.textAlignment=NSTextAlignmentLeft;
    codeLabel.font=[UIFont systemFontOfSize:15];
    
     _smsCodeTextField=[self createTextFielfFrame:CGRectMake(125, 10, 145, 30) font:[UIFont systemFontOfSize:13] placeholder:@""];

    smsCodeBtn = [[UIButton alloc]initWithFrame:CGRectMake(_smsCodeTextField.right, 0, bgViewOne.frame.size.width -_smsCodeTextField.right,50 )];
    smsCodeBtn.titleLabel.font = FONT(13, NO);
    smsCodeBtn.layer.cornerRadius = 3.0;
    [smsCodeBtn setBackgroundColor:UIColorFromRGB(0x63a3e3)];
    [smsCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    [smsCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [smsCodeBtn addTarget:self action:@selector(getCodeClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * changeNumBtn = [[UIButton alloc]initWithFrame:CGRectMake(_smsCodeTextField.right, bgViewOne.bottom+5, bgViewOne.frame.size.width -_smsCodeTextField.right,30 )];
    [changeNumBtn setTitleColor:UIColorFromRGB(0x63a3e3) forState:UIControlStateNormal];
    [changeNumBtn setTitle:@"更换手机号" forState:UIControlStateNormal];
    changeNumBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [changeNumBtn addTarget:self action:@selector(changeNumBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [bgViewOne addSubview:codeLabel];
    [bgViewOne addSubview:_smsCodeTextField];
    [bgViewOne addSubview:smsCodeBtn];
    [self.view addSubview:changeNumBtn];
    
    
    bgViewTwo=[[UIView alloc]initWithFrame:CGRectMake(16, 120, frame.size.width-32, 100)];
    bgViewTwo.layer.cornerRadius=3.0;
    bgViewTwo.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bgViewTwo];

    
    codeFirst=[self createTextFielfFrame:CGRectMake(100, 10, 200, 30) font:[UIFont systemFontOfSize:13] placeholder:@""];
    codeFirst.clearButtonMode = UITextFieldViewModeWhileEditing;
    codeFirst.secureTextEntry=YES;
    codeFirst.keyboardType=UIKeyboardTypeNumberPad;
    
    codeAgain=[self createTextFielfFrame:CGRectMake(100, 60, 200, 30) font:[UIFont systemFontOfSize:13]  placeholder:@"" ];
    codeAgain.clearButtonMode = UITextFieldViewModeWhileEditing;

    //密文样式
    codeAgain.secureTextEntry=YES;
    codeAgain.keyboardType=UIKeyboardTypeNumberPad;
    
    UIImageView *line1=[self createImageViewFrame:CGRectMake(20, 50, bgViewTwo.frame.size.width-40, 1) imageName:nil color:[UIColor colorWithRed:180/255.0f green:180/255.0f blue:180/255.0f alpha:.3]];
    
    
    UILabel *phonelabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, 80, 50)];
    phonelabel.text=@"设置密码";
    phonelabel.textColor=UIColorFromRGB(0x666666);
    phonelabel.textAlignment=NSTextAlignmentLeft;
    phonelabel.font=[UIFont systemFontOfSize:15];
    
    UILabel *codelabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 50, 80, 50)];
    codelabel.text=@"确认密码";
    codelabel.textColor=UIColorFromRGB(0x666666);
    codelabel.textAlignment=NSTextAlignmentLeft;
    codelabel.font=[UIFont systemFontOfSize:15];
    [bgViewTwo addSubview:codeFirst];
    [bgViewTwo addSubview:codeAgain];
    
    UIButton *landBtn=[self createButtonFrame:CGRectMake(16, bgViewTwo.frame.size.height+bgViewTwo.frame.origin.y+30,self.view.frame.size.width-32, 44) backImageName:nil title:@"完成" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:17] target:self action:@selector(sure)];
    landBtn.backgroundColor=UIColorFromRGB(0x63a3e3);
    landBtn.layer.cornerRadius=5.0f;
    
    [bgViewTwo addSubview:line1];
    [bgViewTwo addSubview:phonelabel];
    [bgViewTwo addSubview:codelabel];
    [self.view addSubview:landBtn];
}

-(void)getCodeClick:(UIButton *)sender{
    [SVProgressHUD show];
    NSString * urlStr = [NSString stringWithFormat:@"%@users/getSmscode?userId=%@",BaseUrl,[UserManager getDefaultUser].userId];
    [ExpressRequest sendWithParameters:nil MethodStr:urlStr reqType:k_GET success:^(id object) {
        [SVProgressHUD dismiss];
        NSDictionary * dict = [object valueForKey:@"data"][0] ;
        self.smsCode = [[dict objectForKey:@"code"] stringValue];
    } failed:^(NSString *error) {
        [smsCodeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
        if (_timer) {
            [_timer invalidate];
        }
        [SVProgressHUD showErrorWithStatus:error];
    }];
    sender.userInteractionEnabled = NO;
    self.timeCount = 180;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reduceTime:) userInfo:sender repeats:YES];
    
}

- (void)reduceTime:(NSTimer *)codeTimer {
    self.timeCount--;
    if (self.timeCount == 0) {
        [smsCodeBtn setTitle:@"重新发送验证码" forState:UIControlStateNormal];
        UIButton *info = codeTimer.userInfo;
        info.enabled = YES;
        smsCodeBtn.userInteractionEnabled = YES;
        [self.timer invalidate];
    } else {
        NSString *str = [NSString stringWithFormat:@"%lu S", self.timeCount];
        [smsCodeBtn setTitle:str forState:UIControlStateNormal];
        smsCodeBtn.userInteractionEnabled = NO;
    }
}
-(void)changeNumBtn{
    changeInfoViewController * vc = [[changeInfoViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)sure{
    if (![codeFirst.text isEqualToString:codeAgain.text]) {
        [SVProgressHUD showErrorWithStatus:@"两次输入的密码不相同"];
        return;
    }
    if (codeAgain.text.length!=6) {
        [SVProgressHUD showErrorWithStatus:@"密码只能是6位数字"];
        return;
    }
    if (_smsCodeTextField.text.length ==0) {
        [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
        return;
    }
    NSString * payPassword  = [MyMD5 md5:codeAgain.text];
    NSDictionary * dict = @{@"userId":[UserManager getDefaultUser].userId,
                            @"smsCode":_smsCodeTextField.text,
                            @"payPassword":payPassword};
    [ExpressRequest sendWithParameters:dict MethodStr:@"users/upDatePaypassword" reqType:k_POST success:^(id object) {
        [SVProgressHUD showSuccessWithStatus:@"密码重置成功!"];
        [self updateUser];
        [self.navigationController popViewControllerAnimated:YES];
    } failed:^(NSString *error) {
         [SVProgressHUD  showErrorWithStatus:error];
    }];
    /*
     充值支付密码
     /users/upDatePaypassword
     @POST
     参数
     Integer userId;//用户id
     Integer smsCode;//短信验证码
     String payPassword;//用户支付密码
     */
}
- (void)updateUser{
    if ([UserManager getDefaultUser].userId) {
        [RequestManager getuserinfoWithuserId:[UserManager getDefaultUser].userId success:^(NSString *reslut) {
            NSLog(@"更新信息成功");
        } Failed:^(NSString *error) {
            NSLog(@"更新失败");
        }];
    }
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

-(UITextField *)createTextFielfFrame:(CGRect)frame font:(UIFont *)font placeholder:(NSString *)placeholder
{
    UITextField *textField=[[UITextField alloc]initWithFrame:frame];
    
    textField.font=font;
    
    textField.textColor=[UIColor grayColor];
    
    textField.borderStyle=UITextBorderStyleNone;
    
    textField.placeholder=placeholder;
    
    return textField;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
