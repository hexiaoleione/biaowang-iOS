//
//  BaoDanDetailVC.m
//  iwant
//
//  Created by 公司 on 2017/10/13.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "BaoDanDetailVC.h"
#import "Logist.h"
@interface BaoDanDetailVC ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollerView;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property(nonatomic,strong)Logist * model;
@end

@implementation BaoDanDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  [self setCostomeTitle:@"订单详情"];
    self.view.backgroundColor =UIColorFromRGB(0xf4f4f4);
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
    if ([_model.status intValue]==11) {
        self.downLoadBtn.hidden = YES;
    }
    
    self.nameL.text = [NSString stringWithFormat:@"物品名称：%@",_model.cargoName];
    self.tiJiL.text = [NSString stringWithFormat:@"总体积：%@",_model.cargoVolume];
    self.weightL.text = [NSString stringWithFormat:@"总重量：%@",_model.cargoWeight];
    self.sizeL.text = [NSString stringWithFormat:@"件数：%@件",_model.cargoSize];
    
    [self.baodanNumL setTextColor:UIColorFromRGB(0x6e9ad9)];
    [self.baoFreeL  setTextColor:UIColorFromRGB(0x6e9ad9)];
    [self.startL setTextColor:[UIColor blackColor]];
    self.startL.font = [UIFont systemFontOfSize:15];
    [self.endL setTextColor:[UIColor blackColor]];
    self.endL.font = [UIFont systemFontOfSize:15];
    self.startL.text = [NSString stringWithFormat:@"%@",_model.startPlace];
    self.endL.text =[NSString stringWithFormat:@"%@",_model.entPlace];
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
    }else{
        self.baodanNumL.text = @"";
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
