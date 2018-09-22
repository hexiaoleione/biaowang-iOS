//
//  MyFaDetailViewController.m
//  iwant
//
//  Created by 公司 on 2017/6/14.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "MyFaDetailViewController.h"
#import "FaViewConstroller.h"

@interface MyFaDetailViewController ()
@property (weak, nonatomic) IBOutlet UIButton *publishAgainBtn;

@end

@implementation MyFaDetailViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.matName.font = FONT(14, NO);
    self.limitTimeL.font = FONT(14, NO);
    self.replaceMoneyL.font = FONT(14, NO);
    self.guiGeL.font = FONT(14, NO);
    self.weightL.font = FONT(14, NO);
    self.remark.font = FONT(14, NO);
    self.remarkL.font = FONT(14, NO);
    self.transforMoneyL.font = FONT(14, NO);
    self.baofeiL.font = FONT(14, NO);
    self.sendNameL.font = FONT(14, NO);
    self.sendPhoneL.font = FONT(14, NO);
    self.receiveNameL.font = FONT(14, NO);
    self.receivePhoneL.font = FONT(14, NO);
    self.fahuo.font = FONT(14, NO);
    self.shouhuo.font = FONT(14, NO);
    self.startPlaceL.font = FONT(14, NO);
    self.endNamePlaceL.font = FONT(14, NO);
    self.jianshuL.font = FONT(14, NO);
    self.weiguiNoticeL.font = FONT(15, NO);
    self.agreeL.font = FONT(13, NO);
    self.agreeNoL.font = FONT(13, NO);
    self.topNoticeConstraint.constant = 36*RATIO_HEIGHT;
    self.btnTopConstraint.constant = 30*RATIO_HEIGHT;
    self.jianshuL.font = FONT(14, NO);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCostomeTitle:@"发布详情"];
    self.matName.text =[NSString stringWithFormat:@"物品名称：%@",self.model.matName];
    if (self.model.limitTime.length == 0) {
        //顺风
        if (self.model.useTime.length == 0 || self.model.useTime == nil) {
            self.limitTimeL.text = [NSString stringWithFormat:@"发布时间：%@",self.model.publishTime];
        }else{
            self.limitTimeL.text = [NSString stringWithFormat:@"要求到达时间：%@",self.model.useTime];
        }
    }else{
        //限时
     self.limitTimeL.text = [NSString stringWithFormat:@"要求到达时间：%@",self.model.limitTime];
    }
    if (self.model.ifReplaceMoney && self.model.replaceMoney.length!=0) {
        self.replaceMoneyL.hidden = NO;
        self.replaceMoneyL.text = [NSString stringWithFormat:@"代收款：%@元",self.model.replaceMoney];
    }
    
    if (self.model.matVolume.length == 0) {
        self.guiGeL.text = [NSString stringWithFormat:@"要求车型：无要求"];
    }else{
        self.guiGeL.text = [NSString stringWithFormat:@"要求车型：%@",self.model.matVolume];
    }

    if ([self.model.matWeight intValue]==5) {
         self.weightL.text = [NSString stringWithFormat:@"总重量：≤5公斤"];
    }else{
         self.weightL.text = [NSString stringWithFormat:@"总重量：%@公斤",self.model.matWeight];
    }
    
    if ([self.model.whether isEqualToString:@"Y"]) {
        NSString * money = [NSString stringWithFormat:@"%.2f",[self.model.transferMoney doubleValue]-[self.model.insureCost doubleValue]];
        self.transforMoneyL.text = [NSString stringWithFormat:@"运费：%@元",money];
     }else{
    self.transforMoneyL.text = [NSString stringWithFormat:@"运费：%@元",self.model.transferMoney];
    }
    if ([self.model.whether isEqualToString:@"Y"]) {
        self.baofeiL.text = [NSString stringWithFormat:@"保费：%@元",self.model.insureCost];
    }else{
        self.baofeiL.text = @"";
    }
    if (self.model.cargoSize.length == 0) {
        self.jianshuL.text = [NSString stringWithFormat:@"件数：1件"];
    }else{
        self.jianshuL.text = [NSString stringWithFormat:@"件数：%@件",self.model.cargoSize];
    }
    self.sendNameL.text = [NSString stringWithFormat:@"发件人：%@",self.model.personName];
    self.sendPhoneL.text = [NSString stringWithFormat:@"电话：%@",self.model.mobile];
    self.startPlaceL.text = [NSString stringWithFormat:@"%@",self.model.address];
    if (self.model.matRemark.length == 0) {
        self.remark.text = @"";
        self.remarkL.text = [NSString stringWithFormat:@"%@",self.model.matRemark];
    }else{
        self.remarkL.text = [NSString stringWithFormat:@"%@",self.model.matRemark];
    }
    self.receiveNameL.text =[NSString stringWithFormat:@"收件人：%@",self.model.personNameTo];
    self.receivePhoneL.text = [NSString stringWithFormat:@"电话：%@",self.model.mobileTo];
    self.endNamePlaceL.text = [NSString stringWithFormat:@"%@",self.model.addressTo];
    
    //状态为9 的时候货物违规了 所以需要显示是否同意的按钮
    if ([self.model.status intValue]== 9) {
        self.weiguiNoticeL.hidden = NO;
        self.agreeL.hidden = NO;
        self.agreeNoL.hidden = NO;
        self.agreeBtn.hidden = NO;
        self.agreeNoBtn.hidden = NO;
        self.publishAgainBtn.hidden = YES;
    }
}

- (IBAction)weiguiBtnClick:(UIButton *)sender {
    if (sender.tag == 0) {
        //同意
        [ExpressRequest sendWithParameters:nil MethodStr:[NSString stringWithFormat:@"%@%@?recId=%@&ifAgree=1",BaseUrl,API_DRIVER_CUSTOMERCHOOSE,self.model.recId] reqType:k_GET success:^(id object) {
            NSArray *arr = self.navigationController.viewControllers;
            UIViewController *vc = arr[arr.count - 3];
            [self.navigationController popToViewController:vc animated:YES];
        } failed:^(NSString *error) {
            [SVProgressHUD showErrorWithStatus:error];
        }];
    }else{
        [SVProgressHUD show];
        [ExpressRequest sendWithParameters:nil MethodStr:[NSString stringWithFormat:@"%@%@?recId=%@&ifAgree=0",BaseUrl,API_DRIVER_CUSTOMERCHOOSE,self.model.recId] reqType:k_GET success:^(id object) {
            [SVProgressHUD dismiss];
            NSArray *arr = self.navigationController.viewControllers;
            UIViewController *vc = arr[arr.count - 3];
            [self.navigationController popToViewController:vc animated:YES];
        } failed:^(NSString *error) {
            [SVProgressHUD showErrorWithStatus:error];
        }];
    }
}
- (IBAction)publishAgain:(UIButton *)sender {
    
    if (self.model.limitTime.length == 0) {
   //顺路送
        FaViewConstroller * vc = [[FaViewConstroller alloc]init];
        vc.type = 1;
        self.model.useTime =@"";
        vc.model = self.model;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
   //专程送
        FaViewConstroller * vc = [[FaViewConstroller alloc]init];
        vc.type = 2;
        self.model.limitTime =@"";
        vc.model = self.model;
        [self.navigationController pushViewController:vc animated:YES];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
