//
//  EvaluateViewController.m
//  iwant
//
//  Created by dongba on 16/5/4.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "EvaluateViewController.h"
#import "MainHeader.h"
#import "MarkLabel.h"
#import "ZYRatingView.h"
#import "MarkBtn.h"
#import "UIButton+imagePosistion.h"
#import "UITextView+placeholder.h"
#import "BiaoshiInfoViewController.h"
#import "MywindViewController.h"
#define RATIO_H(A)     (WINDOW_HEIGHT - 64.0)/ (667.0 -64.0)  *(A)
@interface EvaluateViewController ()<RatingViewDelegate,UITextViewDelegate>{
    NSArray *_attStr;
    NSArray *_badStr;
    NSArray *_goodStr;
    BOOL _ifGood;
    UILabel *_noticeLabel;
    float _score;
    NSString *_evaTags;
     Evaluation  * _nextModel;
}
@property (strong, nonatomic)  ZYRatingView*starsView;

@property (strong, nonatomic)  UILabel *attitudeLaeble;//满意 不满意

@property (strong, nonatomic)  UITextView *contentView;
@end

@implementation EvaluateViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initArr];
    [self configNavgationBar];
    [self initView];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
- (void)initArr{
    _attStr =[NSArray arrayWithObjects:@"非常不满意，各方面都很差",@"不满意，比较差",@"一般，需要改善",@"较满意，仍可以改善",@"非常满意,无可挑剔",nil];
    _badStr = [NSArray arrayWithObjects:@" 服务态度恶劣",@" 效率低下",@" 交通工具太破",@" 交通工具类型不符", nil];
    _goodStr = [NSArray arrayWithObjects:@" 服务态度棒",@" 效率很高",@" 交通工具棒",nil];
}

