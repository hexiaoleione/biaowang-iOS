//
//  WLUserPay.m
//  iwant
//
//  Created by 公司 on 2017/1/6.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "WLUserPay.h"

@implementation WLUserPay
-(void)awakeFromNib{
    [super awakeFromNib];
    self.payView.layer.cornerRadius=8;
    self.payView.clipsToBounds = YES;
    
    self.paySureBtn.layer.cornerRadius = self.paySureBtn.height/2;
    self.paySureBtn.clipsToBounds = YES;
}


-(void)setLogistModel:(NSArray *)strArr{
    _realPayMoney.text = [NSString stringWithFormat:@"实付款：%@元",strArr[0]];
    _payMoney.text = [NSString stringWithFormat:@"交易费用：%@元",strArr[1]];
    _discountLabel.text =strArr[2];
    _couponSwitch.enabled = NO;
    if ([strArr[0] isEqualToString:@"1"]) {
        _YueEPayBtn.selected = YES;
    }else{
        _YueEPayBtn.selected = YES;
    }
    
}

- (IBAction)payAction:(UIButton *)sender {
    _block(sender.tag);
    for (UIButton * btn in _payBtn) {
        switch (btn.tag) {
            case 1:
                [self.WeChatBtn setBackgroundImage:[UIImage imageNamed:@"noClick_05"] forState:UIControlStateNormal];
                [self.AliPayBtn setBackgroundImage:[UIImage imageNamed:@"noClick_07"] forState:UIControlStateNormal];
                break;
            case 2:
                [self.YueEPayBtn setBackgroundImage:[UIImage imageNamed:@"noderClick"] forState:UIControlStateNormal];
                [self.AliPayBtn setBackgroundImage:[UIImage imageNamed:@"noClick_07"] forState:UIControlStateNormal];
                break;
              case 3:
                [self.WeChatBtn setBackgroundImage:[UIImage imageNamed:@"noClick_05"] forState:UIControlStateNormal];
                [self.YueEPayBtn setBackgroundImage:[UIImage imageNamed:@"noderClick"] forState:UIControlStateNormal];
                break;
            default:
                break;
        }
        btn.selected = NO;
    }
    sender.selected = YES;
}

- (IBAction)switchChange:(UISwitch *)sender {
    _block(sender.tag);

}

//确认支付
- (IBAction)paySure:(UIButton *)sender {
    _block(sender.tag);
}

-(void)show{
    UIWindow * keywindow = [[UIApplication sharedApplication] keyWindow];
    self.frame = keywindow.bounds;
    [keywindow addSubview:self];
}

-(void)dismiss{
    [self removeFromSuperview];
}
- (IBAction)guanbiBtn:(UIButton *)sender {
    [self removeFromSuperview];
}

@end
