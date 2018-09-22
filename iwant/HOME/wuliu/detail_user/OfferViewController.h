//
//  OfferViewController.h
//  iwant
//
//  Created by dongba on 16/8/26.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "BaseViewController.h"
#import "Logist.h"
@interface OfferViewController : BaseViewController


@property (copy, nonatomic)  NSString *wlbID;
/*物流单数据模型*/
@property (strong, nonatomic)  Logist *model;

@end
