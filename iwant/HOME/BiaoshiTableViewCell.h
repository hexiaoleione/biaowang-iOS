//
//  BiaoshiTableViewCell.h
//  iwant
//
//  Created by pro on 16/4/13.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShunFengBiaoShi.h"

@protocol BiaoshiTableViewCellDelegate<NSObject>

-(void)Call:(UIButton *)button AtIndexPath:(NSInteger)path;
-(void)location:(UIButton *)button AtIndexPath:(NSInteger)path;


@end
@interface BiaoshiTableViewCell : UITableViewCell

@property (assign, nonatomic) id<BiaoshiTableViewCellDelegate> delegate;
@property(nonatomic)NSInteger a;

- (void)setModel:(ShunFengBiaoShi *)model;

@end
