//
//  YZCViewController.m
//  YZCSegmentController
//
//  Created by dyso on 16/8/1.
//  Copyright © 2016年 yangzhicheng. All rights reserved.
//

#import "YZCViewController.h"
#import "MainHeader.h"
#import "WeChectLoginViewController.h"
#import "MMZCViewController.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define titleWidth SCREEN_WIDTH/_titleArray.count
#define titleHeight 44
#define backColor [UIColor colorWithWhite:0.300 alpha:1.000]

@interface YZCViewController ()<UIScrollViewDelegate> {
    
    UIButton *selectButton;
//    UIView *_sliderView;
    UIViewController *_viewController;
//    UIScrollView *_scrollView;
}

@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) UIView *kuaidiView;
@property (nonatomic, strong) UIView *userView;
@property (nonatomic, strong) UIView *wuliuView;
@property (nonatomic, strong) UIView *kuaidiAndWuliuView;

@end

@implementation YZCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.scrollEnabled = NO;
    _buttonArray = [NSMutableArray array];
}
-(void)setKuaidiyuanArr:(NSArray *)kuaidiyuanArr{
    _kuaidiyuanArr  = kuaidiyuanArr;
    _titleArray = kuaidiyuanArr[0];
    _btnSelectedImage  = kuaidiyuanArr[1];
    [self initWithTitleButton];
}

-(void)setUserArr:(NSArray *)userArr{
    _userArr  = userArr;
    _titleArray = userArr[0];
    _btnSelectedImage  = userArr[1];
    [self initWithUserTitleButton];
}

-(void)setWuliuArr:(NSArray *)wuliuArr{
    _wuliuArr = wuliuArr;
    _titleArray = wuliuArr[0];
    _btnSelectedImage = _wuliuArr[1];
    [self initWithWuLiuTitleButton];
}

-(void)setKuaidiAndWuliuArr:(NSArray *)kuaidiAndWuliuArr{
    _kuaidiAndWuliuArr = kuaidiAndWuliuArr;
    _titleArray = kuaidiAndWuliuArr[0];
    _btnSelectedImage = kuaidiAndWuliuArr[1];
    [self initBothKuaidiAndWuliuTitleButton];
}

#pragma mark ----- 用户的titleView
- (void)initWithUserTitleButton
{
    _userView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, titleHeight)];
    _userView.backgroundColor = BACKGROUND_COLOR;
    [self.view addSubview:_userView];
    if (self.navigationController.navigationBar) {
        _userView.frame = CGRectMake(0, 0, SCREEN_WIDTH, titleHeight);
    } else {
        _userView.frame = CGRectMake(0, 0, SCREEN_WIDTH, titleHeight);
    }
    
    for (int i = 0; i < _titleArray.count; i++) {
        
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        titleButton.frame = CGRectMake(titleWidth*i, 0, titleWidth, titleHeight);
        [titleButton setImage:[UIImage imageNamed:_titleArray[i]] forState:UIControlStateNormal];
        [titleButton setImage:[UIImage imageNamed:_btnSelectedImage[i]] forState:UIControlStateSelected];
        titleButton.tag = 100+i;
        [titleButton addTarget:self action:@selector(scrollViewSelectToIndex:) forControlEvents:UIControlEventTouchUpInside];
        [_userView addSubview:titleButton];
        if (i == 0) {
            selectButton = titleButton;
            selectButton.selected = YES;
            //            [selectButton setImage:[UIImage imageNamed:@"xsSelected"] forState:UIControlStateNormal];
        }
        [_buttonArray addObject:titleButton];
    }
}

#pragma mark ----- 快递员的titleView
- (void)initWithTitleButton
{
    _kuaidiView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, titleHeight)];
    _kuaidiView.backgroundColor = BACKGROUND_COLOR;
    [self.view addSubview:_kuaidiView];
    if (self.navigationController.navigationBar) {
        _kuaidiView.frame = CGRectMake(0, 0, SCREEN_WIDTH, titleHeight);
    } else {
        _kuaidiView.frame = CGRectMake(0, 0, SCREEN_WIDTH, titleHeight);
    }
    
    for (int i = 0; i < _titleArray.count; i++) {
        
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        titleButton.frame = CGRectMake(titleWidth*i, 0, titleWidth, titleHeight);
        [titleButton setImage:[UIImage imageNamed:_titleArray[i]] forState:UIControlStateNormal];
        [titleButton setImage:[UIImage imageNamed:_btnSelectedImage[i]] forState:UIControlStateSelected];
        titleButton.tag = 100+i;
        [titleButton addTarget:self action:@selector(scrollViewSelectToIndex:) forControlEvents:UIControlEventTouchUpInside];
        [_kuaidiView addSubview:titleButton];
        if (i == 0) {
            selectButton = titleButton;
            selectButton.selected = YES;
//          [selectButton setImage:[UIImage imageNamed:@"xsSelected"] forState:UIControlStateNormal];
        }
        [_buttonArray addObject:titleButton];
    }
}

