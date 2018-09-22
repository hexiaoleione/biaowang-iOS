//
//  TKAddressBook.h
//  Express
//
//  Created by 张宾 on 15/8/29.
//  Copyright (c) 2015年 SCHT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKAddressBook : NSObject {
    NSInteger sectionNumber;
    NSInteger recordID;
    NSString *name;
    NSString *email;
    NSString *tel;
}
@property NSInteger sectionNumber;
@property NSInteger recordID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *tel;

@end