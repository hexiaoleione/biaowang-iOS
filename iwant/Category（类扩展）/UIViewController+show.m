//
//  UIViewController+show.m
//  Express
//
//  Created by 张宾 on 15/7/28.
//  Copyright (c) 2015年 SCHT. All rights reserved.
//

#import "UIViewController+show.h"

@implementation UIViewController (show)

+ (void)presentWithNavFromRootVC
{
    Class class = NSClassFromString([self description]);
    UIViewController *vc = [(UIViewController*)[class alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
}

- (void)presentWithNavFromRootVC
{
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:self];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
}
@end
