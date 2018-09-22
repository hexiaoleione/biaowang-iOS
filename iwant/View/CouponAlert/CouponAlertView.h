//
//  CouponAlertView.h
//  iwant
//
//  Created by dongba on 16/10/13.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouponAlertView : UIView
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *couponname;
@property (weak, nonatomic) IBOutlet UILabel *timeLbel;
@property (weak, nonatomic) IBOutlet UIImageView *typeImg;


- (void)show;
- (void)dismiss;
//快速创建类
+ (instancetype)couponAlertView;
@end
