//
//  UIImage+Persistence.h
//  Express
//
//  Created by 张宾 on 15/8/16.
//  Copyright (c) 2015年 SCHT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Persistence)

- (void)saveToDocumentWithNameId:(NSInteger)nameId;
+ (UIImage *)imageFromDocumentWithNameId:(NSInteger)nameId;
+ (UIImage *)imageFromDownLoadId:(NSInteger)nameId;
@end
