//
//  FinishDetailView.h
//  iwant
//
//  Created by 公司 on 2017/6/23.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Logist.h"
#import "Baojia.h"
@interface FinishDetailView : UIView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *disTopGoodsValueConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *disTopToubaoFreeConstraint;
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

@property (weak, nonatomic) IBOutlet UILabel *noticeL;
@property (weak, nonatomic) IBOutlet UILabel *companyNameL;
@property (weak, nonatomic) IBOutlet UILabel *huochangL;

@property (weak, nonatomic) IBOutlet UILabel *baijia;
@property (weak, nonatomic) IBOutlet UILabel *quL;
@property (weak, nonatomic) IBOutlet UILabel *quqFree;
@property (weak, nonatomic) IBOutlet UILabel *quDanwei;

@property (weak, nonatomic) IBOutlet UILabel *songL;
@property (weak, nonatomic) IBOutlet UILabel *songFree;
@property (weak, nonatomic) IBOutlet UILabel *songDanwei;

@property (weak, nonatomic) IBOutlet UILabel *yunfeiL;
@property (weak, nonatomic) IBOutlet UILabel *yunfeiFree;
@property (weak, nonatomic) IBOutlet UILabel *yunfeiYuan;
@property (weak, nonatomic) IBOutlet UILabel *hejiL;
@property (weak, nonatomic) IBOutlet UILabel *totolFree;
@property (weak, nonatomic) IBOutlet UILabel *hejiDanwei;
@property (weak, nonatomic) IBOutlet UILabel *messgaeL;
@property (weak, nonatomic) IBOutlet UILabel *telNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *toubaoFree;
@property (weak, nonatomic) IBOutlet UILabel *goodsType;
@property (weak, nonatomic) IBOutlet UILabel *baoxianType;
@property (weak, nonatomic) IBOutlet UILabel *goodValueL;
@property (weak, nonatomic) IBOutlet UILabel *specialNeedL;

@property (weak, nonatomic) IBOutlet UIButton *selectAgainBtn;
@property (weak, nonatomic) IBOutlet UIButton *goOnBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;

@property (nonatomic, copy)  void(^Block) (NSInteger tag);

-(void)setViewsWithLogistModel:(Logist *)model withBaojiaModel:(Baojia *)baoJiaModel;

@end
