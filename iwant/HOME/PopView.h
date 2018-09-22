//
//  PopView.h
//  Express
//
//  Created by user on 15/9/6.
//  Copyright (c) 2015年 SCHT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYRatingView.h"
#import "Courier.h"
@interface PopView : UIView
@property(nonatomic,strong)UIImageView *imgHead ;
@property(nonatomic,strong)UILabel *labelAddress;
@property(nonatomic,strong)UILabel *label_person_num;
@property(nonatomic,strong)UILabel *label_dis;
@property(nonatomic,strong)UILabel *label_num ;

@property(nonatomic,strong)ZYRatingView *ratingView;
@property(nonatomic,strong)UILabel *label_compy;
@property(nonatomic,strong)UILabel *label_Arm ;
@property(nonatomic,strong)UIButton *button_Send ;
-(void)loadDic:(Courier *)courier;

@end
