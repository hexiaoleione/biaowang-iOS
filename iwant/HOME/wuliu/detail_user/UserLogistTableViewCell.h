//
//  UserLogistTableViewCell.h
//  iwant
//
//  Created by 公司 on 2016/11/27.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AutoScrollLabel.h"
typedef void (^ClickBlock) (UIButton *sender);

@interface UserLogistTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *goodsName; //货物名称
@property (weak, nonatomic) IBOutlet UILabel *goodsWeight;  //重量
@property (weak, nonatomic) IBOutlet UILabel *countLabel;   //件数
@property (weak, nonatomic) IBOutlet AutoScrollLabel *endAdress;
@property (weak, nonatomic) IBOutlet UILabel *receiverName;   //收件人名字
@property (weak, nonatomic) IBOutlet UILabel *telNum;   //电话
@property (weak, nonatomic) IBOutlet UILabel *publicTime;   //发布时间
@property (weak, nonatomic) IBOutlet UILabel *baojiaShu;  //报价数量
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;   //状态标识
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;  //取消按钮
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;   //看详情
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;     //完成按钮
@property (weak, nonatomic) IBOutlet UIView *viewBg;
@property (weak, nonatomic) IBOutlet UIImageView *baojiaImageView;

@property (copy, nonatomic)  ClickBlock block;


@end
