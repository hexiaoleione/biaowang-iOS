//
//  ShunFengViewController.m
//  iwant
//
//  Created by pro on 16/4/13.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "ShunFengViewController.h"
#import "HuozhuViewController.h"
#import "BiaoshiViewController.h"
#import "MainHeader.h"

@interface ShunFengViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) HuozhuViewController *huozhuVC;
@property (strong, nonatomic) BiaoshiViewController *biaoshiVC;
@property (strong, nonatomic) UIButton *lastBtn;
@property (strong, nonatomic) UITableView *popView;
/*
 * 用于下面判断货主还是镖师
 */
@property (nonatomic) NSUInteger i;

@end

@implementation ShunFengViewController

{
    UIScrollView *_scrollView;
    UIImageView *barView;
    UIButton *_btn;
    BOOL btnClick;
}

- (UITableView *)popView{
    
    if (_popView == nil) {
        _popView = [[UITableView alloc]init];
    }
    return _popView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self configNavgationBar];
    [self _initNavBar];
    [self _initChildVC];
    [self _initToolBar];
    [self _initPopView];
    if (_type == 0) {
        [self btnClick:self.lastBtn];
    }else{
        UIButton *btn = [UIButton buttonWithType:0];
        btn.tag = 1;
        [self btnClick:btn];
        btn =nil;
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)_initNavBar{
    
    
    _btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    [_btn setTitle:@"智能排序" forState:UIControlStateNormal];
    [_btn setImage:[UIImage imageNamed:@")-拷贝-2@3x.png"] forState:UIControlStateNormal];
    [_btn addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    _btn.backgroundColor = [UIColor clearColor];
    btnClick = YES;
    _btn.titleLabel.font = [UIFont systemFontOfSize:13];
    _btn.imageEdgeInsets = UIEdgeInsetsMake(0, 80, 0, 0);
    _btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:_btn];
//    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)_initPopView{
    
    _popView = [[UITableView alloc]initWithFrame:CGRectMake(WINDOW_WIDTH - 120, 10, 100, 140)];
    _popView.delegate = self;
    _popView.dataSource = self;
    //    _popView.backgroundColor = [UIColor greenColor];
    _popView.layer.borderWidth = 1.0f;
    _popView.layer.borderColor =[UIColor orangeColor].CGColor;
    
    
    _popView.hidden = YES;
    _popView.layer.cornerRadius = 6;
    _popView.clipsToBounds = YES;
    [self.view addSubview:_popView];
    
}

- (void)_initToolBar{
    
    barView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, 100)];
    barView.userInteractionEnabled = YES;
    barView.contentMode = UIViewContentModeScaleAspectFill;
    barView.clipsToBounds = YES;
    
    [self.view addSubview:barView];
    

//    [barView addSubview:[self creatbarBtnWithTitle:@"我是货主" FrameX:(WINDOW_WIDTH / 2 - 120) btntag:0]];
//    [barView addSubview:[self creatbarBtnWithTitle:@"我是镖师" FrameX:(WINDOW_WIDTH / 2 + 20) btntag:1]];
}

- (void)_initChildVC{
    
    _scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    _scrollView.contentSize =CGSizeMake(WINDOW_WIDTH *2, WINDOW_HEIGHT);
    _scrollView.scrollEnabled = NO;
    [self.view addSubview:_scrollView];
    //行程列表
//    _huozhuVC = [[HuozhuViewController alloc]init];
//    [self addChildViewController:_huozhuVC];
//    [_scrollView addSubview:_huozhuVC.view];
    
    _biaoshiVC = [[BiaoshiViewController alloc]init];
    [self addChildViewController:_biaoshiVC];
    _biaoshiVC.view.x = WINDOW_WIDTH;
    [_scrollView addSubview:_biaoshiVC.view];
    
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,120,35)];
    btn.center = CGPointMake(WINDOW_WIDTH / 2, WINDOW_HEIGHT-120);
    btn.titleLabel.font = FONT(14,NO);
    [btn setBackgroundColor:[UIColor orangeColor]];
    
    btn.layer.cornerRadius = 10.0;
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.view addSubview:btn];
    
    if (_sendType == 0) {
        [btn setTitle:@"我要发件" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(sendWind) forControlEvents:UIControlEventTouchUpInside];
    }else if(_sendType == 1){
        _biaoshiVC.sendType = 1;
        [btn setTitle:@"我要发件" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(sendLimitExp) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)sendWind{
//    SendCityExpressViewController *vc = [[SendCityExpressViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];

}
- (void)sendLimitExp{
}

- (UIButton *)creatbarBtnWithTitle:(NSString *)title FrameX:(CGFloat)x btntag:(NSInteger)tag{
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(x, 0, 100, 40)];
    [btn setBackgroundColor:[UIColor clearColor]];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    btn.tag = tag;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (tag == 0) {
        self.lastBtn = btn;
    }
    
    return btn;
}

