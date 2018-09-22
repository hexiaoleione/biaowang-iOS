
//
//  PublishSFOne.m
//  iwant
//
//  Created by 公司 on 2017/4/1.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "PublishSFOne.h"
#import "MainHeader.h"
#import "ActionSheetStringPicker.h"
@implementation PublishSFOne

-(void)awakeFromNib{
    [super awakeFromNib];
    if (SCREEN_WIDTH == 320) {
        self.topDistanceConstraint.constant = 11;
    }
    [self.goodsnameL setAttributedText:[self creatLabelText:@"* 物品名称："]];
    [self.weightL setAttributedText:[self creatLabelText:@"* 重量"]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(locatStartBtn:)];
    [self.locatLabel addGestureRecognizer:tap];
    self.locatLabel.textAlignment = NSTextAlignmentLeft;
    self.locatLabel.font = [UIFont systemFontOfSize:14];
    self.locatLabel.type = XPQScrollLabelTypeBan;
    
    [self.locatLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    
    UITapGestureRecognizer *tapTwo = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endPlaceBtn:)];
    
    [self.endLocatLabel addGestureRecognizer:tapTwo];
    self.endLocatLabel.textAlignment = NSTextAlignmentLeft;
    self.endLocatLabel.font = [UIFont systemFontOfSize:14];
    self.endLocatLabel.type = XPQScrollLabelTypeBan;
    
    [self.endTextField addObserver:self forKeyPath:@"textEnd" options:NSKeyValueObservingOptionNew context:nil];

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"text"]) {
        if (self.locatLabel.text.length >0) {
            self.locatLabel.backgroundColor = [UIColor whiteColor];
        }else{
            self.locatLabel.backgroundColor = [UIColor clearColor];
        }
    }else{
//        NSLog(@"self.locatLabel.text发生变化");
        if (self.endLocatLabel.text.length >0) {
            self.endLocatLabel.backgroundColor = [UIColor whiteColor];
        }else{
            self.endLocatLabel.backgroundColor = [UIColor clearColor];
        }
    }
}




-(NSMutableAttributedString *)creatLabelText:(NSString *)text{
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc]initWithString:text attributes:@{NSKernAttributeName:@(0.)}];
    //设置某写字体的颜色
    //NSForegroundColorAttributeName 设置字体颜色
    NSRange blueRange = NSMakeRange([[str string] rangeOfString:@"*"].location, [[str string] rangeOfString:@"*"].length);
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:blueRange];
    return str;
}


//出发地 定位
- (IBAction)locatStartBtn:(UIButton *)sender {
    if (_BlockOne) {
        _BlockOne(1);
    }
}

//目的地定位
- (IBAction)endPlaceBtn:(UIButton *)sender {
    if (_BlockOne) {
        _BlockOne(2);
    }
}

//下一步
- (IBAction)nextBtnClick:(UIButton *)sender {
    if (_BlockOne) {
        _BlockOne(3);
    }
}

//车长选择
- (IBAction)carLengthBtnClick:(UIButton *)sender {
    _carLengthArr = @[@"无",@"1.8米",@"2.7米",@"4.2米"];
    [ActionSheetStringPicker showPickerWithTitle:@"车长需求" rows:_carLengthArr initialSelection:0 target:self successAction:@selector(squreSelected:element:sender:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
}

-(void)squreSelected:(NSNumber *)selectedIndex element:(id)element sender: (UIButton*) btn {
//    if (_BlockOne) {
//        _BlockOne(4);
//    }
    self.carLengthTextField.text = [_carLengthArr objectAtIndex:[selectedIndex intValue]];
    if (_BlockCarLength) {
        _BlockCarLength([NSString stringWithFormat:@"%d",[selectedIndex intValue]+1]);
    }
}

//体积选择
- (IBAction)goodsSqureBtnClick:(UIButton *)sender {
   _squreArr = [[NSMutableArray alloc]init];
    [_squreArr addObject:@"1 立方米以下"];
    for (int i = 0; i<20; i++) {
        NSString * string =[NSString stringWithFormat:@"%d 立方米",i+1];
        [_squreArr addObject:string];
    }
     [ActionSheetStringPicker showPickerWithTitle:@"物品体积" rows:_squreArr initialSelection:0 target:self successAction:@selector(timeWasSelected:element:sender:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
}
-(void)timeWasSelected:(NSNumber *)selectedIndex element:(id)element sender: (UIButton*) btn {
        
    self.goodsSqureTextField.text = [_squreArr objectAtIndex:[selectedIndex intValue]];
    if (_BlockMatVolume) {
        _BlockMatVolume([NSString stringWithFormat:@"%@",[_squreArr objectAtIndex:[selectedIndex intValue]]]);
    }

}
- (void)actionPickerCancelled:(id)sender {
    
}

-(void)dealloc{
    [self.locatLabel removeObserver:self forKeyPath:@"text"context:nil];
    [self.endTextField removeObserver:self forKeyPath:@"textEnd"context:nil];
}



@end
