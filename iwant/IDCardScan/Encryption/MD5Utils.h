//
//  MD5Utils.h
//  EasyPay
//
//  Created by 刘欣 on 15/5/12.
//  Copyright (c) 2015年 刘欣. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MD5Utils : NSObject

 +(NSString*) md5:(NSString*)value AndKey:(NSString*)key;

@end
