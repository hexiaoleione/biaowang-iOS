//
//  settinhHeaderViewController.m
//  chuanke
//
//  Created by mj on 15/11/30.
//  Copyright © 2015年 jinzelu. All rights reserved.
//

#import "settinhHeaderViewController.h"
#import "MMZCViewController.h"
#import "MainHeader.h"
#import "ChangeNumViewController.h"
#import "changeInfoViewController.h"//修改个人信息

#define WINDOW_WIDTH                [[UIScreen mainScreen] bounds].size.width
#define WINDOW_HEIGHT               [[UIScreen mainScreen] bounds].size.height

//按比例获取高度
#define  WGiveHeight(HEIGHT) HEIGHT * [UIScreen mainScreen].bounds.size.height/736.0

//按比例获取宽度
#define  WGiveWidth(WIDTH) WIDTH * [UIScreen mainScreen].bounds.size.width/414.0


@interface settinhHeaderViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>
{
    UIView *bgView;
    UIView *bgView1;
    UITextField *username;   //昵称
    UITextField *cardNo;//身份证号
    NSString *_filePath;
    
    NSString *_midStr;//身份证号的星星代表的东西
}
@property (nonatomic,strong) YMHeaderView *head; //头像
//@property (nonatomic,strong) YMHeaderView *IDCard; //身份证照片


@end

@implementation settinhHeaderViewController

- (NSString *)codeStr:(NSString *)str{
    if ([[UserManager getDefaultUser].idCard isEqualToString:@""]) {
        return str;
    }
    NSString *pre = [[str substringFromIndex:0] substringToIndex:4];
    _midStr = [[str substringFromIndex:4] substringToIndex:10];
    NSString *tail = [[str substringFromIndex:14] substringToIndex:[UserManager getDefaultUser].idCard.length-14];
    NSString *str_code = [NSString stringWithFormat:@"%@***********%@",pre,tail];
    
    return str_code;
}
//身份证去星
- (NSString *)deCodeStr:(NSString *)str{
    NSString *pre = [[str substringFromIndex:0] substringToIndex:4];
    NSString *tail = [[str substringFromIndex:14] substringToIndex:[UserManager getDefaultUser].idCard.length-14];
    
    NSString *str_code = [NSString stringWithFormat:@"%@%@%@",pre,_midStr,tail];
    return str_code;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    [self createTextFields];
    [self configNavgationBar];
}

-(void)createTextFields
{
    CGRect frame=[UIScreen mainScreen].bounds;
    bgView=[[UIView alloc]initWithFrame:CGRectMake(0, WGiveHeight(270),frame.size.width, WGiveHeight(50))];
    //bgView.layer.cornerRadius=3.0;
    bgView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bgView];
    
    username=[self createTextFielfFrame:CGRectMake(10, WGiveHeight(10), self.view.frame.size.width-20, WGiveHeight(30)) font:[UIFont systemFontOfSize:14] placeholder:@"请输入真实姓名"];
    username.textAlignment=NSTextAlignmentCenter;
    username.clearButtonMode = UITextFieldViewModeWhileEditing;
    username.text = [UserManager getDefaultUser].userName;
    
    
    
    cardNo=[self createTextFielfFrame:CGRectMake(10, WGiveHeight(10), self.view.frame.size.width-20, WGiveHeight(30)) font:[UIFont systemFontOfSize:14] placeholder:@"请输入身份证号"];
    cardNo.textAlignment=NSTextAlignmentCenter;
    cardNo.clearButtonMode = UITextFieldViewModeWhileEditing;
    if ([UserManager getDefaultUser].idCard.length > 0) {
        cardNo.text = [self codeStr:[UserManager getDefaultUser].idCard];
    }
    cardNo.delegate = self;
    
    
    bgView1=[[UIView alloc]initWithFrame:CGRectMake(0, WGiveHeight(330),frame.size.width, WGiveHeight(50))];
    //bgView.layer.cornerRadius=3.0;
    bgView1.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bgView1];
    
    
    UIButton *landBtn=[self createButtonFrame:CGRectMake(10, bgView.frame.size.height+bgView.frame.origin.y+WGiveHeight(80),(self.view.frame.size.width-20)/2, WGiveHeight(40)) backImageName:nil title:@"完成" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:17] target:self action:@selector(landClick)];
    landBtn.centerX = SCREEN_WIDTH/2;
    landBtn.backgroundColor= UIColorFromRGB(0x222231);
    landBtn.layer.cornerRadius=5.0f;
    
    
    UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wenxin_img"]];
    imageV.frame = CGRectMake(10, CGRectGetMaxY(landBtn.frame)+20, self.view.frame.size.width-20, WGiveHeight(90));
    
    [bgView addSubview:username];
    
    [bgView1 addSubview:cardNo];
    
    [self.view addSubview:landBtn];
    
//    [self.view addSubview:imageV];
    
    //判断是否实名认证
    if ([[UserManager getDefaultUser].realManAuth isEqualToString:@"Y"]) {
        self.head.userInteractionEnabled = NO;
    }
    if ([UserManager getDefaultUser].completed) {
        username.userInteractionEnabled = NO;
        cardNo.userInteractionEnabled = NO;
    }
}

