//
//  CargodetailsViewController.m
//  iwant
//
//  Created by pro on 16/4/23.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "CargodetailsViewController.h"
#import "YMHeaderView.h"
#import "MainHeader.h"
#import "RequestManager.h"
#import "UserManager.h"
#import "RouteAnnotation.h"
#import "ShunFengBiaoShi.h"
#import "UIImage+ProportionalFill.h"
//#import "ChatViewController.h"
#import "DaiShouKuanAlert.h"
#import "HomeViewController.h"
#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]
#import "RechargeViewController.h"


//按比例获取高度
#define  WGiveHeight(HEIGHT) HEIGHT * [UIScreen mainScreen].bounds.size.height/568.0

//按比例获取宽度
#define  WGiveWidth(WIDTH) WIDTH * [UIScreen mainScreen].bounds.size.width/320.0
#define BG_COLOR            [UIColor colorWithRed:244.0/255.0 green:245.0/255.0 blue:246.0/255.0 alpha:1.0]

@interface CargodetailsViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKRouteSearchDelegate>
{
    
    BMKLocationService* _locService;
    BMKRouteSearch *_routesearch;
    
    //头像
    UIImageView *_headImageView;
    UIView *_ContentView;
    UILabel * _replaceMoneyL;// 代收货款的label
    DaiShouKuanAlert *_daishoukuanAlert;
    
    UILabel * _useTimeL;
}
@property (strong, nonatomic) BMKMapView *mapView;

@end

@implementation CargodetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavgationBar];
    [self creatView];
//  [self addlocatBtn];
    _routesearch =  [[BMKRouteSearch alloc]init];
    [self showTheWay];
    
}


- (void)showTheWay{
    //    此项为驾车查询基础信息类 想改为公交的把(BMKDrivingRoutePlanOption)改为(BMKTransitRoutePlanOption)即可
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    start.pt = (CLLocationCoordinate2D){[_model.fromLatitude doubleValue],[_model.fromLongitude doubleValue]};
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    end.pt = (CLLocationCoordinate2D){[_model.toLatitude doubleValue],[_model.toLongitude doubleValue]};
    
    BMKDrivingRoutePlanOption *drivingRouteSearchOption = [[BMKDrivingRoutePlanOption alloc]init];
    drivingRouteSearchOption.from = start;
    drivingRouteSearchOption.to = end;
    BOOL flag = [_routesearch drivingSearch:drivingRouteSearchOption];
    if(flag)
    {
        NSLog(@"car检索发送成功");//成功后调用onGetDrivingRouteResult
    }
    else
    {
        NSLog(@"car检索发送失败");
    }
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _routesearch.delegate = self;
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _routesearch.delegate = nil;
    _mapView.delegate = nil; // 不用时，置nil
}
#pragma mark- 界面UI
-(void)creatView
{
    _headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(WINDOW_WIDTH/2 -WGiveWidth(40), WGiveHeight(10), WGiveWidth(70), WGiveHeight(70))];
    _headImageView.backgroundColor = [UIColor grayColor];
//    _headImageView.delagate = self;
//    [_headImageView sd_setImageWithURL:[NSURL URLWithString:self.model.matImageUrl] placeholderImage:[UIImage imageNamed:@"物品"]];
    
    [_headImageView setImage:[UIImage imageNamed:@"物品"]];
    
//    _headImageView.layer.cornerRadius = WGiveWidth(40);

