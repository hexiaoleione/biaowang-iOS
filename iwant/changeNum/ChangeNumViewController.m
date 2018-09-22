//
//  ChangeNumViewController.m
//  iwant
//
//  Created by 胡一川 on 16/11/13.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "ChangeNumViewController.h"

@interface ChangeNumViewController ()

@property (nonatomic,strong) UIView * bgViewOne;
@property (nonatomic,strong) UIView * bgViewTwo;
@property (nonatomic,strong) UITextField * IDCard;
@property (nonatomic,strong) UITextField * PhoneNumNew;
@property (nonatomic,strong) UITextField * PhoneNumOld;
@property (nonatomic,strong) UITextField * passWord;
@property (nonatomic,strong) UITextField * yzmNum;
@property (nonatomic,strong) UIButton * yzmBtn;

@property(strong, nonatomic) NSTimer *timer;  //定时器
@property(assign, nonatomic) NSInteger timeCount;
@property(nonatomic, copy) NSString * rightCode;


@property (nonatomic,strong) UIButton * submitBtn;

@end

@implementation ChangeNumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configNavgationBar];
    [self creatUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)creatUI{
    self.view.backgroundColor=[UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
    
    //身份证号
    UILabel *labelCard=[[UILabel alloc]initWithFrame:CGRectMake(35, 30, self.view.frame.size.width-90, 30)];
    labelCard.text=@"请输入您注册时的信息";
    labelCard.textColor=[UIColor grayColor];
    labelCard.textAlignment=NSTextAlignmentLeft;
    labelCard.font=[UIFont systemFontOfSize:13];
    [self.view addSubview:labelCard];
    
    self.bgViewOne = [[UIView alloc] initWithFrame:CGRectMake(10, labelCard.bottom+10, SCREEN_WIDTH-20, 150)];
    self.bgViewOne.layer.cornerRadius=3.0;
    _bgViewOne.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_bgViewOne];
    
    UILabel *IDcardlabel=[[UILabel alloc]initWithFrame:CGRectMake(25, 12, 60, 30)];
    IDcardlabel.text=@"身份证号";
    IDcardlabel.textColor=[UIColor blackColor];
    IDcardlabel.textAlignment=NSTextAlignmentLeft;
    IDcardlabel.font=[UIFont systemFontOfSize:14];
    
    self.IDCard = [self createTextFielfFrame:CGRectMake(100, 10, 200, 30) font:[UIFont systemFontOfSize:14] placeholder:@"请输入18位身份证号"];
    _IDCard.clearButtonMode = UITextFieldViewModeWhileEditing;
    _IDCard.keyboardType = UIKeyboardTypeDefault;
    
    //线1
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(25, 50, _bgViewOne.width-50, 1)];
    line1.backgroundColor = [UIColor colorWithRed:180/255.0f green:180/255.0f blue:180/255.0f alpha:.3];
    
    //旧手机号
    
    UILabel * phoneNumOld = [[UILabel alloc]initWithFrame:CGRectMake(25,line1.bottom+12 , 60, 30)];
    phoneNumOld.text = @"旧手机号";
    phoneNumOld.textColor = [UIColor blackColor];
    phoneNumOld.font = [UIFont systemFontOfSize:14];
    phoneNumOld.textAlignment = NSTextAlignmentLeft;

    
    self.PhoneNumOld = [self createTextFielfFrame:CGRectMake(100,line1.bottom+10,200 , 30) font:[UIFont systemFontOfSize:14] placeholder:@"请输入11位旧手机号"];
    _PhoneNumOld.clearButtonMode = UITextFieldViewModeWhileEditing;
    _PhoneNumOld.keyboardType = UIKeyboardTypeNumberPad;
    
    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(25, 100, _bgViewOne.width-50, 1)];
    line2.backgroundColor = [UIColor colorWithRed:180/255.0f green:180/255.0f blue:180/255.0f alpha:.3];
    
    //登录密码
    self.passWord =  [self createTextFielfFrame:CGRectMake(100,line2.bottom+10,200 , 30) font:[UIFont systemFontOfSize:14] placeholder:@"请输入登录密码"];
    _passWord.clearButtonMode = UITextFieldViewModeWhileEditing;
    //密文样式
    _passWord.secureTextEntry=YES;
    _passWord.keyboardType=UIKeyboardTypeDefault;
    
    UILabel * passwordLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, line2.bottom+12, 60, 30)];
    passwordLabel.text = @"登录密码";
    passwordLabel.textColor = [UIColor blackColor];
    passwordLabel.font = [UIFont systemFontOfSize:14];
    passwordLabel.textAlignment = NSTextAlignmentLeft;
    
    [_bgViewOne addSubview:IDcardlabel];
    [_bgViewOne addSubview:self.IDCard];
    [_bgViewOne addSubview:line1];
    [_bgViewOne addSubview:phoneNumOld];
    [_bgViewOne addSubview:_PhoneNumOld];
    [_bgViewOne addSubview:line2];
    [_bgViewOne addSubview:passwordLabel];
    [_bgViewOne addSubview:_passWord];
    
