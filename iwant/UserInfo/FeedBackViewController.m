//
//  FeedBackViewController.m
//  e发快递（测试）
//
//  Created by pro on 15/9/27.
//  Copyright (c) 2015年 pro. All rights reserved.
//

#import "FeedBackViewController.h"
#import "Masonry.h"
#import "PXAlertView.h"
#import "SVProgressHUD.h"
#import "RequestManager.h"
#import "UserManager.h"
#import "User.h"
#import "QRadioButton.h"

@interface FeedBackViewController ()<UITextFieldDelegate,QRadioButtonDelegate>

{
    UITextField *_emailTextField;
    UITextView *_commentTextField;
    
    NSString *mCurrentFeedBackType ;
}

@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    mCurrentFeedBackType = @"1";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setCostomeTitle:@"意见反馈"];
    [self addhintContactWay];
}

-(void)actionSendFeedCallBack{
    
    if ([_commentTextField.text isEqualToString: @""]) {
        [SVProgressHUD showErrorWithStatus:@"反馈意见不能为空！"];
        return;
    }
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    [SVProgressHUD showWithStatus:@"正在反馈中..."];
    [RequestManager feedbackWithuserId:[UserManager getDefaultUser].userId  typeId:mCurrentFeedBackType content:_commentTextField.text Success:^(id object) {

        [SVProgressHUD showSuccessWithStatus:@"您的意见我们已经收到，我们将尽快进行处理！"];
        [self.navigationController popViewControllerAnimated:YES];
    } Failed:^(NSString *error) {
    [SVProgressHUD showErrorWithStatus:error ];
    }];
}


#pragma mark - 添加radiogroup

-(void)setUpRadioGroup{
    QRadioButton *_radio1 = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupId1"];
    _radio1.delegate = self;
    _radio1.tag = 1;
    [_radio1 setTitle:@"异常反馈" forState:UIControlStateNormal];
    [_radio1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_radio1.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
    [self.view addSubview:_radio1];
    
    [_radio1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.top.mas_equalTo(60);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
    }];
    
    
    QRadioButton *_radio2 = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupId1"];
    _radio2.tag = 2;
    _radio2.delegate = self;
    [_radio2 setTitle:@"建议和意见" forState:UIControlStateNormal];
    [_radio2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_radio2.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
    [self.view addSubview:_radio2];
    
    [_radio2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(100);
        make.top.mas_equalTo(60);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(30);
    }];
    
    
    QRadioButton *_radio3 = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupId1"];
    _radio2.tag = 3;
    _radio3.delegate = self;
    [_radio3 setTitle:@"其他" forState:UIControlStateNormal];
    [_radio3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_radio3.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
    [self.view addSubview:_radio3];
    
    [_radio3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(194);
        make.top.mas_equalTo(60);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
    }];
    
    [_radio1 setChecked:YES];
}

- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId
{
    mCurrentFeedBackType =[NSString stringWithFormat:@"%lu",(long)radio.tag];
}

UILabel *hintlablertype;

#pragma mark - 添加主体页面
-(void)addhintContactWay{
    
    hintlablertype= [[UILabel alloc]init];
    hintlablertype.textColor = [UIColor blackColor];
    hintlablertype.text = @"反馈类型";
    
    [self.view addSubview:hintlablertype];
    [hintlablertype mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(30);
        make.height.mas_equalTo(20);
        
    }];
    
    [self setUpRadioGroup];
    
    
    UILabel *_commnetField = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, 300, 200)];
    _commnetField.textColor = [UIColor blackColor];
    _commnetField.text = @"反馈内容";
    
    [self.view addSubview:_commnetField];
    [_commnetField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(100);
        make.height.mas_equalTo(20);
    }];
    
    
    _commentTextField = [[UITextView alloc]init];
    _commentTextField.font = [UIFont fontWithName:@"Arial" size:18.0];//设置字体名字和字体
    _commentTextField.layer.borderColor = [[UIColor colorWithRed:215.0 / 255.0 green:215.0 / 255.0 blue:215.0 / 255.0 alpha:1] CGColor];
    
    _commentTextField.layer.borderWidth = 0.6f;
    _commentTextField.layer.cornerRadius = 6.0f;
    [self.view addSubview:_commentTextField];
    [_commentTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.equalTo(_commnetField.mas_bottom).with.offset(10);
        make.height.mas_equalTo(80);
    }];
    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    doneBtn.layer.borderColor = COLOR_MainColor.CGColor;
    doneBtn.backgroundColor = COLOR_MainColor;
    doneBtn.layer.borderWidth = 1.0f;
    [doneBtn setTintColor:[UIColor whiteColor]];
    doneBtn.layer.cornerRadius = 5;
    [doneBtn addTarget:self action:@selector(actionSendFeedCallBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doneBtn];
    [doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(50);
        make.top.equalTo(_commentTextField.mas_bottom).with.offset(30);
    }];
}

- (void)backToMenuView
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ---textfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    return YES;
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
