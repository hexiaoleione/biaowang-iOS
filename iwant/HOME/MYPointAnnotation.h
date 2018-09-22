//
//  MYPointAnnotation.h
//  iwant
//
//  Created by dongba on 16/3/26.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "Courier.h"
#import "PopView.h"
@interface MYPointAnnotation : BMKPointAnnotation
@property(nonatomic,assign)NSInteger bid;
@property(nonatomic,copy)NSString *expNameCode;
@property(nonatomic,strong)Courier *courier;
@end
