//
//  TouSuView.h
//  iwant
//
//  Created by 公司 on 2017/1/16.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMHeaderView.h"
typedef void (^Block) (NSInteger tag);
@interface TouSuView : UIView<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *touSuView;
@property (weak, nonatomic) IBOutlet YMHeaderView *tousuImg;

@property (weak, nonatomic) IBOutlet UITextView *tousuTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;

@property(nonatomic,copy)Block block;

@end
