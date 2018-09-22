//
//  AdvertisementView.m
//  iwant
//
//  Created by 胡一川 on 16/11/11.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "AdvertisementView.h"
#import "RequestConfig.h"
#import "ExpressRequest.h"
#import "advermentModel.h"
#import "SDImageCache.h"
@implementation AdvertisementView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self creatData];
    
}


-(void)creatData{
    NSString *URLStr = [NSString stringWithFormat:@"%@advertise/getAdvice",BaseUrl];
    [ExpressRequest sendWithParameters:nil MethodStr:URLStr reqType:k_GET success:^(id object) {
        NSDictionary * dict =[object objectForKey:@"data"][0];
        self.adModel = [advermentModel modelWithDic:dict];
        
        //防止缓存
        NSURL * url =[NSURL URLWithString:self.adModel.advertiseImageUrl];
        NSData * data = [NSData dataWithContentsOfURL:url];
        self.adImageView.image = [UIImage imageWithData:data];
        
        NSString * str =[self.adModel.advertiseName  substringFromIndex:self.adModel.advertiseName.length-1];
        if ([str isEqualToString:@"Y"]) {
            
        }else{
            [self removeFromSuperview];
        }
        
    } failed:^(NSString *error) {
        [self removeFromSuperview];

    } ];
    

}

- (IBAction)goToSeeDetail:(UIButton *)sender {
    if (self.btnClickVC) {
        self.btnClickVC();
    }
    [self removeFromSuperview];

}

- (IBAction)turnOffClick:(UIButton *)sender {
    [self removeFromSuperview];
}

//-(void)interfaceAction{
//    if (self.btnClickVC) {
//        self.btnClickVC();
//    }
//    [self removeFromSuperview];
//}


@end
