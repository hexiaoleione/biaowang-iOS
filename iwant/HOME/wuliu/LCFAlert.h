//
//  LCFAlert.h
//  DelEntry
//
//  Created by hehai on 16/11/29.
//  Copyright © 2016年 J. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface LCFAlert : UIView
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;
@property (weak, nonatomic) IBOutlet UILabel *needPayMoney;

//+(LCFAlert *) shareAlert;
//-(void) showAlert;
@end