- (void)initView{
    static CGFloat space = 10;
    static CGFloat margin = 50;
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *headImageView = [UIImageView new];
    [headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_model.userHeadPath ]] placeholderImage:[UIImage imageNamed:@"user-1"]];
    headImageView.size = CGSizeMake(RATIO_H(72.5), RATIO_H(72.5));
    headImageView.top = RATIO_H(17);
    headImageView.centerX = self.view.centerX;
    headImageView.layer.cornerRadius = headImageView.height *0.5;
    headImageView.layer.masksToBounds = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoDetail)];
    [headImageView addGestureRecognizer:tap];
    headImageView.userInteractionEnabled = YES;
    
    [self.view addSubview:headImageView];
    
    MarkLabel *nameLabel = [[MarkLabel alloc]initWithFrame:CGRectMake(headImageView.x, headImageView.bottom + RATIO_H(space), headImageView.width, RATIO_H(20)) labelTextColor:COLOR_(102, 102, 102, 1) bgColor:[UIColor clearColor] fontSzie:13 labelText:_model.userName attributedString:nil];
    [self.view addSubview:nameLabel];
    
    NSString *typeTitle;
    switch (_info_type) {
        case 0:
            typeTitle = @"匿名评价镖师";
            break;
        case 1:
            typeTitle = @"匿名评价该物流公司";
            break;
        case 2:
            typeTitle = @"匿名评价该承运人";
            break;

        default:
            break;
    }
    
    MarkLabel *mark = [[MarkLabel alloc]initWithFrame:CGRectMake(nameLabel.x, nameLabel.bottom, nameLabel.width, nameLabel.height) labelTextColor:COLOR_(152, 152, 152, 1) bgColor:[UIColor clearColor] fontSzie:13 labelText:typeTitle attributedString:nil];
    [mark sizeToFit];
    mark.centerX = nameLabel.centerX;
    mark.adjustsFontSizeToFitWidth = NO;
    [self.view addSubview:mark];
    
    UIView *line1 = [UIView new];
    line1.backgroundColor = COLOR_(210, 210, 210, 1);
    line1.frame = CGRectMake(RATIO_H(margin) , 0, RATIO_H(77), 1);
    line1.centerY = mark.centerY;
    [self.view addSubview:line1];
    
    UIView *line2 = [UIView new];
    line2.backgroundColor = COLOR_(210, 210, 210, 1);
    line2.frame = CGRectMake(RATIO_H(margin) , 0, RATIO_H(77), 1);
    line2.centerY = mark.centerY;
    line2.x = WINDOW_WIDTH - RATIO_H(77) - RATIO_H(margin);
    [self.view addSubview:line2];
    
    _starsView = [[ZYRatingView alloc]initWithFrame:CGRectMake(0, mark.bottom + RATIO_H(space), RATIO_H(30) *5, RATIO_H(30))];
    _starsView.centerX = nameLabel.centerX;
    [_starsView setImagesDeselected:@"star_zero.png" partlySelected:@"star_one.png" fullSelected:@"star_one.png" andDelegate:self];
    
    _starsView.userInteractionEnabled = YES;
    [self.view addSubview:_starsView];
    
    _attitudeLaeble = [[MarkLabel alloc]initWithFrame:CGRectMake(0, _starsView.bottom + RATIO_H(space), WINDOW_WIDTH, nameLabel.height) labelTextColor:COLOR_ORANGE_DEFOUT bgColor:[UIColor clearColor] fontSzie:14 labelText:_attStr[3] attributedString:nil];
    _attitudeLaeble.textAlignment = NSTextAlignmentCenter;
    _attitudeLaeble.centerX = self.view.centerX;
    [self.view addSubview:_attitudeLaeble];
    
    _noticeLabel = [[MarkLabel alloc]initWithFrame:CGRectMake(RATIO_H(margin) , _attitudeLaeble.bottom + RATIO_H(space), WINDOW_WIDTH, nameLabel.height) labelTextColor: COLOR_(152, 152, 152, 1) bgColor:[UIColor clearColor] fontSzie:13 labelText:@"请选择标签" attributedString:nil];
    _noticeLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_noticeLabel];
    //标签
    [_starsView displayRating:8.0];
    _score = 8.0;
    _ifGood = YES;
    
    _contentView = [[UITextView alloc]initWithFrame:CGRectMake(RATIO_H(margin), _noticeLabel.bottom + 4*RATIO_H(space *2)+_starsView.height*3, WINDOW_WIDTH - 2*RATIO_H(margin), _starsView.height *2.5)];
    _contentView.font = FONT(15, NO);
    _contentView.placeholder = @"如果有其他意见或建议，请放心填写";
    _contentView.layer.cornerRadius = _contentView.height *0.2;
    _contentView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _contentView.layer.borderWidth = 1;
    _contentView.delegate = self;

    [self.view addSubview:_contentView];
    
    UIButton *btn = [UIButton buttonWithType:0];
    [btn setTitle:@"提交评价" forState:0];
    [btn setTitleColor:[UIColor whiteColor] forState:0];
    [btn setBackgroundColor:COLOR_MainColor];
    btn.frame = CGRectMake(0, _contentView.bottom + RATIO_H(space), _contentView.width/2, _starsView.height*1.3);
    btn.bottom = WINDOW_HEIGHT - 64 - RATIO_H(50);
    btn.centerX = self.view.centerX;
    btn.layer.cornerRadius = btn.height *0.2;
    [btn addTarget:self action:@selector(evalute) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    if (!_userId || _userId.length==0) {
        return;
    }
    switch (_info_type) {
        case 0:{
            [RequestManager getdriverdetailWithdriverId:_userId Success:^(id object) {
                _nextModel =object;
                
                nameLabel.text = [NSString stringWithFormat:@"%@",_nextModel.userName];
                [nameLabel sizeToFit];
                nameLabel.centerX = self.view.centerX;
                [headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_nextModel.userHeadPath]] placeholderImage:[UIImage imageNamed:@"user-1"]];
                btn.userInteractionEnabled = YES;
            }
            Failed:^(NSString *error) {
                                                     
         }];
        }
            
            break;
        case 1:{
            
        }
            break;
        case 2:{
            
        }
            break;
            
        default:
            break;
    }
    
    
    
}
- (void)gotoDetail{
    if (!_model) {
        return;
    }
    BiaoshiInfoViewController *vc = [[BiaoshiInfoViewController alloc]init];
    vc.userId = _model.userId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark starsChangeDelegate
-(void)ratingChanged:(float)newRating{
    _score = newRating;
    switch ((int)newRating) {
        case 2:
        {
            _attitudeLaeble.text = _attStr[0];
            [self removeMarks];
            [self addMarks:_badStr];
        }
            break;
        case 4:
        {
            _attitudeLaeble.text = _attStr[1];
            [self removeMarks];
            [self addMarks:_badStr];
        }
            break;
        case 6:
        {
            _attitudeLaeble.text = _attStr[2];
            [self removeMarks];
            [self addMarks:_badStr];
        }
            break;
        case 8:
        {
            _attitudeLaeble.text = _attStr[3];
            [self removeMarks];
            [self addMarks:_goodStr];
        }
            break;
        case 10:
        {
            _attitudeLaeble.text = _attStr[4];
            [self removeMarks];
            [self addMarks:_goodStr];
        }
            break;
            
        default:
            break;
    }
    if (newRating>=6) {
        _ifGood = YES;
    }
    else{
        _ifGood = NO;

        
    }
}

- (void)configNavgationBar {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 60)];
    label.textColor = [UIColor whiteColor];
    label.text = @"评价";
    label.textAlignment = 1;
    self.navigationItem.titleView = label;
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(backToMenuView)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    
}
- (void)backToMenuView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat )getLabelHeightWithText:(NSString *)text{
    UILabel *label = [UILabel new];
    label.text = text;
    label.font = [UIFont systemFontOfSize:14];
    [label sizeToFit];
    
    return label.size.height;
}
- (CGFloat )getLabelWidthWithText:(NSString *)text{
    UILabel *label = [UILabel new];
    label.text = text;
    label.font = [UIFont systemFontOfSize:14];
    [label sizeToFit];
    
    return label.size.width;
}

