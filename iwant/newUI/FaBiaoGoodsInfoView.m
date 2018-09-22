//
//  FaBiaoGoodsInfoView.m
//  iwant
//
//  Created by 公司 on 2017/2/9.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "FaBiaoGoodsInfoView.h"
#import "MainHeader.h"
#import "ActionSheetStringPicker.h"
@interface FaBiaoGoodsInfoView ()<UITextFieldDelegate>
@end

@implementation FaBiaoGoodsInfoView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = BACKGROUND_COLOR;
    
    _goodsValueTextfield.delegate = self;
    
    self.goosInfoView.layer.cornerRadius = 5;
    self.goosInfoView.layer.borderColor = [UIColorFromRGB(0xf5f5f5) CGColor];
    self.goosInfoView.layer.borderWidth = 1;
    self.goosInfoView.layer.masksToBounds = YES;
    self.goodsValueTextfield.userInteractionEnabled = NO;
    self.replaceMoneyTextField.userInteractionEnabled = NO;
    self.carTypeViewHeightConstraint.constant = 0;
    self.goodsInfoViewHeightConstraint.constant -= 35;
    self.topBtn.userInteractionEnabled = NO;

    
}


- (IBAction)topBtnClick:(UIButton *)sender {
    if (_block) {
        _block(0);
    }
}
- (IBAction)timeSelectBtn:(UIButton *)sender {
    if (_block) {
        _block(1);
    }
}

//是否需要特殊车型
- (IBAction)ifNeedHuoChe:(UISwitch *)sender {
    if (sender.on) {
        self.carTypeViewHeightConstraint.constant = 30;
        self.goodsInfoViewHeightConstraint.constant += 30;
        self.smallTruckBtn.hidden = NO;
        self.middleTruckBtn.hidden = NO;
        self.smallMinibusBtn.hidden = NO;
        self.middleMinibusBtn.hidden = NO;
        
    }else{
        self.carTypeViewHeightConstraint.constant = 0;
        self.goodsInfoViewHeightConstraint.constant -= 30;
        self.smallTruckBtn.hidden = YES;
        self.middleTruckBtn.hidden = YES;
        self.smallMinibusBtn.hidden = YES;
        self.middleMinibusBtn.hidden = YES;

    }
    if (_block) {
        _block(2);
    }
}
- (IBAction)ifTouBaobtn:(UIButton *)sender {
    if (_block) {
        _block(3);
    }
    self.goodsValueTextfield.userInteractionEnabled = YES;
    sender.selected = !sender.selected;
    if (sender.selected) {
        [sender setImage:[UIImage imageNamed:@"toubaoxuanzhongLmg"] forState:UIControlStateNormal];
        //后台请求接口顺风的投保费率问题
        NSString * strUrl = [NSString stringWithFormat:@"%@%@",BaseUrl,API_SF_TOUBAO_FEILU];
        [ExpressRequest sendWithParameters:nil MethodStr:strUrl reqType:k_GET success:^(id object) {
            NSString * message = [object objectForKey:@"message"];
            HHAlertView *alert = [[HHAlertView alloc]initWithTitle:@"温馨提示" detailText:message cancelButtonTitle:@"知道了" otherButtonTitles:nil];
            [alert show];
            _goodsValueTextfield.userInteractionEnabled = YES;
            _toubaoStar.hidden = NO;
        } failed:^(NSString *error) {
            [SVProgressHUD showErrorWithStatus:error];
        }];
    }else{
        [sender setImage:[UIImage imageNamed:@"toubaokuangLmg"] forState:UIControlStateNormal];
        _goodsValueTextfield.userInteractionEnabled = NO;
        _toubaoStar.hidden = YES;
        _goodsValueTextfield.text = @"";
    }
}

- (IBAction)beforeViewBtn:(UIButton *)sender {
    NSLog(@"物品信息上一步");
    if (_block) {
        _block(4);
    }
}
- (IBAction)sureBtn:(id)sender {
    
    NSLog(@"确认");
    if (_block) {
        _block(5);
    }
}
- (IBAction)touBaoShuoming:(UIButton *)sender {
    if (_block) {
        _block(6);
    }
}

- (IBAction)ifReplaceMoneyClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (_block) {
        _block(7);
    }
    self.replaceMoneyTextField.userInteractionEnabled = YES;
   
    if (sender.selected) {
        HHAlertView *alert = [[HHAlertView alloc]initWithTitle:@"温馨提示" detailText:@"选择代收货款后，货款将由镖师代您收取，镖师收款完成后，货款将自动转入您的钱包。" cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert show];
        
        [sender setImage:[UIImage imageNamed:@"toubaoxuanzhongLmg"] forState:UIControlStateNormal];
        self.replaceMoneyTextField.userInteractionEnabled = YES;
        _daishoukuanStar.hidden = NO;
    }else{
     [sender setImage:[UIImage imageNamed:@"toubaokuangLmg"] forState:UIControlStateNormal];
        self.replaceMoneyTextField.userInteractionEnabled = NO;
        _daishoukuanStar.hidden = YES;
        self.replaceMoneyTextField.text = @"";
    }
}

//车型选择
- (IBAction)carTypeBtnClick:(UIButton *)sender {
    [self.currentBtn setImage:[UIImage imageNamed:@"carTypeBtnNone"] forState:UIControlStateNormal];
    self.currentBtn = sender;
    [self.currentBtn setImage:[UIImage imageNamed:@"carTypeBtn"] forState:UIControlStateNormal];
    if(_block){
        _block((int)sender.tag);
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@""]) {
        return YES;
    }
    NSString *num =  [textField.text stringByAppendingString:string];
    switch (textField.tag) {
        case 20:
            if ([num floatValue] > 5000) {
                [PXAlertView showAlertWithTitle:@"温馨提示" message:@"物品投保额度最高为5000元" cancelTitle:@"确定" otherTitle:nil completion:^(BOOL cancelled, NSInteger buttonIndex) {
                    if (cancelled) {
                        textField.text = @"";
//                       [textField.text stringByAppendingString:string];
                    }
                }];
                
                return NO;
            }
            break;
            default:
            break;
    }
    return YES;
}
//重量选择
- (IBAction)WeightPickView:(UIButton *)sender {
    
    _arr =[[NSMutableArray alloc]init];
    NSString * str = @"5kg以下";
    [_arr addObject:str];
    for (int i = 0; i<45; i++) {
        NSString  * str =[NSString stringWithFormat:@"%d kg",i+6];
        [_arr addObject:str];
    }
    
    [ActionSheetStringPicker showPickerWithTitle:@"物品重量" rows:_arr initialSelection:0 target:self successAction:@selector(timeWasSelected:element:sender:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
}

-(void)timeWasSelected:(NSNumber *)selectedIndex element:(id)element sender: (UIButton*) btn {
    
//    self.selected = [_arr objectAtIndex:[selectedIndex intValue]];
//    [btn setTitle:[NSString stringWithFormat:@" %@",[_arr objectAtIndex:[selectedIndex intValue]] ] forState:UIControlStateNormal];
    if (_block) {
        _block(8);
    }

//    self.weightTextField = [_arr objectAtIndex:[selectedIndex intValue]];
    NSString * weight = [NSString stringWithFormat:@"%d",[selectedIndex intValue]+5];
    if (_weightBlock) {
        _weightBlock([_arr objectAtIndex:[selectedIndex intValue]],weight);
    }
    self.kgDanwei.hidden = YES;
}

- (void)actionPickerCancelled:(id)sender {
    
}




@end
