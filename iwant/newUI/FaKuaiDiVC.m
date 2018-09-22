//
//  FaKuaiDiVC.m
//  iwant
//
//  Created by 公司 on 2017/2/13.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "FaKuaiDiVC.h"
#import "MainHeader.h"
#import "FaKuaiDiView.h"
#import "EcoinWebViewController.h"
#import "AddressViewController.h"
#import "CommonAddressViewController.h"
#import "Courier.h"
#import "CouriersController.h"
#import "RoleExplainVC.h"
#import "LocationViewController.h"

@interface FaKuaiDiVC (){
    FaKuaiDiView * _faKuaiDiView;
    
    NSString *_lat;
    NSString *_lon;
    NSString *_cityCode;
    NSString *_fromCityName;
    NSString *_townCode;
    
}

/*快递员模型*/
@property (strong, nonatomic)  Courier *courier;

@end

@implementation FaKuaiDiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    _courier = [[Courier alloc]init];
    [self fileBlanks];
    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLoc) name:USER_LOC_CHANGED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(islogin) name:ISLOGIN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(islogout) name:ISLOGOUT object:nil];

}
- (void)changeLoc{
    _lat = [[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCATION_LAT];
    _lon = [[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCATION_LON];
    _faKuaiDiView.locatLabel.text = [[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCASTR];
    _cityCode = [[NSUserDefaults standardUserDefaults] valueForKey:USER_CITY_CODE];
    _townCode = [[NSUserDefaults standardUserDefaults] valueForKey:USER_TOWN_CODE];
}

-(void)initUI{
    __weak FaKuaiDiVC * weakSelf = self;
        _faKuaiDiView = [[[NSBundle mainBundle] loadNibNamed:@"FaKuaiDiView" owner:nil options:nil] lastObject];
    _faKuaiDiView.frame = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _faKuaiDiView.block = ^(int tag){
        [weakSelf sendBtnClick:tag];
    };
    [self.view addSubview:_faKuaiDiView];
}
- (void)sendBtnClick:(int)tag{
    //0-顶部的btn 1-手机联系人 2-定位 3-添加发件人 4-选择快递员 5-电话通知
    switch (tag) {
        case 0:{
            RoleExplainVC * vc = [[RoleExplainVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            [Contacts judgeAddressBookPowerWithUIViewController:self contactsBlock:^(NSString *name, NSString *phoneNumber) {
                _faKuaiDiView.nameTextField.text = name;
                _faKuaiDiView.phoneTextField.text = phoneNumber;
            }];
        }
            break;
        case 2:
        {
            LocationViewController *addVC = [[LocationViewController alloc]init];
//            addVC.isSelectCity = YES;
            addVC.passBlock = ^(NSString *address,NSString *name,NSString *la,NSString *lon,NSString *cityCode,NSString *cityName,NSString *townCode,NSString *townName){
                _faKuaiDiView.locatLabel.text = [NSString stringWithFormat:@"%@",address];
                _faKuaiDiView.detailAddressTextField.text = [NSString stringWithFormat:@"%@",name];
                _lat = la;
                _lon = lon;
                _cityCode = cityCode;
                _townCode = townCode;
                _fromCityName = cityName;
                
                //更换了位置  相应的快递员也需要变
                [RequestManager getCourierListWithUserId:[UserManager getDefaultUser].userId cityCode:cityCode latitude:la longitude:lon success:^(NSMutableArray *result) {
                    if (result.count >0) {
                        Courier *courier = [[Courier alloc]initWithJsonDict:result[0]];
                        _faKuaiDiView.courierTextField.text = [NSString stringWithFormat:@"%@-%@",courier.expName,courier.courierName];
                    }else{
//                        HHAlertView *alert = [[HHAlertView alloc]initWithTitle:nil detailText:@"您所处位置附近没有快递员,请手动添加您常用的快递员" cancelButtonTitle:@"确认" otherButtonTitles:nil];
//                        alert.mode = HHAlertViewModeWarning;
//                        [alert showWithBlock:^(NSInteger index) {
//                            CouriersController *courierVC = [[CouriersController alloc]init];
//                            courierVC.lat = _lat;
//                            courierVC.lon = _lon;
//                            courierVC.cityCode = _cityCode;
//                            courierVC.block = ^(Courier *cour){
//                                _faKuaiDiView.courierTextField.text = [NSString stringWithFormat:@"%@-%@",cour.expName,cour.courierName];
//                                _courier = cour;
//                            };
//                            [self.navigationController pushViewController:courierVC animated:YES];
                        [SVProgressHUD showInfoWithStatus:@"您所处位置附近没有快递员,请手动添加您常用的的快递员"];
//                        }];
                        _faKuaiDiView.courierTextField.text = @"";
                    }
                } Failed:^(NSString *error) {
                    [SVProgressHUD  showErrorWithStatus:error];
                }];

            };
            [self.navigationController pushViewController:addVC animated:YES];
        }
            break;
        case 3:
        {
            CommonAddressViewController *adress = [[CommonAddressViewController alloc]init];
            adress.passvalue = ^(Address *model){
                _faKuaiDiView.nameTextField.text = model.personName;
                _faKuaiDiView.phoneTextField.text = model.mobile;
                _faKuaiDiView.locatLabel.text = model.areaName;
                _faKuaiDiView.detailAddressTextField.text = model.address;
            };
            [self.navigationController pushViewController:adress animated:YES];
        }
            break;
        case 4:
        {
            //选择快递员
            CouriersController *courierVC = [[CouriersController alloc]init];
            courierVC.lat = _lat;
            courierVC.lon = _lon;
            courierVC.cityCode = _cityCode;
            courierVC.block = ^(Courier *cour){
                _faKuaiDiView.courierTextField.text = [NSString stringWithFormat:@"%@-%@",cour.expName,cour.courierName];
                _courier = cour;
            };
            [self.navigationController pushViewController:courierVC animated:YES];
        }
            break;
        case 5:{
            //确认发布 电话通知
            [self PhoneSure];
        }
            break;
        default:
            break;
    }

}

#pragma mark------ 填充信息
- (void)fileBlanks{

    [RequestManager getDefaultAddressUserId:[UserManager getDefaultUser].userId cityCode:[[NSUserDefaults standardUserDefaults] valueForKey:USER_CITY_CODE] latitude:[[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCATION_LAT] longitude:[[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCATION_LON] success:^(id object) {
            Address *address = [[Address alloc]initWithJsonDict:[object objectForKey:@"data"][0]];
            _faKuaiDiView.nameTextField.text = address.personName;
            _faKuaiDiView.phoneTextField.text = address.mobile;
            if (address.areaName && ![address.areaName isEqualToString:@""]) {
                _faKuaiDiView.locatLabel.text = address.areaName;
            }else{
                _faKuaiDiView.locatLabel.text = [[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCASTR];
            }
//            _faKuaiDiView.locatLabel.text = address.address;
            _lat = [NSString stringWithFormat:@"%lf",address.latitude];
            _lon = [NSString stringWithFormat:@"%lf",address.longitude];
            _cityCode = [NSString stringWithFormat:@"%@",address.fromCity];
            _fromCityName = [NSString stringWithFormat:@"%@",address.fromCityName];
            _townCode = [NSString stringWithFormat:@"%@",address.townCode];
            
            _courier.courierId = [[(NSDictionary *)object objectForKey:@"data"][0] valueForKey:@"courierId"];
            
            
            //请求到的快递员为空的时候提醒
            if ([[[(NSDictionary *)object objectForKey:@"data"][0] valueForKey:@"courierName"] isEqualToString:@""])
            {
                [self notice];
            }
            else{
                //不为空就填上快递员
                _faKuaiDiView.courierTextField.text = [NSString stringWithFormat:@"%@-%@",[[(NSDictionary *)object objectForKey:@"data"][0] valueForKey:@"expName"],[[(NSDictionary *)object objectForKey:@"data"][0] valueForKey:@"courierName"]];
                _courier.courierName = [[(NSDictionary *)object objectForKey:@"data"][0] valueForKey:@"courierName"];
                _courier.expName = [[(NSDictionary *)object objectForKey:@"data"][0] valueForKey:@"expName"];
            }
            //第一次使用，没有发过快递，把username填上并且填上最近的快递员
            if ([address.personName isEqualToString:@""] || !address.personName) {
                _faKuaiDiView.nameTextField.text = [UserManager getDefaultUser].userName;
                _faKuaiDiView.phoneTextField.text = [UserManager getDefaultUser].mobile;
                _faKuaiDiView.locatLabel.text = [[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCASTR];
                _lat = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCATION_LAT]];
                _lon = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCATION_LON]];
                _cityCode = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:USER_CITY_CODE]];
                _fromCityName = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:USER_CITY]];
                _townCode = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:USER_TOWN_CODE]];
                return ;
            }
        } Failed:^(NSString *error) {
            [SVProgressHUD showErrorWithStatus:error];
            _faKuaiDiView.nameTextField.text = [UserManager getDefaultUser].userName;
            _faKuaiDiView.phoneTextField.text = [UserManager getDefaultUser].mobile;
            _faKuaiDiView.locatLabel.text = [[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCASTR];
            _lat = [[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCATION_LAT];
            _lon = [[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCATION_LON];
            _cityCode = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:USER_CITY_CODE]];
            _townCode = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:USER_TOWN_CODE]];
        }];
}

