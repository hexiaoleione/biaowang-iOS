//
//  LookMyDetailVC.m
//  iwant
//
//  Created by 公司 on 2017/6/29.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "LookMyDetailVC.h"
#import "FaViewConstroller.h"
#import "WLModel.h"

@interface LookMyDetailVC ()

@property(nonatomic,strong)Logist * model;

@end

@implementation LookMyDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.nameL.font = FONT(14, NO);
    self.limitTimeL.font = FONT(14, NO);
    self.guiGeL.font = FONT(14, NO);
    self.sizeL.font = FONT(14, NO);
    self.takeCargoL.font = FONT(14, NO);
    self.sendCargoL.font = FONT(14, NO);
    self.sendNameL.font = FONT(14, NO);
    self.sendPhoneL.font = FONT(14, NO);
    self.arriveNameL.font = FONT(14, NO);
    self.arrivePhoneL.font = FONT(14, NO);
    self.start.font = FONT(14, NO);
    self.end.font = FONT(14, NO);
    self.startL.font = FONT(14, NO);
    self.endL.font = FONT(14, NO);
    self.yuanquL.font = FONT(14, NO);
    self.weightL.font = FONT(14, NO);
    self.specialNeedL.font = FONT(14, NO);
    [self creatData];
    [self setCostomeTitle:@"订单详情"];
}

-(void)creatData{
    [SVProgressHUD show];
    NSString * urlStr =[NSString stringWithFormat:@"%@logistics/task/info?recId=%@",BaseUrl,self.recId];
    [ExpressRequest sendWithParameters:nil MethodStr:urlStr reqType:k_GET success:^(id object) {
        [SVProgressHUD dismiss];
        NSDictionary  * dict =[object objectForKey:@"data"][0];
        self.model = [[Logist alloc]initWithJsonDict:dict];
        [self configSubviews];
    } failed:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
}

-(void)configSubviews{
    self.nameL.text = [NSString stringWithFormat:@"物品名称：%@",_model.cargoName];
    self.limitTimeL.text = [NSString stringWithFormat:@"要求到达时间：%@",_model.arriveTime];
    self.guiGeL.text = [NSString stringWithFormat:@"总体积：%@",_model.cargoVolume];
    if ([_model.carType isEqualToString:@"cold"]) {
      self.specialNeedL.hidden = NO;
      self.specialNeedL.text = [NSString stringWithFormat:@"需求：%@",_model.carName];
    }
    
    self.weightL.text = [NSString stringWithFormat:@"总重量：%@",_model.cargoWeight];

    self.sizeL.text = [NSString stringWithFormat:@"件数：%@件",_model.cargoSize];
    
    //温度要求问题
    if ([_model.carType isEqualToString:@"cold"]) {
        self.takeCargoL.text = [NSString stringWithFormat:@"温度要求：%@",self.model.tem];
        self.sendCargoL.hidden  = YES;
    }else{
       self.takeCargoL.text = _model.takeCargo ?@"物流公司上门取货":@"发件人送到货场";
       self.sendCargoL.text = _model.sendCargo ?@"物流公司送货上门":@"收件人自提";
    }
    
    self.startL.text = _model.startPlace;
    self.endL.text = _model.entPlace;
    self.sendNameL.text = [NSString stringWithFormat:@"发件人：%@",_model.sendPerson];
    self.sendPhoneL.text = [NSString stringWithFormat:@"电话：%@",_model.sendPhone];
    self.arriveNameL.text = [NSString stringWithFormat:@"收件人：%@",_model.takeName];
    self.arrivePhoneL.text = [NSString stringWithFormat:@"电话：%@",_model.takeMobile];
    if (_model.sendCargo) {
        self.yuanquL.text = @"";
    }else{
     self.yuanquL.text = [NSString stringWithFormat:@"指定物流园区：%@",_model.appontSpace];
    }
}

- (IBAction)publishAgain:(UIButton *)sender {
    FaViewConstroller * vc =[[FaViewConstroller alloc]init];
    vc.type = 3;
    WLModel * model = [[WLModel alloc]init];
    model.sendPerson = self.model.sendPerson;
    model.sendPhone = self.model.sendPhone;
    model.cargoName = self.model.cargoName;
    model.entPlace = self.model.entPlace;
    model.startPlace = self.model.startPlace;
    model.takeCargo = self.model.takeCargo ? @"1":@"0";
    model.sendCargo = self.model.sendCargo ? @"1":@"0";
    model.cargoVolume = self.model.cargoVolume;
    //物流再来一单，要求到达时间 重新赋值
    model.arriveTime = @"";
    
    model.takeName = self.model.takeName;
    model.takeMobile = self.model.takeMobile;
    model.latitude = [NSString stringWithFormat:@"%f",self.model.latitude];
    model.longitude =[NSString stringWithFormat:@"%f", self.model.longitude];
    model.startPlaceCityCode = self.model.startPlaceCityCode;
    model.entPlaceCityCode = self.model.entPlaceCityCode;
    model.latitudeTo = self.model.latitudeTo;
    model.longitudeTo = self.model.longitudeTo;
    model.appontSpace = self.model.appontSpace;
    model.weight = self.model.weight;
    model.cargoSize = self.model.cargoSize;
    model.carType = self.model.carType;
    model.carName = self.model.carName;
    model.startPlaceTownCode =self.model.startPlaceTownCode;
    model.tem = self.model.tem;
    vc.wlModel = model;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
