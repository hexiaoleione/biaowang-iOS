//
//  FaWuLiuVC.m
//  iwant
//
//  Created by 公司 on 2017/2/14.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "FaWuLiuVC.h"
#import "ScrollLabelView.h"
#import "MainHeader.h"
#import "MHDatePicker.h"
#import "FaBiaoPersonView.h"
#import "FaWLGoodsInfoView.h"
#import "TopBarView.h"
#import "AddressViewController.h"
#import "LDPickViewController.h"
#import "Logist.h"
#import "LocationViewController.h"
#import "ActionSheetStringPicker.h"
#import "PublishWLOne.h"
#import "PublishWLTwo.h"

@interface FaWuLiuVC (){
    UIScrollView * _scrollerView;
    

    PublishWLOne * _publishOne;
    PublishWLTwo * _publishTwo;
    
    NSString * _endPlaceName; //市县名字
    
    
    NSString *_lat;
    NSString *_lon;
    NSString *_cityCodeFrom;
    NSString *_townCodeFrom;
    NSString *_cityCodeTo;
    NSString *_latitudeTo;//收件地纬度
    NSString *_longitudeTo;//收件地经度
    
    NSString * _takeCargo; //取
    NSString * _sendCargo; //送
}

@property (strong, nonatomic) MHDatePicker *selectTimePicker;

@end

@implementation FaWuLiuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _takeCargo = @"0";
    _sendCargo = @"0";
    
    [self initUI];
    [self firstFill];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(islogin) name:ISLOGIN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(islogout) name:ISLOGOUT object:nil];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [_publishOne addSubview: [self creatTopScrollerView]];
    [_publishTwo addSubview:[self creatTopScrollerView]];
}

-(void)initUI{
    __weak FaWuLiuVC * weakSelf = self;
    //允许改变层级
    self.view.autoresizesSubviews = YES;
    _scrollerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (SCREEN_WIDTH == 320) {
        _scrollerView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+100);
    }
    _publishOne = [[[NSBundle mainBundle] loadNibNamed:@"PublishWLOne" owner:nil options:nil] lastObject];
    _publishOne.frame = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _publishOne.BlockOne = ^(UIButton * sender,int tag){
        [weakSelf sendBtnClick:tag withSender:sender];
    };
    _publishTwo =  [[[NSBundle mainBundle] loadNibNamed:@"PublishWLTwo" owner:nil options:nil] lastObject];
    _publishTwo.frame = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _publishTwo.BlockTwo = ^(int tag){
        [weakSelf receiveBtnClick:tag ];
    };
    [_scrollerView addSubview:_publishOne];
    
    [self.view addSubview:_publishTwo];
    [self.view addSubview:_scrollerView];
}

