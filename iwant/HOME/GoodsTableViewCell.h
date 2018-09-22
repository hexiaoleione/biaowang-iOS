//
//  GoodsTableViewCell.h
//  iwant
//
//  Created by pro on 16/4/29.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShunFeng.h"

@protocol GoodsTableViewCellDelegate<NSObject>

-(void)cancel:(UIButton *)button AtIndexPath:(NSInteger)path;

@end


@interface GoodsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

- (void)setModel:(ShunFeng *)model;

@property (assign, nonatomic) id<GoodsTableViewCellDelegate> delegate;

@property(nonatomic)NSInteger a;


@end
