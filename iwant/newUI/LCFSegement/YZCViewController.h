//
//  YZCViewController.h
//  YZCSegmentController
//
//  Created by dyso on 16/8/1.
//  Copyright © 2016年 yangzhicheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZCViewController : UIViewController

@property (nonatomic, strong) NSArray *kuaidiyuanArr;  //快递员的模块
@property (nonatomic, strong) NSArray *userArr;   //用户的模块
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *controllerArray;

@property (nonatomic, strong) NSArray *wuliuArr; //物流模块
@property (nonatomic, strong) NSArray *kuaidiAndWuliuArr;  //快递员和物流


@property (nonatomic, strong) UIScrollView * scrollView;


@property(nonatomic,strong) NSArray * btnSelectedImage;  //按钮被选中时候的图片

- (void)showTitle:(NSInteger )type;
@end
