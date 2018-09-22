//
//  newView.h
//  iwant
//
//  Created by 公司 on 2016/12/20.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface newView : UIView
<
UITextFieldDelegate
>
@property (weak, nonatomic) IBOutlet UITextField *quhuoFree;//取货费
@property (weak, nonatomic) IBOutlet UITextField *songhuoFree; //送货费
@property (weak, nonatomic) IBOutlet UITextField *costLabel;  //运费
@property (weak, nonatomic) IBOutlet UILabel *totalFree;  //总计
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *getConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sendConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *costConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputGetConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputSendConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputCostConstraint;
@property (weak, nonatomic) IBOutlet UIView *detailView;//子view
@property (weak, nonatomic) IBOutlet UIButton *baoJiaBtn;//提交报价按钮

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *danweiTake; //取货费单位高度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;//距离上边的约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *distanceConstraint;//距离约束

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *danweiSend;  //送货费单位高度约束

-(void)hiddenGet:(BOOL)hiddenGet
      hiddenSend:(BOOL)hiddenSend;
-(void) setData:(id)data;
@end