- (void)removeMarks{
    for (MarkBtn *btn in self.view.subviews) {
        
//        if ([btn isKindOfClass:[MarkBtn class]]) {
        if (btn.tag != 0) {
            [btn removeFromSuperview];
        }
    }
}
- (void)addMarks:(NSArray *)arr{
    
    
    static CGFloat space = 10;
    static CGFloat margin = 50;
    int j = 0;
    for (int i = 0; i < arr.count; i++) {
        UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        //    button1.backgroundColor = [UIColor lightGrayColor];
        [button1 setTitleColor:[UIColor lightGrayColor] forState:0];
        [button1 setTitle:arr[i] forState:UIControlStateNormal];
        CGFloat height = [self getLabelHeightWithText:arr[i] ];
        CGFloat width = [self getLabelWidthWithText:arr[i] ];
        button1.titleLabel.font = [UIFont systemFontOfSize:14];
        CGFloat btnWidth = height* 1.6  + width *1.1;
        button1.tag = i+1;
        button1.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        button1.layer.borderWidth = 1.0;
        button1.layer.masksToBounds = YES;
        button1.frame = CGRectMake(j%2 == 0? RATIO_H(margin):self.view.centerX, _noticeLabel.bottom + RATIO_H(space *2) *(j/2 + 1) + _starsView.height * (j/2), btnWidth, _starsView.height);
        [button1 setImage:[UIImage imageNamed:@"heart_nil"] forState:
         UIControlStateNormal];
        button1.layer.cornerRadius  = _starsView.height *0.5;
        if (arr == _goodStr) {
            [button1 addTarget:self action:@selector(changeGoodColor:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [button1 addTarget:self action:@selector(changeBadColor:) forControlEvents:UIControlEventTouchUpInside];
        }
        [button1 SetbuttonType:BtnTypeLeft];
        [self.view addSubview:button1];
        j++;
        
    }
    
    
    /*
    static CGFloat space = 10;
    static CGFloat margin = 50;
    int j = 0;
    for (int i = 0; i < arr.count; i++) {
        
        CGFloat height = [self getLabelHeightWithText:arr[i]];
        CGFloat width = [self getLabelWidthWithText:arr[i]];
        CGFloat btnWidth = height* 1.6  + width *1.1;
        CGFloat maxBtnWdth  = (WINDOW_WIDTH - RATIO_H(margin))*0.5;
        MarkBtn *btn = [MarkBtn buttonWithType:0];
        [btn setImage:[UIImage imageNamed:@"heart_nil"] forState:0];
        [btn setTitle:arr[i] forState:0];
        [btn setTitleColor:[UIColor lightGrayColor] forState:0];
        btn.tag = i;
        if (arr == _goodStr) {
            [btn addTarget:self action:@selector(changeGoodColor:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [btn addTarget:self action:@selector(changeBadColor:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        if (btnWidth > maxBtnWdth && (i%2 !=0)) {
            j++;
        }
        btn.frame = CGRectMake(j%2 == 0? RATIO_H(margin):self.view.centerX, _noticeLabel.bottom + RATIO_H(space *2) *(j/2 + 1) + _starsView.height * (j/2), btnWidth, _starsView.height);
        btn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        [self.view addSubview:btn];
        if (btnWidth > maxBtnWdth && (i%2 ==0)) {
            j++;
        }
        j++;
    }
     */
}
//- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
//    textView.text = @"";
//    return YES;
//}
- (void)changeGoodColor:(MarkBtn *)btn{
    
    if (!btn.selected) {
        [btn setTitleColor:[UIColor orangeColor] forState:0];
        btn.layer.borderColor = [[UIColor orangeColor] CGColor];
        [btn setImage:[UIImage imageNamed:@"heart"] forState:0];
        
    }else{
        [btn setTitleColor:[UIColor lightGrayColor] forState:0];
        btn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        [btn setImage:[UIImage imageNamed:@"heart_nil"] forState:0];
    }
    btn.selected = !btn.selected;
    
}
- (void)changeBadColor:(MarkBtn *)btn{
    if (!btn.selected) {
        [btn setTitleColor:[UIColor orangeColor] forState:0];
        btn.layer.borderColor = [[UIColor orangeColor] CGColor];
        [btn setImage:[UIImage imageNamed:@"heart_break"] forState:0];
        
    }else{
        [btn setTitleColor:[UIColor lightGrayColor] forState:0];
        btn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        [btn setImage:[UIImage imageNamed:@"heart_nil"] forState:0];
    }
    btn.selected = !btn.selected;
}

- (void)checkTags{
    _evaTags = @"";
    for (MarkBtn *btn in self.view.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            if (btn.selected) {
                NSLog(@"%d",(int)btn.tag) ;
                NSString *temStr = _ifGood ? _goodStr[btn.tag - 1] :_badStr[btn.tag- 1];
                _evaTags = [_evaTags stringByAppendingString:[NSString stringWithFormat:@"%@",temStr]];
            }
        }
        
    }
}

- (void)evalute{
    [self checkTags];
    _score = _score *0.5;
    
    [SVProgressHUD show];

    switch (_info_type) {
        case 0:
        {
            NSDictionary *dic = @{
                                  @"recId":_recId,
                                  @"driverId":_model.userId ?_model.userId :_userId,
                                  @"driverScore":[NSNumber numberWithFloat:_score],
                                  @"driverContent":_contentView.text ?[NSString stringWithFormat:@"%@",_contentView.text]  : @"",
                                  @"driverTag":[NSString stringWithFormat:@"%@\n",_evaTags]
                                  };
            [ExpressRequest sendWithParameters:dic MethodStr:API_ADD_EVALUATE reqType:k_POST success:^(id object) {
                //         NSDictionary *dic = [object valueForKey:@"data"];
                [SVProgressHUD showSuccessWithStatus:[object valueForKey:@"message"]];
                if (_userId && _userId.length > 0) {
                    [self.navigationController popViewControllerAnimated:YES];
                    [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH object:nil];
                    return ;
                }
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            } failed:^(NSString *error) {
                [SVProgressHUD showErrorWithStatus:error];
            }];

        }
            break;
        case 1:
        {
            NSDictionary *dic = @{
                                  @"recId":@"38",
                                  @"userToId":@"72437",
                                  @"evaluationScore":[NSNumber numberWithFloat:_score],
                                  @"evaluationContent":_contentView.text ?[NSString stringWithFormat:@"%@",_contentView.text]  : @"",
                                  @"evaluationTag":[NSString stringWithFormat:@"%@\n",_evaTags]
                                  };
            [ExpressRequest sendWithParameters:dic MethodStr:@"logistics/task/addEvaluation" reqType:k_POST success:^(id object) {
                //         NSDictionary *dic = [object valueForKey:@"data"];
                [SVProgressHUD showSuccessWithStatus:[object valueForKey:@"message"]];
                if (_userId && _userId.length > 0) {
                    [self.navigationController popViewControllerAnimated:YES];
                    [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH object:nil];
                    return ;
                }
                for (UIViewController *temp in self.navigationController.viewControllers) {
                    if ([temp isKindOfClass:[MywindViewController class]]) {
                        [self.navigationController popToViewController:temp animated:YES];
                        [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH object:nil];
                    }
                }
                
                //        if ([dic valueForKey:@"complate"]) {
                //            [SVProgressHUD showErrorWithStatus:[object valueForKey:@"message"]];
                //        }
                
            } failed:^(NSString *error) {
                [SVProgressHUD showErrorWithStatus:error];
            }];
            
        }
            break;
        case 2:
        {
            
        }
            break;
            
        default:
            break;
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
