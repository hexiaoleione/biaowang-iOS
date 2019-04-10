//
//  ShareView.m
//  iwant
//
//  Created by dongba on 16/4/2.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "ShareView.h"
#import "SVProgressHUD.h"
/*   <!-- 应用规范字体大小 -->*/
#define  text_size_big_1    21
#define  text_size_big_2    20
#define  text_size_big_3    19
#define  text_size_middle_1 18
#define  text_size_middle_2 17
#define  text_size_middle_3 15
#define  text_size_little_1 14
#define  text_size_little_2 13
#define  text_size_little_3 12
#define  text_size_little_4 10
#define  text_size_other    16

#define  AppFont(c_font) [UIFont systemFontOfSize:c_font]
#define ApplicationframeValue [[UIScreen mainScreen]bounds].size


//**提示框宏定义
CG_INLINE void AlertLog (NSString *titleStr,NSString *message,NSString *button1,NSString *button2)
{
    if(!titleStr)
        titleStr = @"";
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: titleStr
                                                        message: message
                                                       delegate: nil
                                              cancelButtonTitle: button1
                                              otherButtonTitles: button2,
                              nil];
    [alertView show];
    
}
@interface ShareView ()
@property (nonatomic,strong)NSArray *imageArr;
@property (nonatomic,strong)NSArray *titleArr;

@end


@implementation ShareView


-(NSArray *)imageArr
{
    
    if (!_imageArr) {
        if (_types == 0) {
            _imageArr = [NSArray arrayWithObjects:@"share_pengyouquan",@"share_wechat",@"share_qq",@"qzone",nil];
        }else {
         
            _imageArr = [NSArray arrayWithObjects:@"share_pengyouquan",@"share_wechat",nil];
        }
    }
    return _imageArr;
}

-(NSArray *)titleArr
{
    
    if (!_titleArr) {
        
        if (_types == 0) {
           
             _titleArr = [NSArray arrayWithObjects:@"朋友圈",@"微信好友",@"QQ好友",@"QQ空间",nil];
        }else {
            
             _titleArr = [NSArray arrayWithObjects:@"朋友圈",@"微信好友",nil];
        }
        
       
    }
    return _titleArr;
}

-(id)initWithFrame:(CGRect)frame type:(NSInteger)type dismissOpration:(void (^)(void))dismissfn
{
    _types = type;
    float Margin = ceilf(ApplicationframeValue.width/self.imageArr.count/2);
    
    self = [super initWithFrame:frame];
    if (self) {
        self.disView = dismissfn;
        self.overlayView = [[UIControl alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.overlayView.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.5];
        [self.overlayView addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *viewS = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ApplicationframeValue.width, ApplicationframeValue.height)];
        viewS.backgroundColor =[UIColor whiteColor];
        [self addSubview:viewS];
        /*
        UILabel *TitleLabel = [[UILabel alloc] initWithFrame:CGRectMake((ApplicationframeValue.width-100)/2, 15, 100, 20)];
        TitleLabel.textAlignment = NSTextAlignmentCenter;
        TitleLabel.text = @"分享到";
        TitleLabel.backgroundColor = [UIColor whiteColor];
        TitleLabel.font = AppFont(text_size_other);
        [viewS addSubview:TitleLabel];
        
        UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 45, ApplicationframeValue.width, 1)];
        lineImage.alpha = 0.5f;
        lineImage.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4f];
        [viewS addSubview:lineImage];
        */
        for (int i = 0; i < [self.imageArr count]; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = i +1;
            btn.frame = CGRectMake(Margin/2+2*Margin*i,60, Margin, Margin);
            [btn setBackgroundImage:[UIImage imageNamed:self.imageArr[i]] forState:UIControlStateNormal];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(Margin/2+2*Margin*i, CGRectGetMaxY(btn.frame)+10, Margin, 15)];
            
            label.textAlignment = NSTextAlignmentCenter;
            label.text = self.titleArr[i];
            label.font = AppFont(text_size_little_2);
            label.adjustsFontSizeToFitWidth = YES;
            [btn addTarget:self action:@selector(onBtn:) forControlEvents:UIControlEventTouchUpInside];
            [viewS addSubview:label];
            [viewS addSubview:btn];
        }
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(40, Margin *3, ApplicationframeValue.width-80,80)];
        label.text = @"苹果安卓用户扫描下面二维码即可下载体验 镖王!";
        label.numberOfLines = 0;
        label.textAlignment = 1;
        [self addSubview:label];
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(ApplicationframeValue.width *0.25, CGRectGetMaxY(label.frame)+20, ApplicationframeValue.width *0.5, ApplicationframeValue.width *0.5)];
        
        imgV.image = [UIImage imageNamed:@"erweima"];
        [self addSubview:imgV];
    }
    return self;
}



