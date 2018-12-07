//
//  JieOrderDetailVC.m
//  iwant
//
//  Created by 公司 on 2017/6/9.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "JieOrderDetailVC.h"
#import "PwdInputField.h"
#import "HuowuWeiguiView.h"
#import "YMHeaderView.h"
#import "LXAlertView.h"
#import "CarNumCell.h"
#import "CarNumModel.h"
#import "KeyChain.h"
#import <MapKit/MKFoundation.h>
#import <MapKit/MKPlacemark.h>
#import "LCFNoticeAlert.h"
#import <MapKit/MapKit.h>

@interface JieOrderDetailVC ()<BMKLocationServiceDelegate,YMHeaderViewDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>{
    BMKLocationService * _locService;
    CLLocationCoordinate2D _pt;
    
    PwdInputField *_pwdView;
    UIVisualEffectView *_visualEffectView;
    
    HuowuWeiguiView * _huowuWeiguiView;
    NSString * _illegalUrl; //货物违规照片路径
    
    UIView * _bigView;//大的背景  //关于车牌号的
    LCFNoticeAlert * _noticeAlert;
}

@property (strong, nonatomic) UITableView * carNumTableView;
@property (strong, nonatomic)  NSMutableArray *dataArray;


@end

@implementation JieOrderDetailVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.topCallConstraint.constant = 50*RATIO_HEIGHT;
    self.sureBtnTopConstraint.constant = 100.0*RATIO_HEIGHT;
    self.mateNameL.font = FONT(15, YES);
    self.start.font = FONT(14, NO);
    self.end.font  = FONT(14, NO);
    self.startL.font = FONT(14, NO);
    self.endPlaceL.font = FONT(14, NO);
    self.limitTimeL.font = FONT(14, NO);
    self.replaceMoneyL.font = FONT(14, NO);
    self.guigeL.font = FONT(14, NO);
    self.weightL.font = FONT(14, NO);
    self.replaceMoneyL.font = FONT(14, NO);
    self.distanceL.font = FONT(14, NO);
    self.remarkL.font = FONT(14, NO);
    self.jianshuL.font = FONT(14, NO);
    
    self.carNumL.font = FONT(14, NO);
    self.carNumTextField.font = FONT(14, NO);
    self.transforMoneyL.font = FONT(14, NO);
    
    //开启定位服务，获取当前的经纬度
    [self locService];
}
-(void)locService{
    _locService = [[BMKLocationService alloc]init];
    _locService.distanceFilter = 100;
    _locService.delegate = self;
    [_locService startUserLocationService];
}
#pragma mark ----locationService  delegate