#pragma mark  ------ 填充信息
-(void)firstFill{
    _publishTwo.sendNameTextField.text = [UserManager getDefaultUser].userName;
    _publishTwo.sendPhoneTextField.text = [UserManager getDefaultUser].mobile;
    _publishOne.locatLabel.text = [[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCASTR];
    _lon = [[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCATION_LON] ;
    _lat = [[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCATION_LAT];
    _cityCodeFrom = [[NSUserDefaults standardUserDefaults] valueForKey:USER_CITY_CODE];
    _townCodeFrom = [[NSUserDefaults standardUserDefaults] valueForKey:USER_TOWN_CODE];
}

-(UIView *)creatTopScrollerView{
    UIView *   topScrollView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    topScrollView.backgroundColor = [UIColor whiteColor];
    ScrollLabelView * scrollLabel = [[ScrollLabelView alloc]initWithFrame:CGRectMake(85, 0, SCREEN_WIDTH - 95, 30)];
    [scrollLabel addObaserverNotification];
    scrollLabel.textColor = COLOR_ORANGE_DEFOUT;
    scrollLabel.textFont = [UIFont systemFontOfSize:14];
    scrollLabel.text = @"您的物流将由多家物流公司报价，请留意系统提示，选择最合适的物流公司。";
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 85, 30)];
    label.text =@"  温馨提示：";
    label.font = [UIFont systemFontOfSize:15];
    [topScrollView addSubview:label];
    [topScrollView addSubview:scrollLabel];
    return topScrollView;
}

-(void)sendBtnClick:(int)tag withSender:(UIButton *)sender{
    switch (tag) {
        case 0:{
           
        }
            break;
        case 1:
        {
            LocationViewController *addVC = [[LocationViewController alloc]init];
            addVC.passBlock = ^(NSString *address,NSString *name,NSString *la,NSString *lon,NSString *cityCode,NSString *cityName,NSString *townCode,NSString *townName){
                _publishOne.locatLabel.text = [NSString stringWithFormat:@"%@%@",address,name];
                _lat = la;
                _lon = lon;
                _cityCodeFrom = cityCode;
                _townCodeFrom = townCode;
            };
            [self.navigationController pushViewController:addVC animated:YES];
        }
            break;
        case 2:
        {
            LocationViewController *addVC = [[LocationViewController alloc]init];
            addVC.passBlock = ^(NSString *address,NSString *name,NSString *la,NSString *lon,NSString *cityCode,NSString *cityName,NSString *townCode,NSString *townName){
                _publishOne.endTextField.text = [NSString stringWithFormat:@"%@%@",address,name];
                _latitudeTo = la;
                _longitudeTo = lon;
                _cityCodeTo = cityCode;
                _endPlaceName = [NSString stringWithFormat:@"%@%@",cityName,townName];
            };
            [self.navigationController pushViewController:addVC animated:YES];
        }
            break;
        case 3:
        {
            [self PickTimebtn:_publishOne.timeTextField];
        }
            break;
        case 4:
        {
            //公斤或者吨  单位选择
           NSArray * arr = @[@"吨",@"公斤"];
           [ActionSheetStringPicker showPickerWithTitle:@"单位选择" rows:arr initialSelection:0 target:self successAction:@selector(squreSelected:element:sender:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
        }
            break;
        case 5:{
            [self.view bringSubviewToFront:_publishTwo];
        }
            break;
        default:
            break;
    }
}

-(void)squreSelected:(NSNumber *)selectedIndex element:(id)element sender:(UIButton *)sender{
    if (selectedIndex == 0) {
     [_publishOne.danweiBtn setTitle:@"吨" forState:UIControlStateNormal];

    }else{
     [_publishOne.danweiBtn setTitle:@"公斤" forState:UIControlStateNormal];
    }
}
- (void)actionPickerCancelled:(id)sender {
    
}

-(void)receiveBtnClick:(int)tag{
    switch (tag) {
        case 0:{
         
        }
            break;
        case 1:
        {
            [Contacts judgeAddressBookPowerWithUIViewController:self contactsBlock:^(NSString *name, NSString *phoneNumber) {
                _publishTwo.sendNameTextField.text = name;
                _publishTwo.sendPhoneTextField.text = phoneNumber;

            }];
        }
            break;
        case 2:
        {
            [Contacts judgeAddressBookPowerWithUIViewController:self contactsBlock:^(NSString *name, NSString *phoneNumber) {
            _publishTwo.receiveNameTextField.text = name;
            _publishTwo.receivePhoneTextField.text = phoneNumber;
        }];
        }
            break;
        case 3:{
            //公司上门取货
            _publishTwo.QuHuoBlock = ^(NSString *takeCargo) {
                _takeCargo = takeCargo;
            };
        }
            break;
        case 4:
        {
            //公司送货上门
            _publishTwo.SongHuoBlock = ^(NSString *sendCargo) {
                _sendCargo =sendCargo;
            };
        }
            break;
        case 5:
        {
            [self.view bringSubviewToFront:_scrollerView];
        }
            break;
        case 6:{
            [self makeSure];
        }
            break;
        default:
            break;
    }
}


-(void)PickTimebtn:(UITextField *)textField
{
    _selectTimePicker = [[MHDatePicker alloc] init];
    _selectTimePicker.datePickerMode=UIDatePickerModeDate;
    _selectTimePicker.isBeforeTime = NO;
    __weak typeof(self) weakSelf = self;
    [_selectTimePicker didFinishSelectedDate:^(NSDate *selectedDate) {
        textField.text = [weakSelf dateStringWithDate:selectedDate DateFormat:@"yyyy-MM-dd"];
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

#pragma mark ---- 确认发布
-(void)makeSure{
//发布之后注意清空一些内容  然后注意跳转
    if (![self checkPrem]) {
        return;
    }
    [SVProgressHUD show];
    //发货地拼接
    NSString * fromAdddress = [NSString stringWithFormat:@"%@%@",_publishOne.locatLabel.text,_publishOne.startDetailTextField.text];
    //收货地
    NSString * toAddress = [NSString stringWithFormat:@"%@%@",_publishOne.endTextField.text,_publishOne.endDetailTextField.text];
    
    NSDictionary * dic =@{k_USER_ID:[UserManager getDefaultUser].userId,
                          @"sendPerson":_publishTwo.sendNameTextField.text,
                          @"sendPhone":_publishTwo.sendPhoneTextField.text,
                          @"cargoName":_publishOne.goodsNameTextField.text,
                          @"startPlace":fromAdddress,
                          @"entPlace":toAddress,
                          @"takeCargo":_takeCargo ,
                          @"sendCargo":_sendCargo ,
                          @"cargoWeight":[NSString stringWithFormat:@"%@%@",_publishOne.weightTextField.text,_publishOne.danweiBtn.currentTitle],
                          @"cargoVolume":_publishOne.goodsSqureTextField.text,
                          @"arriveTime":_publishOne.timeTextField.text,
                          @"takeName":_publishTwo.receiveNameTextField.text,
                          @"takeMobile":_publishTwo.receivePhoneTextField.text,
                          @"latitude":_lat?_lat:@"",
                          @"longitude":_lon?_lon:@"",
                          @"startPlaceCityCode":_cityCodeFrom,
                          @"startPlaceTownCode":_townCodeFrom,
                          @"entPlaceCityCode":_cityCodeTo,
                          @"latitudeTo":_latitudeTo,
                          @"longitudeTo":_longitudeTo,
                          @"endPlaceName":_endPlaceName,
                          @"cargoNumber":_publishOne.cargoNumberTextField.text ?_publishOne.cargoNumberTextField.text :@"",
                          @"appontSpace":_publishTwo.ZiTiRemarkTextField.text ? _publishTwo.ZiTiRemarkTextField.text :@""
                          };
    [ExpressRequest sendWithParameters:dic MethodStr:@"logistics/task/publishNew" reqType:k_POST success:^(id object) {
        [SVProgressHUD dismiss];
        [self removeAllInfo];
        [self.view bringSubviewToFront:_scrollerView];
         [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(sendSuceed) userInfo:nil repeats:NO];

    } failed:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
}
-(void)sendSuceed{
    [SVProgressHUD showSuccessWithStatus:@"发布成功"];
}

-(void)removeAllInfo{
    [self firstFill];
    _publishOne.startDetailTextField.text = @"";
    _publishOne.endDetailTextField.text =@"";
    _publishOne.endTextField.text = @"";
    _publishTwo.receivePhoneTextField.text = @"";
    _publishTwo.receiveNameTextField.text = @"";
//    [_publishTwo.takeBtn setImage:[UIImage imageNamed:@"toubaokuangLmg"] forState:UIControlStateNormal];
//    [_publishTwo.sendBtn setImage:[UIImage imageNamed:@"toubaokuangLmg"] forState:UIControlStateNormal];
    _publishTwo.labelOne.text = @"送到货场";
    _publishTwo.labelTwo.text = @"用户自提";
    _publishTwo.ZiTiRemarkTextField.text = @"";
    _publishOne.weightTextField.text = @"";
    _publishOne.cargoNumberTextField.text = @"";
    _publishOne.timeTextField.text =@"";
    _publishOne.goodsNameTextField.text = @"";
    _publishOne.goodsSqureTextField.text = @"";
    [_publishOne.danweiBtn setTitle:@"吨" forState:UIControlStateNormal];
    _takeCargo = @"0";
    _sendCargo = @"0";
}

- (BOOL)checkPrem{
    if (_publishTwo.sendNameTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请填写发货人姓名"];
        return NO;
    }
    if (_publishTwo.sendPhoneTextField.text.length != 11) {
        [SVProgressHUD showErrorWithStatus:@"请填写正确的发货人手机号"];
        
        return NO;
    }
    if (_publishOne.locatLabel.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择起始地点"];
        return NO;
    }
    
    if (_publishTwo.receiveNameTextField.text.length == 0 ) {
        [SVProgressHUD showErrorWithStatus:@"请填写收货人姓名"];
        return NO;
    }
    if (_publishTwo.receivePhoneTextField.text.length != 11) {
        [SVProgressHUD showErrorWithStatus:@"请填写正确的收货人手机号"];
        return NO;
    }

    if (_publishOne.endTextField.text.length == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"请选择到达地点"];
        return NO;
    }
    
    if (_publishOne.weightTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请填写货物重量"];
        return NO;
    }
    
    if (_publishOne.goodsSqureTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请填写货物体积"];
        return NO;
    }
    
    if (_publishOne.timeTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择到达时间"];
        return NO;
    }
       return YES;
}

//登录之后的操作
-(void)islogin{
    [self firstFill];
    /*    _sendInfoView.nameTextField.text = [UserManager getDefaultUser].userName;
    _sendInfoView.phoneTextField.text = [UserManager getDefaultUser].mobile;
    _sendInfoView.locatLabel.text = [[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCASTR];
    _lon = [[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCATION_LON] ;
    _lat = [[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCATION_LAT];
    _cityCodeFrom = [[NSUserDefaults standardUserDefaults] valueForKey:USER_CITY_CODE];
    _townCodeFrom = [[NSUserDefaults standardUserDefaults] valueForKey:USER_TOWN_CODE];
     */
}
-(void)islogout{
    [self removeAllInfo];
    _publishTwo.sendNameTextField.text = @"";
    _publishTwo.sendPhoneTextField.text = @"";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
