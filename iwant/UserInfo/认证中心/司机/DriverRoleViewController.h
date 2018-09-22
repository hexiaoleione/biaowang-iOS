//
//  DriverRoleViewController.h
//  iwant
//
//  Created by dongba on 16/9/6.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "BaseViewController.h"
#import "CourierCerIdCardView.h"
@interface DriverRoleViewController : BaseViewController

@property (nonatomic, strong) UIView *drivingLicenceView;
@property (nonatomic, strong) CourierCerIdCardView *courierCerIdCardViewController;

@property (nonatomic,strong) NSMutableDictionary * dictInfo;
@end