- (void)willStartLocatingUser
{
    NSLog(@"start locate");
}
/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"----didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    _pt = userLocation.location.coordinate;
    if (userLocation.location.coordinate.latitude == 0) {
        [_locService stopUserLocationService];
        [_locService startUserLocationService];
        return;
    }
}
/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)didStopLocatingUser
{
    NSLog(@"stop locate");
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error:%@",error);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCostomeTitle:@"订单详情"];
    [self getCarNum];
    [self initUI];
    [self initPassWord];
}
-(void)initUI{
    self.mateNameL.text = [NSString stringWithFormat:@"物品名称:%@",self.model.matName];
    if (self.model.limitTime.length == 0) {
        self.limitTimeL.text = [NSString stringWithFormat:@"要求到达时间：%@",self.model.useTime];
    }else{
        self.limitTimeL.text = [NSString stringWithFormat:@"要求到达时间：%@",self.model.limitTime];
    }
    if (self.model.ifReplaceMoney && self.model.replaceMoney.length !=0) {
        self.replaceMoneyL.hidden = NO;
        self.replaceMoneyL.text = [NSString stringWithFormat:@"代收款：%@元",self.model.replaceMoney];
    }
    self.startL.text = self.model.address;
    self.endPlaceL.text = self.model.addressTo;
    if (self.model.cargoSize && self.model.cargoSize.length!=0) {
        self.jianshuL.text = [NSString stringWithFormat:@"件数：%@件",self.model.cargoSize];
    }else{
        self.jianshuL.text = [NSString stringWithFormat:@"件数：1件"];
    }
    if ([self.model.matWeight intValue]== 5) {
        self.weightL.text = [NSString stringWithFormat:@"总重量：≤5公斤"];
    }else{
        self.weightL.text = [NSString stringWithFormat:@"总重量：%@公斤",self.model.matWeight];
    }
    self.transforMoneyL.text  = [NSString stringWithFormat:@"运费：%@元",self.model.transferMoney];
    self.distanceL.text = [NSString stringWithFormat:@"运送距离：大约%.2f公里",[self.model.distance floatValue]/1000];
    
    if (self.model.matVolume.length == 0) {
         self.guigeL.text = [NSString stringWithFormat:@"要求车型：无要求"];
    }else{
         self.guigeL.text = [NSString stringWithFormat:@"要求车型：%@",self.model.matVolume];
    }
    
    if (self.model.matRemark.length == 0) {
        self.remarkL.text=@"";
    }else{
        self.remarkL.text = [NSString stringWithFormat:@"备注：%@",self.model.matRemark];
    }
    
    //判断是否需要填写车牌号码
    if ([self.model.whether isEqualToString:@"Y"] && [self.model.premium intValue]>5000) {
        self.carNumL.hidden = NO;
        self.carNumTextField.hidden = NO;
        self.carNumdownBtn.hidden = NO;
      if (self.model.carNumber.length >0) {
        self.carNumTextField.text = self.model.carNumber;
        self.carNumdownBtn.hidden = YES;
      }
    }
    //   2(已抢单) 3 已取件(不需要代收款) 4 订单取消(镖师)  5 成功  6 删除
    //   7 已评价    8订单取消(用户)   9货物违规状态(镖师点击货物违规按钮后,用户界面出现是否同意的按钮)
    
    switch ([self.model.status intValue]) {
        case 2:{
            self.quhuoBtn.hidden = NO;
            self.jiuweiBtn.hidden = YES;
            /////////
//            self.weiguiBtn.hidden = NO;
            self.shoukuanBtn.hidden  = YES;
            self.songdaBtn.hidden = YES;
            self.noPassWordBtn.hidden = YES;
        }
            break;
        case 3:{
            if (self.model.ifReplaceMoney && self.model.replaceMoney.length!=0) {
                if (self.model.ifTackReplace) {
                    self.quhuoBtn.hidden = YES;
                    self.jiuweiBtn.hidden = YES;
                    self.weiguiBtn.hidden = YES;
                    self.shoukuanBtn.hidden  = YES;
                    self.songdaBtn.hidden = NO;
                    self.noPassWordBtn.hidden = NO;
                }else{
                    self.quhuoBtn.hidden = YES;
                    self.jiuweiBtn.hidden = YES;
                    self.weiguiBtn.hidden = YES;
                    self.shoukuanBtn.hidden  = NO;
                    self.songdaBtn.hidden = YES;
                    self.noPassWordBtn.hidden = YES;
                }
            }else{
                self.quhuoBtn.hidden = YES;
                self.jiuweiBtn.hidden = YES;
                self.weiguiBtn.hidden = YES;
                self.shoukuanBtn.hidden  = YES;
                self.songdaBtn.hidden = NO;
                self.noPassWordBtn.hidden = NO;
            }
        }
            break;
        case 4:{
            self.quhuoBtn.hidden = YES;
            self.jiuweiBtn.hidden = YES;
            self.weiguiBtn.hidden = YES;
            self.shoukuanBtn.hidden  = YES;
            self.songdaBtn.hidden = YES;
            self.noPassWordBtn.hidden = YES;
        }
            break;
        case 5:{
            self.quhuoBtn.hidden = YES;
            self.jiuweiBtn.hidden = YES;
            self.weiguiBtn.hidden = YES;
            self.shoukuanBtn.hidden  = YES;
            self.songdaBtn.hidden = YES;
            self.noPassWordBtn.hidden = YES;
        }
            break;
        case 7:{
            self.quhuoBtn.hidden = YES;
            self.jiuweiBtn.hidden = YES;
            self.weiguiBtn.hidden = YES;
            self.shoukuanBtn.hidden  = YES;
            self.songdaBtn.hidden = YES;
            self.noPassWordBtn.hidden = YES;
        }
            break;
        case 8:
        {
            self.quhuoBtn.hidden = YES;
            self.jiuweiBtn.hidden = YES;
            self.weiguiBtn.hidden = YES;
            self.shoukuanBtn.hidden  = YES;
            self.songdaBtn.hidden = YES;
            self.noPassWordBtn.hidden = YES;
        }
            break;
        case 9:{
            self.quhuoBtn.hidden = YES;
            self.jiuweiBtn.hidden = YES;
            self.weiguiBtn.hidden = YES;
            self.shoukuanBtn.hidden  = YES;
            self.songdaBtn.hidden = YES;
            self.noPassWordBtn.hidden = YES;
        }
            break;
        case 10:{
            self.quhuoBtn.hidden = YES;
            self.jiuweiBtn.hidden = YES;
            self.weiguiBtn.hidden = YES;
            self.shoukuanBtn.hidden  = YES;
            self.songdaBtn.hidden = YES;
            self.noPassWordBtn.hidden = YES;
        }
            break;
        case 11:{
            self.quhuoBtn.hidden = YES;
            self.jiuweiBtn.hidden = YES;
            self.weiguiBtn.hidden = YES;
            self.shoukuanBtn.hidden  = YES;
            self.songdaBtn.hidden = YES;
            self.noPassWordBtn.hidden = YES;
        }
            break;
        default:
            break;
    }
}

