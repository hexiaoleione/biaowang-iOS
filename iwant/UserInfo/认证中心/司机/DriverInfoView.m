//
//  DriverInfoView.m
//  iwant
//
//  Created by dongba on 16/9/12.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "DriverInfoView.h"

@implementation DriverInfoView

-(void)awakeFromNib{
    [super  awakeFromNib];
    _carType.layer.cornerRadius = 5;
    _carType.layer.borderColor = [[UIColor grayColor] CGColor];
    _carType.layer.borderWidth = 1.;
    _carNo.layer.cornerRadius = 5;
    _carNo.layer.borderColor = [[UIColor grayColor] CGColor];
    _carNo.layer.borderWidth = 1.;
    _driverNo.layer.cornerRadius = 5;
    _driverNo.layer.borderColor = [[UIColor grayColor] CGColor];
    _driverNo.layer.borderWidth = 1.;
    _quaCertificate.layer.cornerRadius = 5;
    _quaCertificate.layer.borderColor = [[UIColor grayColor] CGColor];
    _quaCertificate.layer.borderWidth = 1.;
    
}

@end
