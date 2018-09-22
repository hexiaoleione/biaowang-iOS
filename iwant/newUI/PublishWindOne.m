//
//  PublishWindOne.m
//  iwant
//
//  Created by 公司 on 2017/3/25.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "PublishWindOne.h"
#import "MainHeader.h"
#import "ActionSheetStringPicker.h"

@implementation PublishWindOne
-(void)awakeFromNib{
    [super awakeFromNib];
    
    if (SCREEN_WIDTH ==320) {
        self.topConstraintHeight.constant = 20;
    }
    
    self.backgroundColor = BACKGROUND_COLOR;
    self.startView.layer.cornerRadius = 8;
    self.startView.layer.masksToBounds = YES;
    
    self.deataintView.layer.cornerRadius = 8;
    self.deataintView.layer.masksToBounds = YES;
    
    self.weightView.layer.cornerRadius = 8;
    self.weightView.layer.masksToBounds = YES;
    
    self.timeView.layer.cornerRadius = 8;
    self.timeView.layer.masksToBounds = YES;
    
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
    
    //设置为YES时文本会自动缩小以适应文本窗口大小.默认是保持原来大小,而让长文本滚动
    self.startTextField.adjustsFontSizeToFitWidth = YES;
//    self.startTextField.minimumFontSize = 8;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"text"]) {
//        NSLog(@"self.locatLabel.text发生变化");
        if (self.locatLabel.text.length >0) {
            self.locatLabel.backgroundColor = [UIColor whiteColor];
        }else{
            self.locatLabel.backgroundColor = [UIColor clearColor];
        }
    }else{
        NSLog(@"self.locatLabel.text发生变化");
        if (self.endLocatLabel.text.length >0) {
            self.endLocatLabel.backgroundColor = [UIColor whiteColor];
        }else{
            self.endLocatLabel.backgroundColor = [UIColor clearColor];
        }
    }
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

//限制时间选择
- (IBAction)timeSelected:(UIButton *)sender {
    if (_BlockOne) {
        _BlockOne(4);
    }
}
- (IBAction)weightSelected:(UIButton *)sender {
    
    _arr =[[NSMutableArray alloc]init];
    NSString * str = @"5kg以下";
    [_arr addObject:str];
    for (int i = 0; i<45; i++) {
        NSString  * str =[NSString stringWithFormat:@"%d kg",i+6];
        [_arr addObject:str];
    }
    
    [ActionSheetStringPicker showPickerWithTitle:@"物品重量" rows:_arr initialSelection:0 target:self successAction:@selector(timeWasSelected:element:sender:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
}

-(void)timeWasSelected:(NSNumber *)selectedIndex element:(id)element sender: (UIButton*) btn {
    
    
    if (_BlockOne) {
        _BlockOne(5);
    }

   //    self.weightTextField = [_arr objectAtIndex:[selectedIndex intValue]];
    NSString * weight = [NSString stringWithFormat:@"%d",[selectedIndex intValue]+5];
    if (_WeightBlock) {
        _WeightBlock([_arr objectAtIndex:[selectedIndex intValue]],weight);
    }
    self.kgDanwei.hidden = YES;
}
- (void)actionPickerCancelled:(id)sender {
    
}


-(void)dealloc{
    [self.locatLabel removeObserver:self forKeyPath:@"text"context:nil];
    [self.endTextField removeObserver:self forKeyPath:@"textEnd"context:nil];
}



@end
