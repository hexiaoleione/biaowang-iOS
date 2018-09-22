//
//  LogistCompanyViewController.m
//  iwant
//
//  Created by dongba on 16/9/6.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "LogistCompanyViewController.h"
#import "YMHeaderView.h"
@interface LogistCompanyViewController ()<YMHeaderViewDelegate>{
    UIScrollView *_scrollView;
      
}
@property (nonatomic,strong)YMHeaderView * IdCardOpenImage; //正面
@property (nonatomic,strong)YMHeaderView * IdCardObverseImage; //反面
@property (nonatomic,strong)YMHeaderView * businessLicenseImage;//营业执照

@end

@implementation LogistCompanyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCostomeTitle:@"物流注册2"];
    self.view.backgroundColor = BACKGROUND_COLOR;
//    [self configSubViews];
    [self creatViews];// 上传三张图片的视图
}

- (void)configSubViews{
    _scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    _scrollView.contentSize = CGSizeMake(WINDOW_WIDTH, 760.);
    [self.view addSubview:_scrollView];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_WIDTH*50/72)];
    imageView.image = [UIImage imageNamed:@"trucksInTheSky.jpg"];
    imageView.centerX = _scrollView.centerX;
    imageView.top = 30;
    [_scrollView addSubview:imageView];
    
    _fieldview  = [[[NSBundle mainBundle] loadNibNamed:@"LogistCompanyInfo" owner:nil options:nil] lastObject];
    _fieldview.backgroundColor = [UIColor clearColor];
    _fieldview.top = 200;
    _fieldview.centerX = _scrollView.centerX;
    [_scrollView addSubview:_fieldview];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = 1;
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:COLOR_ORANGE_DEFOUT];
    btn.layer.cornerRadius = 10;
    btn.size = CGSizeMake(160, 35);
    btn.top = _fieldview.bottom + 15;
    btn.centerX = _scrollView.centerX;
    [_scrollView addSubview:btn];
    [btn addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.tag = 2;
    [backBtn setTitle:@"<<上一步>>" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backToFirstView:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.layer.cornerRadius = 10;
    backBtn.size = CGSizeMake(160, 35);
    backBtn.top = btn.bottom + 15;
    backBtn.centerX = _scrollView.centerX;
    [_scrollView addSubview:backBtn];
}
-(void)creatViews{
    _scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    _scrollView.contentSize = CGSizeMake(WINDOW_WIDTH, 864.);
    [self.view addSubview:_scrollView];

    if (_isRegist) {
     _IdCardOpenImage =[[YMHeaderView alloc]initWithFrame:CGRectMake(44, 22, SCREEN_WIDTH-44*2,200)];
    }else{
     _IdCardOpenImage =[[YMHeaderView alloc]initWithFrame:CGRectMake(44, 22, SCREEN_WIDTH-44*2,200)];
    }
    _IdCardOpenImage.image = [UIImage imageNamed:@"正面"];
    _IdCardOpenImage.layer.cornerRadius = 5;
    _IdCardOpenImage.tag = 0;
    _IdCardOpenImage.delagate = self;
    [_scrollView addSubview:_IdCardOpenImage];
    
    _IdCardObverseImage =[[YMHeaderView alloc]initWithFrame:CGRectMake(44, _IdCardOpenImage.bottom+10, SCREEN_WIDTH-44*2,200)];
    _IdCardObverseImage.image = [UIImage imageNamed:@"反面"];
    _IdCardObverseImage.layer.cornerRadius = 5;
    _IdCardObverseImage.tag = 1;
    _IdCardObverseImage.delagate = self;
    [_scrollView addSubview:_IdCardObverseImage];
    
    _businessLicenseImage =[[YMHeaderView alloc]initWithFrame:CGRectMake(44, _IdCardObverseImage.bottom+10, SCREEN_WIDTH-44*2,200)];
    _businessLicenseImage.image = [UIImage imageNamed:@"执照"];
    _businessLicenseImage.tag = 2;
    _businessLicenseImage.layer.cornerRadius = 5;
    _businessLicenseImage.delagate = self;
    [_scrollView addSubview:_businessLicenseImage];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = 1;
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:COLOR_MainColor];
    btn.layer.cornerRadius = 10;
    btn.size = CGSizeMake(160, 35);
    btn.top = _businessLicenseImage.bottom + 15;
    btn.centerX = _scrollView.centerX;
    [_scrollView addSubview:btn];
    [btn addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.tag = 2;
    [backBtn setTitle:@"<<上一步>>" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backToFirstView:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.layer.cornerRadius = 10;
    backBtn.size = CGSizeMake(160, 35);
    backBtn.top = btn.bottom + 15;
    backBtn.centerX = _scrollView.centerX;
    [_scrollView addSubview:backBtn];


}
-(void)headerView:(YMHeaderView *)headerView didSelectWithImage:(UIImage *)image{
    [SVProgressHUD showWithStatus:@"正在上传"];
    NSDictionary *dic = @{k_USER_ID:[UserManager getDefaultUser].userId,k_FILE_NAME:@"companyPic.png"};
    NSDictionary *fileDic = @{@"data":image,@"fileName":@"companyPic.png"};
    
    NSString *api;
    switch (headerView.tag) {
        case 0:
            api = @"file/idCardOpen";
            break;
        case 1:
            api = @"file/idCardObverse";
            break;
        case 2:
            api = @"file/businessLicense";
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
                                           self.idCardOpenPath = [([object objectForKey:@"data"][0]) valueForKey:@"filePath"];
                                           break;
                                       case 1:
                                           self.idCardObversePath = [([object objectForKey:@"data"][0]) valueForKey:@"filePath"];
                                           break;
                                       case 2:
                                           self.businessLicensePath = [([object objectForKey:@"data"][0]) valueForKey:@"filePath"];
                                           break;
                                           
                                       default:
                                           break;
                                   }
                                   
                               } failed:^(NSString *error) {
                                   switch (headerView.tag) {
                                       case 0:
                                           _IdCardOpenImage.image = [UIImage imageNamed:@"正面"];
                                           break;
                                       case 1:
                                           _IdCardObverseImage.image = [UIImage imageNamed:@"反面"];
                                           break;
                                       case 2:
                                           _businessLicenseImage.image = [UIImage imageNamed:@"执照"];
                                           break;
                                           
                                       default:
                                           break;
                                   }
                                   [SVProgressHUD showErrorWithStatus:error];
                               }];


}

- (void)backToFirstView:(UIButton *)btn{
    if (_block) {
        _block(btn);
    }
}

- (void)submit:(UIButton *)btn{
    if (_block) {
        _block(btn);
    }
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
