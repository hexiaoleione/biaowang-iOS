//
//  HuoZhuSFTaskTableViewCell.h
//  iwant
//
//  Created by 公司 on 2017/2/20.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShunFeng.h"

@protocol SFTaskTableViewCellDelegate<NSObject>

-(void)cancel:(UIButton *)button AtIndexPath:(NSInteger)path;

@end

@interface HuoZhuSFTaskTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

-(void)setModel:(ShunFeng *)model;

@property (assign, nonatomic) id<SFTaskTableViewCellDelegate> delegate;

@property(nonatomic)NSInteger a;

@property (nonatomic,copy) void (^Block)(int tag);

@end
