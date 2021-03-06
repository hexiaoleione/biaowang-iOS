//
//  WLFaViewController.h
//  iwant
//
//  Created by 公司 on 2017/6/6.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "BaseViewController.h"
#import "WLModel.h"
#import "DwHelp.h"
@interface ColdFaViewController :BaseViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *faHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shouHeightConstrainr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *matNameHeighConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *coldTextFieldHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *publishTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cargoVolumeHeightConstraint;

@property (weak, nonatomic) IBOutlet UILabel *topNoticeL;


@property (weak, nonatomic) IBOutlet UILabel *matName;
@property (weak, nonatomic) IBOutlet UILabel *cargoVolumeL;

@property (weak, nonatomic) IBOutlet UITextField *sendNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *sendPhoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *receiveNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *receivePhoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *cargoVolumeTextField;

@property (weak, nonatomic) IBOutlet UITextField *coldTextField;

@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UITextField *timeTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeTextFieldHeightConstraint;


@property (nonatomic,strong) WLModel * wlModel;
@property (nonatomic,assign) BOOL publishAgain;

@property (nonatomic,copy)NSString * timeString;

@end
