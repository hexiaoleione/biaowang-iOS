//
//  PublishWindTwo.m
//  iwant
//
//  Created by 公司 on 2017/3/25.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "PublishWindTwo.h"
#import "MainHeader.h"

@interface PublishWindTwo ()<UITextFieldDelegate>

@end
@implementation PublishWindTwo

-(void)awakeFromNib{
    [super awakeFromNib];
    
    if (SCREEN_WIDTH == 320) {
        self.topHeightConstraint.constant = 44;
    }
    
    self.backgroundColor = BACKGROUND_COLOR;
    self.sendView.layer.cornerRadius = 8;
    self.sendView.layer.masksToBounds = YES;
    
    self.receiveView.layer.cornerRadius = 8;
    self.receiveView.layer.masksToBounds = YES;
    
    self.goodsView.layer.cornerRadius = 8;
    self.goodsView.layer.masksToBounds = YES;
    
    self.goodsNameView.layer.cornerRadius = 8;
    self.goodsNameView.layer.masksToBounds = YES;
    
    self.remarkvIew.layer.cornerRadius = 8;
    self.remarkvIew.layer.masksToBounds = YES;
    
    self.noticeView.layer.cornerRadius = 8;
    self.noticeView.layer.masksToBounds = YES;
    
    _goodsValueTextField.delegate = self;
    self.goodsValueTextField.userInteractionEnabled = NO;
    self.replaceMoneyTextField.userInteractionEnabled = NO;
}


//发件人通讯录
- (IBAction)sendPersonClick:(UIButton *)sender {
    if (_BlockTwo) {
        _BlockTwo(1);
    }
}
//收件人通讯录
- (IBAction)receivePersonClick:(UIButton *)sender {
    if (_BlockTwo) {
        _BlockTwo(2);
    }
}

//上一步
- (IBAction)beforeBtnClick:(UIButton *)sender {
    if (_BlockTwo) {
        _BlockTwo(3);
    }
}
//下一步
- (IBAction)nextBtnClick:(UIButton *)sender {
    if (_BlockTwo) {
        _BlockTwo(4);
    }
}
//投保须知
- (IBAction)toubaoNeedKnow:(UIButton *)sender {
    if (_BlockTwo) {
        _BlockTwo(5);
    }
}
//投保
- (IBAction)ifTouBaoBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (_BlockTwo) {
        _BlockTwo(6);
    }
    self.goodsValueTextField.userInteractionEnabled = YES;
    if (sender.selected) {
        [sender setImage:[UIImage imageNamed:@"toubaoxuanzhongLmg"] forState:UIControlStateNormal];
        //后台请求接口顺风的投保费率问题
        NSString * strUrl = [NSString stringWithFormat:@"%@%@",BaseUrl,API_SF_TOUBAO_FEILU];
        [ExpressRequest sendWithParameters:nil MethodStr:strUrl reqType:k_GET success:^(id object) {
            NSString * message = [object objectForKey:@"message"];
            HHAlertView *alert = [[HHAlertView alloc]initWithTitle:@"温馨提示" detailText:message cancelButtonTitle:@"知道了" otherButtonTitles:nil];
            [alert show];
            _goodsValueTextField.userInteractionEnabled = YES;
            _toubaoImg.hidden = NO;
        } failed:^(NSString *error) {
            [SVProgressHUD showErrorWithStatus:error];
        }];
    }else{
        [sender setImage:[UIImage imageNamed:@"toubaokuangLmg"] forState:UIControlStateNormal];
        _goodsValueTextField.userInteractionEnabled = NO;
        _toubaoImg.hidden = YES;
        _goodsValueTextField.text = @"";
    }
}

- (IBAction)ifReplaceMoney:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (_BlockTwo) {
        _BlockTwo(7);
    }
    self.replaceMoneyTextField.userInteractionEnabled = YES;
    
    if (sender.selected) {
        HHAlertView *alert = [[HHAlertView alloc]initWithTitle:@"温馨提示" detailText:@"选择代收货款后，货款将由镖师代您收取，镖师收款完成后，货款将自动转入您的钱包。" cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert show];
        
        [sender setImage:[UIImage imageNamed:@"toubaoxuanzhongLmg"] forState:UIControlStateNormal];
        self.replaceMoneyTextField.userInteractionEnabled = YES;
        _replaceMoneyImg.hidden = NO;
    }else{
        [sender setImage:[UIImage imageNamed:@"toubaokuangLmg"] forState:UIControlStateNormal];
        self.replaceMoneyTextField.userInteractionEnabled = NO;
        _replaceMoneyImg.hidden = YES;
        self.replaceMoneyTextField.text = @"";
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

@end
