//
//  CourierCerIdCardView.h
//  iwant
//
//  Created by hehai on 16/11/8.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CourierCerIdCardDelegate <NSObject>

-(void) courierCerIdCardHasUpdate;

@end

@interface CourierCerIdCardView : UIViewController

@property (nonatomic, weak) id<CourierCerIdCardDelegate> delegate;

@property (nonatomic,copy)NSDictionary * dict;
@end
