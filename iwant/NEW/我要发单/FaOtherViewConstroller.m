//
//  FaViewConstroller.m
//  iwant
//
//  Created by 公司 on 2017/6/2.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "FaOtherViewConstroller.h"
#import "MainHeader.h"
#import "SFFaViewConstroller.h"
#import "XSFaViewConstroller.h"
#import "WLFaViewController.h"
#import "LocationViewController.h"
#import "ActionSheetStringPicker.h"
#import "carTypeModel.h"

#import "MHDatePicker.h"
#import "XZPickView.h"
#import "ColdFaViewController.h"

@interface FaOtherViewConstroller ()<UITextFieldDelegate,XZPickViewDelegate, XZPickViewDataSource>{
    NSString * _matWeight;
    NSString * _cargoSize;
    NSString * _time;
}

@property (nonatomic,strong)NSMutableArray * weightArr;
@property (nonatomic,strong)NSArray * danweiArr;

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

@implementation FaOtherViewConstroller

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.endPlaceLabelHeightConstrainr.constant = 28 * RATIO_HEIGHT;
    self.weightBtnHeightConstraint.constant = 45 * RATIO_HEIGHT;
    self.timeTextFieldHeightConstraint.constant = 40 * RATIO_HEIGHT;
    self.jianshuBtnHeightConstraint.constant = 45 * RATIO_HEIGHT;
    self.carTypeTextFieldHeightConstraint.constant = 45 * RATIO_HEIGHT;
    self.submitTopConstraint.constant = 40*RATIO_HEIGHT;
    
    self.distanceTopConstraint.constant = 20 *RATIO_HEIGHT;
    self.tuijianTopConstraint.constant = 16*RATIO_HEIGHT;
    self.leftTuijianConstraint.constant = 8*RATIO_WIDTH;
    self.rightTuijianConstrainr.constant = 8* RATIO_WIDTH;
    
    self.startPlaceDetailL.font = FONT(12, NO);
    self.endPlaceDetailL.font = FONT(12, NO);
    
    self.weightL.font = FONT(18, YES);
    self.carTypeL.font = FONT(18, YES);
    self.jianshuL.font = FONT(18, YES);
    self.timeL.font = FONT(18, YES);
    
    self.carTypeTextField.userInteractionEnabled = NO;
    self.carTypeTextField.font = FONT(18, NO);
    
    self.weightTextField.font = FONT(18, NO);
    self.danweiBtn.titleLabel.font = FONT(18, YES);
    self.jianshuBtn.titleLabel.font =FONT(18, NO);
    self.timeTextField.font = FONT(18, NO);
    self.timeTextField.userInteractionEnabled = NO;
    self.startPlaceL.font = FONT(17, NO);
    self.endPlaceL.font = FONT(17, NO);
    self.endPlaceL.textColor = [UIColor blackColor];
    self.endPlaceDetailL.font = FONT(13, NO);
    
    self.distanceLabel.font = FONT(18, NO);
    
    self.noticeLabel.font = FONT(12, NO);
    self.noticeL.font = FONT(12, NO);
    self.noticeLabelTwo.font = FONT(12, NO);
    
    self.SFNoticeL.font = FONT(14, NO);
    self.XSNoticeL.font = FONT(14, NO);
    self.WLNoticeL.font = FONT(11, NO);
    self.WLOnlyNoticeL.font = FONT(14, NO);
    self.SFMoneyL.font = FONT(17, NO);
    self.XSMoneyL.font = FONT(17, NO);
    self.WLMoneyL.font = FONT(17, NO);
    self.WLWLMoneyL.font = FONT(13, NO);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self ShowNavgationView];

    self.endPlaceDetailL.delegate = self;
    self.startPlaceDetailL.delegate = self;
    [self creatData];
