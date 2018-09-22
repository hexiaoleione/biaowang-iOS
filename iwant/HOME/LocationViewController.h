//
//  LocationViewController.h
//  iwant
//
//  Created by 公司 on 2017/3/14.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^PPassValue)(NSString *address,NSString *name,NSString *lat,NSString *lon,NSString *cityCode,NSString *cityName,NSString * townCode,NSString *townName);

@interface LocationViewController : UIViewController

@property (nonatomic,copy)PPassValue passBlock ;
@end
