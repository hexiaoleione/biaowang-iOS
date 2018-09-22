//
//  PublishWLTwo.m
//  iwant
//
//  Created by 公司 on 2017/4/6.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "PublishWLTwo.h"
#import "MainHeader.h"
#import "ActionSheetStringPicker.h"

@implementation PublishWLTwo

-(void)awakeFromNib{
    [super awakeFromNib];
    self.ZiTiRemarkTextField.font = FONT(13, NO);
}
//发件人通讯录
- (IBAction)sendBtnClick:(UIButton *)sender {
    if (_BlockTwo) {
        _BlockTwo(1);
    }
}

//收件人通讯录
- (IBAction)receiveBtnClick:(UIButton *)sender {
    if (_BlockTwo) {
        _BlockTwo(2);
    }
}

//上门取货  送到货场
- (IBAction)takeCargoBtn:(UIButton *)sender {
    _arr =[[NSArray alloc]init];
    _arr = @[@"送到货场",@"上门取货"];
    [ActionSheetStringPicker showPickerWithTitle:@"" rows:_arr initialSelection:0 target:self successAction:@selector(timeWasSelected:element:sender:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
}
-(void)timeWasSelected:(NSNumber *)selectedIndex element:(id)element sender: (UIButton*) btn {
    if (_BlockTwo) {
        _BlockTwo(3);
    }
    self.labelOne.text = _arr[[selectedIndex intValue]];
    if (_QuHuoBlock) {
        _QuHuoBlock([NSString stringWithFormat:@"%d",[selectedIndex intValue]]);
    }
}
- (void)actionPickerCancelled:(id)sender {
    
}


//送货上门
- (IBAction)sendCargoBtn:(UIButton *)sender {
    _arrTwo =[[NSArray alloc]init];
    _arrTwo = @[@"用户自提",@"送货上门"];
    [ActionSheetStringPicker showPickerWithTitle:@"" rows:_arrTwo initialSelection:0 target:self successAction:@selector(NeedWasSelected:element:sender:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
}

-(void)NeedWasSelected:(NSNumber *)selectedIndex element:(id)element sender: (UIButton*) btn {
    if (_BlockTwo) {
        _BlockTwo(4);
    }
        self.labelTwo.text = _arrTwo[[selectedIndex intValue]];
    if ([selectedIndex intValue] == 1) {
        self.ZiTiRemark.hidden = YES;
    }else{
        self.ZiTiRemark.hidden = NO;
    }
    if (_SongHuoBlock) {
        _SongHuoBlock([NSString stringWithFormat:@"%d",[selectedIndex intValue]]);
    }

}
//上一步
- (IBAction)beforeBtnClick:(UIButton *)sender {
    if (_BlockTwo) {
        _BlockTwo(5);
    }
}

//发布
- (IBAction)sureBtn:(UIButton *)sender {
    if (_BlockTwo) {
        _BlockTwo(6);
    }
}


@end