-(void)onBtn:(UIButton *)sender{
    OSMessage *msg=[[OSMessage alloc] init];
    msg.title =[NSString stringWithFormat:@"镖王"];
    msg.image= [UIImage imageNamed:@"shareIcon"];
    msg.thumbnail = [UIImage imageNamed:@"shareIcon"];
    msg.desc=[NSString stringWithFormat:@"我推荐镖王App，快来安装体验吧!"];
    msg.link=@"http://www.efamax.com/user_dl.html";
    __weak  ShareView *selfView = self;
    switch (sender.tag) {
        case 1:{
            NSLog(@"分享到朋友圈");

            msg.title = @"我推荐镖王App，快来安装体验吧!";
            [OpenShare shareToWeixinTimeline:msg Success:^(OSMessage *message) {
                
                if (selfView.types ==0) {
                   
                     [SVProgressHUD showSuccessWithStatus:@"分享微信朋友圈成功"];
                    
                }else {
                    
                    selfView.disView();
                }
                
               
            } Fail:^(OSMessage *message, NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"取消分享"];
            }];
        }
            
            break;
            
        case 2:{
            
            {
                NSLog(@"分享给微信好友");
                [OpenShare shareToWeixinSession:msg Success:^(OSMessage *message) {
                    
                    if (selfView.types ==0) {
                        
                        [SVProgressHUD showSuccessWithStatus:@"分享给微信好友成功"];
                        
                    }else {
                        
                        selfView.disView();
                    }
                    
                } Fail:^(OSMessage *message, NSError *error) {
                    [SVProgressHUD showErrorWithStatus:@"取消分享"];
                }];
            }
        }
            break;
        case 3:{
            NSLog(@"分享给QQ好友");
            [OpenShare shareToQQFriends:msg Success:^(OSMessage *message) {
                [SVProgressHUD showSuccessWithStatus:@"分享给QQ好友成功"];
            } Fail:^(OSMessage *message, NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"取消分享"];
            }];
        }

            break;
        case 4:{
            NSLog(@"分享给QQ空间");
            [OpenShare shareToQQZone:msg Success:^(OSMessage *message) {
                [SVProgressHUD showSuccessWithStatus:@"分享到QQ空间成功"];

            } Fail:^(OSMessage *message, NSError *error) {
                 [SVProgressHUD showErrorWithStatus:@"取消分享"];
            }];
        }
           break;
        default:
            break;
    }
}

-(void)onCancleBtn{
    
    [self dismiss];
    
}

- (void)show
{
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:self.overlayView];
    [keywindow addSubview:self];
    
    [self fadeIn];
}

- (void)dismiss
{
    [self fadeOut];
}

//弹入层
- (void)fadeIn
{
    
    self.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        
        self.alpha = 1;
        
    }];
    
}

//弹出层
- (void)fadeOut
{
    [UIView animateWithDuration:.35 animations:^{
        
        self.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        if (finished) {
            [self.overlayView removeFromSuperview];
            [self removeFromSuperview];
        }
    }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
