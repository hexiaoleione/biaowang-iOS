//
//  ShaiXuanView.h
//  iwant
//
//  Created by 公司 on 2017/3/24.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScreenView : UIView

@property (weak, nonatomic) IBOutlet UIView *shaixuanView;
@property (weak, nonatomic) IBOutlet UITextField *MoneyTextFieldMin;
@property (weak, nonatomic) IBOutlet UITextField *MoneyTextFieldMax;
@property (weak, nonatomic) IBOutlet UITextField *distanceTextfieldMin;
@property (weak, nonatomic) IBOutlet UITextField *distanceTextfieldMax;
@property (weak, nonatomic) IBOutlet UITextField *weightTextFieldMin;
@property (weak, nonatomic) IBOutlet UITextField *weightTextFieldMax;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@property (nonatomic, copy) void (^shaixuanBlock)();
-(void)showShaiXuanView;

@end
