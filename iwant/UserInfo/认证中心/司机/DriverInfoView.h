//
//  DriverInfoView.h
//  iwant
//
//  Created by dongba on 16/9/12.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DriverInfoView : UIView
@property (weak, nonatomic) IBOutlet UITextField *carType;
@property (weak, nonatomic) IBOutlet UITextField *carNo;
@property (weak, nonatomic) IBOutlet UITextField *driverNo;

@property (weak, nonatomic) IBOutlet UITextField *quaCertificate;

@end
