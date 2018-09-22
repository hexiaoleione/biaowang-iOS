//
//  ExpressCViewController.h
//  Express
//
//  Created by user on 15/8/11.
//  Copyright (c) 2015年 SCHT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpCompany.h"

typedef void (^ReturnCompanyBlock)(ExpCompany *company);
@interface ExpressCViewController : UIViewController
@property(nonatomic,copy)ReturnCompanyBlock returnCompanyBlock;
@end
