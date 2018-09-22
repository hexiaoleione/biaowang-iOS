//
//  SendLogView.h
//  iwant
//
//  Created by dongba on 16/8/24.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^Block) (int i);
@interface SendLogView : UIView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fromAdressHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toAddressHeight;
@property (weak, nonatomic) IBOutlet UITextField *logName;
@property (weak, nonatomic) IBOutlet UITextField *matName;
@property (weak, nonatomic) IBOutlet UITextField *fromArea;
@property (weak, nonatomic) IBOutlet UITextField *toArea;
@property (weak, nonatomic) IBOutlet UITextField *matWeight;
@property (weak, nonatomic) IBOutlet UIButton *danwei;
@property (weak, nonatomic) IBOutlet UITextField *tiJi;
@property (weak, nonatomic) IBOutlet UITextField *StarTime;
@property (weak, nonatomic) IBOutlet UITextField *ReceiveTime;

@property (weak, nonatomic) IBOutlet UISwitch *pickSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *arriveSwitch;

@property (weak, nonatomic) IBOutlet UITextField *fromDetailAdress;  //起始地的详细地址
@property (weak, nonatomic) IBOutlet UITextField *toDetailAdress;   //目的地的详细地址
@property (weak, nonatomic) IBOutlet UILabel *sendtimeLabel; //送到货场时间   上门取货时间
@property (weak, nonatomic) IBOutlet UILabel *arriveTimeLabel;// 送货上门时间  用户自提时间

@property (copy, nonatomic)  Block block;//

@end
