//
//  SearchResult.h
//  iwant
//
//  Created by dongba on 16/3/21.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchResult : NSObject

/*城市Array*/
@property (strong, nonatomic)  NSArray *cityArr;
/*区Array*/
@property (strong, nonatomic)  NSArray *districtArr;
/*关键字Array*/
@property (strong, nonatomic)  NSArray *keyArr;
/*poiIdArray*/
@property (strong, nonatomic)  NSArray *poiArr;
/**
 *  pt列表，成员是：封装成NSValue的CLLocationCoordinate2D
 */
@property (nonatomic, strong) NSArray* ptArr;

@end
