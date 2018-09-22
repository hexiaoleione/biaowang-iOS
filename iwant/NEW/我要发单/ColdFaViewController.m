//
//  WLFaViewController.m
//  iwant
//
//  Created by 公司 on 2017/6/6.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "ColdFaViewController.h"
#import "ActionSheetStringPicker.h"
#import "XZPickView.h"
@interface ColdFaViewController ()<XZPickViewDelegate, XZPickViewDataSource>{
    NSArray *  _arr;  //温度选择
    NSArray * _arrTwo;
    NSMutableArray * _cargoVolumeArr;
    
}
//时间选择
@property (nonatomic,strong) XZPickView * pickView;
@property (nonatomic,copy) NSDictionary * dateDic;
@property (nonatomic,copy) NSString * weekStr;
@property (nonatomic,copy) NSString * timeStr;
@property (nonatomic, strong) NSDate *selectDate;
@property (nonatomic, assign) NSInteger currentSelectDay;

@end

@implementation ColdFaViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.topConstraint.constant = 18*RATIO_HEIGHT;
    self.faHeightConstraint.constant = 40*RATIO_HEIGHT;
    self.shouHeightConstrainr.constant = 40*RATIO_HEIGHT;
    self.matNameHeighConstraint.constant = 40*RATIO_HEIGHT;
    self.coldTextFieldHeightConstraint.constant = 40*RATIO_HEIGHT;
    self.cargoVolumeHeightConstraint.constant = 40*RATIO_HEIGHT;
    self.publishTopConstraint.constant = 49*RATIO_HEIGHT;
    self.timeTextFieldHeightConstraint.constant = 50* RATIO_WIDTH;
    self.topNoticeL.font = FONT(15, NO);
    self.timeL.font = FONT(17, NO);
    self.timeTextField.font= FONT(17, NO);
    self.sendNameTextField.font = FONT(17, NO);
    self.receiveNameTextField.font = FONT(17, NO);
    self.sendPhoneTextField.font = FONT(17, NO);
    self.receivePhoneTextField.font = FONT(17, NO);
    self.cargoVolumeL.font =FONT(17, NO);
    self.cargoVolumeTextField.font = FONT(17, NO);
    self.matName.font =FONT(17, NO);
    self.nameTextField.font = FONT(17, NO);
    self.coldTextField.font = FONT(17, NO);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib
    [self ShowNavgationView];
    
    //默认冷链车 上门取货 并且送货上门啦  都是 1 1
   
    self.sendNameTextField.text = [UserManager getDefaultUser].userName;
    self.sendPhoneTextField.text = [UserManager getDefaultUser].mobile;
    
    self.wlModel.takeCargo = @"1";
    self.wlModel.sendCargo = @"1";
    
    //从上一界面选择的时间
    self.timeTextField.text = self.timeString;
    
    //再来一单物流
    if (_publishAgain) {
        self.sendNameTextField.text = self.wlModel.sendPerson;
        self.sendPhoneTextField.text = self.wlModel.sendPhone;
        self.receiveNameTextField.text = self.wlModel.takeName;
        self.receivePhoneTextField.text = self.wlModel.takeMobile;
        self.nameTextField.text = self.wlModel.cargoName;
        self.cargoVolumeTextField.text = [NSString stringWithFormat:@"%@",self.wlModel.cargoVolume];
        self.coldTextField.text = [NSString stringWithFormat:@"%@",self.wlModel.tem];

        self.wlModel.takeCargo = @"1";
        self.wlModel.sendCargo = @"1";
    }
}
  
    
- (IBAction)btnClick:(UIButton *)sender {
    //0 发件人姓名电话  1 收件人 2温度选择的问题  3  4总体积  5提交  6 是否更改到达时间
    switch (sender.tag) {
        case 0:{
            [Contacts judgeAddressBookPowerWithUIViewController:self contactsBlock:^(NSString *name, NSString *phoneNumber) {
                self.sendNameTextField.text = name;
                self.sendPhoneTextField.text = phoneNumber;
            }];
        }
            break;
        case 1:{
            [Contacts judgeAddressBookPowerWithUIViewController:self contactsBlock:^(NSString *name, NSString *phoneNumber) {
                self.receiveNameTextField.text = name;
                self.receivePhoneTextField.text = phoneNumber;
            }];
        }
            break;
        case 2:{
           _arr =[[NSArray alloc]init];
           _arr = @[@"常温",@"0-4℃",@"-18℃"];
            [ActionSheetStringPicker showPickerWithTitle:@"温度要求" rows:_arr initialSelection:0 target:self successAction:@selector(timeWasSelected:element:sender:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
        }
            break;
//        case 3:{
//           _arrTwo =[[NSArray alloc]init];
//           _arrTwo = @[@"送货上门",@"用户自提"];
//            [ActionSheetStringPicker showPickerWithTitle:@"" rows:_arrTwo initialSelection:0 target:self successAction:@selector(NeedWasSelected:element:sender:) cancelAction:@selector(sendActionPickerCancelled:) origin:sender];
//        }
//            break;
        case 4:{
            _cargoVolumeArr = [[NSMutableArray alloc]init];
            [_cargoVolumeArr addObject:@"1立方米以下"];
            for (int i = 0; i<50; i++) {
                NSString  * str =[NSString stringWithFormat:@"%d立方米",i+1];
                [_cargoVolumeArr addObject:str];
            }
            [ActionSheetStringPicker showPickerWithTitle:@"总体积" rows:_cargoVolumeArr initialSelection:0 target:self successAction:@selector(cargoVolumeWasSelected:element:sender:) cancelAction:@selector(cargoVolumesendActionPickerCancelled:) origin:sender];
        }
            break;
        case 5:{
            [self publishSure];
        }
            break;
        case 6:{
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
        default:
            break;
    }
}

#pragma mark -----体积  特殊要求（上门取货，送货上门）的选择
-(void)cargoVolumeWasSelected:(NSNumber *)selectedIndex element:(id)element sender: (UIButton*) btn{
    self.cargoVolumeTextField.text = _cargoVolumeArr[[selectedIndex intValue]];
}

-(void)timeWasSelected:(NSNumber *)selectedIndex element:(id)element sender: (UIButton*) btn{
   self.coldTextField.text = _arr[[selectedIndex intValue]];
}
- (void)actionPickerCancelled:(id)sender {
    self.wlModel.takeCargo = @"1";
}
- (void)sendActionPickerCancelled:(id)sender {

    
}
-(void)cargoVolumesendActionPickerCancelled:(id)sender{
}

#pragma mark ----时间选择器  TimePicker Delegate
-(void)pickView:(XZPickView *)pickerView confirmButtonClick:(UIButton *)button{
    
    NSInteger left = [pickerView selectedRowInComponent:0];
    NSInteger right = [pickerView selectedRowInComponent:1];
    self.selectDate = [[self.dateDic[@"time"] objectAtIndex:left] objectAtIndex:right];
    self.timeTextField.text = [self dateStringWithDate: self.selectDate DateFormat:@"MM月dd日 HH:mm"];
    
    //后台需要计算时间去
    _wlModel.arriveTime = [self dateStringWithDate:self.selectDate DateFormat:@"yyyy-MM-dd HH:mm"];
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

#pragma mark -----确认发布
-(void)publishSure{
    if (![self checkPrem]) {
        return;
    }
    NSDictionary * dic =@{k_USER_ID:[UserManager getDefaultUser].userId,
                          @"sendPerson":self.sendNameTextField.text,
                          @"sendPhone":self.sendPhoneTextField.text,
                          @"takeName":self.receiveNameTextField.text,
                          @"takeMobile":self.receivePhoneTextField.text,
                          @"latitude":self.wlModel.latitude,
                          @"longitude":self.wlModel.longitude,
                          @"startPlace":self.wlModel.startPlace,
                          @"startPlaceCityCode":self.wlModel.startPlaceCityCode,
                          @"startPlaceTownCode":self.wlModel.startPlaceTownCode,
                          @"latitudeTo":self.wlModel.latitudeTo,
                          @"longitudeTo":self.wlModel.longitudeTo,
                          @"entPlaceCityCode":self.wlModel.entPlaceCityCode,
                          @"entPlace":self.wlModel.entPlace,
                          @"cargoName":self.nameTextField.text,
                          @"takeCargo":self.wlModel.takeCargo ,
                          @"sendCargo":self.wlModel.sendCargo ,
                          @"cargoWeight":self.wlModel.cargoWeight,
                          @"arriveTime":self.wlModel.arriveTime,
                          @"cargoSize":self.wlModel.cargoSize,
                          @"cargoVolume":self.cargoVolumeTextField.text,
                          @"appontSpace":@"",
                          @"carType":self.wlModel.carType,
                          @"carName":self.wlModel.carName,
                          @"tem":self.coldTextField.text
                          };
    [SVProgressHUD show];
    [ExpressRequest sendWithParameters:dic MethodStr:@"logistics/task/publishNew" reqType:k_POST success:^(id object) {
        [SVProgressHUD dismiss];
        [[NSNotificationCenter defaultCenter] postNotificationName:PUBLISH_SUCCESS object:nil];
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(sendSuceed) userInfo:nil repeats:NO];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failed:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
}
-(void)sendSuceed{
    [SVProgressHUD showSuccessWithStatus:@"发布成功"];
}
-(BOOL)checkPrem{
    if (self.sendNameTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请填写发件人姓名"];
        return NO;
    }
    if (self.receiveNameTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请填写收件人姓名"];
        return NO;
    }
    if (self.receivePhoneTextField.text.length != 11) {
        [SVProgressHUD showErrorWithStatus:@"请填写正确的收件人电话"];
        return NO;
    }
    if (self.sendPhoneTextField.text.length != 11) {
        [SVProgressHUD showErrorWithStatus:@"请填写正确的发件人电话"];
        return NO;
    }
    if (self.nameTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请填写真实的物品名称"];
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
