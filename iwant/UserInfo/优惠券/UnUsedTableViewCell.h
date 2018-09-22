//
//  UnUsedTableViewCell.h
//  iwant
//
//  Created by pro on 16/3/9.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Wallet;
@protocol UnUsedTableViewCellDelegate <NSObject>

-(void)UseCard:(UIButton *)Button tIndexPath:(NSInteger)path;


@end
@interface UnUsedTableViewCell : UITableViewCell

@property(assign,nonatomic)id<UnUsedTableViewCellDelegate>delegate;
- (void)configModel:(Wallet *)model;
@property(nonatomic)NSInteger a;

@property (assign, nonatomic)  BOOL ifSelecct;

- (void)select;

@end