-(void)initPassWord{
    //密码框
    _visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    _visualEffectView.frame = self.view.bounds;
    _visualEffectView.alpha = 0.4;
    [self.view addSubview:_visualEffectView];
    _visualEffectView.hidden = YES;
    _pwdView = [[[NSBundle mainBundle] loadNibNamed:@"PwdInputField" owner:nil options:nil] lastObject];
    _pwdView.backgroundColor = [UIColor clearColor];
    _pwdView.y = WINDOW_HEIGHT;
    _pwdView.width = WINDOW_WIDTH;
    _pwdView.height = 400;
    _pwdView.getMessageAgainBtn.hidden = YES;
    [self.view addSubview:_pwdView];
    __weak JieOrderDetailVC *weakSelf = self;
    _pwdView.block = ^(id sender){
        if ([sender isKindOfClass:[UIButton class]]) {
            UIButton *btn = sender;
            if (btn.tag==0) {
                //关闭按钮
                [weakSelf closePwd];
            }else{
                //重新发送短信
            }
        }else{
            //密码输入完成
            [weakSelf checkPwd];
        }
    };
}

- (IBAction)btnClick:(UIButton *)sender {
    //sender。tag  0发件人电话  1收件人电话  2去取货  3去送达(跳转手机内地图)   4确认取货  5确认收款  6有密码送达 7我已就位  8 货物违规  9无密码送达订单
    switch (sender.tag) {
        case 0:{
          [Utils callAction:self.model.mobile];
        }
            break;
        case 1:{
          [Utils callAction:self.model.mobileTo];
        }
            break;
        case 2:{
            [self daohangWithType:0];
        }
            break;
        case 3:{
            [self daohangWithType:1];
        }
            break;
        case 4:{
            //确认取货
            LXAlertView *alert = [[LXAlertView alloc]initWithTitle:@"温馨提示" message:@"1.根据公安部规定，禁止押运易燃易爆，一切与毒品有关物品。\r2.请认真检查货物是否完整，是否符合安全规定。\r3.请确认货主身份信息，是否与平台信息一致。" cancelBtnTitle:@"" otherBtnTitle:@"收货成功" clickIndexBlock:^(UIButton *btn) {
                for (UIView *view in alert.subviews){
                    if ([view isKindOfClass:[UILabel class]]) {
                        UILabel *label = (UILabel *)view;
                        label.textAlignment = NSTextAlignmentLeft;
                    }
                }
                if (btn.tag == 0) {
                    btn.selected = !btn.selected;
                    if (btn.selected) {
                        [btn setBackgroundImage:[UIImage imageNamed:@"yiyanshou_bar"] forState:UIControlStateNormal];
                    }else{
                        [btn setBackgroundImage:[UIImage imageNamed:@"n0yanshou_bar"] forState:UIControlStateNormal];
                    }
                }else{
                    //勾选了验货
                 if (btn.selected) {
                        NSLog(@" 取货");
                        if (_pt.latitude == 0 || _pt.longitude == 0) {
                            [SVProgressHUD showErrorWithStatus:@"定位失败，请检查定位设置或手机网络"];
                            return ;
                        }
                     //判断是否需要车牌号码  超过五千投保
                     if ([self.model.whether isEqualToString:@"Y"] && [self.model.premium intValue]>5000 && _carNumTextField.text.length == 0 ) {
                          [SVProgressHUD showErrorWithStatus:@"请填写正确的车牌照号"];
                         return;
                     }
                        [SVProgressHUD show];
                        [RequestManager sendDriverPickpasswordWithrecId:self.model.recId Withlat:[NSString stringWithFormat:@"%f",_pt.latitude] withLon:[NSString stringWithFormat:@"%f",_pt.longitude] withCarNum:_carNumTextField.text?_carNumTextField.text:@"" success:^(NSMutableArray *result) {
                            [SVProgressHUD showSuccessWithStatus:@"取件成功，密码已发给收件人"];
                            [self.navigationController popViewControllerAnimated:YES];
                            [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH object:nil];
                            self.jiuweiBtn.hidden = YES;
                            self.weiguiBtn.hidden = YES;
                            self.quhuoBtn.hidden = YES;
                            if (self.model.ifReplaceMoney && self.model.replaceMoney.length!=0 && !self.model.ifTackReplace) {
                                self.shoukuanBtn.hidden = NO;
                                self.songdaBtn.hidden = YES;
                                self.noPassWordBtn.hidden = YES;
                            }else{
                                self.shoukuanBtn.hidden = YES;
                                self.songdaBtn.hidden = NO;
                                self.noPassWordBtn.hidden = NO;
                            }
                        }Failed:^(NSString *error) {
                        [SVProgressHUD showErrorWithStatus:error];
                    }];
                    }else{
                        //未勾选验货
                        NSLog(@"未勾选验货");
                    }
                }
            }];
            [alert.cancelBtn setBackgroundImage:[UIImage imageNamed:@"n0yanshou_bar"] forState:0];
            alert.animationStyle=LXASAnimationLeftShake;
            [alert showLXAlertView];
         }
            break;
        case 5:{
            //确认收款
         UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确认收款后，平台将会把冻结的相应金额支付给发件人。" preferredStyle:UIAlertControllerStyleAlert];
          [self presentViewController:alert animated:YES completion:nil];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [SVProgressHUD show];
                NSString * urlStr = [NSString stringWithFormat:@"%@%@?recId=%@",BaseUrl,API_DRIVER_TAKEReplayMoney,_model.recId];
                [ExpressRequest sendWithParameters:nil MethodStr:urlStr reqType:k_GET success:^(id object) {
                    _model.ifTackReplace = YES;
                    self.shoukuanBtn.hidden = YES;
                    self.songdaBtn.hidden = NO;
                    self.noPassWordBtn.hidden = NO;
                    [SVProgressHUD dismiss];
                } failed:^(NSString *error) {
                    [SVProgressHUD showErrorWithStatus:error];
                }];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"点击了取消按钮");
            }]];
        }
            break;
        case 6:{
            //确认送达
            [self checkPwd];
//             [self showPwd];
        }
            break;
        case 7:{
            //我已就位
            float lat =  _pt.latitude;
            float lon =  _pt.longitude;
            NSString * urlStr = [NSString stringWithFormat:@"%@%@?recId=%@&readyLatitude=%f&readyLongitude=%f",BaseUrl,API_DOWNWIND_TASK_ONREADY,_model.recId,lat,lon];
            [ ExpressRequest sendWithParameters:nil MethodStr:urlStr reqType:k_GET success:^(id object) {
                self.jiuweiBtn.selected = YES;
                self.jiuweiBtn.userInteractionEnabled = NO;
            } failed:^(NSString *error) {
                [SVProgressHUD showErrorWithStatus:error];
            }];
        }
            break;
        case 8:{
            //货物违规
            __weak JieOrderDetailVC * weakSelf = self;
//            _huowuWeiguiView =[[NSBundle mainBundle] loadNibNamed:@"HuowuWeiguiView" owner:nil options:nil].firstObject;
//            _huowuWeiguiView.frame = [UIApplication sharedApplication].windows.lastObject.bounds;
//            [[[UIApplication sharedApplication] keyWindow] addSubview:_huowuWeiguiView];
//            _huowuWeiguiView.huowuImg.delagate = self;
//            _huowuWeiguiView.huowuImg.layer.cornerRadius =0.0;
//            _huowuWeiguiView.huowuImg.image = [UIImage imageNamed:@"zhaopianKuang"];
            
           UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"发件人是否已同意取消？" message:nil preferredStyle:UIAlertControllerStyleAlert];
           UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [weakSelf sendBtnClick:1];
            }];
            [alert addAction:action1];
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
            }];
            [alert addAction:action2];
            [self presentViewController:alert animated:YES completion:nil];
        }
            break;
        case 9:{
            //无密码核对完成
            __weak JieOrderDetailVC * weakSelf = self;
            _noticeAlert = [[NSBundle mainBundle] loadNibNamed:@"LCFNoticeAlert" owner:nil options:nil].firstObject;
            [_noticeAlert show];
            _noticeAlert.Block = ^(NSInteger tag) {
                [weakSelf noPassWordBtnClick:tag];
            };
        }
            break;
        default:
            break;
    }
}

