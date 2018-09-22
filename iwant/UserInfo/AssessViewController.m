//
//  AssessViewController.m
//  Express
//
//  Created by user on 15/8/24.
//  Copyright (c) 2015年 SCHT. All rights reserved.
//

#import "AssessViewController.h"
#import "ZYRatingView.h"
#import "MainHeader.h"



@interface AssessViewController ()<RatingViewDelegate,UITextViewDelegate>
{
    UIScrollView *_backScrollView;
    UITextView *_textView;
    CGFloat ratingValue;
    NSDictionary *evlationDic;
    UIButton *pingjiaBtn;
    
    CGFloat courierScore;
    ZYRatingView *courierRatingView;
}
@end

@implementation AssessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor= [UIColor whiteColor];
    [self configNavgationBar];
    [self configSubviews];
        
    
  
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}

- (void)configSubviews
{
    _backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)];
    _backScrollView.contentSize = CGSizeMake(WINDOW_WIDTH, WINDOW_HEIGHT+50);
    
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT+50)];
    [_backScrollView addSubview:contentView];
    
    [self.view addSubview:_backScrollView];
    
//    UILabel *timeTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 120, 40)];
//    timeTitleLabel.text = @"取件响应时间:";
//    [contentView addSubview:timeTitleLabel];
    
    
//    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 20, 150, 40)];

//    [contentView addSubview:timeLabel];

    
//    UILabel *courierScoreTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, 160, 40)];
//    courierScoreTitleLabel.text = @"快递员综合评分:";
//    [contentView addSubview:courierScoreTitleLabel];
//    
//    courierRatingView = [[ZYRatingView alloc]initWithFrame:CGRectMake(150, 80, 130, 40)];
//    [contentView addSubview:courierRatingView];
//    [courierRatingView setImagesDeselected:@"0.png" partlySelected:@"1.png" fullSelected:@"2.png" andDelegate:self];
//
//    [courierRatingView displayRating:0];
//    courierRatingView.userInteractionEnabled = NO;
    
    
    UILabel *pingjiaTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 60, 100, 40)];
    pingjiaTitleLabel.text = @"您的评分:";
    [contentView addSubview:pingjiaTitleLabel];

    ZYRatingView *ratingView = [[ZYRatingView alloc]initWithFrame:CGRectMake(130, 70, 130, 30)];
    [contentView addSubview:ratingView];
    [ratingView setImagesDeselected:@"star_zero" partlySelected:@"star_one" fullSelected:@"star_one" andDelegate:self];
    ratingView.centerY = pingjiaTitleLabel.centerY;
    if (_package.score==0) {
        [ratingView displayRating:1];
    }
    else {
        [ratingView displayRating:_package.score];
        ratingView.userInteractionEnabled = NO;
    }
        
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(30, CGRectGetMinX(ratingView.frame), WINDOW_WIDTH-60, 100)];
    _textView.delegate = self;
    _textView.layer.borderColor = [COLOR_ORANGE_DEFOUT CGColor];
    _textView.layer.borderWidth = 1.0f;
    _textView.layer.cornerRadius  = 5;

    [contentView addSubview:_textView];
    
    pingjiaBtn =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [pingjiaBtn setTitle:@"提交" forState:UIControlStateNormal];
    pingjiaBtn.layer.borderColor = [COLOR_ORANGE_DEFOUT CGColor];
    pingjiaBtn.layer.borderWidth = 1.0f;
    [pingjiaBtn setTintColor:[UIColor whiteColor]];
    pingjiaBtn.backgroundColor = COLOR_ORANGE_DEFOUT;
    pingjiaBtn.layer.cornerRadius = 5;
    [pingjiaBtn addTarget:self action:@selector(pingjiaBtnTap) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:pingjiaBtn];
    [pingjiaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.equalTo(_textView.mas_bottom).with.offset(15);
        make.height.mas_equalTo(50);
    }];

}

- (void)upDateViewData
{
    _textView.text = [evlationDic objectForKey:@"content"];
    _textView.editable = NO;
    pingjiaBtn.hidden = YES;
}

-(void)ratingChanged:(float)newRating {
    ratingValue = newRating;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES; 
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //隐藏键盘
    [_textView resignFirstResponder];
}

- (void)pingjiaBtnTap
{
    [SVProgressHUD showWithStatus:@"正在提交..." ];
    [RequestManager assWithBusinessId:[NSString stringWithFormat:@"%d",(int)_package.businessId] evaTypeId:@"1" score:[NSString stringWithFormat:@"%0.2f",ratingValue] evaContent:_textView.text Success:^(id object) {
        NSLog(@"%@",object);
        [SVProgressHUD showSuccessWithStatus:@"感谢您的评价"];
        if (_block) {
            if (_block) {
                _block(_textView.text,ratingValue);
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
       
    } Failed:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
    
}

#pragma mark -- bar
- (void)configNavgationBar {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 60)];
    label.textColor = [UIColor whiteColor];
    label.text = @"评价";
    label.textAlignment = 1;
    self.navigationItem.titleView = label;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBarTintColor:COLOR_ORANGE_DEFOUT];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(backToMenuView)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

- (void)backToMenuView
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    if (_block) {
        _block(_textView.text,ratingValue);
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)backToMyExpressVC
{
    
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
