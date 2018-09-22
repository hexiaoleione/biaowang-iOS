//
//  AssessViewController.h
//  Express
//
//  Created by user on 15/8/24.
//  Copyright (c) 2015年 SCHT. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Package.h"
typedef void (^returnBlock) (NSString *content,float score);
@interface AssessViewController : UIViewController
//@property(nonatomic,assign)NSInteger bussinessID;
@property(nonatomic,strong)Package *package;

/*<#uttext#>*/
@property (copy, nonatomic)  returnBlock block;

@end
