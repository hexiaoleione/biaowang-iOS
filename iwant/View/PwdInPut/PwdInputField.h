//
//  PwdInputField.h
//  iwant
//
//  Created by dongba on 16/9/19.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ActionBlock) (id sender);
@interface PwdInputField : UIView<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *firstImg;
@property (weak, nonatomic) IBOutlet UIImageView *secImg;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImg;
@property (weak, nonatomic) IBOutlet UIImageView *fouthImg;
@property (weak, nonatomic) IBOutlet UIImageView *fifthImg;
@property (weak, nonatomic) IBOutlet UIImageView *sixthOmg;
@property (weak, nonatomic) IBOutlet UITextField *field;
@property (weak, nonatomic) IBOutlet UIView *greenView;
@property (weak, nonatomic) IBOutlet UIView *imgBGV;

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imageVs;
@property (weak, nonatomic) IBOutlet UIButton *getMessageAgainBtn;

@property (copy, nonatomic)  ActionBlock block;
@end
