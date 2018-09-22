//
//  UIImage+Persistence.m
//  Express
//
//  Created by 张宾 on 15/8/16.
//  Copyright (c) 2015年 SCHT. All rights reserved.
//

#import "UIImage+Persistence.h"
#import "RequestManager.h"
@implementation UIImage (Persistence)

- (void)saveToDocumentWithNameId:(NSInteger)nameId
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"pic_%d.png", (int)nameId]];   // 保存文件的名称
    [UIImagePNGRepresentation(self) writeToFile: filePath   atomically:YES];
        
    });
    
}

+ (UIImage*)imageFromDocumentWithNameId:(NSInteger)nameId
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"pic_%d.png", (int)nameId]];   // 保存文件的名称
    return [UIImage imageWithContentsOfFile:filePath];
}

+ (UIImage *)imageFromDownLoadId:(NSInteger)nameId
{
   __block UIImage *image = nil;
    if ([UIImage imageFromDocumentWithNameId:nameId]) {
        image = [UIImage imageFromDocumentWithNameId:nameId];
    }
    else
    {
        [RequestManager downloadFile:nameId Success:^(id object) {
            if (object) {
                image = (UIImage*)object;
                [(UIImage*)object saveToDocumentWithNameId:nameId];
            }
        } Failed:^{
            image = [UIImage imageNamed:@""];
        }];
    }
    return image;
}

@end
