//
//  SendWindTripViewController.m
//  iwant
//
//  Created by pro on 16/4/18.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "SendWindTripViewController.h"
#import "MainHeader.h"
#import "YMTextView.h"
#import "MHDatePicker.h"
#import "RequestManager.h"
#import "UserManager.h"

//#import "OperationViewController.h"


#define ScreenW                [[UIScreen mainScreen] bounds].size.width
#define ScreenH               [[UIScreen mainScreen] bounds].size.height
#define BACKGROUND_COLOR            [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0]

//按比例获取高度
#define  WGiveHeight(HEIGHT) HEIGHT * [UIScreen mainScreen].bounds.size.height/568.0

//按比例获取宽度
#define  WGiveWidth(WIDTH) WIDTH * [UIScreen mainScreen].bounds.size.width/320.0

@interface SendWindTripViewController ()<UITextFieldDelegate>
{
    UITableView *_tableView;
    UIView *_TopView;
    UIView *_bottom;

    
    UIButton *_firstBtn;
    UIButton *_secBtn;
    UIButton *_thirdBtn;
    UIButton *_courentBtn;//当前按钮
    
    UITextField *_PickTimeFiled;
    UITextField *_StartplaceFiled;
    UITextField *_EndingplaceFiled;

    NSString * _time;
    NSString *_startLat;
    NSString *_startLon;
    NSString *_endLat;
    NSString *_endtLon;
    NSString *_startCityCode;
    NSString *_endCityCode;
    
    NSString *_transType;
}
//输入控件
@property (nonatomic, weak) YMTextView *textView;

@property (strong, nonatomic) MHDatePicker *selectTimePicker;
@property (strong, nonatomic) MHDatePicker *selectDatePicker;
@end

@implementation SendWindTripViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configNavgationBar];
    [self CreatTableview];
    [self CreatSubwviews];
    
}
-(void)CreatTableview
{
    
_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
_tableView.backgroundColor = BACKGROUND_COLOR;

_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

[self.view addSubview:_tableView];

}
#pragma mark- 界面UI
-(void)CreatSubwviews
{
    _TopView = [[UIView alloc]initWithFrame:CGRectMake(15, WGiveHeight(20), ScreenW-30, WGiveHeight(240))];
    _TopView.layer.cornerRadius = 10;
    
    _TopView.backgroundColor = [UIColor whiteColor];
    [_tableView addSubview:_TopView];
    
    UIImageView *barView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _TopView.frame.size.width, _TopView.frame.size.height)];
    barView.userInteractionEnabled = YES;
    barView.contentMode = UIViewContentModeScaleToFill;
    barView.clipsToBounds = YES;
    [barView setImage:[UIImage imageNamed:@"qishi_bg"]];
    [_TopView addSubview:barView];
    
    _PickTimeFiled = [[UITextField alloc]initWithFrame:CGRectMake(WGiveWidth(30), WGiveHeight(60), WINDOW_WIDTH-WGiveWidth(60), WGiveHeight(40))];
    //    _StartplaceFiled.keyboardType = UIKeyboardTypeNumberPad;
    //    _mobile.borderStyle = UITextBorderStyleLine;
    _PickTimeFiled.backgroundColor = [UIColor clearColor];
    _PickTimeFiled.placeholder = @"请选择出发时间";
    _PickTimeFiled.font = [UIFont systemFontOfSize:16];
    _PickTimeFiled.textAlignment = NSTextAlignmentLeft;
    _PickTimeFiled.delegate = self;
    [barView addSubview:_PickTimeFiled];
    
    UIButton *PickTimebtn = [[UIButton alloc]initWithFrame:_PickTimeFiled.frame];
    [PickTimebtn addTarget:self action:@selector(PickTimebtn) forControlEvents:UIControlEventTouchUpInside];
    [barView addSubview:PickTimebtn];

    
    
    
    _StartplaceFiled = [[UITextField alloc]initWithFrame:CGRectMake(WGiveWidth(30), WGiveHeight(110), WINDOW_WIDTH-WGiveWidth(60) -30, WGiveHeight(40))];
