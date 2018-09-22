//
//  PublishWLOne.m
//  iwant
//
//  Created by 公司 on 2017/4/6.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "PublishWLOne.h"
@interface PublishWLOne ()
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *weightL;
@property (weak, nonatomic) IBOutlet UILabel *squreL;

@end

@implementation PublishWLOne

-(void)awakeFromNib{
    [super awakeFromNib];
    [self.nameL setAttributedText:[self creatLabelText:@"* 物品名称："]];
    [self.timeL setAttributedText:[self creatLabelText:@"* 期望到达日期"]];
    [self.weightL setAttributedText:[self creatLabelText:@"* 重量："]];
    [self.squreL setAttributedText:[self creatLabelText:@"* 体积："]];
    
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

//出发地
- (IBAction)locatStartBtn:(UIButton *)sender {
    if(_BlockOne){
        _BlockOne(sender,1);
    }
}
//目的地
- (IBAction)endPlaceBtn:(UIButton *)sender {
    if(_BlockOne){
        _BlockOne(sender,2);
    }
}
//时间选择
- (IBAction)timeSelectBtn:(UIButton *)sender {
    if(_BlockOne){
        _BlockOne(sender,3);
    }
}
//单位选择 吨或者 公斤
- (IBAction)danweiSelectBtn:(UIButton *)sender {
    if (_BlockOne) {
        _BlockOne(sender,4);
     }
}
//下一步
- (IBAction)nextBtnClick:(UIButton *)sender {
    if (_BlockOne) {
        _BlockOne(sender,5);
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

-(void)dealloc{
    [self.locatLabel removeObserver:self forKeyPath:@"text"context:nil];
    [self.endTextField removeObserver:self forKeyPath:@"textEnd"context:nil];
}


@end
