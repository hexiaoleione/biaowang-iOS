//
//  baojiaView.m
//  iwant
//
//  Created by 公司 on 2016/11/29.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "baojiaView.h"

@interface baojiaView ()
<
UITextFieldDelegate
>
{
    int qu;
    int song;
    int trans;
}
@end

@implementation baojiaView


-(void)awakeFromNib{
    [super awakeFromNib];
    
    _quhuoFree.delegate = self;
    _songhuoFree.delegate = self;
    _transforMoney.delegate = self;
}

/*
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //字符串输入结果
    NSString *str = textField.text;
    if (string.length>0) {
        str = [str stringByAppendingString:string];
    }else{
        str = [str substringToIndex:str.length-1];
    }
//    //判断是否超过小数点
//    NSRange ran = [str rangeOfString:@"."];
//    if (NSNotFound == ran.location) {
//        //没有小数点
//    }else{
//        //有小数点
//        if (range.location - ran.location>2) {
//            //超过两位数
//            return NO;
//        }
//    }
       
    //判断是谁
    switch (textField.tag) {
        case 0:
            qu = [str intValue];
            break;
        case 1:
            song = [str intValue];
            break;
        case 2:
            trans = [str intValue];
            break;
        default:
            break;
    }
    [self updateTotalLabel];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSString *str ;
    switch (textField.tag) {
        case 0:
            str = [NSString stringWithFormat:@"%d",qu];
            break;
        case 1:
            str = [NSString stringWithFormat:@"%d",song];
            break;
        case 2:
            str = [NSString stringWithFormat:@"%d",trans];
            break;
        default:
            break;
    }
    textField.text = str;
}
 */
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    NSString * str = [NSString stringWithFormat:@"%d", [_quhuoFree.text intValue] + [_songhuoFree.text intValue] +[_transforMoney.text intValue]];
    _totalMoney.text = str;
   
    return YES;
}
-(void)updateTotalLabel{
    NSString *resStr = [NSString stringWithFormat:@"%d",qu+song+trans];
    _totalMoney.text = resStr;
}

@end