//    [self.view addSubview:_headImageView];
    
    _ContentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, WGiveHeight(130))];
    _ContentView.backgroundColor = BG_COLOR;
    [self.view addSubview:_ContentView];
    
    if (self.model.limitTime.length>0 && ![self.model.limitTime isEqualToString:@""]) {
     [self CreatLabelWithtext:[NSString stringWithFormat:@"限定到达时间：%@",self.model.limitTime] textfont: FONT(15,NO) textcolor:[UIColor orangeColor]X:WGiveWidth(10) Y:WGiveHeight(5) W:WINDOW_WIDTH-WGiveWidth(20) H:WGiveHeight(25)];
    }else{
    [self CreatLabelWithtext:[NSString stringWithFormat:@"发货时间：%@",self.model.publishTime] textfont: FONT(15,NO) textcolor:[UIColor orangeColor]X:WGiveWidth(10) Y:WGiveHeight(5) W:WINDOW_WIDTH-WGiveWidth(20) H:WGiveHeight(25)];
    }
    
    if (self.model.ifReplaceMoney &&self.model.replaceMoney.length > 0&& ![self.model.replaceMoney isEqualToString:@""]) {
       _replaceMoneyL = [self CreatLabelWithtext:[NSString stringWithFormat:@"代收款：%@元",self.model.replaceMoney] textfont:FONT(14, NO) textcolor:[UIColor orangeColor] X:WGiveWidth(10) Y:WGiveHeight(30) W:WINDOW_WIDTH-WGiveWidth(20) H:WGiveHeight(25)];
    }else{
        _replaceMoneyL = [self CreatLabelWithtext:@"" textfont:FONT(14, NO) textcolor:[UIColor orangeColor] X:WGiveWidth(10) Y:WGiveHeight(30) W:WINDOW_WIDTH-WGiveWidth(20) H:WGiveHeight(0)];
        _ContentView.height = WGiveHeight(110);
    }
    
    UILabel *fromL = [self CreatLabelWithtext:[NSString stringWithFormat:@"起始地:%@",self.model.address] textfont:FONT(14,NO)  textcolor:[UIColor blackColor] X:WGiveWidth(10) Y:CGRectGetMaxY(_replaceMoneyL.frame) W:WINDOW_WIDTH-WGiveWidth(40) H:WGiveHeight(25)];
    UILabel *fromM =[self CreatLabelWithtext:[NSString stringWithFormat:@"目的地:%@",self.model.addressTo] textfont:FONT(14,NO) textcolor:[UIColor blackColor] X:WGiveWidth(10) Y:CGRectGetMaxY(fromL.frame) W:WINDOW_WIDTH-WGiveWidth(10) H:WGiveHeight(25)];
    fromL.numberOfLines = 0;
    [fromL sizeToFit];
    fromM.numberOfLines = 0;
    [fromM sizeToFit];
    
//    
//    UILabel *fromLabel = [UILabel new];
//    fromLabel.text = @"起始地:";
//    fromLabel.textColor = [UIColor blackColor];
//    fromLabel.font = FONT(14,NO);
//    fromLabel.frame = CGRectMake(WGiveWidth(20),CGRectGetMaxY(_replaceMoneyL.frame), WGiveWidth(40), WGiveHeight(25));
//    [_ContentView addSubview:fromLabel];
 
