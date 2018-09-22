//
//  LCFAccidentAlert.m
//  iwant
//
//  Created by 李晨芳 on 2017/12/15.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "LCFAccidentAlert.h"
#import "QuickControl.h"
#import "MainHeader.h"
@implementation LCFAccidentAlert

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self creatUI];
    }
    return self;
}
-(void)creatUI{
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    //背景view
    UIView * bgView = [QuickControl createViewWithFrame:CGRectMake(0, 0, 240*RATIO_WIDTH, 220*RATIO_HEIGHT) backgroundColor:[UIColor whiteColor]];
    bgView.centerX = self.centerX;
    bgView.centerY = self.centerY;
    bgView.layer.cornerRadius = 8;
    bgView.layer.masksToBounds = YES;
    [self addSubview:bgView];
    //图片
    UIImageView * imgView = [QuickControl createImageViewWithFrame:CGRectMake(0, 0, bgView.width, 105*RATIO_HEIGHT) image:@"ywxAlertImg"];
    [bgView addSubview:imgView];
    
    UILabel * noticeL = [QuickControl createLabelWithFrame:CGRectMake(0, imgView.bottom+20, bgView.width, 30*RATIO_HEIGHT) backgroundColor:[UIColor clearColor] text:@"如需购买意外险请先交纳保证金" textColor:[UIColor blackColor] font:FONT(16, NO)];
    noticeL.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:noticeL];
    UIView * line = [QuickControl createViewWithFrame:CGRectMake(0, noticeL.bottom+20, bgView.width, 1) backgroundColor:[UIColor lightGrayColor]];
    [bgView addSubview:line];
    
    UIButton * cancleBtn = [QuickControl createButtonWithFrame:CGRectMake(0, line.bottom, bgView.width/2, bgView.height-line.bottom) backgroundColor:[UIColor clearColor] title:@"取消" titleColor:[UIColor blackColor] font:FONT(16, NO) target:self action:@selector(btnClick:)];
    cancleBtn.tag = 0;
    
    UIView * line1= [QuickControl createViewWithFrame:CGRectMake(cancleBtn.right, noticeL.bottom+20, 1, cancleBtn.height) backgroundColor:[UIColor lightGrayColor]];
    [bgView addSubview:line1];
    
     UIButton * sureBtn = [QuickControl createButtonWithFrame:CGRectMake(bgView.width/2, line.bottom, bgView.width/2, bgView.height-line.bottom) backgroundColor:[UIColor clearColor] title:@"立即前往" titleColor:[UIColor blackColor] font:FONT(16, NO) target:self action:@selector(btnClick:)];
    sureBtn.tag = 1;
    [bgView addSubview:cancleBtn];
    [bgView addSubview:sureBtn];
}

#pragma mark -----btnClick
-(void)btnClick:(UIButton *)btn{
    if (_Block) {
        _Block(btn.tag);
    }
    [self removeFromSuperview];
}
@end
