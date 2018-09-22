//
//  DDAlertView.h
//  iwant
//
//  Created by dongba on 16/10/10.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDAlertView : UIView
@property (weak, nonatomic) IBOutlet UIView *greenView;
@property (weak, nonatomic) IBOutlet UIImageView *botomImageView;
@property (weak, nonatomic) IBOutlet UIView *whiteClearView;
@property (weak, nonatomic) IBOutlet UIButton *goToBtn;
@property (weak, nonatomic) IBOutlet UIButton *refuseBtn;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gotoBtnHeight;
@property (weak, nonatomic) IBOutlet UIView *redDian;

@end
