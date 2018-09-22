//
//  LuxianTableViewCell.h
//  iwant
//
//  Created by dongba on 16/9/1.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DeleteBlock) (id);
@interface LuxianTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;


@property (copy, nonatomic)  DeleteBlock block;
@end
