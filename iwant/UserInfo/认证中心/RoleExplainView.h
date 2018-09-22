//
//  RoleExplainView.h
//  RoleAuthentication
//
//  Created by 公司 on 2017/2/27.
//  Copyright © 2017年 lcf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoleExplainView : UIView
@property (weak, nonatomic) IBOutlet UIView *view;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIButton *guanbiBtn;

-(void)show;
-(void)dismiss;
@end