#pragma mark ------ 无密码核对
-(void)noPassWordBtnClick:(NSInteger)tag{
    if (tag==0) {
        [_noticeAlert dismiss];
        NSLog(@"%ld",(long)tag);
    }else{
        [SVProgressHUD show];
        if (_pt.latitude == 0 || _pt.longitude == 0) {
            [SVProgressHUD showErrorWithStatus:@"定位失败，请检查定位设置或手机网络"];
            return ;
        }
        float lat =  _pt.latitude;
        float lon =  _pt.longitude;
        if (!ARG_SAVED_IDFV) {
            NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
            [KeyChain save:ARG_IDFV data:idfv];
        }
        NSString * urlStr = [NSString stringWithFormat:@"%@driver/trueTake?recId=%@&checkDeviceId=%@&arriveLatitude=%f&arriveLongitude=%f",BaseUrl,self.model.recId,ARG_SAVED_IDFV,lat,lon];
        [ExpressRequest sendWithParameters:nil MethodStr:urlStr reqType:k_GET success:^(id object) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showWithStatus:@"交易完成"];
            [self fadeOut];
        } failed:^(NSString *error) {
            [SVProgressHUD showErrorWithStatus:error];
        }];

    }
}

- (void)fadeOut
{
    [UIView animateWithDuration:.35 animations:^{
        _noticeAlert.alpha = 0.0;
        _noticeAlert.y = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        if (finished) {
            [_noticeAlert removeFromSuperview];
            [_noticeAlert removeFromSuperview];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark -----核对交易密码
- (void)showPwd{
    _visualEffectView.hidden = NO;
    [UIView animateWithDuration:.5 delay:0 usingSpringWithDamping:.5 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
        _pwdView.y = 64;
        _pwdView.width = SCREEN_WIDTH;
    } completion:^(BOOL finished) {
        [_pwdView.field becomeFirstResponder];
    }];
}

- (void)closePwd{
    _visualEffectView.hidden = YES;
    [_pwdView.field resignFirstResponder];
    [UIView animateWithDuration:.8 delay:0 usingSpringWithDamping:.5 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
        _pwdView.y -= WINDOW_HEIGHT;
    } completion:^(BOOL finished) {
        for (UIImageView *img in _pwdView.imageVs) {
            img.image = [UIImage imageNamed: @""];
        }
        _pwdView.field.text = nil;
    }];
}

- (void)checkPwd{
    [SVProgressHUD show];
    if (_pt.latitude == 0 || _pt.longitude == 0) {
        [SVProgressHUD showErrorWithStatus:@"定位失败，请检查定位设置或手机网络"];
        return ;
    }
    [SVProgressHUD show];
    [RequestManager ChecktransactionpasswordWithrecId:self.model.recId Withlat:[NSString stringWithFormat:@"%f",_pt.latitude] withLon:[NSString stringWithFormat:@"%f",_pt.longitude] dealPassword:@"000000" success:^(id result) {
        [SVProgressHUD dismiss];
        NSString *msg = [NSString stringWithFormat:@"%@",result[@"message"]];
        [SVProgressHUD showSuccessWithStatus:msg];
//        [self done];
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH object:nil];
    }Failed:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
}
- (void)done{
    [self closePwd];
}

#pragma mark ------我已就位
-(void)sendBtnClick:(NSInteger)tag{
    /*
    货物违规按钮
    路径driver/removeDow
    请求 GET
    参数 Integer recId（顺风单号）,String illegalImageUrl（上传图片的路径，若镖师不上传就传NUll）
    */
    NSString * urlStr = [NSString stringWithFormat:@"%@%@?recId=%@&illegalImageUrl=%@",BaseUrl,API_DOWNWIND_DRIVER_REMOVEDOW,_model.recId,_illegalUrl?_illegalUrl:@""];
    [ExpressRequest sendWithParameters:nil MethodStr:urlStr reqType:k_GET success:^(id object) {
        [self.navigationController popViewControllerAnimated:YES];
        [_huowuWeiguiView removeFromSuperview];
    } failed:^(NSString *error) {
      [SVProgressHUD showErrorWithStatus:error];
    }];
}

-(void)headerView:(YMHeaderView *)headerView didSelectWithImage:(UIImage *)image{
    _huowuWeiguiView.hidden = NO;
    [SVProgressHUD showWithStatus:@"正在上传"];
    NSDictionary *dic = @{k_USER_ID:[UserManager getDefaultUser].userId,k_FILE_NAME:@"huowuweigui.png"};
    NSDictionary *fileDic = @{@"data":image,@"fileName":@"huowuweigui.png"};
            
    NSString *api =@"file/illegal";
    [ExpressRequest sendWithParameters:dic MethodStr:api fileDic:fileDic success:^(id object) {
        [SVProgressHUD showSuccessWithStatus:@"上传成功"];
        _illegalUrl = [([object objectForKey:@"data"][0]) valueForKey:@"filePath"];
     } failed:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _huowuWeiguiView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ------跳转程序外导航
-(void)daohangWithType:(int)type{
    __block NSString *urlScheme = @"";
    
    __block NSString *appName = @"镖王";
    __block CLLocationCoordinate2D coordinate ;
    if (type == 0) {
         coordinate =  CLLocationCoordinate2DMake([self.model.fromLatitude floatValue], [self.model.fromLongitude floatValue]);
    }else{
        coordinate =  CLLocationCoordinate2DMake([self.model.toLatitude floatValue], [self.model.toLongitude floatValue]);
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择地图" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        //这个判断其实是不需要的
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]])
    {
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=bd09ll",coordinate.latitude,coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSLog(@"%@",urlString);
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
         }];
         [alert addAction:action];
    }
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]])
    {
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",appName,urlScheme,coordinate.latitude,coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSLog(@"%@",urlString);
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }];
         [alert addAction:action];
    }
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]])
        
    {
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"谷歌地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%f,%f&directionsmode=driving",appName,urlScheme,coordinate.latitude, coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSLog(@"%@",urlString);
             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
         }];
          [alert addAction:action];
      }
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"http://maps.apple.com/"]])
    {
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"苹果地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
            
            MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil]];
            　 　  currentLocation.name = @"我的位置";
            　   　toLocation.name = @"目的地位置";
            [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                           launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
            
        }];
        [alert addAction:action];
    }
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:^{
    }];
}