//    要更换的新手机号
    UILabel *inputNewTel = [[UILabel alloc] initWithFrame:CGRectMake(35, _bgViewOne.bottom+10, self.view.frame.size.width-90, 30)];
    inputNewTel.text = @"请输入您要绑定的新手机号";
    inputNewTel.font = [UIFont systemFontOfSize:13];
    inputNewTel.textColor = [UIColor grayColor];
    [self.view addSubview:inputNewTel];
    
    self.bgViewTwo = [[UIView alloc] initWithFrame:CGRectMake(_bgViewOne.x, inputNewTel.bottom+10, _bgViewOne.width, 100)];
    _bgViewTwo.backgroundColor = [UIColor whiteColor];
    self.bgViewTwo.layer.cornerRadius=3.0;
    [self.view addSubview:_bgViewTwo];
    
    self.PhoneNumNew = [self createTextFielfFrame:CGRectMake(100, 10,200 , 30) font:[UIFont systemFontOfSize:14] placeholder:@"请输入11位新手机号"];
    _PhoneNumNew.clearButtonMode = UITextFieldViewModeWhileEditing;
    _PhoneNumNew.keyboardType = UIKeyboardTypeNumberPad;
   
    
    UILabel * phoneNumNew = [[UILabel alloc]initWithFrame:CGRectMake(25, 12, 60, 30)];
    phoneNumNew.text = @"新手机号";
    phoneNumNew.textColor = [UIColor blackColor];
    phoneNumNew.font = [UIFont systemFontOfSize:14];
    phoneNumNew.textAlignment = NSTextAlignmentLeft;


    UIView * line3 = [[UIView alloc]initWithFrame:CGRectMake(25, 50, _bgViewOne.width-50, 1)];
    line3.backgroundColor = [UIColor colorWithRed:180/255.0f green:180/255.0f blue:180/255.0f alpha:.3];
    
    UILabel * yzmLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, line3.bottom+12, 60, 30)];
    yzmLabel.text= @"验证码";
    yzmLabel.textColor = [UIColor blackColor];
    yzmLabel.font = [UIFont systemFontOfSize:14];
    yzmLabel.textAlignment = NSTextAlignmentLeft;
    
    _yzmNum = [self createTextFielfFrame:CGRectMake(100, 60, 90, 30) font:[UIFont systemFontOfSize:14] placeholder:@"4位数字"];
    _yzmNum.clearButtonMode = UITextFieldViewModeWhileEditing;
    //密文样式
    _yzmNum.secureTextEntry=YES;
    _yzmNum.keyboardType=UIKeyboardTypeNumberPad;
    
    _yzmBtn = [[UIButton alloc]initWithFrame:CGRectMake(_bgViewTwo.width-100-20, 62, 110, 30)];
    [_yzmBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_yzmBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _yzmBtn.titleLabel.font=[UIFont systemFontOfSize:13];
    [_yzmBtn addTarget:self action:@selector(getValidCode:) forControlEvents:UIControlEventTouchUpInside];
    
    [_bgViewTwo addSubview:phoneNumNew];
    [_bgViewTwo addSubview:_PhoneNumNew];
    [_bgViewTwo addSubview:line3];
    [_bgViewTwo addSubview:yzmLabel];
    [_bgViewTwo addSubview:_yzmNum];
    [_bgViewTwo addSubview:_yzmBtn];
    
    _submitBtn  = [[UIButton alloc]init];
    _submitBtn.width = SCREEN_WIDTH*2/3;
    _submitBtn.height = 40;
    _submitBtn.centerX = SCREEN_WIDTH/2;
    _submitBtn.y = _bgViewTwo.bottom + 30;
//    _submitBtn.backgroundColor = [UIColor orangeColor];
//    [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
//    [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitBtn setImage:[UIImage imageNamed:@"Fa_submit"] forState:UIControlStateNormal];
    [_submitBtn addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    _submitBtn.layer.cornerRadius = 8;
    _submitBtn.clipsToBounds = YES;
    [self.view addSubview:_submitBtn];
}
//点击获取验证码
- (void)getValidCode:(UIButton *)sender
{
    if ([_IDCard.text isEqualToString:@""]||(_IDCard.text.length !=18))
    {
        [SVProgressHUD showInfoWithStatus:@"请输入正确格式的身份证号"];
        return;
    }
    if (_PhoneNumOld.text.length != 11) {
        [SVProgressHUD showInfoWithStatus:@"请输入正确格式的手机号"];
        return ;
    }
    if (_PhoneNumNew.text.length != 11) {
        [SVProgressHUD showInfoWithStatus:@"请输入正确格式的手机号"];
        return ;
    }

    if (!sender.userInteractionEnabled) {
        return;
    }
    
    [SVProgressHUD show];
    [RequestManager getNewMobileCode:_PhoneNumNew.text success:^(NSString *reslut) {
        self.rightCode = (NSString *)reslut;
        [SVProgressHUD dismiss];
        NSLog(@"%@",reslut);
        sender.userInteractionEnabled = NO;
        self.timeCount = 180;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reduceTime:) userInfo:sender repeats:YES];

    } Failed:^(NSString *error) {
        [_yzmBtn setTitle:@"重新获取验证码" forState:UIControlStateNormal];
          if (_timer) {
            [_timer invalidate];
           }
          [SVProgressHUD showErrorWithStatus:error];
    }];
    
}

