//
//  BaoJiaDetailViewController.h
//  iwant
//
//  Created by 公司 on 2017/6/23.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "BaseViewController.h"
#import "Logist.h"
#import "Baojia.h"
@interface BaoJiaDetailViewController : BaseViewController

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
@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;

//冷链车特殊需求
@property (weak, nonatomic) IBOutlet UILabel *specialNeedL;

@property (nonatomic,strong)Logist * model;
@property (nonatomic,strong)Baojia * baojiaModel;

/*物流公司Id*/
@property (copy, nonatomic)  NSString *comId;


@end