////    
//    UILabel *toLabel = [UILabel new];
//    toLabel.text = @"目的地:";
//    toLabel.font = FONT(14,NO);
//    toLabel.textColor = [UIColor blackColor];
//    toLabel.frame = CGRectMake(WGiveWidth(20),CGRectGetMaxY(fromL.frame), WGiveWidth(40), WGiveHeight(25));
//    [_ContentView addSubview:toLabel];
//
    [self CreatLabelWithtext:@"货物:" textfont:FONT(14,NO) textcolor:[UIColor blackColor] X:WGiveWidth(10) Y:CGRectGetMaxY(fromM.frame) W:WGiveWidth(40) H:WGiveHeight(25)];
    [self CreatLabelWithtext:self.model.matName textfont:FONT(14,NO) textcolor:[UIColor orangeColor] X:WGiveWidth(45) Y:CGRectGetMaxY(fromM.frame) W:WGiveWidth(60) H:WGiveHeight(25)];
    
    [self CreatLabelWithtext:@"镖费:" textfont:FONT(14,NO) textcolor:[UIColor blackColor] X:WGiveWidth(120) Y:CGRectGetMaxY(fromM.frame)W:WGiveWidth(40) H:WGiveHeight(25)];
    
    [self CreatLabelWithtext:[NSString stringWithFormat:@"%0.2f元",[self.model.transferMoney doubleValue]] textfont:FONT(14,NO) textcolor:[UIColor orangeColor] X:WGiveWidth(160) Y:CGRectGetMaxY(fromM.frame) W:WGiveWidth(60) H:WGiveHeight(25)];
    
    UILabel *weightM = [self CreatLabelWithtext:@"重量:" textfont:FONT(14,NO) textcolor:[UIColor blackColor] X:WGiveWidth(210) Y:CGRectGetMaxY(fromM.frame) W:WGiveWidth(40) H:WGiveHeight(25)];
    
    UILabel *weightL = [self CreatLabelWithtext:[NSString stringWithFormat:@"%0.2fkg",[self.model.matWeight doubleValue]] textfont:FONT(14,NO) textcolor:[UIColor orangeColor] X:WGiveWidth(250) Y:CGRectGetMaxY(fromM.frame) W:WGiveWidth(60) H:WGiveHeight(25)];
    weightL.right = self.view.width;
    weightM.right = weightL.x;
    