//    _matWeight = @"5";
    _cargoSize = @"1";
    if (self.type ==1 || self.type == 2 ) {
        _startPlaceL.text = [NSString stringWithFormat:@"%@",_model.address];
        self.endPlaceL.text = self.model.addressTo;
        self.carTypeTextField.text = [NSString stringWithFormat:@"%@",self.model.matVolume];
        [self.jianshuBtn  setTitle:[NSString stringWithFormat:@"%@件",self.model.cargoSize] forState:UIControlStateNormal];
        
    }else if(self.type == 3){
        _startPlaceL.text = [NSString stringWithFormat:@"%@",self.wlModel.startPlace];
        self.endPlaceL.text = self.wlModel.entPlace;
        [self.jianshuBtn  setTitle:[NSString stringWithFormat:@"%@件",self.wlModel.cargoSize] forState:UIControlStateNormal];
        self.carTypeTextField.text = [NSString stringWithFormat:@"%@",self.wlModel.carName];

    }else{
        _model.matWeight = _matWeight;
        _model.cargoSize = _cargoSize;
        
        _wlModel.cargoWeight = _matWeight;
        _wlModel.cargoSize = _cargoSize;
        _startPlaceL.text = [NSString stringWithFormat:@"%@",_model.address];
        
        NSString * urlStr = [NSString stringWithFormat:@"%@%@?userId=%@",BaseUrl,API_FD_LatesAddress,[UserManager getDefaultUser].userId];
        [ExpressRequest sendWithParameters:nil MethodStr:urlStr reqType:k_GET success:^(id object){
            
            if ([[object objectForKey:@"errCode"] integerValue] == 0) {
                
                NSDictionary *data = [object objectForKey:@"data"][0];
                _startPlaceL.text = [NSString stringWithFormat:@"%@",[data objectForKey:@"locationAddress"] ];
                _startPlaceDetailL.text = [NSString stringWithFormat:@"%@",[data objectForKey:@"address"] ];
                _model.cityCode = [NSString stringWithFormat:@"%@",[data objectForKey:@"cityCode"] ];
                _model.fromLongitude= [NSString stringWithFormat:@"%@",[data objectForKey:@"fromLongitude"] ];
                _model.fromLatitude = [NSString stringWithFormat:@"%@",[data objectForKey:@"fromLatitude"] ];;
//                _cityName = [NSString stringWithFormat:@"%@",[data objectForKey:@"cityName"]];
                _wlModel.latitude = [NSString stringWithFormat:@"%@",[data objectForKey:@"fromLatitude"] ];;
                _wlModel.longitude = [NSString stringWithFormat:@"%@",[data objectForKey:@"fromLongitude"] ];;
                _wlModel.startPlaceCityCode = [NSString stringWithFormat:@"%@",[data objectForKey:@"cityCode"] ];
                
            }
            
        }failed:^(NSString *error) {
            
        }
         ];
        
    }
    
    //默认选择一小时之后的时间
     [self getCurrentTimesAddOneHour];
}

-(void)creatData{
    NSString * carTypeUrl = [NSString stringWithFormat:@"%@logistics/task/getCagoType",BaseUrl];
    [SVProgressHUD show];
    [ExpressRequest sendWithParameters:nil MethodStr:carTypeUrl reqType:k_GET success:^(id object){
    [SVProgressHUD dismiss];
        _carTypeArr = [[NSMutableArray alloc]init];
        _carTypeNameArr = [[NSMutableArray alloc]init];
        NSArray * arr = [object valueForKey:@"data"];
        for (NSDictionary *dic in arr) {
            carTypeModel * carModel = [[carTypeModel alloc]initWithJsonDict:dic];
            [_carTypeArr addObject:carModel];
            [_carTypeNameArr addObject:carModel.cagoType];
        }
        //如果再来一单 就不需要有默认值了 防止因为数据请求的快慢产生问题
        if (self.type ==1 || self.type == 2 || self.type == 3) {
            
        }else{
           carTypeModel * model = _carTypeArr[0];
           self.model.carType = model.carType;
           //此处传matVolume  是为了之后显示那个carname  后台不用新的字段
           self.model.matVolume = model.carName;
           self.wlModel.carType = model.carType;
           self.wlModel.carName = model.cagoType;
           self.carTypeTextField.text = [NSString stringWithFormat:@"%@",model.cagoType];
        }
      }failed:^(NSString *error) {
       [SVProgressHUD showErrorWithStatus:error];
     }
   ];
}

