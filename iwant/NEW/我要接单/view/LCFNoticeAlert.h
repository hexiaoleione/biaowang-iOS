//
//  LCFNoticeAlert.h
//  iwant
//
//  Created by 公司 on 2017/7/13.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCFNoticeAlert : UIView

@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIView *noticView;

@property (nonatomic,copy) void (^Block)(NSInteger tag);

-(void)show;
-(void)dismiss;

@end