//    if (!([self.model.length isEqualToString:@"0"] || [self.model.wide isEqualToString:@"0"] || [self.model.high isEqualToString:@"0"])) {
//        [self CreatLabelWithtext:@"尺寸:" textfont:FONT(16,NO) textcolor:[UIColor blackColor] X:WGiveWidth(20) Y:WGiveHeight(110) W:WGiveWidth(40) H:WGiveHeight(25)];
//         [self CreatLabelWithtext:[NSString stringWithFormat:@"长：%@cm 宽：%@cm 高：%@cm ",self.model.length,self.model.wide,self.model.high] textfont:FONT(15,NO) textcolor:[UIColor orangeColor] X:WGiveWidth(60) Y:WGiveHeight(110) W:WINDOW_WIDTH-WGiveWidth(60)  H:WGiveHeight(25)];
//    }else{
//    }
    if (self.model.limitTime.length ==0 || [self.model.limitTime isEqualToString:@""]) {

    NSString *_carLength ;
    if ([_model.carLength intValue] == 1|| [_model.carLength isEqualToString:@""]) {
        _carLength = @"车长要求：无";
    }else if ([_model.carLength intValue] == 2){
        _carLength = [NSString stringWithFormat:@"车长要求：1.8米"];
    }else if([_model.carLength intValue] == 3){
        _carLength = [NSString stringWithFormat:@"车长要求：2.7米"];
    }else if([_model.carLength intValue] == 4){
        _carLength = [NSString stringWithFormat:@"车长要求：4.2米"];
    }
   _ContentView.height += WGiveHeight(25);
   UILabel * carLengthLabel = [self CreatLabelWithtext:_carLength textfont:FONT(14,NO) textcolor:[UIColor blackColor] X:WGiveWidth(10) Y:CGRectGetMaxY(weightL.frame) W:WGiveWidth(120) H:WGiveHeight(25)];
    
   
    NSString * _matVolume;
    if (_model.matVolume.length == 0) {
        _matVolume = @"体积：1立方米以下";
    }else if([_model.matVolume intValue] == 0){
        _matVolume = [NSString stringWithFormat:@"体积：1立方米以下"];
    }else{
        _matVolume = [NSString stringWithFormat:@"体积：%@",_model.matVolume];
    }
    [self CreatLabelWithtext:_matVolume textfont:FONT(14,NO) textcolor:[UIColor blackColor] X:carLengthLabel.right+5 Y:CGRectGetMaxY(weightL.frame) W:WINDOW_WIDTH-WGiveWidth(60)  H:WGiveHeight(25)];
        
    if (_model.useTime && _model.useTime.length >0) {
        _ContentView.height += WGiveHeight(25);
      _useTimeL=  [self CreatLabelWithtext:[NSString stringWithFormat:@"取货时间：%@",_model.useTime] textfont:FONT(14,NO) textcolor:[UIColor blackColor] X:WGiveWidth(10) Y:CGRectGetMaxY(carLengthLabel.frame) W:WINDOW_WIDTH-WGiveWidth(60)  H:WGiveHeight(25)];
    }else{
       _useTimeL = [self CreatLabelWithtext:@"" textfont:FONT(14,NO) textcolor:[UIColor blackColor] X:carLengthLabel.right+5 Y:CGRectGetMaxY(carLengthLabel.frame) W:WINDOW_WIDTH-WGiveWidth(60)  H:WGiveHeight(0)];
    }
        

    if (_model.matRemark && _model.matRemark.length > 0) {
       UILabel * remarkL = [self CreatLabelWithtext:@"备注:" textfont:FONT(14,NO) textcolor:[UIColor blackColor] X:WGiveWidth(10) Y:CGRectGetMaxY(_useTimeL.frame) W:WGiveWidth(40) H:WGiveHeight(25)];
        _ContentView.height += WGiveHeight(25);
        [self CreatLabelWithtext:[NSString stringWithFormat:@"%@",_model.matRemark] textfont:FONT(14,NO) textcolor:[UIColor blackColor] X:remarkL.right +5 Y:CGRectGetMaxY(_useTimeL.frame) W:WINDOW_WIDTH - WGiveWidth(60) H:WGiveHeight(25)];
        _ContentView.height = CGRectGetMaxY(remarkL.frame);
        [self CreatLabelWithtext:[NSString stringWithFormat:@"友情提示：若用户有额外需求，请提前打电话议价"] textfont:FONT(14,NO) textcolor:[UIColor orangeColor] X:WGiveWidth(10) Y:CGRectGetMaxY(remarkL.frame) W:WINDOW_WIDTH - WGiveWidth(10) H:WGiveHeight(25)];
        _ContentView.height += WGiveHeight(25);
        
    }else{
        UILabel * remarkL = [self CreatLabelWithtext:@"" textfont:FONT(14,NO) textcolor:[UIColor blackColor] X:WGiveWidth(10) Y:CGRectGetMaxY(_useTimeL.frame) W:WGiveWidth(40) H:WGiveHeight(0)];
        [self CreatLabelWithtext:[NSString stringWithFormat:@"%@",_model.matRemark] textfont:FONT(14,NO) textcolor:[UIColor blackColor] X:remarkL.right +5 Y:CGRectGetMaxY(_useTimeL.frame) W:WINDOW_WIDTH - WGiveWidth(60) H:WGiveHeight(0)];
        [self CreatLabelWithtext:[NSString stringWithFormat:@"友情提示：若用户有额外需求，请提前打电话议价"] textfont:FONT(14,NO) textcolor:[UIColor orangeColor] X:WGiveWidth(10) Y:CGRectGetMaxY(_useTimeL.frame) W:WINDOW_WIDTH - WGiveWidth(10) H:WGiveHeight(25)];
        _ContentView.height += WGiveHeight(25);
    }
        
 }else{
     
     if (_model.matRemark && _model.matRemark.length > 0) {
         UILabel * remarkL = [self CreatLabelWithtext:@"备注:" textfont:FONT(14,NO) textcolor:[UIColor blackColor] X:WGiveWidth(10) Y:CGRectGetMaxY(weightL.frame) W:WGiveWidth(40) H:WGiveHeight(25)];
         _ContentView.height += WGiveHeight(25);
         [self CreatLabelWithtext:[NSString stringWithFormat:@"%@",_model.matRemark] textfont:FONT(14,NO) textcolor:[UIColor blackColor] X:remarkL.right +5 Y:CGRectGetMaxY(weightL.frame) W:WINDOW_WIDTH - WGiveWidth(60) H:WGiveHeight(25)];
         _ContentView.height = CGRectGetMaxY(remarkL.frame);
         [self CreatLabelWithtext:[NSString stringWithFormat:@"友情提示：若用户有额外需求，请提前打电话议价"] textfont:FONT(14,NO) textcolor:[UIColor orangeColor] X:WGiveWidth(10) Y:CGRectGetMaxY(remarkL.frame) W:WINDOW_WIDTH - WGiveWidth(10) H:WGiveHeight(25)];
         _ContentView.height += WGiveHeight(25);
         
     }else{
         UILabel * remarkL = [self CreatLabelWithtext:@"" textfont:FONT(14,NO) textcolor:[UIColor blackColor] X:WGiveWidth(10) Y:CGRectGetMaxY(weightL.frame) W:WGiveWidth(40) H:WGiveHeight(0)];
         [self CreatLabelWithtext:[NSString stringWithFormat:@"%@",_model.matRemark] textfont:FONT(14,NO) textcolor:[UIColor blackColor] X:remarkL.right +5 Y:CGRectGetMaxY(_useTimeL.frame) W:WINDOW_WIDTH - WGiveWidth(60) H:WGiveHeight(0)];
         [self CreatLabelWithtext:[NSString stringWithFormat:@"友情提示：若用户有额外需求，请提前打电话议价"] textfont:FONT(14,NO) textcolor:[UIColor orangeColor] X:WGiveWidth(10) Y:CGRectGetMaxY(remarkL.frame) W:WINDOW_WIDTH - WGiveWidth(10) H:WGiveHeight(25)];
         _ContentView.height += WGiveHeight(25);
     }
    
}
    
    
    _mapView =[[BMKMapView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_ContentView.frame)-1, WINDOW_WIDTH, WINDOW_HEIGHT-CGRectGetMaxY(_ContentView.frame)-1)];
    [self.view addSubview:_mapView];
    
    
    UIButton *Surebtn = [[UIButton alloc]initWithFrame:CGRectMake(WGiveWidth(100),WGiveHeight(450),WINDOW_WIDTH -WGiveWidth(200),WGiveHeight(35))];
    Surebtn.titleLabel.font = FONT(15,NO);
    [Surebtn setBackgroundColor:[UIColor orangeColor]];
    [Surebtn setTitle:@"接镖" forState:UIControlStateNormal];
    Surebtn.layer.cornerRadius = 10.0;
    Surebtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [Surebtn addTarget:self action:@selector(Pickup) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Surebtn];
}

