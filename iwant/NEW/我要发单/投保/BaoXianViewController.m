//
//  BaoXianViewController.m
//  iwant
//
//  Created by 公司 on 2017/10/13.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "BaoXianViewController.h"
#import "MyTouBaoListVC.h"
#import "TouBaoVC.h"
@interface BaoXianViewController (){
   //再定义一个imageview来等同于这个黑线
   UIImageView *navBarHairlineImageView;
   UIImageView *navLine;  //自定义横线
   UIButton * _startInsureBtn;  //开始投保
   UIButton * _myInsureListBtn;  //我的保单

   TouBaoVC * _touBaoVC; //开始投保
   MyTouBaoListVC * _touBaoList; //投保列表
}
@end

@implementation BaoXianViewController
//通过一个方法来找到这个黑线(findHairlineImageViewUnder):
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

//同样的在界面出现时候开启隐藏
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
     navBarHairlineImageView.hidden = NO;
}
//在页面消失的时候就让出现
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [navLine removeFromSuperview];
    navBarHairlineImageView.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCostomeTitle:@"投保详情"];
    [self configNavgationBar];
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    line.backgroundColor = COLOR_PurpleColor;
    [self.view addSubview:line];

    [self initTopBtns];
    [self addSubChildVC];
}

-(void)addSubChildVC{
    _touBaoVC = [[TouBaoVC alloc]init];
    [self addChildViewController:_touBaoVC];
    _touBaoVC.view.width = SCREEN_WIDTH;
    [self.view addSubview:_touBaoVC.view];
    _touBaoVC.view.left = 0;
    _touBaoVC.view.top = 40*RATIO_HEIGHT+1;
    _touBaoVC.view.height = SCREEN_HEIGHT-(40*RATIO_HEIGHT+1);
    
    _touBaoList = [[MyTouBaoListVC alloc]init];
    [self addChildViewController:_touBaoList];
    [self.view addSubview:_touBaoList.view];
    _touBaoList.view.left = SCREEN_WIDTH;
    _touBaoList.view.top = 40*RATIO_HEIGHT+1;
}

-(void)initTopBtns{
    _startInsureBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 1, (SCREEN_WIDTH-1)/2, 40*RATIO_HEIGHT)];
    _startInsureBtn.selected = YES;
    _startInsureBtn.tag = 0;
    [_startInsureBtn setBackgroundImage:[UIImage imageNamed:@"toubaoSelectedNone"] forState:UIControlStateNormal];
    [_startInsureBtn setBackgroundImage:[UIImage imageNamed:@"toubaoSelected"] forState:UIControlStateSelected];
    [_startInsureBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-1)/2, 1, 1, 40*RATIO_HEIGHT)];
    line.backgroundColor = COLOR_PurpleColor;
    
    _myInsureListBtn = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-1)/2+1, 1, (SCREEN_WIDTH-1)/2, 40*RATIO_HEIGHT)];
    _myInsureListBtn.tag = 1;
    [_myInsureListBtn setBackgroundImage:[UIImage imageNamed:@"toubaoListSelectedNone"] forState:UIControlStateNormal];
    [_myInsureListBtn setBackgroundImage:[UIImage imageNamed:@"toubaoListSelected"] forState:UIControlStateSelected];
    [_myInsureListBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_startInsureBtn];
    [self.view addSubview:_myInsureListBtn];
    [self.view addSubview:line];
}

-(void)btnClick:(UIButton * )sender{
    sender.selected = YES;
    [UIView animateWithDuration:0.3 animations:^{
        _touBaoVC.view.left = - SCREEN_WIDTH * sender.tag;
        _touBaoList.view.left = SCREEN_WIDTH *(labs(sender.tag - 1));
    }];
    if (sender.tag ==0) {
        if (_myInsureListBtn.selected == YES) {
            
        }else{
            
        }
        _myInsureListBtn.selected = NO;
    }else{
        [_touBaoList beginRefresh];
        _startInsureBtn.selected = NO;
    }
    
}

- (void)configNavgationBar {
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"home_btn_selection"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]                                                                          style:UIBarButtonItemStylePlain                                                                         target:self                                                                         action:@selector(backToMenuView)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}
- (void)backToMenuView{
    [self.navigationController popViewControllerAnimated:NO];
    
}

@end
