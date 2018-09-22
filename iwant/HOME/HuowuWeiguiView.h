//
//  HuowuWeiguiView.h
//  iwant
//
//  Created by 公司 on 2017/1/16.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMHeaderView.h"
typedef void (^Block) (NSInteger tag);//0-立即上传 1-暂不上传

@interface HuowuWeiguiView : UIView
@property (weak, nonatomic) IBOutlet UIView *weiguiView;
@property (weak, nonatomic) IBOutlet YMHeaderView *huowuImg;

@property (copy, nonatomic)  Block block;
@end