-(void)landClick
{
    NSString *cardNOStr = nil;
    if ([cardNo.text rangeOfString:@"*"].length >0) {
        cardNOStr = [UserManager getDefaultUser].idCard;
    }else{
        cardNOStr = cardNo.text;
    }
//    if (_filePath.length<=0) {
//        [SVProgressHUD showInfoWithStatus:@"请上传身份证照片"];
//        return;
//    }
    if (![username.text isValidUserName]) {
        [SVProgressHUD showInfoWithStatus:@"请填写正确的姓名"];
        return;
    }
    if (![cardNOStr isValidIDCardNumber]) {
        [SVProgressHUD showInfoWithStatus:@"请正确填写您的身份证号"];
        return;
    }
    [SVProgressHUD show];
    
    [RequestManager userInfoWithUserId:[UserManager getDefaultUser].userId
                              userName:username.text
                                idCard:cardNOStr
                               idCardPath:_filePath ? _filePath : [UserManager getDefaultUser].idCardPath
                               Success:^(id object) {
                                   [SVProgressHUD dismiss];
                                   NSString *message = [object valueForKey:@"message"];
                                   [SVProgressHUD showSuccessWithStatus:message];
                                   if (_isRegist) {
                                       [self dissmissView];
                                       return ;
                                   }

        } Failed:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
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

-(void)clickaddBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createUI
{
    UIImageView *bg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, WGiveHeight(250))];
    [bg setImage:[UIImage imageNamed:@"mycenter_bg.png"]];
    bg.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bg];
    
    _head = [[YMHeaderView alloc]initWithFrame:CGRectMake(WGiveWidth(60), WGiveHeight(44), WGiveWidth(320), WGiveHeight(200))];
    _head.centerX = self.view.centerX;
    _head.backgroundColor = [UIColor grayColor];
    _head.layer.cornerRadius = 10;
    _head.delagate = self;
    [_head sd_setImageWithURL:[NSURL URLWithString:[UserManager getDefaultUser].idCardPath] placeholderImage:[UIImage imageNamed:@"lizi"]];
    [self.view addSubview:_head];
    
    
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width-WGiveWidth(80))/2, WGiveHeight(180), WGiveWidth(100), WGiveHeight(80))];
    label.centerX = self.view.centerX;
//    label.text=@"露个脸呗~";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor=[UIColor whiteColor];
    label.font=[UIFont systemFontOfSize:13];
    [self.view addSubview:label];
}



-(void)changeHeadView1:(UIButton *)tap
{
    
    UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:@"更改图像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册上传", nil];
    menu.delegate=self;
    menu.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [menu showInView:self.view];
    
}

- (void)headerView:(YMHeaderView *)headerView didSelectWithImage:(UIImage *)image{
    //设置头像
    [_head setImage:image];
    //上传头像
    [self updatePhotoFor:image];
}

//*************************代理方法*******************************
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //NSLog(@"index:%zd",buttonIndex);
    //0->拍照，1->相册
    
    if (buttonIndex == 0) {
        [self snapImage];
    } else if (buttonIndex == 1) {
        [self localPhoto];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //完成选择
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //NSLog(@"type:%@",type);
    if ([type isEqualToString:@"public.image"]) {
        //转换成NSData
        UIImage *image =  [info objectForKey:UIImagePickerControllerEditedImage];
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:^{
            //设置头像
            [_head setImage:image];
                        //上传头像
            [self updatePhotoFor:image];
        }];
        
    }
}

-(void)updatePhotoFor:(UIImage *)image{
        [SVProgressHUD show];
        [RequestManager uploadPictureWithUserId:[UserManager getDefaultUser].userId fileName:@"id_card.png" file:image Success:^(NSDictionary *result) {
            _filePath = [([result objectForKey:@"data"][0]) valueForKey:@"filePath"];
            [SVProgressHUD showSuccessWithStatus:@"上传成功"];
        } Failed:^(NSString *error) {
            [SVProgressHUD showErrorWithStatus:error];
        }];
}





#pragma mark --头像上传
-(void)updatePhoto:(NSString *)base64Str
{
}

//*****************************拍照**********************************
- (void) snapImage
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        __block UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
        ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
        ipc.delegate = (id)self;
        ipc.allowsEditing = YES;
        ipc.navigationBar.barTintColor =[UIColor whiteColor];
        ipc.navigationBar.tintColor = [UIColor whiteColor];
//        ipc.navigationBar.titleTextAttributes = @{UITextAttributeTextColor:[UIColor whiteColor]};
        [self presentViewController:ipc animated:YES completion:^{
            ipc = nil;
        }];
    } else {
        NSLog(@"模拟器无法打开照相机");
    }
}

#define CommonThimeColor HEXCOLOR(0x11a0ee)
-(void)localPhoto
{
    __block UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = (id)self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    picker.navigationBar.barTintColor =[UIColor whiteColor];
    picker.navigationBar.tintColor = [UIColor blackColor];
//  picker.navigationBar.titleTextAttributes = @{UITextAttributeTextColor:[UIColor blackColor]};
    [self presentViewController:picker animated:YES completion:^{
        picker = nil;
    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)configNavgationBar {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 60)];
    label.textColor = [UIColor blackColor];
    label.text = @"完善实名信息";
    label.textAlignment = 1;
    self.navigationItem.titleView = label;
    self.view.backgroundColor=[UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
    NSString *imageName = @"home_btn_selection";
    if (_isRegist) {
        label.textColor = [UIColor orangeColor];;
        imageName = @"goback_back_orange_on";
        self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
        self.navigationController.navigationBar.translucent = NO;
    }
    
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(backToMenuView)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;

    if (_isRegist) {
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"跳过" style:UIBarButtonItemStylePlain target:self action:@selector(dissmissView)];
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    }
   
}
-(void)changeInfo{
    changeInfoViewController * changeInfoVC = [[changeInfoViewController alloc]init];
    [self.navigationController pushViewController:changeInfoVC animated:YES];

}

-(void)dissmissView
{
    NSLog(@"跳到主界面");
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:ISLOGIN object:nil];
    
}
- (void)backToMenuView
{
    if (_isRegist) {
        [self dissmissView];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (_midStr.length > 0) {
        cardNo.text = [UserManager getDefaultUser].idCard;
//        cardNo.text = [self deCodeStr:cardNo.text];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
