//
//  BaoJiaDetailViewController.m
//  iwant
//
//  Created by 公司 on 2017/6/23.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "BaoJiaDetailViewController.h"
#import "DanBaoViewController.h"
@interface BaoJiaDetailViewController ()

@end

@implementation BaoJiaDetailViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
    self.noticeL.font = FONT(17, NO);
    self.companyNameL.font = FONT(14, NO);
    self.huochangL.font = FONT(14, NO);
    self.baijia.font = FONT(14, NO);
    self.quL.font = FONT(14, NO);
    self.quqFree.font = FONT(14, NO);
    self.quDanwei.font = FONT(14, NO);
    self.songL.font = FONT(14, NO);
    self.songFree.font = FONT(14, NO);
    self.songDanwei.font = FONT(14, NO);
    self.yunfeiL.font = FONT(14, NO);
    self.yunfeiFree.font = FONT(14, NO);
    self.yunfeiYuan.font = FONT(14, NO);
    self.hejiL.font = FONT(14, NO);
    self.hejiDanwei.font = FONT(14, NO);
    self.totolFree.font = FONT(14, NO);
    self.messgaeL.font = FONT(14, NO);
    self.specialNeedL.font = FONT(14, NO);
    self.weightL.font = FONT(14, NO);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configSubViews];
    [self setCostomeTitle:@"报价详情"];
}
-(void)configSubViews{
    self.nameL.text = [NSString stringWithFormat:@"物品名称：%@",self.model.cargoName];
    self.limitTimeL.text = [NSString stringWithFormat:@"要求到达时间：%@",self.model.arriveTime];
    self.guiGeL.text = [NSString stringWithFormat:@"总体积：%@",self.model.cargoVolume];
    if ([self.model.carType isEqualToString:@"cold"]) {
        self.specialNeedL.hidden = NO;
        self.specialNeedL.text = [NSString stringWithFormat:@"需求：%@",self.model.carName];
    }
    
    self.weightL.text = [NSString stringWithFormat:@"总重量：%@",self.model.cargoWeight];
    self.sizeL.text = [NSString stringWithFormat:@"件数：%@件",self.model.cargoSize];
    if ([self.model.carType isEqualToString:@"cold"]) {
        self.takeCargoL.text=[NSString stringWithFormat:@"温度要求：%@",self.model.tem];
        self.sendCargoL.hidden = YES;
    }else{
       self.takeCargoL.text = self.model.takeCargo ?@"物流公司上门取货":@"发件人送到货场";
       self.sendCargoL.text = self.model.sendCargo ?@"物流公司送货上门":@"收件人自提";
    }
    
    self.startL.text = self.model.startPlace;
    self.endL.text = self.model.entPlace;
    self.sendNameL.text = [NSString stringWithFormat:@"发件人：%@",self.model.sendPerson];
    self.sendPhoneL.text = [NSString stringWithFormat:@"电话：%@",self.model.sendPhone];
    self.arriveNameL.text = [NSString stringWithFormat:@"收件人：%@",self.model.takeName];
    self.arrivePhoneL.text = [NSString stringWithFormat:@"电话：%@",self.model.takeMobile];
    self.companyNameL.text = [NSString stringWithFormat:@"名称：%@",self.baojiaModel.companyName];
    
    if (self.baojiaModel.takeCargo) {
         self.huochangL.text = @"";
    }else{
    self.huochangL.text = [NSString stringWithFormat:@"货场地址：%@",self.baojiaModel.yardAddress];
    }
    //温度要求问题
    if ([self.model.carType isEqualToString:@"cold"]) {
        self.quL.text = @"运费";
        self.quqFree.text =[NSString stringWithFormat:@"%@",_baojiaModel.cargoTotal];
        self.songL.text = @"合计";
        self.songFree.text = [NSString stringWithFormat:@"%@",_baojiaModel.transferMoney];
        self.yunfeiL.hidden = YES;
        self.yunfeiFree.hidden = YES;
        self.yunfeiYuan.hidden = YES;
        self.hejiL.hidden = YES;
        self.hejiDanwei.hidden = YES;
        self.totolFree.hidden = YES;
    }else{
        
        self.quqFree.text = [NSString stringWithFormat:@"%@",_baojiaModel.takeCargoMoney];
        self.songFree.text = [NSString stringWithFormat:@"%@",_baojiaModel.sendCargoMoney];
        self.yunfeiFree.text = [NSString stringWithFormat:@"%@",_baojiaModel.cargoTotal];
        self.totolFree.text =[NSString stringWithFormat:@"%@",_baojiaModel.transferMoney];
    }
    self.messgaeL.text = [NSString stringWithFormat:@"留言：%@",_baojiaModel.luMessage];
}

- (IBAction)selectBtnClick:(UIButton *)sender {
    //就选它了
    NSString * strUrl = [NSString stringWithFormat:@"%@logistics/task/chose?recId=%@&userId=%@",BaseUrl,self.model.recId,self.comId];
    [ExpressRequest sendWithParameters:nil MethodStr:strUrl reqType:k_GET success:^(id object) {
        
        DanBaoViewController * danbaoVc =[[DanBaoViewController alloc]init];
        danbaoVc.isZhiFu = YES;
        danbaoVc.recId = self.model.recId;
        [self.navigationController pushViewController:danbaoVc animated:YES];
        
    } failed:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
