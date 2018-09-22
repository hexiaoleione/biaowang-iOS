//
//  HuoChangAdressCell.h
//  iwant
//
//  Created by 公司 on 2017/1/4.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ClickBlock) (UIButton *sender);

@interface HuoChangAdressCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *locationAddress;
@property (weak, nonatomic) IBOutlet UILabel *detailAdress;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *setDefaultBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UILabel *defaultLabel; //设为默认的label

@property (copy, nonatomic)  ClickBlock block;

@end
