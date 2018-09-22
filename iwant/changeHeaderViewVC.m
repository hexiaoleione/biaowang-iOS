//
//  changeHeaderViewVC.m
//  iwant
//
//  Created by 公司 on 2016/12/8.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "changeHeaderViewVC.h"
#import "MainHeader.h"
#import "YMHeaderView.h"
@interface changeHeaderViewVC ()<YMHeaderViewDelegate>

@property(nonatomic,strong)YMHeaderView * headerView;
@property(nonatomic,strong)UIButton * updateBtn;
@end

@implementation changeHeaderViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =BACKGROUND_COLOR;
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.updateBtn];
    
    
}
#pragma ---------lazyLoad
-(YMHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[YMHeaderView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2, 64, 200, 200)];
        _headerView.layer.cornerRadius = 100;
        _headerView.delagate = self;
        [_headerView sd_setImageWithURL:[NSURL URLWithString:[UserManager getDefaultUser].headPath]
                    placeholderImage:[UIImage imageNamed:@"rabace"]];
        _headerView.delagate = self;
    }
    return _headerView;
}

-(UIButton *)updateBtn{
    if (!_updateBtn) {
        _updateBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _updateBtn.x=0;
        _updateBtn.width = SCREEN_WIDTH;
        _updateBtn.y= self.headerView.bottom +44;
        [_updateBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        [_updateBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_updateBtn setTitle:@"请点击图片上传或修改头像" forState:UIControlStateNormal];
    }
   return  _updateBtn;
}
#pragma mark ---- btnClick
-(void)btnClick{
    [_headerView imageTaped:nil];
}

#pragma mark - YMHeaderView Delegate
- (void)headerView:(YMHeaderView *)headerView didSelectWithImage:(UIImage *)image{
    [SVProgressHUD showWithStatus:@"正在上传图片"];
    NSDictionary *dic = @{k_USER_ID:[UserManager getDefaultUser].userId,
                          k_FILE_NAME:@"head_image.png"};
    NSDictionary *fileDic = @{@"data":image,@"fileName":@"head_image.png"};
    [ExpressRequest sendWithParameters:dic MethodStr:API_UPLOAD_HEAD
                               fileDic:fileDic
                               success:^(id object) {
                                   [SVProgressHUD showSuccessWithStatus:@"上传成功"];
                                   [RequestManager getuserinfoWithuserId:[UserManager getDefaultUser].userId success:^(NSString *reslut) {
                                       NSLog(@"更新成功");
                                   } Failed:^(NSString *error) {
                                       NSLog(@"%@",error);
                                   }];
                                   
                               } failed:^(NSString *error) {
                                   [SVProgressHUD showErrorWithStatus:error];
                               }];
    
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
