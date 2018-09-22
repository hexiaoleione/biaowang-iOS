//
//  changeInfoViewController.m
//  iwant
//
//  Created by 公司 on 2016/12/8.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "changeInfoViewController.h"
#import "changeHeaderViewVC.h"   //修改头像VC
#import "ChangeNumViewController.h" //修改手机号VC
#import "settinhHeaderViewController.h"//实名认证

@interface changeInfoViewController (){

}
@end

@implementation changeInfoViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTintColor:COLOR_MainColor];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 60)];
    label.textColor = [UIColor blackColor];
    label.text = @"完善个人信息";
    label.textAlignment = 1;
    self.navigationItem.titleView = label;
    self.view.backgroundColor=[UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
    
    NSString *imageName = @"home_btn_selection";
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] style:UIBarButtonItemStylePlain target:self action:@selector(backToMenuView)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    UIBarButtonItem * rightBarButtonItem =[[UIBarButtonItem alloc]initWithTitle:@"实名认证" style:UIBarButtonItemStylePlain target:self action:@selector(shimingRenZheng)];
    [rightBarButtonItem setTintColor:[UIColor blackColor]];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    [self creatUI];
}

-(void)creatUI{
    changeHeaderViewVC * vc1 = [[changeHeaderViewVC alloc]init];
    vc1.title=@"修改头像";
    
    ChangeNumViewController * vc2 =[[ChangeNumViewController alloc]init];
    vc2.title=@"修改手机号";
    self.viewControllers = @[vc1,vc2];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backToMenuView{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)shimingRenZheng{
//实名认证
    settinhHeaderViewController *headVC =  [[settinhHeaderViewController alloc]init];
    [self.navigationController pushViewController:headVC animated:YES];
}
@end
