//
//  FaViewConstroller.m
//  iwant
//
//  Created by 公司 on 2017/6/2.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "FaViewConstroller.h"
#import "MainHeader.h"
#import "SFFaViewConstroller.h"
#import "XSFaViewConstroller.h"
#import "WLFaViewController.h"
#import "LocationViewController.h"
#import "ActionSheetStringPicker.h"
#import "carTypeModel.h"
#import "NSDate+Category.h"

#import "MHDatePicker.h"
#import "XZPickView.h"
#import "ColdFaViewController.h"

@interface FaViewConstroller ()<UITextFieldDelegate,XZPickViewDelegate, XZPickViewDataSource>{
    NSString * _matWeight;
    NSString * _cargoSize;
    NSString * _time;
    
    NSString * _weatherId; //天气
    NSString * _temp; //温度
}

@property (nonatomic,copy)NSString * insureUrl;  //下一页需要的网址链接
@property (nonatomic,strong)NSMutableArray * weightArr;
@property (nonatomic,strong)NSMutableArray * countArr;
@property (nonatomic,strong)NSMutableArray * carTypeArr;
@property (nonatomic,strong)NSMutableArray * carTypeNameArr;
@property (strong, nonatomic) MHDatePicker *selectTimePicker;

//时间选择
@property (nonatomic,strong) XZPickView * pickView;
@property (nonatomic,copy) NSDictionary * dateDic;
@property (nonatomic,copy) NSString * weekStr;
@property (nonatomic,copy) NSString * timeStr;
@property (nonatomic, strong) NSDate *selectDate;
@property (nonatomic, assign) NSInteger currentSelectDay;

@end

