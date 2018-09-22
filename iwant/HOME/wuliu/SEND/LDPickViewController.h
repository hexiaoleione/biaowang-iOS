//
//  LDPickViewController.h
//  iwant
//
//  Created by dongba on 16/8/25.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ClickBlock) (NSString *str);
@interface LDPickViewController : UIViewController


@property (copy, nonatomic)  ClickBlock block;


@property(nonatomic,strong) NSArray *dataArray;

@end
