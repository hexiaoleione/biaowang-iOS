//
//  jiaoFeiDetailViewController.h
//  iwant
//
//  Created by 公司 on 2017/6/20.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "BaseViewController.h"
#import "Logist.h"
#import "Baojia.h"
@interface jiaoFeiDetailViewController : BaseViewController

@property(nonatomic,copy)NSString * recId;

@property(nonatomic,strong)Logist * model;
@property(nonatomic,strong)Baojia * baojiaModel;

@property (nonatomic,assign)BOOL ifJustLook;

@end
