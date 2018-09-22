//
//  matView.m
//  iwant
//
//  Created by dongba on 16/7/21.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "matView.h"
#import "MainHeader.h"
@interface matView ()<UITextFieldDelegate>
@end
@implementation matView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.layer.cornerRadius = 5;
    self.layer.borderColor = [UIColorFromRGB(0xf5f5f5) CGColor];
    self.layer.borderWidth = 1;
    self.layer.masksToBounds = YES;
    
    _matLength.delegate = self;
    _matWidth.delegate = self;
    _matHeight.delegate = self;
    
    self.matLengthHeightConstraint.constant = 0.0;
    self.topToConstraint.constant = 0.0;
    self.line4.hidden = YES;
    
    self.height -= 30;
    
}
//是否需要大型车运输
- (IBAction)ifNeedSpecial:(UIButton *)sender {
    _block(3);
    sender.selected = !sender.selected;
    if (sender.selected) {
        [sender setBackgroundImage:[UIImage imageNamed:@"duihao"] forState:UIControlStateNormal];
        self.needSpecialLabel.text = [NSString stringWithFormat:@"是否需要大型货车运输(请填写货物尺寸)"];
//        self.noticeLabel.hidden = NO;
        self.matLength.hidden = NO;
        self.matLengthDanWei.hidden = NO;
        self.matLengthImage.hidden = NO;
        
        self.matWidthDanWei.hidden = NO;
        self.matWidthimage.hidden = NO;
        self.matWidth.hidden = NO;
        
        self.matHeightImage.hidden = NO;
        self.matHeight.hidden = NO;
        self.matHeightDanwei.hidden = NO;
        
        self.matLengthHeightConstraint.constant = 30.0;
        self.topToConstraint.constant = 5.0;
        self.line4.hidden = NO;

        self.height += 30;
        
    }else{
        [sender setBackgroundImage:[UIImage imageNamed:@"fangkuang"] forState:UIControlStateNormal];
        self.needSpecialLabel.text = [NSString stringWithFormat:@"是否需要大型货车运输"];

//        self.noticeLabel.hidden = YES;
        self.matLength.hidden = YES;
        self.matLengthDanWei.hidden = YES;
        self.matLengthImage.hidden = YES;
        
        self.matWidthDanWei.hidden = YES;
        self.matWidthimage.hidden = YES;
        self.matWidth.hidden = YES;
        
        self.matHeightImage.hidden = YES;
        self.matHeight.hidden = YES;
        self.matHeightDanwei.hidden = YES;
        
        _matWidth.text =@"";
        _matHeight.text = @"";
        _matLength.text = @"";
        
        self.topToConstraint.constant = 0.0;
        self.matLengthHeightConstraint.constant = 0.0;
        self.line4.hidden = YES;
        self.height -= 30;
    }
}





- (IBAction)ifTouBao:(UIButton *)sender {
    _block(1);
    sender.selected = !sender.selected;
    if (sender.selected) {
        [sender setBackgroundImage:[UIImage imageNamed:@"duihao"] forState:UIControlStateNormal];
        //后台请求接口顺风的投保费率问题
       NSString * strUrl = [NSString stringWithFormat:@"%@%@",BaseUrl,API_SF_TOUBAO_FEILU];
       [ExpressRequest sendWithParameters:nil MethodStr:strUrl reqType:k_GET success:^(id object) {
           NSString * message = [object objectForKey:@"message"];
           HHAlertView *alert = [[HHAlertView alloc]initWithTitle:@"温馨提示" detailText:message cancelButtonTitle:@"知道了" otherButtonTitles:nil];
           [alert show];
           _baojiaField.hidden = NO;
           _bottomView.hidden = NO;
       } failed:^(NSString *error) {
           [SVProgressHUD showErrorWithStatus:error];
       }];
  }else{
        [sender setBackgroundImage:[UIImage imageNamed:@"fangkuang"] forState:UIControlStateNormal];
        _baojiaField.hidden = YES;;
        _bottomView.hidden = YES;;
    }
}



- (IBAction)pickTime:(id)sender {
    if (_block) {
        _block(0);
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@""]) {
        return YES;
    }
    NSString *num =  [textField.text stringByAppendingString:string];
    switch (textField.tag) {
        case 20:
            if ([num floatValue] > 130) {
                [PXAlertView showAlertWithTitle:@"温馨提示" message:@"物品长度已经超过私家车限定，需要货车运送，是否继续" cancelTitle:@"取消" otherTitle:@"继续" completion:^(BOOL cancelled, NSInteger buttonIndex) {
                    if (!cancelled) {
                        textField.text = [textField.text stringByAppendingString:string];
                    }
                }];
                
                return NO;
            }
            break;
        case 21:
            if ([num floatValue] > 50) {
                [PXAlertView showAlertWithTitle:@"温馨提示" message:@"物品宽度已经超过私家车限定，需要货车运送，是否继续" cancelTitle:@"取消" otherTitle:@"继续" completion:^(BOOL cancelled, NSInteger buttonIndex) {
                    if (!cancelled) {
                        textField.text = [textField.text stringByAppendingString:string];
                    }
                }];
                return NO;
            }
            break;
        case 22:
            if ([num floatValue] > 60) {
                [PXAlertView showAlertWithTitle:@"温馨提示" message:@"物品高度已经超过私家车限定，需要货车运送，是否继续" cancelTitle:@"取消" otherTitle:@"继续" completion:^(BOOL cancelled, NSInteger buttonIndex) {
                    if (!cancelled) {
                        textField.text = [textField.text stringByAppendingString:string];
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



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
