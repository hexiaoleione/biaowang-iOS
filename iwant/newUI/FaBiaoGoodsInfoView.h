//
//  FaBiaoGoodsInfoView.h
//  iwant
//
//  Created by 公司 on 2017/2/9.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMHeaderView.h"
typedef void (^Block) (int tag); // -0晋级镖师  1-选择时间   2-是否需要货车   3-是否投保   4-上一步   5-确认发布 6-投保声明

typedef void (^WeightBlock) (NSString * weightStr,NSString * weight);

@interface FaBiaoGoodsInfoView : UIView 


@property (weak, nonatomic) IBOutlet UIView *goosInfoView;
@property (weak, nonatomic) IBOutlet UITextField *receiveTime;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *weightTextField;
@property (weak, nonatomic) IBOutlet UIButton *ifTouBaoBtn;
@property (weak, nonatomic) IBOutlet UISwitch *ifNeedHuoChe; //是否需要货车开关
@property (weak, nonatomic) IBOutlet UILabel *ifNeedHuocheLabel;//是否需要货车L
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line5TopConstraint;

@property (weak, nonatomic) IBOutlet UITextField *goodsValueTextfield;
@property (weak, nonatomic) IBOutlet YMHeaderView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *noticeLabel; //顶部的提示条
@property (weak, nonatomic) IBOutlet UIButton *topBtn;


@property (weak, nonatomic) IBOutlet
NSLayoutConstraint *topLineConstraint;
@property (weak, nonatomic) IBOutlet UIButton *timeSelectBtn;
@property (weak, nonatomic) IBOutlet UIImageView *timeSelectImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodsInfoViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *distanceBtnConstraint;
@property (weak, nonatomic) IBOutlet UIButton *ifReplaceMoneyBtn;
@property (weak, nonatomic) IBOutlet UITextField *replaceMoneyTextField;
@property (weak, nonatomic) IBOutlet UILabel *toubaoStar;
@property (weak, nonatomic) IBOutlet UILabel *daishoukuanStar;


@property (weak, nonatomic) IBOutlet UIView *carTypeView; //车型View
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *carTypeViewHeightConstraint;

@property (weak, nonatomic) IBOutlet UIButton *smallMinibusBtn; //小面包

@property (weak, nonatomic) IBOutlet UIButton *middleMinibusBtn;  //中面包
@property (weak, nonatomic) IBOutlet UIButton *smallTruckBtn;//小货车
@property (weak, nonatomic) IBOutlet UIButton *middleTruckBtn;  //中货车

@property (strong, nonatomic) UIButton * currentBtn;

@property (copy,nonatomic) Block block;

@property (copy, nonatomic)  WeightBlock weightBlock;

@property (weak, nonatomic) IBOutlet UIButton *weightBtn;
@property (weak, nonatomic) IBOutlet UILabel *kgDanwei; //kg的单位

@property (nonatomic, strong) NSMutableArray *arr;

@end