- (void)reduceTime:(NSTimer *)codeTimer {
    self.timeCount--;
    if (self.timeCount == 0) {
        [_yzmBtn setTitle:@"重新获取验证码" forState:UIControlStateNormal];
        [_yzmBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        UIButton *info = codeTimer.userInfo;
        info.enabled = YES;
        _yzmBtn.userInteractionEnabled = YES;
        [self.timer invalidate];
    } else {
        NSString *str = [NSString stringWithFormat:@"%ld秒后重新获取", (long)self.timeCount];
        [_yzmBtn setTitle:str forState:UIControlStateNormal];
        _yzmBtn.userInteractionEnabled = NO;
        
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_PhoneNumNew resignFirstResponder];
    
}


-(void)submit:(UIButton *)submitBtn{
    
    
    NSString * password = [_passWord.text MD5];
    // 提交信息

    if ([_yzmNum.text isEqualToString:self.rightCode]) {
    
        [RequestManager changeNewMobileWithUserId:[UserManager getDefaultUser].userId oldPassword:password mobile:_PhoneNumOld.text newMobile:_PhoneNumNew.text idCode:_IDCard.text success:^(NSString *reslut) {
            [SVProgressHUD showSuccessWithStatus:@"恭喜您，修改手机号成功"];
            [self backToMenuView];
        } Failed:^(NSString *error) {
            [SVProgressHUD showErrorWithStatus:error];
        }];

    }else{
        [SVProgressHUD showInfoWithStatus:@"请输入正确的验证码"];
    }
}

- (void)configNavgationBar {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 60)];
    label.textColor = [UIColor blackColor];
    label.text = @"修改手机号";
    label.textAlignment = 1;
    self.navigationItem.titleView = label;
    self.view.backgroundColor=[UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
    NSString *imageName = @"home_btn_selection";
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(backToMenuView)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}
-(void)backToMenuView{
    [self.navigationController popViewControllerAnimated:YES];
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

@end
