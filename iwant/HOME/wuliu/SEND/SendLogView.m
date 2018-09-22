//
//  SendLogView.m
//  iwant
//
//  Created by dongba on 16/8/24.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "SendLogView.h"

@implementation SendLogView

-(void)awakeFromNib{
    [super awakeFromNib];
    
}
//起始地
- (IBAction)selectAddess:(id)sender {
    _block(5);
}
//目的地
- (IBAction)selectAddress:(id)sender {
    _block(6);
}


- (IBAction)needPickSwitch:(UISwitch *)sender {
    
//    CGFloat height = sender.on ? 50.0 : 0;
//    [self layoutIfNeeded];
//    [UIView animateWithDuration:0.5
//                     animations:^{
//                         _fromAdressHeight.constant = height;
//                         [self layoutIfNeeded];
//                     }];
    _block(0);
    
    

}

- (IBAction)needAchive:(UISwitch *)sender {
    
//    CGFloat height = sender.on ? 50.0 : 0;
    
//    [self layoutIfNeeded];
//    [UIView animateWithDuration:0.5
//                     animations:^{
//                         _toAddressHeight.constant = height;
//                         [self layoutIfNeeded];
//                     }];
    _block(1);
}

- (IBAction)choseDanWei:(UIButton *)sender {
    _block(2);
}

- (IBAction)changeStartTime{
    _block(3);
}
- (IBAction)changeEndTime{
    _block(4);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
