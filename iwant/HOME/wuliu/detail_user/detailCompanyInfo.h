//
//  detailCompanyInfo.h
//  iwant
//
//  Created by 公司 on 2017/1/10.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Baojia.h"
@interface detailCompanyInfo : UIView

@property (weak, nonatomic) IBOutlet UIImageView *companyImagevIew;   //公司logo
@property (weak, nonatomic) IBOutlet UILabel *companyName;   //公司姓名
@property (weak, nonatomic) IBOutlet UILabel *baojiaTimeLLabel;   //公司报价时间
@property (weak, nonatomic) IBOutlet UILabel *companyAdress; // 公司地址（详情）
@property (weak, nonatomic) IBOutlet UILabel *dizhiLabel; //公司地址（四个字）
@property (weak, nonatomic) IBOutlet UILabel *beizhuLabel; //留言

@property (weak, nonatomic) IBOutlet UILabel *quhuoFree;  //取货费
@property (weak, nonatomic) IBOutlet UILabel *songhuoFree;  //送货费

@property (weak, nonatomic) IBOutlet UILabel *yunfei;   //送货上门费
@property (weak, nonatomic) IBOutlet UILabel *totolTransforMoney;
@property (weak, nonatomic) IBOutlet UILabel *telNumLabel;  //联系电话
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *telHeightConstraint;//联系电话栏高度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *disistanceConstraint; //距离约束

- (void) setViewsWithModel:(Baojia *)model;

@end
