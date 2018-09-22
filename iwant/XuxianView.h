//
//  XuxianView.h
//  iwant
//
//  Created by dongba on 16/3/22.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>
#define screen_width    [UIScreen mainScreen].bounds.size.width
@interface XuxianView : UIView

@property(nonatomic)CGPoint startPoint;//虚线起点

@property(nonatomic)CGPoint endPoint;//虚线终点

@property(nonatomic,strong)UIColor* lineColor;//虚线颜色

@end
