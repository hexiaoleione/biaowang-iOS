//
//  WalletTableViewCell.h
//  iwant
//
//  Created by pro on 16/3/9.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Wallet;
@protocol  WalletTableViewCellDelegate<NSObject>


@end
@interface WalletTableViewCell : UITableViewCell
@property (assign, nonatomic) id<WalletTableViewCellDelegate> delegate;

- (void)configModel:(Wallet *)model;

@end
