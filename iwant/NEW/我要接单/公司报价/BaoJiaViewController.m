//
//  BaoJiaViewController.m
//  iwant
//
//  Created by 公司 on 2017/6/20.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "BaoJiaViewController.h"
#import "HuoChangAdressVC.h"
#import "HuoChangModel.h"

@interface BaoJiaViewController ()<UITextFieldDelegate>{
    NSString * _transforMoney;
}
@property (weak, nonatomic) IBOutlet UILabel *matNameL;
@property (weak, nonatomic) IBOutlet UILabel *start;
@property (weak, nonatomic) IBOutlet UILabel *end;
@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;
@property (weak, nonatomic) IBOutlet UILabel *limitTimeL;
@property (weak, nonatomic) IBOutlet UILabel *guiGeL;
@property (weak, nonatomic) IBOutlet UILabel *weightL;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *takeCargoL;
@property (weak, nonatomic) IBOutlet UILabel *sendCargoL;
@property (weak, nonatomic) IBOutlet UILabel *zitiAdressL;
@property (weak, nonatomic) IBOutlet UITextField *remarkTextField;
@property (weak, nonatomic) IBOutlet UILabel *huochangLabel;
@property (weak, nonatomic) IBOutlet UIButton *baoJiaBtn;

@property (weak, nonatomic) IBOutlet UIView *takeView;
@property (weak, nonatomic) IBOutlet UIView *sendView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *takeViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sendViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *beizhu;

@property (weak, nonatomic) IBOutlet UILabel *huoChang;
@property (weak, nonatomic) IBOutlet UIButton *huoChangAdd;

//冷链车需求
@property (weak, nonatomic) IBOutlet UILabel *specialNeedL;


@property (nonatomic,strong)NSString * takeCargoMoney;//取货费
@property (nonatomic,strong)NSString * sendCargoMoney;//送货费

@property (weak, nonatomic) IBOutlet UITextField *quhuoFreeTextField;
@property (weak, nonatomic) IBOutlet UITextField *songhuoFreeTextField;
@property (weak, nonatomic) IBOutlet UITextField *yunFreeTextField;
@property (weak, nonatomic) IBOutlet UILabel *totolFreeL;
@property (weak, nonatomic) IBOutlet UIButton *baijiaBtn;

@end

@implementation BaoJiaViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.matNameL.font = FONT(14, NO);
    self.start.font = FONT(14, NO);
    self.end.font = FONT(14, NO);
    self.startLabel.font = FONT(14, NO);
    self.endLabel.font = FONT(14, NO);
    self.limitTimeL.font = FONT(14, NO);
    self.guiGeL.font = FONT(14, NO);
    self.weightL.font = FONT(14, NO);
    self.sizeLabel.font = FONT(14, NO);
    self.takeCargoL.font = FONT(14, NO);;
    self.sendCargoL.font = FONT(14, NO);
    self.zitiAdressL.font = FONT(14, NO);
    self.remarkTextField.font = FONT(14, NO);
    self.huochangLabel.font = FONT(14, NO);
    self.huoChang.font = FONT(14, NO);
    self.beizhu.font = FONT(14, NO);
    self.specialNeedL.font = FONT(14, NO);

    self.baoJiaBtn.layer.cornerRadius = 5;
    self.baoJiaBtn.layer.masksToBounds = YES;
    
    self.quhuoFreeTextField.delegate = self;
    self.songhuoFreeTextField.delegate = self;
    self.yunFreeTextField.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCostomeTitle:@"物流报价"];
    [self initWithUI];
}

