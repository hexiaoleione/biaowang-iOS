//
//  settinhHeaderViewController.h
//  chuanke
//
//  Created by mj on 15/11/30.
//  Copyright © 2015年 jinzelu. All rights reserved.
//

#import "BaseViewController.h"
#import "YMHeaderView.h"
@interface settinhHeaderViewController : BaseViewController<YMHeaderViewDelegate>
/*是否是由注册跳转而来*/
@property (assign, nonatomic)  BOOL isRegist;

@end
