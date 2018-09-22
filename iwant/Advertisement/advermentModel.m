//
//  advermentModel.m
//  iwant
//
//  Created by 公司 on 2016/11/18.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "advermentModel.h"

@implementation advermentModel

+(instancetype)modelWithDic:(NSDictionary *)dic{

    advermentModel *am = [[advermentModel alloc] init];
    [am setValuesForKeysWithDictionary:dic];
    return am;

}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}

@end
