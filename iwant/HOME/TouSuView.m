//
//  TouSuView.m
//  iwant
//
//  Created by 公司 on 2017/1/16.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "TouSuView.h"

@implementation TouSuView
-(void)awakeFromNib{
    [super awakeFromNib];
    self.touSuView.layer.cornerRadius = 8;
    self.touSuView.clipsToBounds = YES;
    
    self.tousuTextView.layer.borderWidth = 0.5f;
    self.tousuTextView.layer.cornerRadius = 5;
    self.tousuTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    宽度，样式，颜色
//      textField.leftView = view; textField.leftViewMode = UITextFieldViewModeAlways;
    self.tousuTextView.delegate = self;
    
    if (SCREEN_WIDTH == 320) {
        self.textViewHeightConstraint.constant = 50.0;
    }
}

- (IBAction)updateBtn:(UIButton *)sender {
    if (_block) {
        _block(2);
    }
    
}
- (IBAction)guanbiBtn:(UIButton *)sender {
    [UIView animateWithDuration:.35 animations:^{
        self.y = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];

}
-(void)textViewDidChangeSelection:(UITextView *)textView{

    //下面这句最重要
    NSInteger number = [textView.text length];
    if(number <=0)
        [self.placeholderLabel setHidden:NO];
    else
        [self.placeholderLabel setHidden:YES];
}



@end
