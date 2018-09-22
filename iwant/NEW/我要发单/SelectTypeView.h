//
//  SelectTypeView.h
//  iwant
//
//  Created by 公司 on 2017/8/24.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectTypeView : UIView

@property (weak, nonatomic) IBOutlet UIView *viewBg;
@property (nonatomic, copy) void (^Block)(NSInteger tag);

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *distanceConstraint;
@property (weak, nonatomic) IBOutlet UILabel *noticeL;

@end
