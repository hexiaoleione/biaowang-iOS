//
//  LeadingPage.h
//  ECadillac
//
//  Created by DuZexu on 15/4/17.
//  Copyright (c) 2015年 Duzexu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeadingPage : UIView<UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
+ (void)addLeadingPage;

@end
