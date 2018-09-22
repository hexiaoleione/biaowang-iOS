//
//  ActivityModel.m
//  hhhh
//
//  Created by yaojiaqi on 2016/11/19.
//  Copyright © 2016年 Shangji Online (Beijing) Network Technology Co., Ltd. All rights reserved.
//

#import "ActivityModel.h"

@implementation ActivityModel
+(instancetype)modelWithDic:(NSDictionary *)dic{
    
    ActivityModel *am = [[ActivityModel alloc] init];
    [am setValuesForKeysWithDictionary:dic];
    return am;
    
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}
@end
