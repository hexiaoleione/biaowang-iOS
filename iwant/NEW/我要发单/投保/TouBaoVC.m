//
//  TouBaoVC.m
//  iwant
//
//  Created by 公司 on 2017/8/29.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "TouBaoVC.h"
#import "LocationViewController.h"
#import "ActionSheetStringPicker.h"
#import "InforWebViewController.h"
#import "RechargeViewController.h"
#import "settinhHeaderViewController.h"   //实名认证

@interface TouBaoVC (){
    NSString * _category;    //1 常规货物类、2 蔬菜、3 水果、4牲畜及禽鱼
    NSString * _insurance;   //承险类别  1 基本险  2综合险
}

@property(nonatomic,strong)UIButton * catoryBtn;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollerView;
@property (weak, nonatomic) IBOutlet UITextField *sendNameTextfield;
@property (weak, nonatomic) IBOutlet UITextField *sendPhoneTexteField;

@property (weak, nonatomic) IBOutlet UITextField *receiveNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *receivePhoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *startPlaceTextField;
@property (weak, nonatomic) IBOutlet UITextField *endPlaceTextField;
@property (weak, nonatomic) IBOutlet UITextField *cargoNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *weightTextField;
@property (weak, nonatomic) IBOutlet UIButton *danweiBtn;

@property (weak, nonatomic) IBOutlet UITextField *cargoVolumeTextField;
@property (weak, nonatomic) IBOutlet UITextField *cargoSizeTextField;
@property (weak, nonatomic) IBOutlet UITextField *cargoValueTextField;
@property (weak, nonatomic) IBOutlet UITextField *carNumTextField;

@property (weak, nonatomic) IBOutlet UIButton *insureBtn;
@property (weak, nonatomic) IBOutlet UIButton *zongHeBtn;

@property (weak, nonatomic) IBOutlet UIButton *ifAgreeBtn;

@property (nonatomic,strong)NSMutableArray * weightArr;
@property (nonatomic,strong)NSMutableArray * countArr;
@property (nonatomic,strong)NSArray * danweiArr;
@property (nonatomic,strong)NSMutableArray * cargoVolumeArr;

@property (nonatomic,copy)NSString * startPlaceCityCode;
@property (nonatomic,copy)NSString * startPlaceTownCode;
@property (nonatomic,copy)NSString * entPlaceCityCode;

@property (nonatomic,copy)NSString *cargoSize;//件数

@property (nonatomic,copy)NSString * recId;

@end

