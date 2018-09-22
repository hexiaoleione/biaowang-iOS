//
//  HYPWheelView.h
//  彩票
//
//  Created by huangyipeng on 14-8-17.
//  Copyright (c) 2014年 HYP. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import <UIKit/UIKit.h>
#import "ChouJiangViewController.h"
typedef void (^Block)();
@interface HYPWheelView : UIView

+ (instancetype)wheelView;

- (IBAction)startSelectNumber;


@property(nonatomic,strong) NSString * ecoinStr;

@property (nonatomic,assign) ChouJiangViewController * choujiangVc;

@property (nonatomic,assign)   BOOL  IsEnd; //是否结束
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *centerBtn;

@property (nonatomic,copy) Block block;

- (void)startWithSeconds:(int)seconds;
@end
