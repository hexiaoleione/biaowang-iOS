//
//  LogisticsTrackingViewController.m
//  iwant
//
//  Created by dongba on 16/5/4.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "LogisticsTrackingViewController.h"
#import "MainHeader.h"
#import "ZWTagListView.h"
#import "MarkLabel.h"
#import "ZYRatingView.h"
#import "EvaluateViewController.h"
#import "BiaoshiInfoViewController.h"
#import "Evaluation.h"
//#import "ChatViewController.h"
#import "RouteAnnotation.h"
#import "MYPointAnnotation.h"
#import "TouSuView.h"
#import "MyFaDetailViewController.h"

#define margin 25 *WINDOW_WIDTH /414.0
#define RATIO_H   (WINDOW_HEIGHT - 64.0) /(736.0 - 64.0)
#define RATIO_W   WINDOW_WIDTH /414.0

#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]

@interface LogisticsTrackingViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKRouteSearchDelegate,YMHeaderViewDelegate>
{
    Evaluation  * _nextModel;
    UIButton *btn;//评价按钮
    BMKLocationService* _locService;
    BMKRouteSearch *_routesearch;
    
    UIImageView *_sexImg;
    UIImageView *_realImg;
    
    TouSuView * _touSuView;
    NSString  * _accusationUrl;// 投诉的照片路径
}

@property (strong, nonatomic)  UILabel *nameLabel;
@property (strong, nonatomic)  UILabel *timesLabel;
@property (strong, nonatomic)  UILabel *evaluateLabel;
@property (strong, nonatomic)  ZYRatingView*starsView;
@property (strong, nonatomic)  UIButton *sendMsgBtn;
@property (strong, nonatomic)  UIButton *callBtn;
//@property (strong, nonatomic)  UIView *mapView;
@property (copy, nonatomic)  NSArray *dataArray;

@property (strong, nonatomic)  MarkLabel *sexMarklabel;
@property (strong, nonatomic)  MarkLabel *realMarklabel;
@property (strong, nonatomic)  MarkLabel *fineMarklabel;
@property (strong,nonatomic) UIImageView *imageV;
@property (strong, nonatomic) BMKMapView *mapView;
@property (strong, nonatomic)  NSMutableArray *locationArrayM;
@property (strong, nonatomic)  BMKPolyline *polyLine;
@property (nonatomic, strong) CLLocation *preLocation;

@end

@implementation LogisticsTrackingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavgationBar];
    [self initView];
    [self loadEvaluateData];
    _routesearch =  [[BMKRouteSearch alloc]init];
//    [self showDriverLocat];
    [self showTheWay];
    if ([_model.status intValue] == 5) {
        btn.enabled = YES;
        [btn setBackgroundColor:COLOR_MainColor];
    }
}

