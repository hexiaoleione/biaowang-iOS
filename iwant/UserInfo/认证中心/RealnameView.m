//
//  RealnameView.m
//  iwant
//
//  Created by dongba on 16/5/25.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "RealnameView.h"
#import "MainHeader.h"
//#define RATIO_WIDTH             WINDOW_WIDTH /375.0
@interface RealnameView ()
@end
@implementation RealnameView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        
        self.backgroundColor = UIColorFromRGB(0xf5f5f5);
        UILabel * titleLabel = [UILabel new];
        titleLabel.font = FONT(13, NO);
        titleLabel.text = @"请填写您的支付宝账号";
        titleLabel.textColor = UIColorFromRGB(0x666666);
        [self addSubview:titleLabel];
        
        UIView *backView = [UIView new];
        backView.backgroundColor = UIColorFromRGB(0xffffff);
        [self addSubview:backView];
        
        UIView *firstLine = [UIView new];
        firstLine.backgroundColor = UIColorFromRGB(0xd6d6d6);
        [self addSubview:firstLine];
        
        UILabel *nameTitle = [UILabel new];
        nameTitle.textColor = [UIColor blackColor];
        nameTitle.font = FONT(13, NO);
        nameTitle.text = @"真实姓名";
        [self addSubview:nameTitle];
        
        UITextField *nameFiled = [[UITextField alloc]init];
        nameFiled.userInteractionEnabled = NO;
        nameFiled.textColor = UIColorFromRGB(0x9a9a9a);
        nameFiled.font = FONT(13, NO);
        nameFiled.text = @"钱川";
        _nameFiled = nameFiled;
        [self addSubview:_nameFiled];
        
        UIButton *nameImg = [UIButton buttonWithType:0];
//        nameImg .image = [UIImage imageNamed:@"green_o"];
        [nameImg setImage:[UIImage imageNamed:@"green_o"] forState:0];
        [nameImg addTarget:self action:@selector(nameAlert) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:nameImg];
        
        UIView *secondLine = [UIView new];
        secondLine.backgroundColor = UIColorFromRGB(0xd6d6d6);
        [self addSubview:secondLine];
        
        UILabel *cardTitle = [UILabel new];
        cardTitle.text = @"支付宝账号";
        cardTitle.font = FONT(13, NO);
        cardTitle.textColor = [UIColor blackColor];
        [self addSubview:cardTitle];
        
        UITextField *cardFiled = [UITextField new];
        cardFiled.textColor = UIColorFromRGB(0x9a9a9a);
        cardFiled.font = FONT(13, NO);
        cardFiled.keyboardType = UIKeyboardTypeNumberPad;
        _cardNoFiled = cardFiled;
        [self addSubview:_cardNoFiled];
        
        UIButton *cameraImage = [UIButton buttonWithType:0];
        [cameraImage setImage:[UIImage imageNamed:@"carm_bar48"] forState:0];
        [cameraImage addTarget:self action:@selector(scan) forControlEvents:UIControlEventTouchUpInside];
//        cameraImage.image = [UIImage imageNamed:@"carm_bar48"];
        [self addSubview:cameraImage];
        
        UIView *thirdLine = [UIView new];
        thirdLine.backgroundColor = UIColorFromRGB(0xd6d6d6);
        [self addSubview:thirdLine];
        
        UIButton *nextBtn = [UIButton buttonWithType:0];
        nextBtn.backgroundColor = COLOR_ORANGE_DEFOUT;
        [nextBtn setTitle:@"提交" forState:0];
        [nextBtn setTitleColor:[UIColor whiteColor] forState:0];
        [self addSubview:nextBtn];
        
        static CGFloat backViewHeight = 80;
        static CGFloat textFieldHeight = 40;
        titleLabel.sd_layout.leftSpaceToView(self,23).widthIs(286).heightIs(25).topSpaceToView(self,20);
        backView.sd_layout.leftEqualToView(self).rightEqualToView(self).topSpaceToView(titleLabel,5).heightIs(backViewHeight *RATIO_HEIGHT);
        firstLine.sd_layout.leftEqualToView(self).rightEqualToView(self).topEqualToView(backView).heightIs(1);
        nameTitle.sd_layout.leftSpaceToView(self,23).topSpaceToView(firstLine,0).widthIs(55).heightIs(textFieldHeight *RATIO_HEIGHT);
        _nameFiled.sd_layout.leftSpaceToView(nameTitle,15).rightEqualToView(self).topEqualToView(backView).bottomEqualToView(nameTitle);
        nameImg.sd_layout.rightSpaceToView(self,25).centerYEqualToView(_nameFiled).widthIs(30).heightIs(30);
        secondLine.sd_layout.leftSpaceToView(self,23).rightSpaceToView(self,0).topSpaceToView(nameTitle,0).heightIs(1);
        cardTitle.sd_layout.leftEqualToView(nameTitle).widthRatioToView(nameTitle,1).topSpaceToView(secondLine,0).heightRatioToView(nameTitle,1);
        _cardNoFiled.sd_layout.leftSpaceToView(cardTitle,15).rightSpaceToView(self,0).topSpaceToView(secondLine,0).bottomEqualToView(cardTitle);
        cameraImage.sd_layout.rightSpaceToView(self,25).centerYEqualToView(_cardNoFiled).widthIs(30).heightIs(30);
        thirdLine.sd_layout.leftEqualToView(self).rightEqualToView(self).topSpaceToView(backView,0).heightIs(1);
        nextBtn.sd_layout.centerXEqualToView(self).topSpaceToView(thirdLine,32).widthIs(270 *RATIO_WIDTH).autoHeightRatio(0.15);
        [nextBtn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
        nextBtn.sd_cornerRadius = @10;

    }
    
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
}

-(void)nameAlert{
    NSLog(@"姓名提示");
    if (_block) {
        _block(0);
    }
}
-(void)scan{
    NSLog(@"扫描银行卡");
    if (_block) {
        _block(1);
    }
}
-(void)next{
    NSLog(@"下一步");
    if (_block) {
        _block(2);
    }
}
- (void)setName:(NSString *)name{
    _nameFiled.text = name;
}
- (void)setCardNo:(NSString *)cardNo{
    _cardNoFiled.text = cardNo;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
