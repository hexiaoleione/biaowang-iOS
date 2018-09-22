//
//  BiaoshiViewController.h
//  iwant
//
//  Created by pro on 16/4/13.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BiaoshiViewController : UIViewController


@property (assign, nonatomic)  int sendType;//0-顺路送 1-专程送
- (void)changePX:(int)type;
@end
