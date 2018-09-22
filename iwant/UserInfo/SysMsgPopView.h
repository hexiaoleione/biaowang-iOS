//
//  SysMsgPopView.h
//  iwant
//
//  Created by dongba on 16/10/12.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ClickBlock) (id sender);
@class Message;
@interface SysMsgPopView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIView *whiteView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (strong, nonatomic)  UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topToSuperView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelHeight;

@property (copy, nonatomic)  ClickBlock block;
- (void)setModel:(Message *)model;


@end
