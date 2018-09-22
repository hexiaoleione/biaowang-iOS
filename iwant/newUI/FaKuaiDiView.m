//
//  FaKuaiDiView.m
//  iwant
//
//  Created by 公司 on 2017/2/13.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "FaKuaiDiView.h"
#import "MainHeader.h"

@implementation FaKuaiDiView

-(void)awakeFromNib{
    if (SCREEN_WIDTH == 320) {
        self.diatanceConstraint.constant = 22;
    }
    self.backgroundColor = BACKGROUND_COLOR;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(locatBtn:)];
    [self.locatLabel addGestureRecognizer:tap];
    
    self.sendView.layer.cornerRadius = 5;
    self.sendView.layer.borderColor = [UIColorFromRGB(0xf5f5f5) CGColor];
    self.sendView.layer.borderWidth = 1;
    self.sendView.layer.masksToBounds = YES;
    
    self.locatLabel.textAlignment = NSTextAlignmentLeft;
    self.locatLabel.font = [UIFont systemFontOfSize:14];
    self.locatLabel.type = XPQScrollLabelTypeBan;
    
    [self.locatLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    
    [super awakeFromNib];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"text"]) {
        NSLog(@"self.locatLabel.text发生变化");
        if (self.locatLabel.text.length >0) {
            self.locatLabel.backgroundColor = [UIColor whiteColor];
        }else{
            self.locatLabel.backgroundColor = [UIColor clearColor];
        }
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
}
- (IBAction)topBtnClick:(id)sender {
    NSLog(@"晋级镖师Btn");
    if (_block) {
        _block(0);
    }
}

- (IBAction)toConneterList:(UIButton *)sender {
    NSLog(@"手机联系人");
    if (_block) {
        _block(1);
    }
}

- (IBAction)locatBtn:(id )sender {
    NSLog(@"点位");
    if (_block) {
        _block(2);
    }
}


- (IBAction)addFajianren:(UIButton *)sender {
    NSLog(@"添加发件人");
    if (_block) {
        _block(3);
    }
}

- (IBAction)selectKuaidiyuan:(UIButton *)sender {
    NSLog(@"选择快递员");
    if (_block) {
        _block(4);
    }
}


- (IBAction)phoneNotice:(UIButton *)sender {
    //打电话通知
    if (_block) {
        _block(5);
    }
}



-(void)dealloc{
    [self.locatLabel removeObserver:self forKeyPath:@"text"context:nil];
}
@end
