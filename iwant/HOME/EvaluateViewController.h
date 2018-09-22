//
//  EvaluateViewController.h
//  iwant
//
//  Created by dongba on 16/5/4.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum eva_type{
   Driver=0,//顺风司机
    Company,//物流公司
    Personal//物流个人
}EVA_TYPE;
@class Evaluation;
@interface EvaluateViewController : UIViewController

@property (strong, nonatomic)  Evaluation  * model;

@property (copy, nonatomic)  NSString *recId;

@property (copy, nonatomic)  NSString *userId;

@property(nonatomic,assign)EVA_TYPE info_type;
@end
