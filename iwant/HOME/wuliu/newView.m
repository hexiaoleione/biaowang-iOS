
//
//  newView.m
//  iwant
//
//  Created by 公司 on 2016/12/20.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "newView.h"
#import "MainHeader.h"
@implementation newView
-(void)awakeFromNib{
    [super awakeFromNib];
    self.detailView.layer.cornerRadius = 5;
    self.detailView.clipsToBounds = YES;
    self.baoJiaBtn.layer.cornerRadius = 10;
    self.baoJiaBtn.clipsToBounds = YES;
    [self.baoJiaBtn setBackgroundColor:COLOR_MainColor];
    _quhuoFree.delegate = self;
    _songhuoFree.delegate = self;
    _costLabel.delegate = self;

}

-(void)hiddenGet:(BOOL)hiddenGet
      hiddenSend:(BOOL)hiddenSend
{
    if (!hiddenGet) {
        _topConstraint.constant = 0;
        _getConstraint.constant = 0;
        _inputGetConstraint.constant = 0;
        _danweiTake.constant = 0;
    }else{
        _getConstraint.constant = 16;
        _inputGetConstraint.constant = 30;
    }
    if (!hiddenSend) {
        _distanceConstraint.constant = 8;
        _sendConstraint.constant = 0;
        _inputSendConstraint.constant = 0;
        _danweiSend.constant = 0;
    }else{
        _sendConstraint.constant = 16;
        _inputSendConstraint.constant = 30;
    }
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    NSString * str = [NSString stringWithFormat:@"%d", [_quhuoFree.text intValue] + [_songhuoFree.text intValue] +[_costLabel.text intValue]];
    _totalFree.text = str;
    
    return YES;
}

-(void) setData:(id)data{
    
}
@end