#pragma mark- 提醒用户添加快递员
- (void)notice{
    HHAlertView *alert = [[HHAlertView alloc]initWithTitle:@"温馨提示" detailText:@"您所处位置附近没有快递员，请手动添加您常用的快递员。" cancelButtonTitle:@"确定" otherButtonTitles:nil];
    alert.mode = HHAlertViewModeWarning;
    [alert showWithBlock:^(NSInteger index) {
        CouriersController *courierVC = [[CouriersController alloc]init];
        courierVC.lat = _lat;
        courierVC.lon = _lon;
        courierVC.cityCode = _cityCode;
        courierVC.block = ^(Courier *cour){
            _faKuaiDiView.courierTextField.text = [NSString stringWithFormat:@"%@-%@",cour.expName,cour.courierName];
            _courier = cour;
        };
        [self.navigationController pushViewController:courierVC animated:YES];
    }];
}
#pragma mark- 电话通知确认发布
-(void)PhoneSure{
    if ([self check]) {
        NSLog(@"电话通知");
        //status  为1短信通知   为2为电话通知
        [SVProgressHUD show];
        User *user =  [UserManager getDefaultUser];
        
        [RequestManager sendMailWithUserId:user.userId
                                  userName:user.userName
                                personName:_faKuaiDiView.nameTextField.text
                              personNameTo:@""
                                    mobile:_faKuaiDiView.phoneTextField.text
                                  mobileTo:@""
                                  areaName:_faKuaiDiView.locatLabel.text
                                areaNameTo:@""
                                   address:_faKuaiDiView.detailAddressTextField.text
                                 addressTo:@""
                                  latitude:_lat ? _lat :[[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCATION_LAT]
                                 longitude:_lon ?_lon : [[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCATION_LON]
                                  fromCity: _cityCode ? _cityCode :[[NSUserDefaults standardUserDefaults] valueForKey:USER_CITY_CODE]
                              fromCityName:_fromCityName && ![_fromCityName isEqualToString:@""] ? _fromCityName:[[NSUserDefaults standardUserDefaults] valueForKey:USER_CITY]
                                  fromTown:_townCode ?_townCode :[[NSUserDefaults standardUserDefaults] valueForKey:USER_TOWN_CODE]
                                    toCity:@""
                                toCityName:@""
                                     expId:@""
                                   pointId:@"0"
                                 courierId:_courier.courierId ? _courier.courierId : @""
                               courierName:@""
                             courierMobile:@""
                                  assigned:@"U"
                                    status:@"2"
                                   success:^(NSMutableArray *result) {
                                       
                                       [SVProgressHUD dismiss];
                                       NSDictionary * dict = [result valueForKey:@"data"][0];
                                       NSString * courierMobile = [dict objectForKey:@"courierMobile"];
                                       //打电话
                                       [Utils callAction:courierMobile];
                                       [self.navigationController popViewControllerAnimated:YES];
                                       [[NSNotificationCenter defaultCenter] postNotificationName:ISPOST object:nil];
                                   } Failed:^(NSString *error) {
                                       [SVProgressHUD showErrorWithStatus:error];
                                   }];
    }
    
    
}

- (BOOL)check{
    
    NSString *alert;
    if ([_faKuaiDiView.courierTextField.text isEqualToString:@""]) {
        alert = @"请选择快递员";
    }
    if ([_faKuaiDiView.locatLabel.text isEqualToString:@""]) {
        alert = @"请正确填写发件人地址";
    }
        if ([_faKuaiDiView.phoneTextField.text isEqualToString:@""] || ![_faKuaiDiView.phoneTextField.text isValidPhoneNumber]) {
        alert = @"请正确填写发件人手机号";
    }
    
    if ([_faKuaiDiView.nameTextField.text isEqualToString:@""] ) {
        alert = @"请正确填写发件人姓名";
    }
    
    BOOL isOK;
    if (alert) {
        [SVProgressHUD showErrorWithStatus:alert];
        isOK = NO;
    }else{
        isOK = YES;
    }
    
    return isOK;
    
}

-(void)islogin{
  [self fileBlanks];
}
-(void)islogout{
   _faKuaiDiView.nameTextField.text = @"";
   _faKuaiDiView.phoneTextField.text = @"";
   _faKuaiDiView.locatLabel.text = @"";
   _faKuaiDiView.detailAddressTextField.text =@"";
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