#pragma mark ---- 按钮点击事件
- (IBAction)btnClick:(UIButton *)sender {
    // 0 发件地定位 1收件地定位  2总重量选择 3 件数选择 4时间选择  5货物种类 6 提交按钮
    switch (sender.tag) {
        case 0:{
            [self hiddenTuijianView];
            LocationViewController * vc =[[LocationViewController alloc]init];
            vc.passBlock  = ^(NSString *address, NSString *name, NSString *lat, NSString *lon, NSString *cityCode, NSString *cityName, NSString *townCode, NSString *townName) {
                self.startPlaceL.text = [NSString stringWithFormat:@"%@%@",address,name];
                _startPlaceDetailL.text = @"";
                _model.cityCode = cityCode;
                _model.fromLongitude= lon;
                _model.fromLatitude = lat;
                
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
            for (int i = 0; i<1000; i++) {
                NSString  * str =[NSString stringWithFormat:@"%d",i+1];
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
            [ActionSheetStringPicker showPickerWithTitle:@"货物种类" rows:_carTypeNameArr initialSelection:0 target:self successAction:@selector(carTypeWasSelected:element:sender:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
        }
            break;
        case 6:{
            if (![self checkParem]) {
                return;
            }
            
            //判断如果选择了冷藏车的车型cold   直接走物流的模块
            if ([self.model.carType isEqualToString:@"cold"]) {
                ColdFaViewController * vc =[[ColdFaViewController alloc]init];
                vc.timeString = self.timeTextField.text;
                vc.wlModel = self.wlModel;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                WLFaViewController * vc =[[WLFaViewController alloc]init];
                vc.timeString = self.timeTextField.text;
                vc.wlModel = self.wlModel;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
            /*
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

            NSDictionary * dict = @{@"userId":[UserManager getDefaultUser].userId,
                                    @"fromLatitude":self.model.fromLatitude,
                                    @"fromLongitude":self.model.fromLongitude,
                                    @"toLatitude":self.model.toLatitude,
                                    @"toLongitude":self.model.toLongitude,
                                    @"cityCode":self.model.cityCode,
                                    @"cityCodeTo":self.model.cityCodeTo,
                                    @"matWeight":self.model.matWeight,
                                    @"cargoSize":self.model.cargoSize,
                                    @"carType":self.model.carType
                                   };
           [SVProgressHUD show];
           [ExpressRequest sendWithParameters:dict MethodStr:API_GETPRICE_BYType reqType:k_POST success:^(id object) {
               
//                private String limitPrice;// 专送价格
//                private String dowPrice;//  顺风价格
//                private String logisPrice;//  物流价格
//                private Integer showType; // 显示方式  1 三种价格全部显示   2 只显示物流
//                private Integer chitType; // 推荐模式  1 顺风 2 专送  3 物流 4 无
             
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
                   self.submitBtn.hidden = YES;
                   [self tuijianWithShowType:showType withchitType:chitType withlimitPrice:limitPrice withDowPrice:dowPrice withLogisPrice:logisPrice withDistance:distance];
               }
           } failed:^(NSString *error) {
               [SVProgressHUD showErrorWithStatus:error];
           }];
        }
             */
    }
            break;
        case 7:{
            _danweiArr = @[@"吨",@"公斤"];
             [ActionSheetStringPicker showPickerWithTitle:@"单位" rows:_danweiArr initialSelection:0 target:self successAction:@selector(danweiWasSelected:element:sender:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
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
    self.weightTextField.text=[NSString stringWithFormat:@"%@",[_weightArr objectAtIndex:[selectedIndex intValue]]];
    self.wlModel.cargoWeight = [NSString stringWithFormat:@"%@%@",self.weightTextField.text,self.danweiBtn.titleLabel.text];
}
-(void)countWasSelected:(NSNumber *)selectedIndex element:(id)element sender: (UIButton*) btn {
    
    [self.jianshuBtn setTitle:[NSString stringWithFormat:@"%@",[_countArr objectAtIndex:[selectedIndex intValue]]] forState:UIControlStateNormal];
    _cargoSize = [NSString stringWithFormat:@"%d",[selectedIndex intValue]+1];
    _model.cargoSize = _cargoSize;
    _wlModel.cargoSize = _cargoSize;
}
-(void)danweiWasSelected:(NSNumber *)selectedIndex element:(id)element sender: (UIButton*) btn {
    [self.danweiBtn setTitle:[NSString stringWithFormat:@"%@",[_danweiArr objectAtIndex:[selectedIndex intValue]]] forState:UIControlStateNormal];
    _cargoSize = [NSString stringWithFormat:@"%d",[selectedIndex intValue]+1];
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
-(void)tuijianWithShowType:(NSInteger )showType withchitType:(NSInteger)chitType withlimitPrice:(NSString *)limitPrice withDowPrice:(NSString *)dowPrice withLogisPrice:(NSString *)logisPrice withDistance:(NSString *)distance{
    _SFMoneyL.text = dowPrice;
    _XSMoneyL.text = limitPrice;
    _WLNoticeL.text = [NSString stringWithFormat:@"%@",logisPrice];
    _WLWLMoneyL.text = logisPrice;
    self.distanceLabel.text = [NSString stringWithFormat:@"运送距离：%@公里",distance];
    if (showType == 1) {
        _Tuijian_SF.hidden = NO;
        _Tuijian_XS.hidden = NO;
        _Tuijian_WL.hidden = NO;
        _XS_View.hidden = NO;
        _SF_View.hidden = NO;
        _WL_View.hidden = NO;
        self.distanceLabel.hidden = NO;
        self.noticeLabel.hidden = NO;
        self.noticeLabelTwo.hidden = NO;
        self.noticeL.hidden = NO;
        _Tuijian_WLOnly.hidden = YES;
        _WLWL_View.hidden = YES;
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
                _WLTuijian.hidden = NO;
            }
                break;
            case 4:{
                _SFTujian.hidden = YES;
                _XSTuijian.hidden = YES;
                _WLTuijian.hidden = YES;
                _WLOnlyTuijian.hidden = YES;
            }
                break;
            default:
                break;
        }
    }else{
     //只推荐物流了
        _Tuijian_SF.hidden = YES;
        _Tuijian_XS.hidden = YES;
        _Tuijian_WL.hidden = YES;
        _XS_View.hidden = YES;
        _SF_View.hidden = YES;
        _WL_View.hidden = YES;
        self.noticeLabel.hidden = YES;
        self.noticeLabelTwo.hidden = YES;
        self.noticeL.hidden = YES;
        self.distanceLabel.hidden = NO;
        _Tuijian_WLOnly.hidden = NO;
        _WLWL_View.hidden = NO;
    }
}

//隐藏智能推荐
-(void)hiddenTuijianView{
    _Tuijian_SF.hidden = YES;
    _Tuijian_XS.hidden = YES;
    _Tuijian_WL.hidden = YES;
    _XS_View.hidden = YES;
    _SF_View.hidden = YES;
    _WL_View.hidden = YES;
    _Tuijian_WLOnly.hidden = YES;
    _WLWL_View.hidden = YES;
    self.distanceLabel.hidden = YES;
    self.noticeLabel.hidden = YES;
    self.noticeLabelTwo.hidden = YES;
    self.noticeL.hidden = YES;
    self.submitBtn.hidden = NO;
}

#pragma mark --------UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self hiddenTuijianView];
    return YES;
    
}
- (IBAction)btnSelectedClick:(UIButton *)sender {
    // 1 顺风 2限时 3物流 4只推荐物流
    switch (sender.tag) {
        case 1:{
            SFFaViewConstroller * vc =[[SFFaViewConstroller alloc]init];
            vc.sfModel = self.model;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:{
            XSFaViewConstroller * vc =[[XSFaViewConstroller alloc]init];
            vc.sfModel = self.model;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:{
            WLFaViewController * vc =[[WLFaViewController alloc]init];
            vc.timeString = self.timeTextField.text;
            vc.wlModel = self.wlModel;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4:{
            WLFaViewController * vc =[[WLFaViewController alloc]init];
            vc.timeString = self.timeTextField.text;
            vc.wlModel = self.wlModel;
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
    if (self.weightTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择总重量"];
        return NO;
    }

    if (self.timeTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择要求到达时间"];
        return NO;
    }
    _matWeight = [NSString stringWithFormat:@"%@%@",self.weightTextField.text,self.danweiBtn.titleLabel.text];
    _model.address = [NSString stringWithFormat:@"%@ · %@",self.startPlaceL.text,self.startPlaceDetailL.text];
    _model.addressTo = [NSString stringWithFormat:@"%@ · %@", self.endPlaceL.text,self.endPlaceDetailL.text];
    
    _wlModel.cargoWeight = _matWeight;
    _wlModel.startPlace = [NSString stringWithFormat:@"%@ · %@",self.startPlaceL.text,self.startPlaceDetailL.text];
    _wlModel.entPlace = [NSString stringWithFormat:@"%@ · %@", self.endPlaceL.text,self.endPlaceDetailL.text];
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
