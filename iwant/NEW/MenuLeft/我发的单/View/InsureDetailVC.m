//
//  InsureDetailVC.m
//  iwant
//
//  Created by 公司 on 2017/8/19.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "InsureDetailVC.h"
#import "Logist.h"

@interface InsureDetailVC ()

@property(nonatomic,strong)Logist * model;

@end

@implementation InsureDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCostomeTitle:@"订单详情"];
    self.nameL.font = FONT(15, NO);
    self.tiJiL.font = FONT(15, NO);
    self.sizeL.font = FONT(15, NO);
    self.sendNameL.font = FONT(15, NO);
    self.sendPhoneL.font = FONT(15, NO);
    self.arriveNameL.font = FONT(15, NO);
    self.arrivePhoneL.font = FONT(15, NO);
    self.startL.font = FONT(15, NO);
    self.endL.font = FONT(15, NO);
    self.weightL.font = FONT(15, NO);
    self.baodanNumL.font = FONT(15, NO);
    [self creatData];
    }


-(void)creatData{
    [SVProgressHUD show];
    NSString * urlStr =[NSString stringWithFormat:@"%@logistics/task/info?recId=%@",BaseUrl,self.recId];
    [ExpressRequest sendWithParameters:nil MethodStr:urlStr reqType:k_GET success:^(id object) {
        [SVProgressHUD dismiss];
        NSDictionary  * dict =[object objectForKey:@"data"][0];
        self.model = [[Logist alloc]initWithJsonDict:dict];
        if (_model.pdfURL.length !=0) {
            self.downLoadBtn.hidden = NO;
        }
        [self configSubviews];
    } failed:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
}

-(void)configSubviews{
    self.nameL.text = [NSString stringWithFormat:@"物品名称：%@",_model.cargoName];
    self.tiJiL.text = [NSString stringWithFormat:@"总体积：%@",_model.cargoVolume];
    self.weightL.text = [NSString stringWithFormat:@"总重量：%@",_model.cargoWeight];
    self.sizeL.text = [NSString stringWithFormat:@"件数：%@件",_model.cargoSize];
    
    self.startL.text = [NSString stringWithFormat:@"始发地：%@",_model.startPlace];
    self.endL.text =[NSString stringWithFormat:@"目的地：%@",_model.entPlace]; ;
    self.sendNameL.text = [NSString stringWithFormat:@"发件人：%@",_model.sendPerson];
    self.sendPhoneL.text = [NSString stringWithFormat:@"电话：%@",_model.sendPhone];
    self.arriveNameL.text = [NSString stringWithFormat:@"收件人：%@",_model.takeName];
    self.arrivePhoneL.text = [NSString stringWithFormat:@"电话：%@",_model.takeMobile];
    
    self.cargoValueL.text = [NSString stringWithFormat:@"货物价值：%@元",_model.cargoCost];
    self.baoFreeL.text =[NSString stringWithFormat:@"投保费用：%@元",_model.insureCost];
    switch ([_model.category intValue]) {
        case 1:
            self.categoryL.text = [NSString stringWithFormat:@"货物种类：常规货物"];
            break;
        case 2:
            self.categoryL.text = [NSString stringWithFormat:@"货物种类：蔬菜"];
            break;
        case 3:
            self.categoryL.text = [NSString stringWithFormat:@"货物种类：水果"];
            break;
        case 4:
            self.categoryL.text = [NSString stringWithFormat:@"货物种类：牲畜及禽鱼"];
            break;
        default:
            break;
    }
    if ([_model.insurance isEqualToString:@"1"]) {
        self.typeL.text = [NSString stringWithFormat:@"承保类别：基本险"];
    }
    if([_model.insurance isEqualToString:@"2"]){
        self.typeL.text = [NSString stringWithFormat:@"承保类别：综合险"];
    }
    
    self.carNumberL.text = [NSString stringWithFormat:@"车牌号：%@",_model.carNumImg];
    if (_model.remark.length!=0) {
    self.baodanNumL.text = [NSString stringWithFormat:@"保单号：%@",_model.remark];
    }
}
- (IBAction)downLoadBaoDan:(UIButton *)sender {
    [self baodanBtn];
}

//保单
-(void)baodanBtn{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_model.pdfURL]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
