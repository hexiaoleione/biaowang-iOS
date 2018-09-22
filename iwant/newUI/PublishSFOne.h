//
//  PublishSFOne.h
//  iwant
//
//  Created by 公司 on 2017/4/1.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XPQScrollLabel.h"
@interface PublishSFOne : UIView

@property (weak, nonatomic) IBOutlet UILabel *topNoticeLabel;
@property (weak, nonatomic) IBOutlet UIView *viewOne;
@property (weak, nonatomic) IBOutlet UIView *viewTwo;
@property (weak, nonatomic) IBOutlet UIView *viewThree;
@property (weak, nonatomic) IBOutlet UIView *viewFour;

@property (weak, nonatomic) IBOutlet UIView *viewFive;

@property (weak, nonatomic) IBOutlet UITextField *startTextField;
@property (weak, nonatomic) IBOutlet XPQScrollLabel *locatLabel;
@property (weak, nonatomic) IBOutlet UITextField *startDetailTextField;
@property (weak, nonatomic) IBOutlet UITextField *endTextField;

@property (weak, nonatomic) IBOutlet XPQScrollLabel *endLocatLabel;

@property (weak, nonatomic) IBOutlet UITextField *endDetailTextField;
@property (weak, nonatomic) IBOutlet UITextField *weightTextField;

@property (weak, nonatomic) IBOutlet UITextField *goodsNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *carLengthTextField;
@property (weak, nonatomic) IBOutlet UITextField *goodsSqureTextField;

@property (nonatomic, strong) NSMutableArray *squreArr;
@property (nonatomic, strong) NSArray *carLengthArr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDistanceConstraint;

@property (weak, nonatomic) IBOutlet UILabel *goodsnameL;

@property (weak, nonatomic) IBOutlet UILabel *weightL;


@property (nonatomic, copy) void (^BlockOne)(int tag);

@property (nonatomic, copy) void (^BlockCarLength)(NSString * carLength);

@property (nonatomic, copy) void (^BlockMatVolume)(NSString * matVolume);


@end