- (void)btnClick:(UIButton *)btn{
    switch (btn.tag) {
        case 0:
        {
            //顺丰专递 我是货主 列表
            _scrollView.contentOffset = CGPointMake(btn.tag * WINDOW_WIDTH, 0);
            [barView setImage:[UIImage imageNamed:@"镖师行程.jpg"]];
//            _huozhuVC.view.hidden = NO;
//            _biaoshiVC.view.hidden = YES;
//            _huozhuVC.view.x = 0;
//            _biaoshiVC.view.x = WINDOW_WIDTH;
            
            _i = 1;
            
            _popView.height = 105;
            [_popView reloadData];
            
        }
            break;
        case 1:
        {
            _scrollView.contentOffset = CGPointMake(btn.tag * WINDOW_WIDTH, 0);
            if (_sendType == 1) {
                [barView setImage:[UIImage imageNamed:@"xianshi_bannerimg.jpg"]];
            }else{
                [barView setImage:[UIImage imageNamed:@"附近镖件.jpg"]];
            }
//            _huozhuVC.view.hidden = YES;
//            _biaoshiVC.view.hidden = NO;
//            _biaoshiVC.view.x = 0;
//            _huozhuVC.view.x = WINDOW_WIDTH;
            _i = 2;
            _popView.height = 105;
            [_popView reloadData];
        }
            break;
    }
    
    self.lastBtn.selected = NO;
    btn.selected = YES;
    self.lastBtn = btn;
}

- (void)rightClick{
    
    if (btnClick) {
        [_btn setImage:[UIImage imageNamed:@")-拷贝-5@3x.png"] forState:UIControlStateNormal];
        btnClick = NO;
        _popView.hidden = NO;
        [_popView reloadData];
    }else{
        [_btn setImage:[UIImage imageNamed:@")-拷贝-2@3x.png"] forState:UIControlStateNormal];
        btnClick = YES;
        _popView.hidden = YES;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_i == 1) {
        
        return 3;
        
        
    }
    else
    {
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *str = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame] ;
    cell.selectedBackgroundView.backgroundColor = [UIColor orangeColor];
    cell.textLabel.highlighted = [UIColor whiteColor];
    
    if (_i == 1) {
        NSArray *arr = [[NSArray alloc]initWithObjects:@"离我最近", @"出发时间最早", @"好评率最高", nil];
        //        NSLog(@"__________________%lu",(unsigned long)arr.count);
        cell.textLabel.text = arr[indexPath.row];
        //        NSLog(@"*********%@",cell.textLabel.text);
    }else
    {
        NSArray *arr = [[NSArray alloc]initWithObjects:@"离我最近", @"运费最高", @"信用等级最高", nil];
        cell.textLabel.text = arr[indexPath.row];
        //        NSLog(@"%@",cell.textLabel.text);
    }
    cell.textLabel.font = [UIFont systemFontOfSize:10];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 35;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if ([UserManager getDefaultUser].userType == 1) {
//       HHAlertView *alertView = [[HHAlertView alloc]initWithTitle:@"温 馨 提 醒 ！" detailText:@"您还不是镖师，没有权限使用，是否去认证镖师" cancelButtonTitle:@"我知道了" otherButtonTitles:@[@"去认证"]];
//         alertView.mode = HHAlertViewModeWarning;
//          [alertView showWithBlock:^(NSInteger index) {
//            if (index != 0) {
//                UserNameViewController *userVC = [UserNameViewController new];
//                userVC.courentbtnTag = 2;
//                [self.navigationController pushViewController:userVC animated:YES];
//            }
//            }];
//            return;
//        }
    
    if (_i == 1) {
        [_huozhuVC changePX:(int)indexPath.row + 1];
        if (indexPath.row ==0) {
            NSLog(@"==========离我最近1");
            btnClick = YES;
            _popView.hidden = YES;
            
        }
        else if(indexPath.row == 1)
        {
            
            NSLog(@"==========出发时间最早1");
            btnClick = YES;
            _popView.hidden = YES;
            
        }
        else if(indexPath.row == 2)
        {
            
            NSLog(@"==========好评率最高1");
            btnClick = YES;
            _popView.hidden = YES;
            
        }else
        {
            NSLog(@"==========啊啊啊1");
            btnClick = YES;
            _popView.hidden = YES;
        }
        
    }
    else
    {
        [_biaoshiVC changePX:(int)indexPath.row + 1];
        if (indexPath.row ==0) {
            NSLog(@"==========离我最近");
            btnClick = YES;
            _popView.hidden = YES;
            
    }
        else if(indexPath.row == 1)
        {
            
            NSLog(@"==========运费最高");
            btnClick = YES;
            _popView.hidden = YES;
            
        }
        else if(indexPath.row == 2)
        {
            
            NSLog(@"==========信用等级最高");
            btnClick = YES;
            _popView.hidden = YES;
            
        }
    }
}

- (void)configNavgationBar {
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 60)];
    label.centerX = self.view.centerX;
    label.textColor = [UIColor whiteColor];
    
    if (_type == 0) {
        label.text = @"我是货主";
    }else{
         label.text = @"我是镖师";
    }
    if (_sendType == 0) {
        label.text = @"顺路送";
    }else if(_sendType == 1){
        label.text = @"专程送";
    }
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
@end
