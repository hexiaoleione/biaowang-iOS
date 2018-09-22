//
//  ViewController.h
//  CityListDemo
//
//  Created by md on 16/6/1.
//  Copyright © 2016年 HKQ. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^block)(NSString *city);
@interface CitysViewController : UIViewController

@property (copy, nonatomic)   block block ;


@end

