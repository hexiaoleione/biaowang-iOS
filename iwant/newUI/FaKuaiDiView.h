//
//  FaKuaiDiView.h
//  iwant
//
//  Created by 公司 on 2017/2/13.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XPQScrollLabel.h"
typedef void (^Block) (int tag);//0-顶部的btn 1-手机联系人 2-定位 3-选择快递员 4-添加发件人 5-电话通知
@interface FaKuaiDiView : UIView
@property (weak, nonatomic) IBOutlet UIView *sendView;
@property (weak, nonatomic) IBOutlet UIButton *TopBtn;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UIButton *tongxunluBtn;

@property (weak, nonatomic) IBOutlet XPQScrollLabel *locatLabel;

@property (weak, nonatomic) IBOutlet UITextField *detailAddressTextField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *diatanceConstraint;

@property (weak, nonatomic) IBOutlet UITextField *courierTextField;

@property (copy, nonatomic)  Block block;
@end
