//
//  AdvertisementView.h
//  iwant
//
//  Created by 胡一川 on 16/11/11.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "advermentModel.h"
typedef void (^BtnClickVC)();

@interface AdvertisementView : UIView

@property (nonatomic,copy) BtnClickVC btnClickVC;
@property (weak, nonatomic) IBOutlet UIImageView *adImageView;
@property  (nonatomic,retain) advermentModel * adModel;

@end
