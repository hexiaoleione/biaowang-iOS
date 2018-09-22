//
//  JieOrderDetailVC.h
//  iwant
//
//  Created by 公司 on 2017/6/9.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "BaseViewController.h"
#import "ShunFengBiaoShi.h"
@interface JieOrderDetailVC : BaseViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topCallConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sureBtnTopConstraint;

@property (weak, nonatomic) IBOutlet UILabel *start;
@property (weak, nonatomic) IBOutlet UILabel *end;

@property (weak, nonatomic) IBOutlet UILabel *mateNameL;
@property (weak, nonatomic) IBOutlet UILabel *limitTimeL;
@property (weak, nonatomic) IBOutlet UILabel *replaceMoneyL;
@property (weak, nonatomic) IBOutlet UILabel *guigeL;
@property (weak, nonatomic) IBOutlet UILabel *weightL;
@property (weak, nonatomic) IBOutlet UILabel *transforMoneyL;
@property (weak, nonatomic) IBOutlet UILabel *distanceL;
@property (weak, nonatomic) IBOutlet UILabel *remarkL;
@property (weak, nonatomic) IBOutlet UILabel *jianshuL;

@property (weak, nonatomic) IBOutlet UILabel *startL;
@property (weak, nonatomic) IBOutlet UILabel *endPlaceL;

//车牌照号码
@property (weak, nonatomic) IBOutlet UILabel *carNumL;
@property (weak, nonatomic) IBOutlet UITextField *carNumTextField;
@property (weak, nonatomic) IBOutlet UIButton *carNumdownBtn;

//状态按钮
@property (weak, nonatomic) IBOutlet UIButton *jiuweiBtn;
@property (weak, nonatomic) IBOutlet UIButton *weiguiBtn;
@property (weak, nonatomic) IBOutlet UIButton *shoukuanBtn;
@property (weak, nonatomic) IBOutlet UIButton *quhuoBtn;
@property (weak, nonatomic) IBOutlet UIButton *songdaBtn; //有密码
@property (weak, nonatomic) IBOutlet UIButton *noPassWordBtn;



@property (nonatomic,strong)ShunFengBiaoShi * model;


@end