#pragma mark ------车牌号码

- (IBAction)carNumBtnClick:(UIButton *)sender {
    [self showHistoryNum];
}

-(void)getCarNum{
    //获取车牌照号列表logistics/task/carNumber    API_WL_CARNUMLIST
    [ExpressRequest sendWithParameters:nil MethodStr:[NSString stringWithFormat:@"%@%@?userId=%@",BaseUrl,API_WL_CARNUMLIST,[UserManager getDefaultUser].userId] reqType:k_GET success:^(id object) {
        NSArray *dataArr = [object objectForKey:@"data"];
        if (dataArr &&[self.model.whether isEqualToString:@"Y"] && [self.model.premium intValue]>5000 ) {
            _carNumdownBtn.hidden = NO;
            self.dataArray = [[NSMutableArray alloc]init];
            for (NSDictionary * dic in dataArr) {
                CarNumModel * model = [[CarNumModel alloc]initWithJsonDict:dic];
                [self.dataArray addObject:model];
            }
        }else{
            _carNumdownBtn.hidden = YES;
        }
        [_carNumTableView reloadData];
    } failed:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
}

-(void)showHistoryNum{
    _carNumTableView = [[UITableView alloc]initWithFrame:CGRectMake(_carNumTextField.x , _carNumTextField.bottom, 170, 150) style:UITableViewStylePlain];
    _carNumTableView.bottom = _carNumTextField.top;
    if (SCREEN_WIDTH == 320) {
        _carNumTableView = [[UITableView alloc]initWithFrame:CGRectMake(_carNumTextField.x , _carNumTextField.bottom, 170, 150) style:UITableViewStylePlain];
    }
    _carNumTableView.backgroundColor = [UIColor whiteColor];
    _carNumTableView.layer.cornerRadius = 3;
    _carNumTableView.layer.masksToBounds = YES;
    _carNumTableView.delegate = self;
    _carNumTableView.dataSource = self;
    
    _bigView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bigBg:)];
    recognizer.delegate = self;
    [_bigView addGestureRecognizer:recognizer];
    _bigView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.4];
    [UIView animateWithDuration:.35 animations:^{
        _bigView.y = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [_bigView addSubview:_carNumTableView];
            [self.view addSubview:_bigView];
        }
    }];
}