-(void)initWithUI{
    self.matNameL.text = [NSString stringWithFormat:@"物品名称：%@",_model.cargoName];
    self.startLabel.text = _model.startPlace;
    self.endLabel.text = _model.entPlace;
    self.limitTimeL.text = [NSString stringWithFormat:@"要求到达时间：%@", _model.arriveTime];
    self.guiGeL.text = [NSString stringWithFormat:@"总体积：%@",self.model.cargoVolume];
    self.weightL.text = [NSString stringWithFormat:@"总重量：%@",self.model.cargoWeight];
    
    self.sizeLabel.text = [NSString stringWithFormat:@"件数：%@件",_model.cargoSize];
    //温度要求的问题
    if ([_model.carType isEqualToString:@"cold"]) {
        self.takeCargoL.text = [NSString stringWithFormat:@"温度要求：%@",_model.tem];
        self.sendCargoL.hidden = YES;
    }else{
        self.takeCargoL.text = _model.takeCargo?@"物流公司上门取货":@"用户送到货场";
        self.sendCargoL.text = _model.sendCargo?@"物流公司送货上门":@"收件人自提";
    }
    
    if ([_model.carType isEqualToString:@"cold"]) {
        self.specialNeedL.hidden = NO;
        self.specialNeedL.text = [NSString stringWithFormat:@"需求：%@",_model.carName];
    }
    
    if (_model.takeCargo) {
        _huochangLabel.hidden = YES;
        _huoChang.hidden = YES;
        _huoChang.text = @"";
        _huoChangAdd.hidden = YES;
    }else{
        _huochangLabel.hidden = NO;
        _huoChang.hidden = NO;
        _huoChang.text = @"货场地址";
        _huoChangAdd.hidden = NO;
        _huochangLabel.text = [NSString stringWithFormat:@"%@",_model.yardAddress];
    }
    if (_model.sendCargo) {
        self.zitiAdressL.text = @"";
    }else{
        self.zitiAdressL.text = [NSString stringWithFormat:@"收件人自提地址：%@",_model.appontSpace];
    }
    self.remarkTextField.text = [NSString stringWithFormat:@"%@",_model.luMessage];
    
    //温度要求的问题
    if ([_model.carType isEqualToString:@"cold"]) {
       [self hiddenTake:NO hiddenSend:NO];
    }else{
       [self hiddenTake:_model.takeCargo hiddenSend:_model.sendCargo];
    }
    if ([_model.takeCargoMoney intValue]==0) {
        _quhuoFreeTextField.text =@"";
    }else{
        _quhuoFreeTextField.text = _model.takeCargoMoney;
    }
    
    if ([_model.sendCargoMoney intValue] == 0) {
        _songhuoFreeTextField.text = @"";
    }else{
    _songhuoFreeTextField.text = _model.sendCargoMoney;
    }
    if ([_model.cargoTotal intValue] ==0) {
        _yunFreeTextField.text = @"";
    }else{
        _yunFreeTextField.text = _model.cargoTotal;
    }
    _totolFreeL.text = [NSString stringWithFormat:@"合计：%@元",_model.transferMoney];
    
    //根据ifQuotion来判断 是否已经报过价了
    if (_model.ifQuotion) {
        [self.baoJiaBtn setTitle:@"修改报价" forState:UIControlStateNormal];
    }else{
        [self.baoJiaBtn setTitle:@"提交报价" forState:UIControlStateNormal];
    }
}

//报价
- (IBAction)baoJiaBtnClick:(UIButton *)sender {
    //提交报价
    [self publish];
}

- (void)publish{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message: [NSString stringWithFormat:@"参与报价，用户选择后，对接成功将收取平台使用费。您确定要报价吗？"] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"报价" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (self.model.takeCargo) {
            self.takeCargoMoney = _quhuoFreeTextField.text;
        }else{
           self.takeCargoMoney = @"0";
        }
        if (self.model.sendCargo) {
            self.sendCargoMoney = _songhuoFreeTextField.text;
        }else{
            self.sendCargoMoney =@"0";
        }
     [self firstBaojia];
        
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:sureAction];
    [self presentViewController:alert animated:NO completion:nil];
}
- (void)firstBaojia{
    //    发布报价
    if (_model.takeCargo) {
        _huochangLabel.text = @"";
    }else{
        if (_huochangLabel.text.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请添加货场地址"];
            return;
        }
    }
    
    [SVProgressHUD show];
    NSDictionary *dic = @{@"userId":[UserManager getDefaultUser].userId,
                          @"transferMoney":_transforMoney?_transforMoney:_model.transferMoney,
                          @"luMessage":self.remarkTextField.text,
                          @"WLBId":_model.recId,
                          @"takeCargoMoney":self.takeCargoMoney,
                          @"sendCargoMoney":self.sendCargoMoney,
                          @"cargoTotal":self.yunFreeTextField.text,
                          @"yardAddress":_huochangLabel.text
                          };
    [ExpressRequest sendWithParameters:dic
                             MethodStr:@"quotation/publish"
                               reqType:k_POST
                               success:^(id object) {
                                   [SVProgressHUD dismiss];
                                   [self notice];
                               } failed:^(NSString *error) {
                                   [SVProgressHUD showErrorWithStatus:error];
                               }];
}
- (void)notice{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)hiddenTake:(BOOL)hiddenTake hiddenSend:(BOOL)hiddenSend
{
    if (!hiddenTake) {
        self.takeView.hidden = YES;
        self.takeViewHeightConstraint.constant = 0;
    }else{
        self.takeView.hidden = NO;
        self.takeViewHeightConstraint.constant = 35;
    }
    if (!hiddenSend) {
        self.sendView.hidden = YES;
        self.sendViewHeightConstraint.constant = 0;
    }else{
        self.sendView.hidden = NO;
        self.sendViewHeightConstraint.constant = 35;
    }
}

//货场地址
- (IBAction)huochangBtn:(UIButton *)sender {
    HuoChangAdressVC * addressVc =[[HuoChangAdressVC alloc]init];
    addressVc.block = ^(HuoChangModel * model){
        _huochangLabel.text = [NSString stringWithFormat:@"%@%@",model.locationAddress,model.address];
    };
    [self.navigationController pushViewController:addressVc animated:YES];
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    _transforMoney= [NSString stringWithFormat:@"%d", [_quhuoFreeTextField.text intValue] + [_songhuoFreeTextField.text intValue] +[_yunFreeTextField.text intValue]];
    _totolFreeL.text = [NSString stringWithFormat:@"合计：%@元",_transforMoney];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
