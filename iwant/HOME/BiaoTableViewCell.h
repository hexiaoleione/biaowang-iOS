//
//  BiaoTableViewCell.h
//  iwant
//
//  Created by pro on 16/4/29.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShunFengBiaoShi.h"
#import "CZCountDownView.h"
@interface BiaoTableViewCell : UITableViewCell

- (void)setModel:(ShunFengBiaoShi *)model;

@property (nonatomic,copy) void (^Block)(int tag);

@end