-(void)bigBg:(UITapGestureRecognizer *)tap{
    [UIView animateWithDuration:.35 animations:^{
        _bigView.y = SCREEN_HEIGHT;
        _carNumTableView.y = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        if (finished) {
            [_carNumTableView removeFromSuperview];
            [_bigView removeFromSuperview];
        }
    }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isDescendantOfView:_carNumTableView]) {
        return NO;
    }
    return YES;
}
#pragma tableViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CarNumCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CarNumCell" owner:nil options:nil] firstObject];
    }
    CarNumModel * model = _dataArray[indexPath.row];
    [cell setModel:model];
    cell.Block = ^(NSInteger tag) {
        //       logistics/task/deleteCarNum 删除车牌号
    [ExpressRequest sendWithParameters:nil MethodStr:[NSString stringWithFormat:@"%@%@?recId=%@",BaseUrl,API_WL_DELETECARNUM,model.recId] reqType:k_GET success:^(id object) {
        [_dataArray removeObjectAtIndex:indexPath.row];
        [_carNumTableView reloadData];
        } failed:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
    };
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    CarNumModel * model = _dataArray[indexPath.row];
    _carNumTextField.text = model.carNum;
    
    [UIView animateWithDuration:.35 animations:^{
        _carNumTableView.y = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        if (finished) {
            [_carNumTableView removeFromSuperview];
            [_bigView removeFromSuperview];
        }
    }];
}


@end