- (void)showDriverLocat{

//    NSString *URLStr = [NSString stringWithFormat:@"%@%@?%@=%@",BaseUrl,API_LOCATION_LIST,K_DRIVERID,_model.driverId];
//    [ExpressRequest sendWithParameters:nil MethodStr:URLStr reqType:k_GET success:^(id object) {
//        NSArray *arr = object[@"data"];
//        for (NSDictionary *dic in arr) {
//            double lat = [dic[@"latitude"] doubleValue];
//            double lon = [dic[@"longitude"] doubleValue];
//            CLLocation *location = [[CLLocation alloc]initWithLatitude:lon longitude:lat];
//            [self recordTrackingWithUserLocation:location];
//        }
//        
//        
//    } failed:^(NSString *error) {
//        [SVProgressHUD showErrorWithStatus:error];
//    }];
    
//    MYPointAnnotation *annotation = [[MYPointAnnotation alloc]init];
//    annotation.coordinate = CLLocationCoordinate2DMake([_model.latitude doubleValue] +0.005, [_model.longitude doubleValue]+0.0006);
//    NSArray *arr = [NSArray arrayWithObject:annotation];
//    [_mapView addAnnotations:arr];
    
    if ([_model.status intValue]==2 || [_model.status intValue]==3) {
        NSString *URLStr = [NSString stringWithFormat:@"%@%@?%@=%@&%@=%@",BaseUrl,API_LOCAT_LATEST,k_USER_ID,_model.driverId,k_USER_TYPE,@"2"];
        [ExpressRequest sendWithParameters:nil MethodStr:URLStr reqType:k_GET success:^(id object) {
            double lat = [[object valueForKey:@"data"][0][ARG_LAT] doubleValue];
            double lon = [[object valueForKey:@"data"][0][ARG_LON] doubleValue];
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = (CLLocationCoordinate2D){lat ,lon};
            item.title = @"镖师";
            item.type = 6;
            [_mapView addAnnotation:item];
            
        } failed:^(NSString *error) {
            NSLog(@"%@",error);
        }];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0x222231)];
    self.navigationController.navigationBar.translucent = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [_mapView viewWillAppear];
    _routesearch.delegate = self;
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [_mapView viewWillDisappear];
    _routesearch.delegate = nil;
    _mapView.delegate = nil; // 不用时，置nil
}
-(void)loadEvaluateData
{
    
    [RequestManager getdriverdetailWithdriverId:self.model.driverId Success:^(id object) {
        _nextModel =object;
        _nameLabel.text = [NSString stringWithFormat:@"%@",_nextModel.userName];
        [_nameLabel sizeToFit];
        _sexImg.left  = _nameLabel.right + 5;
        _realImg.left = _sexImg.right + 5;
        _timesLabel.text = [NSString stringWithFormat:@"押镖次数 ：%@次",_nextModel.driverRouteCount];
        
        [_starsView displayRating:[_nextModel.synthesisEvaluate floatValue]*2];
        [_imageV sd_setImageWithURL:[NSURL URLWithString:_nextModel.userHeadPath] placeholderImage:[UIImage imageNamed:@"headerView"]];
        btn.userInteractionEnabled = YES;
    }
    Failed:^(NSString *error) {
        
    }];
    
    
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


-(void)initView{
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat imageEdge = 75 *RATIO_W;//image边长
    CGFloat labelWidth = 60 *RATIO_W;
    CGFloat labelMargin = 4 *RATIO_H;
    CGFloat labelHeiight = (imageEdge - labelMargin *4)/3;
    CGFloat btnEdge = 36 *RATIO_W;
    _imageV = [[UIImageView alloc]initWithFrame:CGRectMake(margin, margin, imageEdge, imageEdge)];
    _imageV.image = [UIImage imageNamed:@"headerView"];
    _imageV.layer.cornerRadius = imageEdge *0.5;
    _imageV.layer.masksToBounds = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoDetail)];
    [_imageV addGestureRecognizer:tap];
    _imageV.userInteractionEnabled = YES;
    
    _nameLabel = [UILabel new];
    _nameLabel.font = FONT(16, NO);
    _nameLabel.frame = CGRectMake(CGRectGetMaxX(_imageV.frame)+margin, margin + labelMargin, labelWidth, labelHeiight);
    _nameLabel.text = @"XXX";
    
    _timesLabel = [UILabel new];
    _timesLabel.font = FONT(14, NO);
    _timesLabel.textColor = [UIColor grayColor];
    _timesLabel.frame = CGRectMake(_nameLabel.x, _nameLabel.bottom + labelMargin, labelWidth *3, labelHeiight);
    _timesLabel.text = @"押镖次数 ：0次";
    
    _sexImg =[[UIImageView alloc]initWithFrame: CGRectMake(_nameLabel.right, margin + labelMargin, labelHeiight, labelHeiight)];
    _sexImg.image = [UIImage imageNamed:@"female"];
    [self.view addSubview:_sexImg];
    
    _realImg =[[UIImageView alloc]initWithFrame:CGRectMake(_sexMarklabel.right + 5, _sexImg.top, labelHeiight *3, labelHeiight)];
    _realImg.image = [UIImage imageNamed:@"real"];
    [self.view addSubview:_realImg ];
    _sexImg.left  = _nameLabel.right + 5;
    _realImg.left = _sexImg.right + 5;
    
    _evaluateLabel = [UILabel new];
    _evaluateLabel.font = FONT(14, NO);
    _evaluateLabel.textColor = [UIColor grayColor];
    _evaluateLabel.frame = CGRectMake(_nameLabel.x, _timesLabel.bottom+labelMargin, labelWidth + labelMargin *4, labelHeiight);
    _evaluateLabel.adjustsFontSizeToFitWidth = YES;
    _evaluateLabel.text = @"货主评价 ：";
    
    _starsView = [[ZYRatingView alloc]initWithFrame:CGRectMake(_evaluateLabel.right, _evaluateLabel.top + 2, labelHeiight *5, labelHeiight)];
    _starsView.centerY = _evaluateLabel.centerY;
    [_starsView setImagesDeselected:@"star_zero" partlySelected:@"star_one" fullSelected:@"star_one" andDelegate:nil];
    _starsView.userInteractionEnabled = NO;
    [self.view addSubview:_starsView];
    
    _callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _callBtn.frame = CGRectMake(0, 0, btnEdge, btnEdge);
    _callBtn.bottom = _evaluateLabel.bottom;
    _callBtn.centerY =  _timesLabel.centerY;
    _callBtn.right = WINDOW_WIDTH - margin;
    [_callBtn setImage:[UIImage imageNamed:@"phoneBtn"] forState:0];
    [_callBtn addTarget:self action:@selector(call:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_callBtn];
    
    
    
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, _imageV.bottom + margin, WINDOW_WIDTH , WINDOW_HEIGHT - _imageV.bottom + margin)];