#pragma mark ----- 物流的titleView
- (void)initWithWuLiuTitleButton
{
    _wuliuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, titleHeight)];
    _wuliuView.backgroundColor = BACKGROUND_COLOR;
    [self.view addSubview:_wuliuView];
    if (self.navigationController.navigationBar) {
        _wuliuView.frame = CGRectMake(0, 0, SCREEN_WIDTH, titleHeight);
    } else {
        _wuliuView.frame = CGRectMake(0, 0, SCREEN_WIDTH, titleHeight);
    }
    for (int i = 0; i < _titleArray.count; i++) {
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        titleButton.frame = CGRectMake(titleWidth*i, 0, titleWidth, titleHeight);
        [titleButton setImage:[UIImage imageNamed:_titleArray[i]] forState:UIControlStateNormal];
        [titleButton setImage:[UIImage imageNamed:_btnSelectedImage[i]] forState:UIControlStateSelected];
        titleButton.tag = 100+i;
        [titleButton addTarget:self action:@selector(scrollViewSelectToIndex:) forControlEvents:UIControlEventTouchUpInside];
        [_wuliuView addSubview:titleButton];
        if (i == 0) {
            selectButton = titleButton;
            selectButton.selected = YES;
        }
        [_buttonArray addObject:titleButton];
    }
}

#pragma mark ----- 快递员与物流的titleView  只有两个模块
-(void)initBothKuaidiAndWuliuTitleButton{
    _kuaidiAndWuliuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, titleHeight)];
    _kuaidiAndWuliuView.backgroundColor = BACKGROUND_COLOR;
    [self.view addSubview:_kuaidiAndWuliuView];
    if (self.navigationController.navigationBar) {
        _kuaidiAndWuliuView.frame = CGRectMake(0, 0, SCREEN_WIDTH, titleHeight);
    } else {
        _kuaidiAndWuliuView.frame = CGRectMake(0, 0, SCREEN_WIDTH, titleHeight);
    }
    for (int i = 0; i < _titleArray.count; i++) {
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        titleButton.frame = CGRectMake(titleWidth*i, 0, titleWidth, titleHeight);
        [titleButton setImage:[UIImage imageNamed:_titleArray[i]] forState:UIControlStateNormal];
        [titleButton setImage:[UIImage imageNamed:_btnSelectedImage[i]] forState:UIControlStateSelected];
        titleButton.tag = 100+i;
        [titleButton addTarget:self action:@selector(scrollViewSelectToIndex:) forControlEvents:UIControlEventTouchUpInside];
        [_kuaidiAndWuliuView addSubview:titleButton];
        if (i == 0) {
            selectButton = titleButton;
            selectButton.selected = YES;
        }
        [_buttonArray addObject:titleButton];
    }

}

-(void)showTitle:(NSInteger )type{
    
    //type  记载用户0   快递员1   物流公司 物流司机 2   快递员和物流公司 3
    switch (type) {
        case 0:{
            _userView.hidden = NO;
            _kuaidiView.hidden = YES;
            _wuliuView.hidden = YES;
            _kuaidiAndWuliuView.hidden = YES;
            selectButton.selected = NO;
            selectButton = _userView.subviews[0];
            selectButton.selected = YES;
            self.controllerArray = self.userArr[2];
            [self initWithController];
        }
            break;
        case 1:{
            _kuaidiView.hidden = NO;
            _userView.hidden = YES;
            _wuliuView.hidden = YES;
            _kuaidiAndWuliuView.hidden = YES;
            selectButton.selected = NO;
            selectButton = _kuaidiView.subviews[0];
            selectButton.selected = YES;
            self.controllerArray = self.kuaidiyuanArr[2];
            [self initWithController];

        }
            break;
        case 2:{
            _wuliuView.hidden = NO;
            _kuaidiView.hidden = YES;
            _userView.hidden = YES;
            _kuaidiAndWuliuView.hidden = YES;
            selectButton.selected = NO;
            selectButton = _wuliuView.subviews[0];
            selectButton.selected = YES;
            self.controllerArray = self.wuliuArr[2];
            [self initWithController];
        }
            break;
        case 3:{
            _kuaidiAndWuliuView.hidden = NO;
            _userView.hidden = YES;
            _wuliuView.hidden = YES;
            _kuaidiView.hidden = YES;
            selectButton.selected = NO;
            selectButton = _kuaidiAndWuliuView.subviews[0];
            selectButton.selected = YES;
            self.controllerArray = self.kuaidiAndWuliuArr[2];
            [self initWithController];
        }
            break;
        default:
            break;
    }
    
    /*
    if (type == 2) {
        _kuaidiView.hidden = NO;
        _userView.hidden = YES;
        selectButton.selected = NO;
        selectButton = _kuaidiView.subviews[0];
        selectButton.selected = YES;
        self.controllerArray = self.kuaidiyuanArr[2];
        
    }else {
        _userView.hidden = NO;
        _kuaidiView.hidden = YES;
        selectButton.selected = NO;
        selectButton = _userView.subviews[0];
        selectButton.selected = YES;
        self.controllerArray = self.userArr[2];
    }
     */
//    [self initWithController];
}

