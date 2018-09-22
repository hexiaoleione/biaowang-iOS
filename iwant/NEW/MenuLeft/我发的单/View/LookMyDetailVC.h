//
//  LookMyDetailVC.h
//  iwant
//
//  Created by 公司 on 2017/6/29.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "BaseViewController.h"

#import "Logist.h"

@interface LookMyDetailVC : BaseViewController

@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *limitTimeL;
@property (weak, nonatomic) IBOutlet UILabel *guiGeL;
@property (weak, nonatomic) IBOutlet UILabel *weightL;
@property (weak, nonatomic) IBOutlet UILabel *sizeL;
@property (weak, nonatomic) IBOutlet UILabel *takeCargoL;
@property (weak, nonatomic) IBOutlet UILabel *sendCargoL;
@property (weak, nonatomic) IBOutlet UILabel *sendNameL;
@property (weak, nonatomic) IBOutlet UILabel *sendPhoneL;
@property (weak, nonatomic) IBOutlet UILabel *start;
@property (weak, nonatomic) IBOutlet UILabel *startL;
@property (weak, nonatomic) IBOutlet UILabel *arriveNameL;
@property (weak, nonatomic) IBOutlet UILabel *arrivePhoneL;
@property (weak, nonatomic) IBOutlet UILabel *end;
@property (weak, nonatomic) IBOutlet UILabel *endL;
@property (weak, nonatomic) IBOutlet UILabel *yuanquL;

//冷链车的需求
@property (weak, nonatomic) IBOutlet UILabel *specialNeedL;

@property(nonatomic,copy) NSString * recId;

@end