@implementation FaViewConstroller

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.endPlaceLabelHeightConstrainr.constant = 28 * RATIO_HEIGHT;
    self.weightBtnHeightConstraint.constant = 45 * RATIO_HEIGHT;
    self.timeTextFieldHeightConstraint.constant = 40 * RATIO_HEIGHT;
    self.jianshuBtnHeightConstraint.constant = 45 * RATIO_HEIGHT;
    self.carTypeTextFieldHeightConstraint.constant = 45 * RATIO_HEIGHT;
    self.submitTopConstraint.constant = 40*RATIO_HEIGHT;
    
    self.distanceTopConstraint.constant = 20 *RATIO_HEIGHT;
    self.onlyTuijianXSTopConstraint.constant = 26 *RATIO_HEIGHT;
    self.tuijianTopConstraint.constant = 16*RATIO_HEIGHT;
    self.weatherNoticeTopConstraint.constant = 16*RATIO_HEIGHT;
    
    self.startPlaceDetailL.font = FONT(12, NO);
    self.endPlaceDetailL.font = FONT(12, NO);
    
    self.weightL.font = FONT(18, YES);
    self.carTypeL.font = FONT(18, YES);
    self.jianshuL.font = FONT(18, YES);
    self.timeL.font = FONT(18, YES);
    
    self.carTypeTextField.userInteractionEnabled = NO;
    self.carTypeTextField.font = FONT(18, NO);
    
    self.weightBtn.titleLabel.font = FONT(18, NO);
    self.jianshuBtn.titleLabel.font =FONT(18, NO);
    self.timeTextField.font = FONT(18, NO);
    self.timeTextField.userInteractionEnabled = NO;
    self.startPlaceL.font = FONT(17, NO);
    self.endPlaceL.font = FONT(17, NO);
    self.endPlaceL.textColor = [UIColor blackColor];
    self.endPlaceDetailL.font = FONT(13, NO);
    
    self.distanceLabel.font = FONT(18, NO);
    
    self.noticeLabel.font = FONT(14, NO);
    
    self.SFNoticeL.font = FONT(14, NO);
    self.XSNoticeL.font = FONT(14, NO);
    self.Only_XSNoticeL.font = FONT(15, NO);
    self.SFMoneyL.font = FONT(17, NO);
    self.XSMoneyL.font = FONT(17, NO);
    self.Only_XSMoneyL.font = FONT(20, NO);
    [self hiddenTuijianView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self ShowNavgationView];
    self.endPlaceDetailL.delegate = self;
    self.startPlaceDetailL.delegate = self;
    [self creatData];
    if ([UserManager getDefaultUser].shopType == 1) {
        [self getChapmanData];
    }
    _matWeight = @"5";
    _cargoSize = @"1";
    if (self.type ==1 || self.type == 2 ) {
        _startPlaceL.text = [NSString stringWithFormat:@"%@",_model.address];
        self.endPlaceL.text = self.model.addressTo;
        if ([self.model.matWeight intValue]==5) {
            [self.weightBtn setTitle:[NSString stringWithFormat:@"≤%@公斤",self.model.matWeight] forState:UIControlStateNormal];
        }else{
            [self.weightBtn setTitle:[NSString stringWithFormat:@"%@公斤",self.model.matWeight] forState:UIControlStateNormal];
        }
        self.carTypeTextField.text = [NSString stringWithFormat:@"%@",self.model.matVolume];
        [self.jianshuBtn  setTitle:[NSString stringWithFormat:@"%@件",self.model.cargoSize] forState:UIControlStateNormal];
        
    }else if(self.type == 3){
        _startPlaceL.text = [NSString stringWithFormat:@"%@",self.wlModel.startPlace];
        self.endPlaceL.text = self.wlModel.entPlace;
        if ([self.wlModel.weight intValue]==5) {
            [self.weightBtn setTitle:[NSString stringWithFormat:@"≤5公斤"] forState:UIControlStateNormal];
        }else{
            [self.weightBtn setTitle:[NSString stringWithFormat:@"%@公斤",self.wlModel.weight] forState:UIControlStateNormal];
        }
        [self.jianshuBtn  setTitle:[NSString stringWithFormat:@"%@件",self.wlModel.cargoSize] forState:UIControlStateNormal];
        self.carTypeTextField.text = [NSString stringWithFormat:@"%@",self.wlModel.carName];

    }else{
        _model.matWeight = _matWeight;
        _model.cargoSize = _cargoSize;
        
        _wlModel.weight = _matWeight;
        _wlModel.cargoSize = _cargoSize;
        _startPlaceL.text = [NSString stringWithFormat:@"%@",_model.address];
        
        NSString * urlStr = [NSString stringWithFormat:@"%@%@?userId=%@",BaseUrl,API_FD_LatesAddress,[UserManager getDefaultUser].userId];
        [ExpressRequest sendWithParameters:nil MethodStr:urlStr reqType:k_GET success:^(id object){
        
            if ([[object objectForKey:@"errCode"] integerValue] == 0) {
                
               _startPlaceL.text = [NSString stringWithFormat:@"%@",[[object objectForKey:@"data"]objectForKey:@"locationAddress"] ];
                _startPlaceDetailL.text = [NSString stringWithFormat:@"%@",[[object objectForKey:@"data"]objectForKey:@"address"] ];
                _model.cityCode = [NSString stringWithFormat:@"%@",[[object objectForKey:@"data"]objectForKey:@"cityCode"] ];
                _model.fromLongitude= [NSString stringWithFormat:@"%@",[[object objectForKey:@"data"]objectForKey:@"fromLongitude"] ];
                _model.fromLatitude = [NSString stringWithFormat:@"%@",[[object objectForKey:@"data"]objectForKey:@"fromLatitude"] ];;
                _cityName = [NSString stringWithFormat:@"%@",[[object objectForKey:@"data"]objectForKey:@"cityName"]];
                _wlModel.latitude = [NSString stringWithFormat:@"%@",[[object objectForKey:@"data"]objectForKey:@"fromLatitude"] ];;
                _wlModel.longitude = [NSString stringWithFormat:@"%@",[[object objectForKey:@"data"]objectForKey:@"fromLongitude"] ];;
                _wlModel.startPlaceCityCode = [NSString stringWithFormat:@"%@",[[object objectForKey:@"data"]objectForKey:@"cityCode"] ];
            }
            
        }failed:^(NSString *error) {
            
        }
         ];
        
    }
    
    //默认选择一小时之后的时间
     [self getCurrentTimesAddOneHour];
}

