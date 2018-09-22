//
//  PwdInputField.m
//  iwant
//
//  Created by dongba on 16/9/19.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "PwdInputField.h"

@implementation PwdInputField
-(void)awakeFromNib{
    [super awakeFromNib];
    
    _field.delegate = self;
    _greenView.layer.masksToBounds  = YES;
    _greenView.layer.cornerRadius = 10;
    _imgBGV.layer.cornerRadius = 10;
    _imgBGV.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _imgBGV.layer.borderWidth = 0.5;
    _imgBGV.layer.masksToBounds = YES;
    _firstImg.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _firstImg.layer.borderWidth = 0.5;
    _secImg.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _secImg.layer.borderWidth = 0.5;
    _thirdImg.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _thirdImg.layer.borderWidth = 0.5;
    _fouthImg.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _fouthImg.layer.borderWidth = 0.5;
    _fifthImg.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _fifthImg.layer.borderWidth = 0.5;
    _sixthOmg.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _sixthOmg.layer.borderWidth = 0.5;
    //[_field becomeFirstResponder];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textfieldChanged) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)textfieldChanged{
    NSLog(@"length:%d",(int)_field.text.length);
    
    for (UIImageView *img in _imageVs) {
        img.image = [UIImage imageNamed:img.tag < _field.text.length ? @"set_password_input_border": @""];
    }
    if (_field.text.length == 6) {
        if (_block) {
            _block(_field);
        }
    }
}

- (IBAction)sendMessage:(id)sender {
    if (_block) {
        _block(sender);
    }
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (string.length == 0) {
        return YES;
    }
    
    
    return YES;
}
- (IBAction)close:(id)sender {
    
    if (_block) {
        _block(sender);
    }
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
