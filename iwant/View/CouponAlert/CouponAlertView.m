//
//  CouponAlertView.m
//  iwant
//
//  Created by dongba on 16/10/13.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "CouponAlertView.h"
#import "MainHeader.h"
@interface CouponAlertView()
//遮盖
@property (nonatomic, strong) UIControl *overlayView;
//叉叉按钮
@property (strong, nonatomic)  UIButton *btn;
@end

@implementation CouponAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)couponAlertView{
    return [[[NSBundle mainBundle] loadNibNamed:@"CouponAlertView" owner:nil options:nil] lastObject];
}

//加载xib时自动调用
- (void)awakeFromNib{
    [super awakeFromNib];
    self.overlayView = [[UIControl alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.overlayView.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.5];
    [self.overlayView addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btn setBackgroundImage:[UIImage imageNamed:@"closeWhite"] forState:UIControlStateNormal];
    [_btn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
     NSLog(@" awakeFromNib =====> 执行了");
}

//-(void)onCancleBtn{
//    
//    [self dismiss];
//    
//}

- (void)show
{
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:self.overlayView];
    self.centerX = keywindow.centerX;
    self.centerY = keywindow.centerY;
    [keywindow addSubview:self];
    _btn.frame = CGRectMake(self.centerX, self.height + 20, 30, 30);
    _btn.centerX = keywindow.centerX;
    _btn.y = self.bottom + 40;
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
    
    self.alpha = 0;
    _btn.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        _btn.alpha = 1;
        self.alpha = 1;
        
    }];
    
}

//弹出层
- (void)fadeOut
{
    [UIView animateWithDuration:.35 animations:^{
        
        self.alpha = 0.0;
        _btn.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.overlayView removeFromSuperview];
             [_btn removeFromSuperview];
            [self removeFromSuperview];
        }
    }];
}


@end
