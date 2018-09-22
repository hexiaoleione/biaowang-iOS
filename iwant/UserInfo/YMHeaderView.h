//
//  YMHeaderView.h
//  photo
//
//  Created by DuZexu on 15/5/6.
//  Copyright (c) 2015年 Duzexu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YMHeaderViewDelegate;
@interface YMHeaderView : UIImageView

@property (weak, nonatomic) IBOutlet id<YMHeaderViewDelegate> delagate;

- (void)imageTaped:(UIGestureRecognizer *)sender;

@end

@protocol YMHeaderViewDelegate <NSObject>

- (void)headerView:(YMHeaderView *)headerView didSelectWithImage:(UIImage *)image;

@end
