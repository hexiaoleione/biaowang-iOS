//
//  FaViewConstroller.h
//  iwant
//
//  Created by 公司 on 2017/6/2.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "BaseViewController.h"
#import "AutoScrollLabel.h"
#import "WLModel.h"
#import "DwHelp.h"
@interface FaViewConstroller :BaseViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *endPlaceLabelHeightConstrainr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *weightBtnHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jianshuBtnHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeTextFieldHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *carTypeTextFieldHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailTextFieldHeightConstraint;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *submitTopConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *distanceTopConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tuijianTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *onlyTuijianXSTopConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *weatherNoticeTopConstraint; //天气距上

@property (weak, nonatomic) IBOutlet UILabel *weightL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *carTypeL;
@property (weak, nonatomic) IBOutlet UILabel *jianshuL;

@property (weak, nonatomic) IBOutlet UIButton *weightBtn;
@property (weak, nonatomic) IBOutlet UITextField *timeTextField;
@property (weak, nonatomic) IBOutlet UITextField *carTypeTextField;

@property (weak, nonatomic) IBOutlet UIButton *jianshuBtn;

@property (weak, nonatomic) IBOutlet UITextField *endPlaceL;
@property (weak, nonatomic) IBOutlet UITextField *endPlaceDetailL;
@property (weak, nonatomic) IBOutlet UITextField *startPlaceL;
@property (weak, nonatomic) IBOutlet UITextField *startPlaceDetailL;


@property (weak, nonatomic) IBOutlet UILabel *SFNoticeL;
@property (weak, nonatomic) IBOutlet UILabel *XSNoticeL;

@property (weak, nonatomic) IBOutlet UILabel *Only_XSNoticeL;

//智能筛选展示推荐隐藏界面等
@property (weak, nonatomic) IBOutlet UIImageView *Tuijian_SF;
@property (weak, nonatomic) IBOutlet UIImageView *Tuijian_XS;
@property (weak, nonatomic) IBOutlet UIView *XS_View;
@property (weak, nonatomic) IBOutlet UIView *SF_View;
@property (weak, nonatomic) IBOutlet UIImageView *SFTujian;
@property (weak, nonatomic) IBOutlet UIImageView *XSTuijian;

@property (weak, nonatomic) IBOutlet UIImageView *Tuijian_XS_Only;
@property (weak, nonatomic) IBOutlet UIView *Only_XS_View;
@property (weak, nonatomic) IBOutlet UILabel *Only_XSMoneyL;


@property (weak, nonatomic) IBOutlet UILabel *SFMoneyL;
@property (weak, nonatomic) IBOutlet UILabel *XSMoneyL;


//距离label
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;  //天气提示weatherMessage


@property (nonatomic,copy) NSString * fromLatitude;
@property (nonatomic,copy) NSString * fromLongitude;
@property (nonatomic,copy) NSString * cityCode;

@property (nonatomic,copy) NSString * cityName; //城市名

@property(nonatomic,strong) ShunFeng * model;
@property (nonatomic,strong)WLModel * wlModel;

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property (weak, nonatomic) IBOutlet UIView *clearView;

@property (nonatomic,assign) NSInteger type;  //顺风 1  限时2  物流3

@end