- (void)scrollViewSelectToIndex:(UIButton *)button
{
    
    if (![self checkIfLogin]) {
    return;
   }
    [self selectButton:button.tag-100];
    [UIView animateWithDuration:0.35 animations:^{
        _scrollView.contentOffset = CGPointMake(SCREEN_WIDTH*(button.tag-100), 0);
    }];
}

//选择某个标题
- (void)selectButton:(NSInteger)index
{
    selectButton.selected = NO;//把旧按钮（没点按钮之前所选中的按钮）设为no未选中
    
    if (_kuaidiView.hidden && _wuliuView.hidden && _kuaidiAndWuliuView.hidden) {
        selectButton = _userView.subviews[index];//给选中的按钮赋值，付给他点击的那个按钮 对吧en
    }else if(_wuliuView.hidden && _userView.hidden && _kuaidiAndWuliuView.hidden){
        selectButton = _kuaidiView.subviews[index];
    }else if(_userView.hidden && _kuaidiView.hidden && _kuaidiAndWuliuView.hidden){
        selectButton = _wuliuView.subviews[index];
    }else if(_userView.hidden && _kuaidiView.hidden && _wuliuView.hidden){
        selectButton = _kuaidiAndWuliuView.subviews[index];
    }else{}
    
    selectButton.selected = YES;//xuan所点的zhong按钮sheweiyes
    
}

//监听滚动事件判断当前拖动到哪一个了
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSInteger index = scrollView.contentOffset.x / SCREEN_WIDTH;
    [self selectButton:index];
    
}

- (void)initWithController
{
    if (_scrollView) {
        _scrollView = nil;
    }
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (self.navigationController.navigationBar) {
        scrollView.frame = CGRectMake(0, titleHeight, SCREEN_WIDTH, SCREEN_HEIGHT-titleHeight-64-44);
    } else {
        scrollView.frame = CGRectMake(0, titleHeight, SCREEN_WIDTH, SCREEN_HEIGHT-titleHeight-64-44);
    }
    scrollView.delegate = self;
    scrollView.backgroundColor = [UIColor colorWithWhite:0.900 alpha:1.000];
    scrollView.pagingEnabled = YES;
    scrollView.scrollEnabled = YES;
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*_controllerArray.count, 0);
//    [self.view addSubview:scrollView];

    _scrollView = scrollView;
    [self.view addSubview:_scrollView];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.autoresizesSubviews = NO;
    _scrollView.alwaysBounceHorizontal = YES;
    _scrollView.bounces = NO;  
    _scrollView.scrollsToTop = NO;
    _scrollView.scrollEnabled = NO;

    
    for (int i = 0; i < _controllerArray.count; i++) {
        UIView *viewcon = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        UIViewController *viewcontroller = _controllerArray[i];
        viewcon = viewcontroller.view;
        [self addChildViewController:_controllerArray[i]];
        viewcon.frame = CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        
        [scrollView addSubview:viewcon];

    }
}

- (BOOL)checkIfLogin{
    if (![UserManager getDefaultUser]) {
        [self goToLogin];
        return NO;
    }
    return YES;
}
#pragma mark -- 进入登陆界面
- (void)goToLogin{
    //    _isGoTOLogin = YES;
    //如果用户装了微信就只能微信登陆，如果没装微信，就进入账号登陆
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
        WeChectLoginViewController *vc = [[WeChectLoginViewController alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
        
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
    }else{
        MMZCViewController *vc = [[MMZCViewController alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
        
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
    }
}

@end
