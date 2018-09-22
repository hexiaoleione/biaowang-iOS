//
//  LDInputView.m
//  PasswordDemo
//
//  Created by dongba on 16/6/2.
//  Copyright © 2016年 bing. All rights reserved.
//

#import "LDInputView.h"
#import "UIView+Layout.h"
#define RATIO       self.bounds.size.height/736.0

@implementation LDInputView


- (instancetype)initWithTitle:(NSString *)title frame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.1];
        
        UIView *bgView = [UIView new];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.layer.cornerRadius = 3.;
        [self addSubview:bgView];
        bgView.frame = CGRectMake(10, 150*RATIO, self.bounds.size.width -20,200*RATIO);
        bgView.layer.masksToBounds = YES;
        
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        
        [bgView addSubview:_titleLabel];
        if (title) {
            _titleLabel.text = title;
        }else{
            _titleLabel.text = @"请输入密码";
        }
        _titleLabel.top  = 5*RATIO;
        _titleLabel.size = CGSizeMake(self.bounds.size.width -40, 40*RATIO);
        _titleLabel.centerX = bgView.centerX;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        
        
        UIButton *closeBtn = [UIButton buttonWithType:0];
        [closeBtn setImage:[UIImage imageNamed:@"close"] forState:0];
        [closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:closeBtn];
        closeBtn.frame = CGRectMake(bgView.bounds.size.width - 5*RATIO - 30*RATIO , 5*RATIO, 30*RATIO, 30*RATIO);
        closeBtn.centerY = _titleLabel.centerY;
        
        UIView *line = [UIView new];
        line.backgroundColor = [UIColor colorWithRed:178/255.0 green:178/255.0 blue:178/255.0 alpha:0.8];
        [bgView addSubview:line];
        line.frame = CGRectMake(0, 50*RATIO, self.bounds.size.width, 0.5);
        
        _passView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([PasswordView class]) owner:nil options:nil].lastObject;
        __weak LDInputView *weakSelf = self;
        _passView.textChangedBlock = ^(NSString *passWord){
            
            if (weakSelf.passWordBlock) {
               weakSelf.passWordBlock(passWord);
                [weakSelf.passView cleanLastState];
//                [weakSelf removeFromSuperview];
            }
        };
        
        _passView.size = CGSizeMake(264, 44);
        
        _passView.centerY = 260*RATIO;
        _passView.centerX = self.centerX;
        [self addSubview:_passView];
        
        UIButton *forgetPwd = [UIButton buttonWithType:0];
        [forgetPwd setTitleColor:[UIColor blueColor] forState:0];
        [forgetPwd setTitle:@"忘记密码？" forState:0];
        forgetPwd.titleLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:forgetPwd];
        forgetPwd.centerY = 280*RATIO;
        forgetPwd.centerX = self.centerX;
        forgetPwd.size = CGSizeMake(240, 44);
        [forgetPwd addTarget:self action:@selector(forgetPWD) forControlEvents:UIControlEventTouchUpInside];
//        [forgetPwd.titleLabel sizeToFit];
//        forgetPwd.titleLabel.textAlignment = 2;
        
        
    }

    return self;
}


- (instancetype)initWithSettingTitle:(NSString *)settingtitle frame:(CGRect)frame;{
    if (self = [self initWithTitle:settingtitle frame:frame]) {
        __weak LDInputView *weakSelf = self;
        _passView.textChangedBlock = ^(NSString *passWord){
            
            if (weakSelf.settingPassWordBlock) {
                    if (!weakSelf.firstPassWord) {
                        weakSelf.firstPassWord = passWord;
                        [weakSelf.passView cleanLastState];
                        weakSelf.titleLabel.text = @"请验证您输入的密码";
                    }else{
                        if ([passWord isEqualToString: weakSelf.firstPassWord]) {
                            //密码设置成功
                            weakSelf.settingPassWordBlock(passWord);
                            [weakSelf removeFromSuperview];
                        }else{
                            //两次密码不一致，重新输入
                            weakSelf.titleLabel.text = @"请重新设置密码";
                           
                        }
                        weakSelf.firstPassWord = nil;
                        [weakSelf.passView cleanLastState];
                    }
                
            }
        };
    }
    

    return self;
}
-(void)close{
    [self removeFromSuperview];
}
- (void)cleanLastState{
    [_passView cleanLastState];
}

- (void)forgetPWD{
    if (_passWordBlock) {
        _passWordBlock(nil);
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    
    
    
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
