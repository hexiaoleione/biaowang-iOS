//
//  PublishWindThree.h
//  iwant
//
//  Created by 公司 on 2017/3/27.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMHeaderView.h"
@interface PublishWindThree : UIView
@property (weak, nonatomic) IBOutlet UIView *goodsInfoView;
@property (weak, nonatomic) IBOutlet UIButton *SmallMinibusBtn;
@property (weak, nonatomic) IBOutlet UIButton *MiddleMinibusBtn;
@property (weak, nonatomic) IBOutlet UIButton *SmallTruckBtn;
@property (weak, nonatomic) IBOutlet UIButton *MiddleTruckBtn;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *smallMinBusLabel;

@property (weak, nonatomic) IBOutlet UILabel *MiddleMinibusLabel;
@property (weak, nonatomic) IBOutlet UILabel *SmallTruckLabel;
@property (weak, nonatomic) IBOutlet UILabel *MiddleTruckLabel;

@property (nonatomic, copy) void (^BlockThree)(int tag);

@end
