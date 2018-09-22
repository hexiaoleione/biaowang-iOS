//
//  UserPayView.m
//  iwant
//
//  Created by 公司 on 2016/12/23.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "UserPayView.h"

@implementation UserPayView
-(void)awakeFromNib{
    [super awakeFromNib];
    self.PayView.layer.cornerRadius = 6;
    self.PayView.clipsToBounds = YES;
    
}

- (IBAction)guanbiBtn:(UIButton *)sender {
    [self removeFromSuperview];
}

@end
