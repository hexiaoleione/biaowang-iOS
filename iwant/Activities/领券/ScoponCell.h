//
//  ScoponCell.h
//  iwant
//
//  Created by 公司 on 2017/4/19.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoponCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *couponName;
@property (weak, nonatomic) IBOutlet UILabel *couponFrom;
@property (weak, nonatomic) IBOutlet UIButton *ReceiveBtn;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponLabel;

@property (copy,nonatomic) void (^Block)();
@end
