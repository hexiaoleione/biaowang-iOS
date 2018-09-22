//
//  LCFAccidentAlert.h
//  iwant
//
//  Created by 李晨芳 on 2017/12/15.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCFAccidentAlert : UIView

//0取消 1立即前往 
@property(nonatomic,copy)  void (^Block)(NSInteger tag);

@end
