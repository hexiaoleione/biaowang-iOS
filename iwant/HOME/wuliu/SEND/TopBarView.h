//
//  TopBarView.h
//  iwant
//
//  Created by dongba on 16/8/24.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XPQScrollLabel.h"
@interface TopBarView : UIView
@property (weak, nonatomic) IBOutlet XPQScrollLabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
- (void)setScroll:(BOOL)ifScroll;
@end
