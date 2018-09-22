//
//  PayView.m
//  iwant
//
//  Created by dongba on 16/10/14.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "PayView.h"
#import "MainHeader.h"
#import "Wallet.h"
@interface PayView(){
    double _needPayMoney;
    NSString * _distance;
}
@property (weak, nonatomic) IBOutlet UIButton *YuEBtn;
@property (weak, nonatomic) IBOutlet UIButton *WeChatBtn;
@property (weak, nonatomic) IBOutlet UIButton *AlipayBtn; 

@end
@implementation PayView

- (void)setLogistModel:(NSArray *)strArr{
    _payType.text = strArr[0];
    _payMoney.text = strArr[1];
    _insuerMoney.text = strArr[2];
    _resultMoney.text = [NSString stringWithFormat:@"共计： %@ 元",strArr[3]];
    _noCopon.hidden = NO;
    _couponSwitch.enabled = NO;
    _insureLable.text = @"优惠减免";
    if ([strArr[1] isEqualToString:@"1"]) {
        _yueBtn.selected = YES;
    }else{
        _yueBtn.selected = YES;
    }
}


- (void)setWLLogistModel:(NSArray *)strArr{
    _payType.text = strArr[0];
    _payMoney.text = strArr[1];
    _insuerMoney.text = strArr[2];
    _resultMoney.text = [NSString stringWithFormat:@"共计： %@ 元",strArr[3]];
    _noCopon.hidden = NO;
    _couponSwitch.enabled = NO;
    _insureLable.text = @"保险费用";
    if ([strArr[1] isEqualToString:@"1"]) {
        _yueBtn.selected = YES;
    }else{
        _yueBtn.selected = YES;
    }
}




//顺风模块 数据模型填充
- (void)setModel:(NSArray *)strArr{
    _payType.text = strArr[0];
    _payMoney.text = strArr[1];
    _insuerMoney.text = strArr[2];
    _resultMoney.text = [NSString stringWithFormat:@"共计：%@元 (%@km)",strArr[3],strArr[4]];
    _needPayMoney = [strArr[3] doubleValue];
    _distance = strArr[4];
}
//顺风模块，选择现金券后刷新数据
- (void)reloadDataWithCoupon:(NSMutableArray *)couponArray{
    float couponMoney;
    Wallet *model = couponArray.lastObject;
    couponMoney = [model.money floatValue];
    _needPayMoney = _needPayMoney - couponMoney;
//    NSLog(@"@@@@@@@@@@@@@@@%f",couponMoney);
//    NSLog(@"@@@@@@@@@@@@@@@@@@@@%f",_needPayMoney);
    _resultMoney.text = [NSString stringWithFormat:@"共计：%0.2f元(%@km)",_needPayMoney,_distance];
    //此处需要用block传值 以便记载三方支付的时候知道需要支付的钱
    if (_needPayBlock) {
        _needPayBlock(_needPayMoney);
    }
    if (_needPayMoney <= 0) {
        _resultMoney.text = [NSString stringWithFormat:@"共计：0 元(%@km)",_distance];
        //传值过去需要支付的钱是0
        _block(666);
    }
}

- (IBAction)payAction:(UIButton *)sender {
     _block(sender.tag);
    for (UIButton *btn in _payBtns) {
        switch (btn.tag) {
            case 1:
                [self.WeChatBtn setBackgroundImage:[UIImage imageNamed:@"noClick_05"] forState:UIControlStateNormal];
                [self.alipayBtn setBackgroundImage:[UIImage imageNamed:@"noClick_07"] forState:UIControlStateNormal];
                break;
            case 2:
                [self.YuEBtn setBackgroundImage:[UIImage imageNamed:@"noderClick"] forState:UIControlStateNormal];
                [self.alipayBtn setBackgroundImage:[UIImage imageNamed:@"noClick_07"] forState:UIControlStateNormal];
                break;
            case 3:
                [self.WeChatBtn setBackgroundImage:[UIImage imageNamed:@"noClick_05"] forState:UIControlStateNormal];
                [self.YuEBtn setBackgroundImage:[UIImage imageNamed:@"noderClick"] forState:UIControlStateNormal];
                break;
            default:
                break;
        }
        btn.selected = NO;
    }
    sender.selected = YES;
}
- (IBAction)surePay:(UIButton *)sender {
    _block(sender.tag);
}

- (IBAction)switchChange:(UISwitch *)sender {
    _block(sender.tag);
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.overlayView = [[UIControl alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.overlayView.backgroundColor = [UIColor colorWithRed:.0 green:.0 blue:.0 alpha:0.75];
    [self.overlayView addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btn setBackgroundImage:[UIImage imageNamed:@"closeWhite"] forState:UIControlStateNormal];
    [_btn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    _btn.hidden = YES;
    self.y = WINDOW_HEIGHT;
    _bgImgHeight.constant = (WINDOW_WIDTH == 320) ? 300 : 350;
    if (WINDOW_WIDTH == 320) {
        self.height = 450;
        _btn.hidden = NO;
    }
    [self layoutIfNeeded];
}

- (void)show
{
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:self.overlayView];
    [keywindow addSubview:self];
    _btn.frame = CGRectMake(WINDOW_WIDTH - 50, WINDOW_HEIGHT - 480, 30, 30);
    [keywindow addSubview:_btn];
    [self fadeIn];
}

- (void)dismiss
{
    [self fadeOut];
}

//弹入层
- (void)fadeIn
{
    [UIView animateWithDuration:.35 animations:^{
        _btn.alpha = 1;
        self.bottom = WINDOW_HEIGHT-55*RATIO_HEIGHT;
    }];
}

//弹出层
- (void)fadeOut
{
    [UIView animateWithDuration:.35 animations:^{
        
        _btn.alpha = 0.0;
        self.y = WINDOW_HEIGHT;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.overlayView removeFromSuperview];
            [_btn removeFromSuperview];
            [self removeFromSuperview];
        }
    }];
}
@end