-(void)Pickup
{
    if (self.model.ifReplaceMoney && self.model.replaceMoney.length >0 && ![self.model.replaceMoney isEqualToString:@""]) {
        _daishoukuanAlert =[[[NSBundle mainBundle] loadNibNamed:@"DaiShouKuanAlert" owner:self options:nil] lastObject];
        [_daishoukuanAlert.sureBtn addTarget:self action:@selector(Sure) forControlEvents:UIControlEventTouchUpInside];
        [_daishoukuanAlert show];
        
    }else{
        
    if (_model.limitTime && _model.limitTime.length>0) {
        //温馨提示  按时送达
    HHAlertView *alert = [[HHAlertView alloc] initWithTitle:@"温馨提示" detailText:@"请务必在用户要求时间内送达" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"]];
        alert.mode = HHAlertViewModeWarning;
        [alert showWithBlock:^(NSInteger index) {
        if (index != 0) {
        [SVProgressHUD show];
        [RequestManager biaoshiqiangdanWithuserId:[UserManager getDefaultUser].userId recId:self.model.recId success:^(NSMutableArray *result) {
            [SVProgressHUD dismiss];
                    // 2假单  -2 真单被抢走
                    NSInteger  errCode = [[result valueForKey:@"errCode"] integerValue];
                    NSString * message = [result valueForKey:@"message"];

                    if (errCode == 2||errCode == -2) {
                        [SVProgressHUD showSuccessWithStatus:message];
                        [self.navigationController popViewControllerAnimated:YES];

                    }else if(errCode == 4){
                        //取消发布货源
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        }];
                        UIAlertAction *suerAction = [UIAlertAction actionWithTitle:@"去充值" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            RechargeViewController * vc = [[RechargeViewController alloc]init];
                            [self.navigationController pushViewController:vc animated:YES];
                            
                        }];
                        [alert addAction:cancelAction];
                        [alert addAction:suerAction];
                        [self presentViewController:alert animated:YES completion:nil];
                        
                    }else{
                    
                        [self.tabBarController setSelectedIndex:2];
                        [self.navigationController popViewControllerAnimated:NO];
                    }
                }
                Failed:^(NSString *error)
                 {
                     [SVProgressHUD showErrorWithStatus:error];
                     
                }];
        }
    }];
    }else{
        [SVProgressHUD show];
        [RequestManager biaoshiqiangdanWithuserId:[UserManager getDefaultUser].userId recId:self.model.recId success:^(NSMutableArray *result) {
            [SVProgressHUD dismiss];
            // 2假单  -2 真单被抢走
            NSInteger  errCode = [[result valueForKey:@"errCode"] integerValue];
            NSString * message = [result valueForKey:@"message"];
            
            if (errCode == 2||errCode == -2) {
                [SVProgressHUD showSuccessWithStatus:message];
                [self.navigationController popViewControllerAnimated:YES];
                
            }else if(errCode == 4){
                //取消发布货源
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                }];
                UIAlertAction *suerAction = [UIAlertAction actionWithTitle:@"去充值" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    RechargeViewController * vc = [[RechargeViewController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }];
                [alert addAction:cancelAction];
                [alert addAction:suerAction];
                [self presentViewController:alert animated:YES completion:nil];
                
            }else{
                [self.tabBarController setSelectedIndex:2];
                [self.navigationController popViewControllerAnimated:NO];
            }
        }
             Failed:^(NSString *error)
         {
             [SVProgressHUD showErrorWithStatus:error];
         }];
    }
  }
}

