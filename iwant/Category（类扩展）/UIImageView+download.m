//
//  UIImageView+download.m
//  Express
//
//  Created by 张宾 on 15/8/20.
//  Copyright (c) 2015年 SCHT. All rights reserved.
//

#import "UIImageView+download.h"
#import "UIImage+Persistence.h"
#import "RequestManager.h"
@implementation UIImageView (download)
- (void)imageWithId:(NSInteger)Id PlaceHolder:(NSString*)name
{
    self.image = [UIImage imageNamed:name];
    if(Id==0)
        return;
//    UIImage *image = [UIImage imageFromDocumentWithNameId:Id];
   
    /*
    if (image) {
        self.image = image;
    }
    else
    {
        __weak UIImageView *imageView = self;
        [RequestManager downloadFile:Id Success:^(id object) {
            if (object) {
                imageView.image = (UIImage*)object;
                [image saveToDocumentWithNameId:Id];
            }
        } Failed:^{
            
        }];
     
    
    }
     */
}
@end
