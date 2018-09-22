//
//  FaBiaoPersonView.m
//  iwant
//
//  Created by 公司 on 2017/2/8.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "FaBiaoPersonView.h"
#import "MainHeader.h"

@implementation FaBiaoPersonView

-(void)awakeFromNib{
    if (SCREEN_WIDTH == 320) {
        self.btnDistanceCobstraint.constant = 44;
        self.diatanceConstraint.constant = 44;
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
    self.TopBtn.userInteractionEnabled = NO;
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
- (IBAction)nextView:(UIButton *)sender {
   
    NSLog(@"发件人下一步");
    if (_block) {
        _block(3);
    }
}
- (IBAction)beforeBtn:(UIButton *)sender {
    NSLog(@"收件人上一步");
    if(_block){
        _block(4);
    }
}
- (IBAction)nextBtn:(UIButton *)sender {
    NSLog(@"收件人下一步");
    if(_block){
        _block(5);
    }
}

-(void)dealloc{
    [self.locatLabel removeObserver:self forKeyPath:@"text"context:nil];
}

@end
