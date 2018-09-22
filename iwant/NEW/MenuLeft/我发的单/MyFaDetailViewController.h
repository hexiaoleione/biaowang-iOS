//
//  MyFaDetailViewController.h
//  iwant
//
//  Created by 公司 on 2017/6/14.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "BaseViewController.h"
#import "ShunFeng.h"
@interface MyFaDetailViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *matName;
@property (weak, nonatomic) IBOutlet UILabel *limitTimeL;
@property (weak, nonatomic) IBOutlet UILabel *replaceMoneyL;
@property (weak, nonatomic) IBOutlet UILabel *guiGeL;
@property (weak, nonatomic) IBOutlet UILabel *weightL;
@property (weak, nonatomic) IBOutlet UILabel *jianshuL;

@property (weak, nonatomic) IBOutlet UILabel *remark;
@property (weak, nonatomic) IBOutlet UILabel *remarkL;

@property (weak, nonatomic) IBOutlet UILabel *transforMoneyL;
@property (weak, nonatomic) IBOutlet UILabel *baofeiL;
@property (weak, nonatomic) IBOutlet UILabel *sendNameL;
@property (weak, nonatomic) IBOutlet UILabel *sendPhoneL;
@property (weak, nonatomic) IBOutlet UILabel *fahuo;
@property (weak, nonatomic) IBOutlet UILabel *startPlaceL;
@property (weak, nonatomic) IBOutlet UILabel *receiveNameL;
@property (weak, nonatomic) IBOutlet UILabel *receivePhoneL;
@property (weak, nonatomic) IBOutlet UILabel *shouhuo;
@property (weak, nonatomic) IBOutlet UILabel *endNamePlaceL;

//镖师投诉货物违规了
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topNoticeConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnTopConstraint;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreeNoBtn;
@property (weak, nonatomic) IBOutlet UILabel *agreeL;
@property (weak, nonatomic) IBOutlet UILabel *agreeNoL;

@property (weak, nonatomic) IBOutlet UILabel *weiguiNoticeL;



@property(nonatomic,strong)ShunFeng * model;
@end
