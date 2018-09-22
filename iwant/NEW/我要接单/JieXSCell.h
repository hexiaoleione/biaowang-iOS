//
//  JieXSCell.h
//  iwant
//
//  Created by 公司 on 2017/6/9.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AutoScrollLabel.h"
#import "ShunFengBiaoShi.h"
@interface JieXSCell : UITableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@property (weak, nonatomic) IBOutlet UILabel *start;

@property (weak, nonatomic) IBOutlet UILabel *end;

@property (weak, nonatomic) IBOutlet UILabel *limitTimeL;
@property (weak, nonatomic) IBOutlet UILabel *replaceMoneyL;
@property (weak, nonatomic) IBOutlet UILabel *matName;
@property (weak, nonatomic) IBOutlet UILabel *yunMoneyL;
@property (weak, nonatomic) IBOutlet UIImageView *statusImg;

@property (weak, nonatomic) IBOutlet UILabel *guiGeL;
@property (weak, nonatomic) IBOutlet UILabel *matWeight;

@property (weak, nonatomic) IBOutlet AutoScrollLabel *startLabel;
@property (weak, nonatomic) IBOutlet AutoScrollLabel *endLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceL;
@property (weak, nonatomic) IBOutlet UILabel *remarkL;
@property (weak, nonatomic) IBOutlet UILabel *jianshuL;

@property (nonatomic,strong) NSString * sendPersonPhone;

@property (weak, nonatomic) IBOutlet UIButton *jieBtn;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;

@property (nonatomic,copy) void (^Block)(int tag);

- (void)setModel:(ShunFengBiaoShi *)model;

@end
