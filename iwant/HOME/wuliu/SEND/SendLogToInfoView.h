//
//  SendLogToInfoView.h
//  iwant
//
//  Created by dongba on 16/8/24.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendLogToInfoView : UIView
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *phone;

@property (weak, nonatomic) IBOutlet UITextField *goodsValue; //货物价值

@property (weak, nonatomic) IBOutlet UITextField *other;//留言

@end
