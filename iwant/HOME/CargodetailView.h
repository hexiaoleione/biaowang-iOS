//
//  CargodetailView.h
//  iwant
//
//  Created by 公司 on 2017/2/20.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShunFengBiaoShi.h"

@interface CargodetailView : UIView
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UILabel *replacerMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromAdress;
@property (weak, nonatomic) IBOutlet UILabel *toAdress;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;

-(void)setModel:(ShunFengBiaoShi *)model;
@end
