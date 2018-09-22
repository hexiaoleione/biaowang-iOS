//
//  LeadingPage.m
//  ECadillac
//
//  Created by DuZexu on 15/4/17.
//  Copyright (c) 2015年 Duzexu. All rights reserved.
//

#import "LeadingPage.h"
#define kPATH_EverLaunched @"everLaunched" //是否打开过应用
#define WINDOW_WIDTH                [[UIScreen mainScreen] bounds].size.width

@interface LeadingPage ()<UIScrollViewDelegate>
@end

@implementation LeadingPage

+ (void)addLeadingPage {
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"everLaunched"]) {//第一次加载
        LeadingPage *view = [[[NSBundle mainBundle]loadNibNamed:@"LeadingPage" owner:self options:nil] lastObject];
        view.scrollView.delegate = view;
        view.frame = [UIApplication sharedApplication].keyWindow.frame;
        [[UIApplication sharedApplication].windows[0] addSubview:view];
    }
}

- (IBAction)buttonClick:(UIButton *)sender {
    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"everLaunched"];
     [[NSUserDefaults standardUserDefaults] synchronize];
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformMakeScale(2, 2);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
#pragma mark-- scrollviewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSLog(@"scrollViewDidScroll");
    CGPoint point=scrollView.contentOffset;
    self.pageControl.currentPage = (int)(point.x /WINDOW_WIDTH);
    
    
}

@end