-(void)creatData{
    NSString * carTypeUrl = [NSString stringWithFormat:@"%@downwind/task/carType",BaseUrl];
    [SVProgressHUD show];
    [ExpressRequest sendWithParameters:nil MethodStr:carTypeUrl reqType:k_GET success:^(id object){
    [SVProgressHUD dismiss];
        _carTypeArr = [[NSMutableArray alloc]init];
        _carTypeNameArr = [[NSMutableArray alloc]init];
        NSArray * arr = [object valueForKey:@"data"];
        for (NSDictionary *dic in arr) {
            carTypeModel * carModel = [[carTypeModel alloc]initWithJsonDict:dic];
            [_carTypeArr addObject:carModel];
            [_carTypeNameArr addObject:carModel.carName];
        }
        //如果再来一单 就不需要有默认值了 防止因为数据请求的快慢产生问题
        if (self.type ==1 || self.type == 2 || self.type == 3) {
            
        }else{
           carTypeModel * model = _carTypeArr[0];
           self.model.carType = model.carType;
           //此处传matVolume  是为了之后显示那个carname  后台不用新的字段
           self.model.matVolume = model.carName;
           self.wlModel.carType = model.carType;
           self.wlModel.carName = model.carName;
          self.carTypeTextField.text = [NSString stringWithFormat:@"%@",model.carName];
        }
      }failed:^(NSString *error) {
       [SVProgressHUD showErrorWithStatus:error];
     }
   ];
}

