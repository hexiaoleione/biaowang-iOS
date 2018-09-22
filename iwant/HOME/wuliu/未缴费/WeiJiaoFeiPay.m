//
//  WeiJiaoFeiPay.m
//  iwant
//
//  Created by 公司 on 2017/2/28.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "WeiJiaoFeiPay.h"
#import "MainHeader.h"
@implementation WeiJiaoFeiPay

-(void)awakeFromNib{
    [super awakeFromNib];
    self.surePay.backgroundColor = COLOR_MainColor;
    self.surePay.layer.cornerRadius = 4;
    self.surePay.layer.masksToBounds = YES;
    
    self.view.layer.cornerRadius = 8;
    self.view.layer.masksToBounds = YES;
}

-(void)show{
    UIWindow * keywindow = [[UIApplication sharedApplication] keyWindow];
    self.frame = keywindow.bounds;
    [keywindow addSubview:self];
}

-(void)dismiss{
    [self removeFromSuperview];
}
- (IBAction)btnClick:(UIButton *)sender {
    if(_block){
        _block(sender.tag);
    }
    switch (sender.tag) {
        case 0:{
            [self.yuEbtn setImage:[UIImage imageNamed:@"click_03"] forState:UIControlStateNormal];
            [self.weChatBtn setImage:[UIImage imageNamed:@"normal-1_05"] forState:UIControlStateNormal];
            [self.AliPay setImage:[UIImage imageNamed:@"normal-1_07"] forState:UIControlStateNormal];
        }
            break;
        case 1:{
            [self.yuEbtn setImage:[UIImage imageNamed:@"normal-1_03"] forState:UIControlStateNormal];
            [self.weChatBtn setImage:[UIImage imageNamed:@"click_05"] forState:UIControlStateNormal];
            [self.AliPay setImage:[UIImage imageNamed:@"normal-1_07"] forState:UIControlStateNormal];
        }
            break;
        case 2:{
            [self.yuEbtn setImage:[UIImage imageNamed:@"normal-1_03"] forState:UIControlStateNormal];
            [self.weChatBtn setImage:[UIImage imageNamed:@"normal-1_05"] forState:UIControlStateNormal];
            [self.AliPay setImage:[UIImage imageNamed:@"click_07"] forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}

- (IBAction)guanbiBtn:(UIButton *)sender {
    [self removeFromSuperview];
}


@end