#pragma mark ---- 确认接镖啦
-(void)Sure{
    
    if (_model.limitTime && _model.limitTime.length>0) {
        [SVProgressHUD show];
        [RequestManager biaoshiqiangdanWithuserId:[UserManager getDefaultUser].userId recId:self.model.recId success:^(NSMutableArray *result) {
            [SVProgressHUD dismiss];
            // 2假单  -2 真单被抢走
            NSInteger  errCode = [[result valueForKey:@"errCode"] integerValue];
            NSString * message = [result valueForKey:@"message"];
            
            if (errCode == 2||errCode == -2) {
                [SVProgressHUD showSuccessWithStatus:message];
                [self.navigationController popViewControllerAnimated:YES];
                
            }else if(errCode == 4){
                //取消发布货源
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                }];
                UIAlertAction *suerAction = [UIAlertAction actionWithTitle:@"去充值" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    RechargeViewController * vc = [[RechargeViewController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }];
                [alert addAction:cancelAction];
                [alert addAction:suerAction];
                [self presentViewController:alert animated:YES completion:nil];
            
            }else{
                self.tabBarController.selectedIndex = 2;
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        }Failed:^(NSString *error)
         {
             [SVProgressHUD showErrorWithStatus:error];
         }];
    }else{
        [SVProgressHUD show];
        [RequestManager biaoshiqiangdanWithuserId:[UserManager getDefaultUser].userId recId:self.model.recId success:^(NSMutableArray *result) {
            [SVProgressHUD dismiss];
            // 2假单  -2 真单被抢走
            NSInteger  errCode = [[result valueForKey:@"errCode"] integerValue];
            NSString * message = [result valueForKey:@"message"];
            
            if (errCode == 2||errCode == -2) {
                [SVProgressHUD showSuccessWithStatus:message];
                [self.navigationController popViewControllerAnimated:YES];
                
            }else if(errCode == 4){
                //取消发布货源
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                }];
                UIAlertAction *suerAction = [UIAlertAction actionWithTitle:@"去充值" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    RechargeViewController * vc = [[RechargeViewController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }];
                [alert addAction:cancelAction];
                [alert addAction:suerAction];
                [self presentViewController:alert animated:YES completion:nil];
                
            }else{
                
                [self.tabBarController setSelectedIndex:2];
                [self.navigationController popViewControllerAnimated:NO];
            }
        }
        Failed:^(NSString *error)
         {
             [SVProgressHUD showErrorWithStatus:error];
         }];
    }
    [_daishoukuanAlert dismiss];
}

