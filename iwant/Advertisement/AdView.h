//
//  AdView.h
//  iwant
//
//  Created by 公司 on 2017/4/25.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"
#import "MainHeader.h"
@interface AdView : UIView
@property (weak, nonatomic) IBOutlet SDCycleScrollView *cycleScrollView;

@property (weak, nonatomic) IBOutlet UIView *viewBG;
@property (nonatomic, copy) void (^Block)();
@end
