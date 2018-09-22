//
//  FinancingViewController.m
//  iwant
//
//  Created by pro on 16/5/9.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "FinancingViewController.h"
#import "MainHeader.h"
#import "InforWebViewController.h"


@interface FinancingViewController ()

{
    UIImageView *_TopImageView;
    UIButton *_IwantButton;
    UIImageView  *_ButtomImageView;
    
    
    
}
@end

@implementation FinancingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavgationBar];
    [self CreatView];

}
-(void)CreatView
{
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    strDate = [strDate substringToIndex:7];
    _TopImageView =  [[UIImageView alloc]init ];
    [_TopImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.efamax.com/images/zhong.jpg?%@",strDate]]];
    [self.view addSubview:_TopImageView];
    

    
    
    //提现申请
    _IwantButton = [[UIButton alloc]init];
    _IwantButton.frame = CGRectMake(0, CGRectGetMaxY(_TopImageView.frame),WINDOW_WIDTH *0.5 , 40);
    _IwantButton.centerX = self.view.centerX;
    
    _IwantButton.layer.borderColor = [[UIColor grayColor] CGColor];
    _IwantButton.layer.borderWidth = 1.0f;
    //    [_ali_MakeSureBtn setTintColor:COLOR_LIGHT_BLUE];
    _IwantButton.backgroundColor = [UIColor clearColor];
    _IwantButton.layer.cornerRadius = 10;
    [_IwantButton setTitle:@"我要成为股东" forState:UIControlStateNormal];
    [_IwantButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_IwantButton addTarget:self action:@selector(Involved) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_IwantButton];

    

    
    
    
    _ButtomImageView =  [[UIImageView alloc]init];
    
    [_ButtomImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.efamax.com/images/youdu.jpg?%@",strDate]]];

    [self.view addSubview:_ButtomImageView];
    
    

    _TopImageView.frame = CGRectMake(0, 0, WINDOW_WIDTH, (WINDOW_HEIGHT - 64) *0.55);
    
    _IwantButton.centerY = CGRectGetMaxY(_TopImageView.frame) + (WINDOW_HEIGHT - 64) *0.05;
    _ButtomImageView.frame = CGRectMake(0,(WINDOW_HEIGHT - 64) *0.65, WINDOW_WIDTH,(WINDOW_HEIGHT - 64) *0.35);
//    _TopImageView.sd_layout.topEqualToView(self.view).leftEqualToView(self.view).rightEqualToView(self.view).bottomSpaceToView(_IwantButton,0);
//    _IwantButton.sd_layout.topSpaceToView(_TopImageView,0).leftEqualToView(self.view).rightEqualToView(self.view).heightIs(50);
//    _ButtomImageView.sd_layout.topSpaceToView(_IwantButton,0).leftEqualToView(self.view).rightEqualToView(self.view).bottomEqualToView(self.view).heightRatioToView(_TopImageView,1);
    
    
    
}
-(void)Involved

{
    [Utils callAction:@"010-52873063"];
    NSLog(@"点击了给发件人打电话");
    
//    NSLog(@"我要成为股东");
//    InforWebViewController *web = [[InforWebViewController alloc]init];
//    web.info_type = INFO_ZHONGCHOU;
//    [self.navigationController pushViewController:web animated:YES];
    
}

- (void)configNavgationBar {
    
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 60)];
    label.textColor = [UIColor whiteColor];
    label.text = @"我的股权";
    label.textAlignment = 1;
    self.navigationItem.titleView = label;
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(backToMenuView)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    
}
- (void)backToMenuView{
    [self.navigationController popViewControllerAnimated:YES];
    
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
