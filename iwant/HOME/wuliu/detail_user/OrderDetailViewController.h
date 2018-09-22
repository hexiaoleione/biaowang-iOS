//
//  OrderDetailViewController.h
//  iwant
//
//  Created by dongba on 16/8/26.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "BaseViewController.h"
#import "Logist.h"
#import "Baojia.h"
@interface OrderDetailViewController : BaseViewController
/*物流公司Id*/
@property (copy, nonatomic)  NSString *comId;
/*报价金额*/
@property (strong, nonatomic)  NSString *money;
/*报价时间*/
@property (strong, nonatomic)  NSString *reportTime;

/*物流单数据模型*/
@property (strong, nonatomic)  Logist *model;   

@property (strong,nonatomic) Baojia * baojiaModel;
@end
