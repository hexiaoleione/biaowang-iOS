//
//  GuideView.h
//  GuideDemo
//
//  Created by 李剑钊 on 15/7/23.
//  Copyright (c) 2015年 sunli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuideView : UIView
/*tips*/
@property (copy, nonatomic)  NSString *tips;
- (void)showInView:(UIView *)view maskBtn:(UIButton *)btn;

@end