-(UILabel *)CreatLabelWithtext:(NSString *)text textfont:(UIFont *)font textcolor:(UIColor *)textcolor X:(CGFloat)x Y:(CGFloat)y W:(CGFloat)w H:(CGFloat)h
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(x, y, w, h)];
    label.text = text;
    label.textColor=textcolor;
    label.font = font;
    [_ContentView addSubview:label];
    
    return label;
    
}

-(UIButton *)CreatBtnWithBgimage:(NSString *)image X:(CGFloat)x Y:(CGFloat)y W:(CGFloat)w H:(CGFloat)h tag:(int)tag
{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(x, y, w, h)];
    
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    btn.layer.cornerRadius = 20.0;
    
    btn.backgroundColor = [UIColor  whiteColor];
    btn.tag = tag;
    [btn addTarget:self action:@selector(tapBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    return btn;
}
- (void)tapBtn:(id)sender{
    
    UIButton *btn = (UIButton*)sender;
    switch (btn.tag) {
        case 1:
            
        {
//            ChatViewController *chaVC=[[ChatViewController alloc]initWithConversationChatter:_model.userId conversationType:eConversationTypeChat];
//            chaVC.title= self.model.personName;
//            [self.navigationController pushViewController:chaVC animated:YES];
//
//            NSLog(@"点击了即时通讯");
            //点击了打电话
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",_model.mobile];
            NSLog(@"str======%@",str);
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            
            NSLog(@"点击了打电话");
            
        }
            break;
        case 2:
        {
            //点击了打电话
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",_model.mobile];
                        NSLog(@"str======%@",str);
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            
            NSLog(@"点击了打电话");}
            break;
    }
}

- (void)locat{
    NSLog(@"点击了定位");
    [self showUser];
}

#pragma mark -- 设置当前地图中心点的位置
-(void)showUser{
    BMKCoordinateRegion adjustRegion = [self.mapView regionThatFits:BMKCoordinateRegionMake(_locService.userLocation.location.coordinate, BMKCoordinateSpanMake(0.02f,0.02f))];
    
    [self.mapView setRegion:adjustRegion animated:YES];
    
}

#pragma mark --------------------------------------------

- (void)addlocatBtn {
    CGRect frame = CGRectMake(0, 0, WINDOW_WIDTH/414 *36, WINDOW_WIDTH/414 *36);
    UIButton *btn = [[UIButton alloc]initWithFrame:frame];
    [btn setImage:[UIImage imageNamed:@"locat"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(locat) forControlEvents:UIControlEventTouchUpInside];
    btn.center = CGPointMake(WINDOW_WIDTH - 46, WINDOW_HEIGHT - 164);
    btn.layer.cornerRadius = 5;
    //阴影颜色
    btn.layer.shadowColor = [UIColor blackColor].CGColor;
    //阴影横向和纵向的偏移值
    btn.layer.shadowOffset = CGSizeMake(5.0, 5.0);
    //阴影透明度
    btn.layer.shadowOpacity = 0.45;
    //  阴影半径大小
    //  btn.layer.shadowRadius = 5.0;
    [self.view addSubview:btn];
}

- (void)configNavgationBar {
    self.view.backgroundColor =[UIColor whiteColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 60)];
    label.textColor = [UIColor whiteColor];
    label.text = @"货物详情";
    label.textAlignment = NSTextAlignmentCenter;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -- mapviewDelegate
- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(RouteAnnotation*)routeAnnotation
{
    BMKAnnotationView* view = nil;
    switch (routeAnnotation.type) {
        case 0:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"start_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_start.png"]];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 1:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"end_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_end.png"]];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 2:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"bus_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"bus_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_bus.png"]];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 3:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"rail_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"rail_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_rail.png"]];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 4:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"route_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_direction.png"]];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
            
        }
            break;
        case 5:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"waypoint_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"waypoint_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_waypoint.png"]];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
        }
            break;
        default:
            break;
    }
    
    return view;
}

- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[RouteAnnotation class]]) {
        return [self getRouteAnnotationView:view viewForAnnotation:(RouteAnnotation*)annotation];
    }
    return nil;
}

- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:1];
        polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
    return nil;
}

- (void)onGetTransitRouteResult:(BMKRouteSearch*)searcher result:(BMKTransitRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKTransitRouteLine* plan = (BMKTransitRouteLine*)[result.routes objectAtIndex:0];
        // 计算路线方案中的路段数目
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKTransitStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
            }
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.instruction;
            item.type = 3;
            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKTransitStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
    }
}
- (void)onGetDrivingRouteResult:(BMKRouteSearch*)searcher result:(BMKDrivingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKDrivingRouteLine* plan = (BMKDrivingRouteLine*)[result.routes objectAtIndex:0];
        // 计算路线方案中的路段数目
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
            }
            //添加annotation节点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.entraceInstruction;
            item.degree = transitStep.direction * 30;
            item.type = 4;
            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        // 添加途经点
        if (plan.wayPoints) {
            for (BMKPlanNode* tempNode in plan.wayPoints) {
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item = [[RouteAnnotation alloc]init];
                item.coordinate = tempNode.pt;
                item.type = 5;
                item.title = tempNode.name;
                [_mapView addAnnotation:item];
            }
        }
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
    }
}

- (void)onGetWalkingRouteResult:(BMKRouteSearch*)searcher result:(BMKWalkingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKWalkingRouteLine* plan = (BMKWalkingRouteLine*)[result.routes objectAtIndex:0];
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKWalkingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
            }
            //添加annotation节点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.entraceInstruction;
            item.degree = transitStep.direction * 30;
            item.type = 4;
            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKWalkingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
    }
}

//根据polyline设置地图范围
- (void)mapViewFitPolyLine:(BMKPolyline *) polyLine {
    CGFloat ltX, ltY, rbX, rbY;
    if (polyLine.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polyLine.points[0];
    ltX = pt.x, ltY = pt.y;
    rbX = pt.x, rbY = pt.y;
    for (int i = 1; i < polyLine.pointCount; i++) {
        BMKMapPoint pt = polyLine.points[i];
        if (pt.x < ltX) {
            ltX = pt.x;
        }
        if (pt.x > rbX) {
            rbX = pt.x;
        }
        if (pt.y > ltY) {
            ltY = pt.y;
        }
        if (pt.y < rbY) {
            rbY = pt.y;
        }
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(ltX , ltY);
    rect.size = BMKMapSizeMake(rbX - ltX, rbY - ltY);
    [_mapView setVisibleMapRect:rect];
    _mapView.zoomLevel = _mapView.zoomLevel - 0.3;
}

- (NSString*)getMyBundlePath1:(NSString *)filename
{
    
    NSBundle * libBundle = MYBUNDLE ;
    if ( libBundle && filename ){
        NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
        return s;
    }
    return nil ;
}

@end
