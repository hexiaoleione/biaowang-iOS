//
//  LCFPayView.m
//  iwant
//
//  Created by 公司 on 2016/12/1.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "LCFPayView.h"

@implementation LCFPayView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.payView.layer.cornerRadius = 8;
    self.payView.layer.masksToBounds = YES;
    if (SCREEN_WIDTH==320) {
        self.leftConstraint.constant = 16;
        self.rightContraint.constant = 16;
    }
}

//+(LCFPayView *) shareAlert{
//    __strong static LCFPayView *_shareObj = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        _shareObj = [[NSBundle mainBundle] loadNibNamed:@"LCFPayView" owner:nil options:nil].firstObject;;
//        _shareObj.frame = [UIApplication sharedApplication].windows.lastObject.bounds;
//    });
//    return _shareObj;
//}
//-(void)showAlert{
//    UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
//    [window addSubview:[LCFPayView shareAlert]];
//}
- (IBAction)thirdPayBtn:(UIButton *)sender {
    self.weChatBtn.hidden = NO;
    self.zhiFuBaoBtn.hidden = NO;
    self.guanbiBtn.hidden = NO;
    
    
}
- (IBAction)goToCharge:(UIButton *)sender {
    if (_block) {
        _block(sender);
    }
}

- (IBAction)gunbiBtn:(id)sender {
    
    self.weChatBtn.hidden = YES;
    self.zhiFuBaoBtn.hidden = YES;
    self.guanbiBtn.hidden = YES;
}

- (IBAction)turnOffAll:(UIButton *)sender {
    [self removeFromSuperview];
}

@end
