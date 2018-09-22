//
//  ConsignorTableViewCell.h
//  iwant
//
//  Created by pro on 16/4/13.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShunFeng.h"
@protocol ConsignorTableViewCellDelegate<NSObject>

-(void)Call:(UIButton *)button AtIndexPath:(NSInteger)path;
-(void)location:(UIButton *)button AtIndexPath:(NSInteger)path;

@end

@interface ConsignorTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImg;

@property (assign, nonatomic) id<ConsignorTableViewCellDelegate> delegate;
@property(nonatomic)NSInteger a;

@property (weak, nonatomic) IBOutlet UIImageView *traficTool;

- (void)setModel:(ShunFeng *)model;

@end
