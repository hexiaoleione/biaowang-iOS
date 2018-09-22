//
//  UserPayView.h
//  iwant
//
//  Created by 公司 on 2016/12/23.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserPayView : UIView
@property (weak, nonatomic) IBOutlet UILabel *baoxianFree;
@property (weak, nonatomic) IBOutlet UILabel *quhuoFree;
@property (weak, nonatomic) IBOutlet UILabel *yunFree;
@property (weak, nonatomic) IBOutlet UILabel *songhuoFree;
@property (weak, nonatomic) IBOutlet UILabel *totolFree;
@property (weak, nonatomic) IBOutlet UIButton *yuePayBtn;
@property (weak, nonatomic) IBOutlet UIButton *weChatPay;
@property (weak, nonatomic) IBOutlet UIButton *AliPay;
@property (weak, nonatomic) IBOutlet UILabel *detailBaofeiLabel; //保费计算的label
@property (weak, nonatomic) IBOutlet UIView *PayView;


@end