//    _mapView.frame = CGRectMake(margin, _imageV.bottom + margin, WINDOW_WIDTH - 2*margin, 420 *RATIO_H);
    _mapView.backgroundColor = [UIColor grayColor];
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, WINDOW_HEIGHT - 40 *RATIO_W - 64  - margin, 150 *RATIO_H, 40 *RATIO_W);
    btn.centerX = self.view.centerX;
    btn.layer.cornerRadius = 10;
    btn.titleLabel.font = FONT(16, NO);
    [btn setTitle:@"评 价 服 务" forState:0];
    [btn setTitleColor:[UIColor whiteColor] forState:0];
    btn.enabled = NO;
    btn.userInteractionEnabled = NO;
    [btn setBackgroundColor: [UIColor lightGrayColor]];
    [btn addTarget:self action:@selector(evaluate:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [self.view addSubview:_imageV];
    [self.view addSubview:_nameLabel];
    [self.view addSubview:_timesLabel];
    [self.view addSubview:_evaluateLabel];
    [self.view addSubview:_mapView];
    [self.view addSubview:btn];
    
    UIButton  *matLabel = [UIButton buttonWithType:UIButtonTypeCustom];
    matLabel.backgroundColor = [UIColor colorWithWhite:1 alpha:0.75];
    [matLabel addTarget:self action:@selector(goToMatDetail) forControlEvents:UIControlEventTouchUpInside];
    [matLabel setTitle:@"点击查看物品详情>>" forState:UIControlStateNormal];
    [matLabel setTitleColor:COLOR_MainColor forState:UIControlStateNormal];
    [matLabel sizeToFit];
    matLabel .top = _mapView.top;
    matLabel.left = _mapView.left;
    matLabel.width = WINDOW_WIDTH;
    [self.view addSubview:matLabel];
}

- (void)goToMatDetail{
    MyFaDetailViewController *informationVC = [[MyFaDetailViewController alloc]init];
    informationVC.model = _model;
    [self.navigationController pushViewController:informationVC animated:YES];
}

-(void)sendMessage:(UIButton *)sender{
    NSLog(@"发信息");
   
    
}

-(void)call:(UIButton *)sender{
    NSLog(@"打电话");
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",_nextModel.driverMobile];
    NSLog(@"str======%@",str);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
}
-(void)evaluate:(UIButton *)sender{
    NSLog(@"评价");
    EvaluateViewController *vc = [[EvaluateViewController alloc]init];
    vc.model = [Evaluation new];
    vc.model = _nextModel;
    vc.recId = _model.recId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)configNavgationBar {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 60)];
    label.textColor = [UIColor whiteColor];
    label.text = @"货物跟踪";
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(backToMenuView)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    if ([_model.status integerValue] == 3 || [_model.status intValue] == 4) {
        if ([_model.ifAgree isEqualToString:@"1"]) {
            return;
        }
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"投诉" style:UIBarButtonItemStylePlain target:self action:@selector(tousuBiaoShi)];
        rightBarButtonItem.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    }
}
-(void)tousuBiaoShi{
    NSLog(@"用户投诉镖师");
    __weak LogisticsTrackingViewController * weakSelf = self;
    _touSuView =[[NSBundle mainBundle] loadNibNamed:@"TouSuView" owner:nil options:nil].firstObject;
    _touSuView.frame = [UIApplication sharedApplication].windows.lastObject.bounds;
    [[[UIApplication sharedApplication] keyWindow] addSubview:_touSuView];
    _touSuView.tousuImg.delagate = self;
    _touSuView.tousuImg.layer.cornerRadius = 0.0;
    _touSuView.tousuImg.image = [UIImage imageNamed:@"zhaopianKuang"];
    _touSuView.block =^(NSInteger tag){
        [weakSelf sendBtnClick:tag];
    };
}
-(void)sendBtnClick:(NSInteger)tag{
    NSDictionary * dic =@{@"userId":[UserManager getDefaultUser].userId,
                          @"toUserId":_model.driverId,
                          @"details":_touSuView.tousuTextView.text,
                          @"toRecId":_model.recId,
                          @"imageUrl":_accusationUrl?_accusationUrl:@"",
                          @"type":@"1"
                          };
    [ExpressRequest sendWithParameters:dic MethodStr:API_DOWNWIND_FEEDBACK_ACCUSATION reqType:k_POST success:^(id object) {
        [_touSuView removeFromSuperview];
        [self.navigationController popViewControllerAnimated:YES];
    } failed:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];

    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    _touSuView.hidden = YES;
}
-(void)headerView:(YMHeaderView *)headerView didSelectWithImage:(UIImage *)image{
            _touSuView.hidden = NO;
            [SVProgressHUD showWithStatus:@"正在上传"];
            NSDictionary *dic = @{k_USER_ID:[UserManager getDefaultUser].userId,k_FILE_NAME:@"tousu.png"};
            NSDictionary *fileDic = @{@"data":image,@"fileName":@"tousu.png"};
            NSString *api =@"file/accusation";
            [ExpressRequest sendWithParameters:dic MethodStr:api
                                       fileDic:fileDic
                                       success:^(id object) {
                                           [SVProgressHUD showSuccessWithStatus:@"上传成功"];
                                           _accusationUrl = [([object objectForKey:@"data"][0]) valueForKey:@"filePath"];
                                       } failed:^(NSString *error) {
                                           [SVProgressHUD showErrorWithStatus:error];
                                       }];
}

