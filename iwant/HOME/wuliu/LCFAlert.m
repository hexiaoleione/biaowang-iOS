//
//  LCFAlert.m
//  DelEntry
//
//  Created by hehai on 16/11/29.
//  Copyright © 2016年 J. All rights reserved.
//

#import "LCFAlert.h"

@implementation LCFAlert

- (IBAction)sureAction:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LCFAlertNotification" object:nil];
    [self removeFromSuperview];
}
- (IBAction)cancelAction:(id)sender {
    [self removeFromSuperview];
}
@end