//    _StartplaceFiled.keyboardType = UIKeyboardTypeNumberPad;
    //    _mobile.borderStyle = UITextBorderStyleLine;
    _StartplaceFiled.backgroundColor = [UIColor clearColor];
    _StartplaceFiled.placeholder = @"现在在哪儿";
    _StartplaceFiled.font = [UIFont systemFontOfSize:16];
    _StartplaceFiled.textAlignment = NSTextAlignmentLeft;
    _StartplaceFiled.delegate = self;
    [barView addSubview:_StartplaceFiled];
    
    UIButton *Startplacebtn = [[UIButton alloc]initWithFrame:_StartplaceFiled.frame];
    [Startplacebtn addTarget:self action:@selector(StartplaceBtn) forControlEvents:UIControlEventTouchUpInside];
    [barView addSubview:Startplacebtn];

    
    
    
    
    
    
    _EndingplaceFiled = [[UITextField alloc]initWithFrame:CGRectMake(WGiveWidth(30), WGiveHeight(150), WINDOW_WIDTH-WGiveWidth(60) -30, WGiveHeight(40))];
    //    _StartplaceFiled.keyboardType = UIKeyboardTypeNumberPad;
    //    _mobile.borderStyle = UITextBorderStyleLine;
    _EndingplaceFiled.backgroundColor = [UIColor clearColor];
    _EndingplaceFiled.placeholder = @"你要去哪儿";
    _EndingplaceFiled.font = [UIFont systemFontOfSize:16];
    _EndingplaceFiled.textAlignment = NSTextAlignmentLeft;
    _EndingplaceFiled.delegate = self;
    [barView addSubview:_EndingplaceFiled];
    
    UIButton *EndingplaceBtn = [[UIButton alloc]initWithFrame:_EndingplaceFiled.frame];
    [EndingplaceBtn addTarget:self action:@selector(EndingplaceBtn) forControlEvents:UIControlEventTouchUpInside];
    [barView addSubview:EndingplaceBtn];
    

    
    
    

    YMTextView *textView = [[YMTextView alloc] init];
    textView.frame = CGRectMake(0, WGiveHeight(195), _TopView.frame.size.width, WGiveHeight(60));
    textView.backgroundColor = [UIColor clearColor];
    textView.font = [UIFont systemFontOfSize:13];
    //设置占位文字
    textView.placeholder = @"备注：（选填）";
    //设置占位文字颜色
    //    textView.placeholderColor = [UIColor redColor];
    [barView addSubview:textView];
    self.textView = textView;
    //监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:textView];

    

  //交通工具
    
    _bottom = [[UIView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(_TopView.frame)+WGiveHeight(20), ScreenW-30, WGiveHeight(120))];
    _bottom.layer.cornerRadius = 10;
    
    _bottom.backgroundColor = [UIColor whiteColor];
    [_tableView addSubview:_bottom];
   
    UILabel *headLabel = [[UILabel alloc]initWithFrame:CGRectMake(WGiveWidth(20),5, ScreenW, WGiveHeight(40))];
    headLabel.backgroundColor = [UIColor clearColor];
    headLabel.text = @"交通工具";
    headLabel.textColor = [UIColor grayColor];
    headLabel.font = [UIFont systemFontOfSize:18];
    [_bottom addSubview:headLabel];

    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, WGiveHeight(50), _bottom.frame.size.width, WGiveHeight(0.2))];
    line.backgroundColor = [UIColor grayColor];
    [_bottom addSubview:line];

    
    _firstBtn = [self creatBtnWithNormalImage:@"hui_fei" SelectImage:@"fei_none" X:WGiveWidth(20) Y:WGiveHeight(60) W:WGiveWidth(50) H:WGiveHeight(50) tag:1];
    
    _secBtn = [self creatBtnWithNormalImage:@"car" SelectImage:@"car_selected" X:WGiveWidth(120) Y:WGiveHeight(60) W:WGiveWidth(50) H:WGiveHeight(50) tag:2];
    
    _thirdBtn = [self creatBtnWithNormalImage:@"bicycle" SelectImage:@"bicycle_selected" X:WGiveWidth(220) Y:WGiveHeight(60) W:WGiveWidth(50) H:WGiveHeight(50) tag:3];

    
    UIButton *Surebtn = [[UIButton alloc]initWithFrame:CGRectMake(WGiveWidth(75),CGRectGetMaxY(_bottom.frame)+WGiveHeight(30),ScreenW -WGiveWidth(150),WGiveHeight(35))];
    Surebtn.titleLabel.font = FONT(15,NO);
    [Surebtn setBackgroundColor:[UIColor orangeColor]];
    [Surebtn setTitle:@"确认发布" forState:UIControlStateNormal];
    Surebtn.layer.cornerRadius = 10.0;
    Surebtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [Surebtn addTarget:self action:@selector(SureSendwindTrip) forControlEvents:UIControlEventTouchUpInside];
    [_tableView addSubview:Surebtn];
    
}

/**
 *  监听文字改变
 */
-(void)textDidChange {
    
    if (self.textView.hasText) {
//        NSLog(@"文字发生改变----%@",self.textView.text);
    }
    
    
    
}

-(void)dealloc {
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//发布顺风行程
-(void)SureSendwindTrip
{
    if (![self checkTextField]) {
        return;
    }
    [SVProgressHUD show];
    
    [RequestManager sendtailWindTripWithuserid:[UserManager getDefaultUser].userId
                                      cityCode:_startCityCode
                                      latitude:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCATION_LAT]]
                                     longitude:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCATION_LON]]
                                      cityCideTo:_endCityCode
                                       address:_StartplaceFiled.text
                                     addressTo:_EndingplaceFiled.text
                                     leaveTime:_time
                              transportationId:_transType
                                        remark:self.textView.text ?self.textView.text :@""
                                  fromLatitude:_startLat
                                 fromLongitude:_startLon
                                    toLatitude:_endLat
                                   toLongitude:_endtLon
                                       success:^(NSMutableArray *result) {
                                           
                   [SVProgressHUD showSuccessWithStatus:@"发布成功"];
                   [self gotoMyWind];
        
    } Failed:^(NSString *error) {
        
        [SVProgressHUD showErrorWithStatus:error];
    }];
    
}

