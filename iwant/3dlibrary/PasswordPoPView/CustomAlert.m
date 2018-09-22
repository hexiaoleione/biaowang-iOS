//
//  CustomAlert.m
//  弹出视图
//
//  Created by 银谷 on 16/4/27.
//  Copyright © 2016年 银谷. All rights reserved.
//

#import "CustomAlert.h"

@implementation CustomAlert

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
                 leftBtnTitle:(NSString *)leftBtntitle
                rightBtnTitle:(NSString *)rightBtntitle
                  bottomTitle:(NSString *)bottomtitle{
    self = [self initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        self.mainTitle = title;
        self.leftBtntitle = leftBtntitle;
        self.rightBtntitle = rightBtntitle;
        self.bottomtitle = bottomtitle;
    }
    return self;
}

+ (CustomAlert *)_alert{
    static CustomAlert *_alert = nil;
    if (!_alert) {
        _alert = ({
            _alert = [[CustomAlert alloc]init];
            _alert;
        });
    }
    return _alert;
}


+ (void)show{
    UIView *mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
    mainView.backgroundColor = [UIColor redColor];
    [mainView setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width/2, [[UIScreen mainScreen] bounds].size.height/2)];
}

+ (void)hide{
    
    
}

@end