@implementation TouBaoVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.scrollerView.width = SCREEN_WIDTH;
    
    self.scrollerView.frame = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-40*RATIO_HEIGHT);
    self.scrollerView.contentSize = CGSizeMake(0, 864);
    if (@available(iOS 11, *)) {
        self.scrollerView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCostomeTitle:@"投保详情"];
    if (SCREEN_WIDTH == 320) {
        self.sendNameTextfield.font = [UIFont systemFontOfSize:13];
        self.sendPhoneTexteField.font =[UIFont systemFontOfSize:13];
        self.receiveNameTextField.font = [UIFont systemFontOfSize:13];
        self.receivePhoneTextField.font = [UIFont systemFontOfSize:13];
    }
    
    self.sendNameTextfield.text = [UserManager getDefaultUser].userName;
    self.sendPhoneTexteField.text = [UserManager getDefaultUser].mobile;
}
- (IBAction)btnClick:(UIButton *)sender {
    //0 发件人姓名电话  1 收件人姓名电话 2始发地  3目的地  4总重量  5单位  6总体积  7件数  8投保协议

    switch (sender.tag) {
        case 0:{
            [Contacts judgeAddressBookPowerWithUIViewController:self contactsBlock:^(NSString *name, NSString *phoneNumber) {
                self.sendNameTextfield.text = name;
                self.sendPhoneTexteField.text = phoneNumber;
            }];
        }
            break;
        case 1:{
            [Contacts judgeAddressBookPowerWithUIViewController:self contactsBlock:^(NSString *name, NSString *phoneNumber) {
                self.receiveNameTextField.text = name;
                self.receivePhoneTextField.text = phoneNumber;
            }];
        }
            break;
        case 2:{
            LocationViewController * vc =[[LocationViewController alloc]init];
            vc.passBlock  = ^(NSString *address, NSString *name, NSString *lat, NSString *lon, NSString *cityCode, NSString *cityName, NSString *townCode, NSString *townName) {
                self.startPlaceTextField.text = [NSString stringWithFormat:@"%@%@",address,name];
                self.startPlaceCityCode = cityCode;
                self.startPlaceTownCode = townCode;
              };
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:{
            LocationViewController * vc =[[LocationViewController alloc]init];
            vc.passBlock  = ^(NSString *address, NSString *name, NSString *lat, NSString *lon, NSString *cityCode, NSString *cityName, NSString *townCode, NSString *townName) {
                self.endPlaceTextField.text = [NSString stringWithFormat:@"%@%@",address,name];
                self.entPlaceCityCode = cityCode;
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4:{
            _weightArr = [[NSMutableArray alloc]init];
            for (int i = 0; i<1000; i++) {
                NSString  * str =[NSString stringWithFormat:@"%d",i+1];
                [_weightArr addObject:str];
            }
            [ActionSheetStringPicker showPickerWithTitle:@"物品重量" rows:_weightArr initialSelection:0 target:self successAction:@selector(weightWasSelected:element:sender:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
        }
            break;
        case 5:{
            _danweiArr = @[@"吨",@"公斤"];
                [ActionSheetStringPicker showPickerWithTitle:@"重量单位" rows:_danweiArr initialSelection:0 target:self successAction:@selector(danweiWasSelected:element:sender:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
        }
            break;
        case 6:{
            _cargoVolumeArr = [[NSMutableArray alloc]init];
            [_cargoVolumeArr addObject:@"1立方米以下"];
            for (int i = 0; i<50; i++) {
                NSString  * str =[NSString stringWithFormat:@"%d立方米",i+1];
                [_cargoVolumeArr addObject:str];
            }
            [ActionSheetStringPicker showPickerWithTitle:@"总体积" rows:_cargoVolumeArr initialSelection:0 target:self successAction:@selector(cargoVolumeWasSelected:element:sender:) cancelAction:@selector(cargoVolumesendActionPickerCancelled:) origin:sender];
        }
            break;
        case 7:{
            _countArr = [[NSMutableArray alloc]init];
            for (int i =0 ; i<1000; i++) {
                NSString  * str =[NSString stringWithFormat:@"%d 件",i+1];
                [_countArr addObject:str];
            }
            [ActionSheetStringPicker showPickerWithTitle:@"件数" rows:_countArr initialSelection:0 target:self successAction:@selector(countWasSelected:element:sender:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
        }
            break;
        case 8:{
            InforWebViewController * vc = [[InforWebViewController alloc]init];
            vc.info_type = WEB_WL_insure;
            [self.navigationController pushViewController:vc animated:YES];
        }
        default:
            break;
    }
}

-(void)weightWasSelected:(NSNumber *)selectedIndex element:(id)element sender: (UIButton*) btn {
    self.weightTextField.text =  [NSString stringWithFormat:@"%@",[_weightArr objectAtIndex:[selectedIndex intValue]]];
   }
-(void)danweiWasSelected:(NSNumber *)selectedIndex element:(id)element sender: (UIButton*) btn {
    [self.danweiBtn setTitle: [NSString stringWithFormat:@"%@",[_danweiArr objectAtIndex:[selectedIndex intValue]]] forState:UIControlStateNormal];
}
-(void)countWasSelected:(NSNumber *)selectedIndex element:(id)element sender: (UIButton*) btn {
    
    self.cargoSizeTextField.text =  [NSString stringWithFormat:@"%@",[_countArr objectAtIndex:[selectedIndex intValue]]];
    _cargoSize = [NSString stringWithFormat:@"%d",[selectedIndex intValue]+1];
 }
-(void)cargoVolumeWasSelected:(NSNumber *)selectedIndex element:(id)element sender: (UIButton*) btn{
    self.cargoVolumeTextField.text = _cargoVolumeArr[[selectedIndex intValue]];
}
-(void)cargoVolumesendActionPickerCancelled:(id)sender{
}

- (void)actionPickerCancelled:(id)sender {
}


#pragma mark ---投保物品种类

- (IBAction)cargoBtnClick:(UIButton *)sender {
    
    if (self.catoryBtn == sender) {
        return;
    }
    self.catoryBtn.selected = NO;
    self.catoryBtn = sender;
    self.catoryBtn.selected = YES;
    
    self.insureBtn.selected = YES;
    self.zongHeBtn.selected = NO;
    _insurance = @"1";
//    NSLog(@"%ld",self.catoryBtn.tag);
    self.zongHeBtn.hidden = NO;
    if (sender.tag != 1) {
        self.zongHeBtn.hidden = YES;
    }
}

#pragma mark ---- 承保类型
- (IBAction)typeSelectBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if(sender.selected){
       if (sender.tag == 1) {
          _insurance = @"1";
           self.zongHeBtn.selected = NO;
       }else{
          _insurance = @"2";
           self.insureBtn.selected = NO;
       }
    }else{
        _insurance = @"";
    }
}

- (IBAction)ifAgreeBtnClick:(UIButton *)sender {
     sender.selected = !sender.selected;
}

#pragma mark --- 提交
- (IBAction)submitClick:(UIButton *)sender {

    if (self.sendNameTextfield.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请填写发件人姓名"];
        return ;
    }
    if (self.sendPhoneTexteField.text.length != 11) {
        [SVProgressHUD showErrorWithStatus:@"请填写正确的发件人电话"];
        return ;
    }

    if (self.receiveNameTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请填写收件人姓名"];
        return ;
    }

    if (self.receivePhoneTextField.text.length != 11) {
        [SVProgressHUD showErrorWithStatus:@"请填写正确的收件人电话"];
        return ;
    }

    if (self.cargoNameTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请填写真实的货物名称"];
        return ;
    }
    if (self.weightTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择物品总重量"];
        return;
    }
    if (self.cargoVolumeTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择物品总体积"];
        return;
    }
    if (self.cargoSize.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择货物件数"];
        return;
    }
    if (self.carNumTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请填写承运车车牌号"];
        return;
    }

    if (self.cargoValueTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请填写货物价值"];
        return;
    }
    if (!self.catoryBtn) {
        [SVProgressHUD showErrorWithStatus:@"请勾选投保物品种类"];
        return;
    }
    if (_insurance.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择承保类型"];
        return;
    }
    if (_carNumTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请填写承运车车牌号"];
        return;
    }
    if (!_ifAgreeBtn.selected) {
        [SVProgressHUD showErrorWithStatus:@"请先阅读并同意《大宗货物投保声明》"];
        return;
    }
    
    NSString * cargoWeight = [NSString stringWithFormat:@"%@%@",_weightTextField.text,_danweiBtn.titleLabel.text];
    
    [SVProgressHUD show];
    NSDictionary * dic =@{@"userId":[UserManager getDefaultUser].userId,
                          @"sendPerson":self.sendNameTextfield.text,
                          @"sendPhone":self.sendPhoneTexteField.text,
                          @"takeName":self.receiveNameTextField.text,
                          @"takeMobile":self.receivePhoneTextField.text,
                          @"startPlace":self.startPlaceTextField.text,
                          @"startPlaceCityCode":self.startPlaceCityCode ?self.startPlaceCityCode:@"",
                          @"startPlaceTownCode":self.startPlaceTownCode ?self.startPlaceTownCode:@"",
                          @"entPlaceCityCode":self.entPlaceCityCode?self.entPlaceCityCode:@"",
                          @"entPlace":self.endPlaceTextField.text,
                          @"cargoName":self.cargoNameTextField.text,
                          @"cargoWeight":cargoWeight,
                          @"cargoSize":self.cargoSize,
                          @"cargoVolume":self.cargoVolumeTextField.text,
                          @"cargoCost":_cargoValueTextField.text,
                          @"category":[NSString stringWithInteger:self.catoryBtn.tag],
                          @"insurance":_insurance,
                          @"carNumImg":_carNumTextField.text
                          };
   [ExpressRequest sendWithParameters:dic MethodStr:@"logistics/task/publishInsureNew" reqType:k_POST success:^(id object) {
       [SVProgressHUD dismiss];
          NSDictionary * dict =[object objectForKey:@"data"][0];
           NSString * insureCost = [dict objectForKey:@"insureCost"];
          self.recId = [dict objectForKey:@"recId"];
           UIAlertController *alertTwo = [UIAlertController alertControllerWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"此单保费%@元",insureCost] preferredStyle:UIAlertControllerStyleAlert];
           UIAlertAction *cancleTwo = [UIAlertAction actionWithTitle:@"暂不支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
               [self.navigationController popToRootViewControllerAnimated:YES];
           }];
           UIAlertAction *updateTwo = [UIAlertAction actionWithTitle:@"立即支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
               [self payInsureCostByYue];
           }];
           [alertTwo addAction:cancleTwo];
           [alertTwo addAction:updateTwo];
           [self presentViewController:alertTwo animated:YES completion:nil];
     
   } failed:^(NSString *error) {
       //实名认证的跳转
       int errCode = [[[NSUserDefaults standardUserDefaults] valueForKey:@"errCode"] intValue];
       if (errCode == -4)
       {
           [SVProgressHUD dismiss];
           HHAlertView *alert = [[HHAlertView alloc]initWithTitle:nil detailText:error cancelButtonTitle:@"暂不认证" otherButtonTitles:@[@"立即认证"]];
           alert.mode = HHAlertViewModeWarning;
           [alert showWithBlock:^(NSInteger index) {
               if(index != 0){
                   [self.navigationController pushViewController:[[settinhHeaderViewController alloc]init] animated:YES];
               }
           }];
       }else{
           [SVProgressHUD showErrorWithStatus:error];
       }
   }];
}

-(void)payInsureCostByYue{
    [SVProgressHUD show];
    [ExpressRequest sendWithParameters:nil MethodStr:[NSString stringWithFormat:@"%@logistics/task/payInsure?recId=%@",BaseUrl,self.recId]reqType:k_GET success:^(id object) {
        [SVProgressHUD dismiss];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failed:^(NSString *error) {
        int errCode = [[[NSUserDefaults standardUserDefaults] valueForKey:@"errCode"] intValue];
        if (errCode == -3)
        {
            [SVProgressHUD dismiss];
            HHAlertView *alert = [[HHAlertView alloc]initWithTitle:nil detailText:error cancelButtonTitle:@"取消" otherButtonTitles:@[@"去充值"]];
            alert.mode = HHAlertViewModeWarning;
            [alert showWithBlock:^(NSInteger index) {
                if(index != 0){
                    [self.navigationController pushViewController:[[RechargeViewController alloc]init] animated:YES];
                }
            }];
        }else{
            [SVProgressHUD showErrorWithStatus:error];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
