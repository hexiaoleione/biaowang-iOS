//
//  MapViewController.h
//  iwant
//
//  Created by 公司 on 2017/6/1.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainHeader.h"
#import "ShunFeng.h"
#import "WLModel.h"
@interface MapViewController : UIViewController
@property(nonatomic,strong) UILabel * startLabel;
@property(nonatomic,strong)ShunFeng * model;
@property(nonatomic,strong) WLModel* wlModel;

@property(nonatomic,strong) NSString * cityName; //城市名

@end