- (void)gotoDetail{
    
    BiaoshiInfoViewController *vc = [[BiaoshiInfoViewController alloc]init];
    vc.model = _nextModel;
    vc.userId = _model.driverId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)backToMenuView
{
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
        case 6:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"waypoint_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"waypoint_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/pin_red.png"]];
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
        int size = [plan.steps count];
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
        int size = [plan.steps count];
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
        [self showDriverLocat];
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
        int size = [plan.steps count];
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

/**
 *  开始记录轨迹
 *
 *  @param userLocation 实时更新的位置信息
 */
- (void)recordTrackingWithUserLocation:(CLLocation *)userLocation
{
    if (self.preLocation) {
        // 计算本次定位数据与上次定位数据之间的距离
        CGFloat distance = [userLocation distanceFromLocation:self.preLocation];
//        self.statusView.distanceWithPreLoc.text = [NSString stringWithFormat:@"%.3f",distance];
        NSLog(@"与上一位置点的距离为:%f",distance);
        
        // (5米门限值，存储数组画线) 如果距离少于 5 米，则忽略本次数据直接返回方法
        if (distance < 5) {
            return;
        }
    }
    
    // 2. 将符合的位置点存储到数组中（第一直接来到这里）
    [self.locationArrayM addObject:userLocation];
    self.preLocation = userLocation;
    
    // 3. 绘图
    [self drawWalkPolyline];
}

/**
 *  绘制轨迹路线
 */
- (void)drawWalkPolyline
{
    // 轨迹点数组个数
    NSUInteger count = self.locationArrayM.count;
    
    // 动态分配存储空间
    // BMKMapPoint是个结构体：地理坐标点，用直角地理坐标表示 X：横坐标 Y：纵坐标
    BMKMapPoint *tempPoints = new BMKMapPoint[count];
    
    // 遍历数组
    [self.locationArrayM enumerateObjectsUsingBlock:^(CLLocation *location, NSUInteger idx, BOOL *stop) {
        BMKMapPoint locationPoint = BMKMapPointForCoordinate(location.coordinate);
        tempPoints[idx] = locationPoint;
    }
     ];
    
    //移除原有的绘图，避免在原来轨迹上重画
    if (self.polyLine) {
        [self.mapView removeOverlay:self.polyLine];
    }
    
    // 通过points构建BMKPolyline
    self.polyLine = [BMKPolyline polylineWithPoints:tempPoints count:count];
    
    //添加路线,绘图
    if (self.polyLine) {
        [self.mapView addOverlay:self.polyLine];
    }
    
    // 清空 tempPoints 临时数组
    delete []tempPoints;
    
    // 根据polyline设置地图范围
//    [self mapViewFitPolyLine:self.polyLine];
}

- (void)drawLine{
//    CLLocationCoordinate2D coors[1000] = {0};
//    for (int i = 0; i < _locationArrayM.count; i++) {
//        CLLocation *location =  _locationArrayM[i];
//        coors[i] = [location coordinate];
//    }
    CLLocationCoordinate2D coors[1000] = {0};
    int i = 0;
    for (CLLocation *location in _locationArrayM) {
         coors[i].latitude = location.coordinate.latitude;
        coors[i].longitude = location.coordinate.longitude;
        i++;
    }
    
    BMKPolyline* polyline = [BMKPolyline polylineWithCoordinates:coors count:_locationArrayM.count];
    [_mapView addOverlay:polyline];
}



- (void)mapView:(BMKMapView *)mapView didAddOverlayViews:(NSArray *)overlayViews{
    
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