-(void)getChapmanData{
    NSString * urlStr = [NSString stringWithFormat:@"%@check/getChapman?userId=%@",BaseUrl,[UserManager getDefaultUser].userId];
    [SVProgressHUD show];
    [ExpressRequest sendWithParameters:nil MethodStr:urlStr reqType:k_GET success:^(id object) {
        [SVProgressHUD dismiss];
        NSArray * arr = [object valueForKey:@"data"][0];
        self.startPlaceDetailL.text=[arr valueForKey:@"address"];
    } failed:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
}

#pragma mark ---- 按钮点击事件
- (IBAction)btnClick:(UIButton *)sender {
    // 0 发件地定位 1收件地定位  2总重量选择 3 件数选择 4时间选择  5要求车型 6 提交按钮
    switch (sender.tag) {
        case 0:{
            [self hiddenTuijianView];
            LocationViewController * vc =[[LocationViewController alloc]init];
            vc.passBlock  = ^(NSString *address, NSString *name, NSString *lat, NSString *lon, NSString *cityCode, NSString *cityName, NSString *townCode, NSString *townName) {
                self.startPlaceL.text = [NSString stringWithFormat:@"%@%@",address,name];
                self.startPlaceDetailL.text = @"";
                _model.cityCode = cityCode;
                _model.fromLongitude= lon;
                _model.fromLatitude = lat;
                _cityName = cityName;
                _wlModel.latitude = lat;
                _wlModel.longitude = lon;
                _wlModel.startPlaceCityCode = cityCode;
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;

        case 1:{
            [self hiddenTuijianView];
            LocationViewController * vc =[[LocationViewController alloc]init];
            vc.passBlock  = ^(NSString *address, NSString *name, NSString *lat, NSString *lon, NSString *cityCode, NSString *cityName, NSString *townCode, NSString *townName) {
                self.endPlaceL.text = [NSString stringWithFormat:@"%@%@",address,name];
                _model.cityCodeTo = cityCode;
                _model.toLongitude = lon;
                _model.toLatitude = lat;
                _wlModel.endPlaceName = [NSString stringWithFormat:@"%@%@",cityName,townName];
                _wlModel.latitudeTo = lat;
                _wlModel.longitudeTo = lon;
                _wlModel.entPlaceCityCode = cityCode;
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:{
            _weightArr = [[NSMutableArray alloc]init];
            [_weightArr addObject:@"≤5公斤"];
            for (int i = 0; i<100000; i++) {
                NSString  * str =[NSString stringWithFormat:@"%d 公斤",i+6];
                [_weightArr addObject:str];
            }
            [self hiddenTuijianView];
            [ActionSheetStringPicker showPickerWithTitle:@"物品重量" rows:_weightArr initialSelection:0 target:self successAction:@selector(weightWasSelected:element:sender:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
        }
            break;
        case 3:{
            _countArr = [[NSMutableArray alloc]init];
            for (int i =0 ; i<1000; i++) {
                NSString  * str =[NSString stringWithFormat:@"%d 件",i+1];
                [_countArr addObject:str];
            }
            [self hiddenTuijianView];
            [ActionSheetStringPicker showPickerWithTitle:@"件数" rows:_countArr initialSelection:0 target:self successAction:@selector(countWasSelected:element:sender:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
        }
            break;
        case 4:{
            if (self.dateDic.count !=0) {
                self.dateDic = @{};
                self.weekStr = @"";
                self.timeStr = @"";
                self.selectDate = nil;
                self.currentSelectDay = 0;
            }
            self.dateDic = [DwHelp LHGetStartTime];
            _pickView = [[XZPickView alloc]initWithFrame:[UIScreen mainScreen].bounds title:@"要求到达时间"];
            _pickView.delegate = self;
            _pickView.dataSource = self;
            [self.pickView reloadData];
            [[UIApplication sharedApplication].keyWindow addSubview:self.pickView];
            [self.pickView show];
        }
            break;
        case 5:{
            [self hiddenTuijianView];
            [ActionSheetStringPicker showPickerWithTitle:@"要求车型" rows:_carTypeNameArr initialSelection:0 target:self successAction:@selector(carTypeWasSelected:element:sender:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
        }
            break;
        case 6:{
            if (![self checkParem]) {
                return;
            }
            //再来一单  1是顺风  2是限时 3 是物流 （3中判断冷链车问题） 直接跳转界面传值  不需要再请求价格
            if (self.type ==1) {
                SFFaViewConstroller * vc =[[SFFaViewConstroller alloc]init];
                vc.sfModel = self.model;
                vc.publishAgain = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else if(self.type == 2){
                XSFaViewConstroller * vc =[[XSFaViewConstroller alloc]init];
                vc.publishAgain = YES;
                vc.sfModel = self.model;
                [self.navigationController pushViewController:vc animated:YES];
            }else if(self.type == 3){
                if ([self.wlModel.carType isEqualToString:@"cold"]) {
                    ColdFaViewController * vc =[[ColdFaViewController alloc]init];
                    vc.publishAgain = YES;
                    vc.timeString = self.timeTextField.text;
                    vc.wlModel = self.wlModel;
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    WLFaViewController * vc =[[WLFaViewController alloc]init];
                    vc.publishAgain = YES;
                    vc.timeString = self.timeTextField.text;
                    vc.wlModel = self.wlModel;
                    [self.navigationController pushViewController:vc animated:YES];
              }
            }else{
#pragma mark ----获取天气
            NSString * urlStr = [NSString stringWithFormat:@"http://v.juhe.cn/weather/index?format=2&cityname=%@&key=09c8829c4d25fe3cbd75ddf5ab394a9c",_cityName];
                urlStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)urlStr, nil, nil, kCFStringEncodingUTF8));
          if (_cityName.length != 0) {
                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                    manager.responseSerializer = [AFJSONResponseSerializer serializer];
                    manager.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:
                                                                        @"application/json",
                                                                        @"text/json",
                                                                        @"text/javascript" ,
                                                                        @"text/plain" ,
                                                                        @"text/html",@"application/xml" ,nil];
                    manager.responseSerializer.stringEncoding = NSUTF8StringEncoding;
                    [SVProgressHUD show];
                    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        NSLog(@"%@",responseObject);
                        [SVProgressHUD dismiss];
                        _temp =[[[responseObject objectForKey:@"result"] objectForKey:@"sk"] objectForKey:@"temp"];
                        _weatherId = [[[[responseObject objectForKey:@"result"] objectForKey:@"today"] objectForKey:@"weather_id"] objectForKey:@"fa"];
                        [self sureSumbit];
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        _weatherId =@"0";
                        _temp = @"";
                    }];
                }else{
                    [self sureSumbit];
             }
        }
    }
            break;
        default:
            break;
    }
}
-(void)carTypeWasSelected:(NSNumber *)selectedIndex element:(id)element sender: (UIButton*) btn {
    self.carTypeTextField.text = [NSString stringWithFormat:@"%@",_carTypeNameArr[[selectedIndex intValue]]];
    carTypeModel * model = _carTypeArr[[selectedIndex intValue]];
    self.model.carType = model.carType;
    //此处传matVolume  是为了之后显示那个carname  后台不用新的字段
    self.model.matVolume = model.carName;
    self.wlModel.carType = model.carType;
    self.wlModel.carName = model.carName;
}

-(void)weightWasSelected:(NSNumber *)selectedIndex element:(id)element sender: (UIButton*) btn {
    [self.weightBtn setTitle:[NSString stringWithFormat:@"%@",[_weightArr objectAtIndex:[selectedIndex intValue]]] forState:UIControlStateNormal];
    _matWeight = [NSString stringWithFormat:@"%d",[selectedIndex intValue]+5];
    _model.matWeight = _matWeight;
    _wlModel.weight = _matWeight;
}
-(void)countWasSelected:(NSNumber *)selectedIndex element:(id)element sender: (UIButton*) btn {
    
    [self.jianshuBtn setTitle:[NSString stringWithFormat:@"%@",[_countArr objectAtIndex:[selectedIndex intValue]]] forState:UIControlStateNormal];
    _cargoSize = [NSString stringWithFormat:@"%d",[selectedIndex intValue]+1];
    _model.cargoSize = _cargoSize;
    _wlModel.cargoSize = _cargoSize;
}
- (void)actionPickerCancelled:(id)sender {
    
}

#pragma mark ----时间选择器  TimePicker Delegate
//获取当前的时间
-(NSString*)getCurrentTimesAddOneHour{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"MM月d日 HH:mm"];
    //现在时间,你可以输出来看下是什么格式
    NSDate *datenow = [[NSDate date] dateByAddingHours:1];
    //----------将nsdate按formatter格式转成nsstring
    NSString *currentTimeString = [formatter stringFromDate:datenow];
//  NSLog(@"currentTimeString =  %@",currentTimeString);
    
    _timeTextField.text = currentTimeString;
    _time = [self dateStringWithDate:datenow DateFormat:@"yyyy-MM-dd HH:mm"];;
    _model.limitTime = _time;
    _model.useTime = _time;
    _wlModel.arriveTime = _time;

    return currentTimeString;
}


-(void)pickView:(XZPickView *)pickerView confirmButtonClick:(UIButton *)button{
    
    NSInteger left = [pickerView selectedRowInComponent:0];
    NSInteger right = [pickerView selectedRowInComponent:1];
    self.selectDate = [[self.dateDic[@"time"] objectAtIndex:left] objectAtIndex:right];
    self.timeTextField.text = [self dateStringWithDate: self.selectDate DateFormat:@"MM月d日 HH:mm"];

    //后台需要计算时间去
    _time = [[NSString alloc]init];
    _time = [self dateStringWithDate:self.selectDate DateFormat:@"yyyy-MM-dd HH:mm"];
    _model.limitTime = _time;
    _model.useTime = _time;
    _wlModel.arriveTime = _time;
}
-(NSInteger)pickerView:(XZPickView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    //时间
    if (component == 0) {
        return [self.dateDic[@"week"] count];
    }else{
        NSInteger whichWeek = [pickerView selectedRowInComponent:0];
        return [[self.dateDic[@"time"] objectAtIndex:whichWeek] count];
    }
}

-(void)pickerView:(XZPickView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(component == 0){
       self.currentSelectDay = [pickerView selectedRowInComponent:0];
       [pickerView pickReloadComponent:1];
      self.weekStr = self.dateDic[@"week"][row];
       NSArray *arr = [[self.dateDic objectForKey:@"time"] objectAtIndex:self.currentSelectDay];
      NSDate *date = [arr objectAtIndex:[pickerView selectedRowInComponent:1]];
      self.timeStr = [self XZGetTimeStringWithDate:date dateFormatStr:@"HH:mm"];
    }else{
        NSInteger whichWeek = [pickerView selectedRowInComponent:0];
        NSDate *date = [[self.dateDic[@"time"] objectAtIndex:whichWeek] objectAtIndex:row];
        self.timeStr = [self XZGetTimeStringWithDate:date dateFormatStr:@"HH:mm"];
    }
}

-(NSString *)pickerView:(XZPickView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if(component == 0){
        return self.dateDic[@"week"][row];
    }else{
        NSArray *arr = [[self.dateDic objectForKey:@"time"] objectAtIndex:self.currentSelectDay];
        NSDate *date = [arr objectAtIndex:row];
        NSString *str = [self XZGetTimeStringWithDate:date dateFormatStr:@"HH:mm"];
        return str;
    }
}

-(NSInteger)numberOfComponentsInPickerView:(XZPickView *)pickerView{
    return 2;
}
- (NSString *)XZGetTimeStringWithDate:(NSDate *)date dateFormatStr:(NSString *)dateFormatStr {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = dateFormatStr;
    return [format stringFromDate:date];
}

- (NSString *)dateStringWithDate:(NSDate *)date DateFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    NSString *str = [dateFormatter stringFromDate:date];
    return str ? str : @"";
}

#pragma mark ----智能推荐啦  根据后台返回的数据看推荐谁  该隐藏的隐藏
-(void)tuijianWithShowType:(NSInteger )showType withchitType:(NSInteger)chitType withlimitPrice:(NSString *)limitPrice withDowPrice:(NSString *)dowPrice withLogisPrice:(NSString *)logisPrice withDistance:(NSString *)distance withWeatherMessage:(NSString *)weatherMessage{
    _SFMoneyL.text = dowPrice;
    _XSMoneyL.text = limitPrice;
    _Only_XSMoneyL.text = limitPrice;
    self.distanceLabel.text = [NSString stringWithFormat:@"运送距离：%@公里",distance];
    self.noticeLabel.text = [NSString stringWithFormat:@"%@",weatherMessage];
    if (showType == 1) {
        _Only_XS_View.hidden = YES;
        _Tuijian_XS_Only.hidden = YES;
        
        _XS_View.hidden = NO;
        _SF_View.hidden = NO;
        _Tuijian_SF.hidden = NO;
        _Tuijian_XS.hidden = NO;
        self.distanceLabel.hidden = NO;
        switch (chitType) {
            case 1:{
                _SFTujian.hidden = NO;
            }
                break;
            case 2:{
                _XSTuijian.hidden = NO;
            }
                break;
            case 3:{
            }
                break;
            case 4:{
                _SFTujian.hidden = YES;
                _XSTuijian.hidden = YES;
            }
                break;
            default:
                break;
        }
    }else{
     //只弹出专程送的弹框
        _Tuijian_SF.hidden = YES;
        _Tuijian_XS.hidden = YES;
        _XS_View.hidden = YES;
        _SF_View.hidden = YES;
        _Only_XS_View.hidden = NO;
        _Tuijian_XS_Only.hidden = NO;
        self.distanceLabel.hidden = NO;
    }
}

//隐藏智能推荐
-(void)hiddenTuijianView{
    _Tuijian_SF.hidden = YES;
    _Tuijian_XS.hidden = YES;
    _XS_View.hidden = YES;
    _SF_View.hidden = YES;
    _Tuijian_XS_Only.hidden = YES;
    _Only_XS_View.hidden = YES;
    self.distanceLabel.hidden = YES;
    self.submitBtn.hidden = NO;
    self.noticeLabel.text = @"";
}

#pragma mark --- 提交信息
-(void)sureSumbit{
    NSDictionary * dict = @{@"userId":[UserManager getDefaultUser].userId,
                            @"fromLatitude":self.model.fromLatitude,
                            @"fromLongitude":self.model.fromLongitude,
                            @"toLatitude":self.model.toLatitude,
                            @"toLongitude":self.model.toLongitude,
                            @"cityCode":self.model.cityCode,
                            @"cityCodeTo":self.model.cityCodeTo,
                            @"matWeight":self.model.matWeight,
                            @"cargoSize":self.model.cargoSize,
                            @"carType":self.model.carType,
                            @"weatherId":_weatherId ?_weatherId :@"1",
                            @"temp":_temp ?_temp:@"25"
                            };
    [SVProgressHUD show];
    [ExpressRequest sendWithParameters:dict MethodStr:API_GETPRICE_BYType reqType:k_POST success:^(id object) {
        /*****
         private String limitPrice;// 专送价格
         private String dowPrice;//  顺风价格
         private String logisPrice;//  物流价格
         private Integer showType; // 显示方式  1 三种价格全部显示   2 只显示物流
         private Integer chitType; // 推荐模式  1 顺风 2 专送  3 物流 4 无
         *****/
        [SVProgressHUD dismiss];
        //判断如果选择了冷藏车的车型cold   直接走物流的模块
        if ([self.model.carType isEqualToString:@"cold"]) {
            ColdFaViewController * vc =[[ColdFaViewController alloc]init];
            vc.timeString = self.timeTextField.text;
            vc.wlModel = self.wlModel;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            NSDictionary * dict = [object objectForKey:@"data"][0];
            NSString * limitPrice =[dict valueForKey:@"limitPrice"];
            NSString * dowPrice = [dict valueForKey:@"dowPrice"];
            NSString * logisPrice = [dict valueForKey:@"logisPrice"];
            NSInteger showType = [[dict objectForKey:@"showType"] integerValue];
            NSInteger chitType = [[dict objectForKey:@"chitType"] integerValue];
            NSString * distance =[NSString stringWithFormat:@"%.2f", [[dict objectForKey:@"distance"] doubleValue]];
            NSString * weatherMessage = [dict objectForKey:@"weatherMessage"];
            self.insureUrl = [dict objectForKey:@"insureUrl"];
            self.submitBtn.hidden = YES;
            //10月10号  <=5公斤的时候呢  就弹出来一个专程送   >5公斤的时候谈两个模块  顺路送 专程送  硬编码 自己判断吧
            /*********
             showType 字段来控制啊
             ************/
//            if ([self.model.matWeight intValue] == 5) {
//             [self tuijianWithShowType:2 withchitType:chitType withlimitPrice:limitPrice withDowPrice:dowPrice withLogisPrice:logisPrice withDistance:distance withWeatherMessage:weatherMessage];
//            }else{
            [self tuijianWithShowType:showType withchitType:chitType withlimitPrice:limitPrice withDowPrice:dowPrice withLogisPrice:logisPrice withDistance:distance withWeatherMessage:weatherMessage];
//            }
        }
    } failed:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
}
#pragma mark --------UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self hiddenTuijianView];
    return YES;
    
}
- (IBAction)btnSelectedClick:(UIButton *)sender {
    // 1 顺风 2限时 3只推荐限时
    switch (sender.tag) {
        case 1:{
            SFFaViewConstroller * vc =[[SFFaViewConstroller alloc]init];
            vc.sfModel = self.model;
            vc.weatherId = _weatherId;
            vc.temp = _temp;
            vc.insureUrl = self.insureUrl;
            vc.sendType = @"1";
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:{
            XSFaViewConstroller * vc =[[XSFaViewConstroller alloc]init];
            vc.sfModel = self.model;
            vc.weatherId = _weatherId;
            vc.temp = _temp;
            vc.insureUrl = self.insureUrl;
            vc.sendType = @"1";
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:{
            XSFaViewConstroller * vc =[[XSFaViewConstroller alloc]init];
            vc.sfModel = self.model;
            vc.weatherId = _weatherId;
            vc.temp = _temp;
            vc.insureUrl = self.insureUrl;
            vc.sendType = @"1";
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}
//判断填写信息是否完成
-(BOOL)checkParem{
    if (self.endPlaceL.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择目的地"];
        return NO;
    }
    if (self.weightBtn.titleLabel.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择总重量"];
        return NO;
    }

    if (self.timeTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择要求到达时间"];
        return NO;
    }
    _model.address = [NSString stringWithFormat:@"%@%@",self.startPlaceL.text,self.startPlaceDetailL.text];
    _model.addressTo = [NSString stringWithFormat:@"%@%@", self.endPlaceL.text,self.endPlaceDetailL.text];
    
    _wlModel.startPlace = [NSString stringWithFormat:@"%@%@",self.startPlaceL.text,self.startPlaceDetailL.text];
    _wlModel.entPlace = [NSString stringWithFormat:@"%@%@", self.endPlaceL.text,self.endPlaceDetailL.text];
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
