//
//  PublishWLTwo.h
//  iwant
//
//  Created by 公司 on 2017/4/6.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublishWLTwo : UIView

@property (weak, nonatomic) IBOutlet UITextField *sendNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *sendPhoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *receiveNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *receivePhoneTextField;

@property (weak, nonatomic) IBOutlet UIButton *takeBtn;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

@property (nonatomic, copy) void (^BlockTwo)(int tag);

@property(nonatomic,copy) NSArray * arr;
@property(nonatomic,copy) NSArray * arrTwo;
@property (weak, nonatomic) IBOutlet UILabel *labelOne;
@property (weak, nonatomic) IBOutlet UILabel *labelTwo;
@property (weak, nonatomic) IBOutlet UIView *ZiTiRemark;
@property (weak, nonatomic) IBOutlet UITextField *ZiTiRemarkTextField;

@property (copy, nonatomic) void (^QuHuoBlock)(NSString * takeCargo);
@property (copy, nonatomic) void (^SongHuoBlock)(NSString * sendCargo);
@end
