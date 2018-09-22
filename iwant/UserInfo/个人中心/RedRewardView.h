//
//  RedRewardView.h
//  iwant
//
//  Created by 公司 on 2017/10/16.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedRewardView : UIView

@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;


@property (nonatomic,copy) void (^Block)(NSInteger tag);

-(void)show;
-(void)dismiss;


@end