-(void)PickTimebtn
{
    
      _selectTimePicker = [[MHDatePicker alloc] init];
     __weak typeof(self) weakSelf = self;
    [_selectTimePicker didFinishSelectedDate:^(NSDate *selectedDate) {
        //        NSString *string = [NSString stringWithFormat:@"%@",[NSDate dateWithTimeInterval:3600*8 sinceDate:selectedDate]];
        //        weakSelf.myLabel.text = string;
        _PickTimeFiled.text = [weakSelf dateStringWithDate:selectedDate DateFormat:@"MM月dd日 HH:mm 准时出发"];
        
        _time = [[NSString alloc]init];
        _time = [weakSelf dateStringWithDate:selectedDate DateFormat:@"yyyy-MM-dd HH:mm"];
        NSLog(@"-------%@++++++++++",_time);
    }];
}

- (NSString *)dateStringWithDate:(NSDate *)date DateFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    NSString *str = [dateFormatter stringFromDate:date];
    return str ? str : @"";
}

-(void)StartplaceBtn
{
    
}
-(void)EndingplaceBtn
{
}
-(UIButton *)creatBtnWithNormalImage:(NSString *)image SelectImage:(NSString *)selectimage X:(CGFloat)x Y:(CGFloat)y W:(CGFloat)w H:(CGFloat)h tag:(int)tag{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(x, y, w, h)];
    
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    
    [btn setImage:[UIImage imageNamed:selectimage] forState:UIControlStateSelected];

//    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    btn.layer.borderColor = [[UIColor grayColor]CGColor];
    btn.layer.cornerRadius = 30.0;
    
//    btn.layer.borderWidth = 1;
    
    btn.backgroundColor = [UIColor  whiteColor];
    btn.tag = tag;
        [btn addTarget:self action:@selector(tapBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_bottom addSubview:btn];
    return btn;
}
- (void)tapBtn:(id)sender{
    
    UIButton *btn = (UIButton*)sender;
    switch (btn.tag) {
        case 1:
//            _firstBtn.selected = NO;
//            _secBtn.selected = NO;
//            _thirdBtn.selected = NO;
//            _courentBtn = _firstBtn;
//           
//            
//            NSLog(@"%ld",(long)_courentBtn.tag);
//            _transType = @"3";
            return;
            
            break;
        case 2:
            _firstBtn.selected = NO;
            _secBtn.selected = YES;
             _thirdBtn.selected = NO;
            _courentBtn = _secBtn;

            NSLog(@"%ld",(long)_courentBtn.tag);
            _transType = @"1";

            break;
        case 3:
            _firstBtn.selected = NO;
            _secBtn.selected = NO;
            _thirdBtn.selected = YES;
            _courentBtn = _firstBtn;
            NSLog(@"%ld",(long)_thirdBtn.tag);
            _transType = @"2";

            break;

    }
}
-(NSString *)deleteCity:(NSString *)str{
//    if (!str || [str isEqualToString:@""]) {
//        return str;
//    }
//    NSString *temp = [str substringToIndex:2];
//    NSString *temp2 = [str substringFromIndex:4];
//    NSRange range = [temp2 rangeOfString:temp];//判断字符串是否包含
//    if (range.length >0)//包含
//    {
//        return temp2;
//    }else{
        return str;
//    }
}


- (void)configNavgationBar {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 60)];
    label.textColor = [UIColor whiteColor];
    label.text = @"发布顺风行程";
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)checkTextField{
    NSString *message = nil;
    if (!_transType || [_transType isEqualToString:@""]) {
        message = @"请选择您的交通工具!";
    }
    if (!_courentBtn) {
        message = @"请选择您的交通工具!";
    }
    if ([_EndingplaceFiled.text isEqualToString:@""]) {
        message = _EndingplaceFiled.placeholder;
    }
    if ([_StartplaceFiled.text isEqualToString:@""]) {
        message = _StartplaceFiled.placeholder;
    }
    if ([_PickTimeFiled.text isEqualToString:@""]) {
        message = _PickTimeFiled.placeholder;
    }
    if (message) {
        [SVProgressHUD showErrorWithStatus:message];
        return NO;
    }else{
        return YES;
    }
    return YES;
}

- (void)gotoMyWind{
    [self.navigationController popToRootViewControllerAnimated:YES];
    NSDictionary *dic = @{CLASS_NAME:@"MywindViewController",
                          OTHER:@"2",
                          METHOD_NAME:@"btnClick:"};
    [[NSNotificationCenter defaultCenter] postNotificationName:GOTOVC object:dic];
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
