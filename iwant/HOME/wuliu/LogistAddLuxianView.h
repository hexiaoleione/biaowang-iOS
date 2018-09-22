//
//  LogistAddLuxianView.h
//  iwant
//
//  Created by dongba on 16/9/1.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^Clickblock) (NSInteger tag);
@interface LogistAddLuxianView : UIView
@property (weak, nonatomic) IBOutlet UIView *touchView;
@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;
@property (weak, nonatomic) IBOutlet UIView *startBGView;
@property (weak, nonatomic) IBOutlet UIView *endBGV;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIImageView *pullView;
@property (copy, nonatomic)   Clickblock block;

@end
