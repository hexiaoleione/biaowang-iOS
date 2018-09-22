//
//  InsureDetailVC.h
//  iwant
//
//  Created by 公司 on 2017/8/19.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "BaseViewController.h"

@interface InsureDetailVC :BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *tiJiL;
@property (weak, nonatomic) IBOutlet UILabel *weightL;
@property (weak, nonatomic) IBOutlet UILabel *sizeL;
@property (weak, nonatomic) IBOutlet UILabel *sendNameL;
@property (weak, nonatomic) IBOutlet UILabel *sendPhoneL;
@property (weak, nonatomic) IBOutlet UILabel *startL;
@property (weak, nonatomic) IBOutlet UILabel *arriveNameL;
@property (weak, nonatomic) IBOutlet UILabel *arrivePhoneL;
@property (weak, nonatomic) IBOutlet UILabel *endL;


@property (weak, nonatomic) IBOutlet UILabel *cargoValueL;
@property (weak, nonatomic) IBOutlet UILabel *categoryL;
@property (weak, nonatomic) IBOutlet UILabel *typeL;

@property (weak, nonatomic) IBOutlet UILabel *carNumberL;
@property (weak, nonatomic) IBOutlet UILabel *baoFreeL;
@property (weak, nonatomic) IBOutlet UIButton *downLoadBtn;

//保单号
@property (weak, nonatomic) IBOutlet UILabel *baodanNumL;

@property(nonatomic,copy) NSString * recId;

@end
