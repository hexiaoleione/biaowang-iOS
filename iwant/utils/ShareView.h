//
//  ShareView.h
//  iwant
//
//  Created by dongba on 16/4/2.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenShareHeader.h"
@interface ShareView : UIView
@property (nonatomic, strong) UIControl *overlayView;
@property(nonatomic,strong)UIView *viewS;


//需在实现代码中添加的属性

/**标题*/
@property (nonatomic, strong) NSString *title;
/**内容简介*/
@property (nonatomic, strong) NSString *message;
/**分享展示的图片*/
@property (nonatomic, strong) NSString *pictureName;
/**跳转到哪里*/
@property (nonatomic, strong) NSString *shareUrl;
-(void)show;
-(void)dismiss;

@end