//
//  HYPWheelView.m
//  彩票
//
//  Created by huangyipeng on 14-8-17.
//  Copyright (c) 2014年 HYP. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "HYPWheelView.h"
#import "UserManager.h"
#import "HHAlertView.h"
#import "Calculagraph.h"
#import "ChouJiangViewController.h"
#import<libkern/OSAtomic.h>

//计时器
@interface HYPWheelView ()<CAAnimationDelegate>{
    
//    BOOL  IsEnd; //是否结束
      int errNumber;
}

@property (weak, nonatomic) IBOutlet UIView *centerView;
// 按钮初始化时的角度
@property (nonatomic, assign) CGFloat angle;

@property(nonatomic,assign) NSInteger  tatolNum;
@property(nonatomic,assign) NSInteger  toNum;
@property(nonatomic,assign) NSInteger drawLevel;//中奖等级
@property (nonatomic,strong) NSString * message;

@property (nonatomic,strong)NSString * recId;

@end


@implementation HYPWheelView

- (void)awakeFromNib
{
    [super awakeFromNib];
//    [self.centerBtn setImage:[UIImage imageNamed:@"centerBtn.png"] forState:UIControlStateSelected];
    self.angle = 0;
    
    [self.centerBtn addSubview:_timeLabel];
//    self.timeLabel.hidden = YES;
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Calculagraph:) name:@"Calculagraph" object:nil];
}

+ (instancetype)wheelView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"LuckyWheel" owner:nil options:nil] lastObject];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self bringSubviewToFront:self.centerBtn];
}


- (IBAction)startSelectNumber {
    
    self.centerBtn.userInteractionEnabled = NO;
    
    if (_IsEnd) {
        
        //开始执行Btn请求方法
        [self toPointPost];
    }else{
        //计时还未结束
        self.centerBtn.userInteractionEnabled = YES;
       [SVProgressHUD showInfoWithStatus:@"请耐心等待倒计时结束再开始~"];
   }
}

-(void)toPointPost{
    //指定转到哪里
    NSString *URLStr = [NSString stringWithFormat:@"%@luckydraw/luckyDial?userId=%@",BaseUrl,[UserManager getDefaultUser].userId];
    [ExpressRequest sendWithParameters:nil MethodStr:URLStr reqType:k_GET success:^(id object) {
        NSDictionary * dict = [object objectForKey:@"data"][0];
        
        self.tatolNum = 10;
        // Integer position;//转盘转到的格数
        self.toNum = [[dict objectForKey:@"position"] integerValue];
        self.drawLevel = [[dict objectForKey:@"drawLevel"] integerValue];
        self.ecoinStr = [[dict objectForKey:@"ecoin"] stringValue];
        self.recId = [[dict objectForKey:@"recId"] stringValue];
        
        [self AnimationStart];
        
        self.message =[object valueForKey:@"message"];
        
    } failed:^(NSString *error) {
        _IsEnd = YES;
        self.centerBtn.userInteractionEnabled = YES;
        int errCode = [[[NSUserDefaults standardUserDefaults] objectForKey:@"errCode"] intValue];
        if (errCode == -4)
        {
            if (_block) {
                _block();
            }
        }else{
            [SVProgressHUD showErrorWithStatus:error];
        }
   }];
}

//获取页面上的积分的剩余数量
-(void)getPageInfo{
    
    NSString *URLStr = [NSString stringWithFormat:@"%@luckydraw/drawPage?userId=%@",BaseUrl,[UserManager getDefaultUser].userId];
    [ExpressRequest sendWithParameters:nil MethodStr:URLStr reqType:k_GET success:^(id object) {
        NSDictionary * dict = [object objectForKey:@"data"][0];
        
//            //积分修改UI
        self.choujiangVc.ecionLabel.text= [NSString stringWithFormat:@"%@",[[dict objectForKey:@"eCoin"] stringValue]];
        
        [self startWithSeconds:[[dict objectForKey:@"luckyTime"] intValue]];

        if ([[dict objectForKey:@"luckyTime"] intValue] == 0) {
            _IsEnd = YES;
            _timeLabel.hidden = YES;
            [self.centerBtn setImage:[UIImage imageNamed:@"centerBtn.png"] forState:UIControlStateNormal];
            
        }else{
            [self startWithSeconds:[[dict objectForKey:@"luckyTime"] intValue]];
        }
        
        
    } failed:^(NSString *error) {
    
        [SVProgressHUD showErrorWithStatus:error];
    }];
    
}



//核心动画
-(void)AnimationStart{
    
    //每个格的角度
    CGFloat fraction = 2*M_PI/_tatolNum;
    CGFloat toValue = (_tatolNum-_toNum)*fraction;
    _angle = toValue;
    toValue = 6*M_PI +toValue;
    // 禁止交互
    self.userInteractionEnabled = NO;
    
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.rotation";
    // 计算核心动画旋转的角度
    animation.toValue = @(toValue);
    animation.fromValue = @(_angle);
    animation.duration = 3;  //执行时间
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    animation.delegate = self;
    //核心动画添加到layer上边
    [self.centerView.layer addAnimation:animation forKey:@"animation"];
}

//动画结束时的代理
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self.centerView.layer removeAnimationForKey:@"animation"];
    [self.centerView.layer setValue:@(_angle) forKeyPath:@"transform.rotation.z"];
    self.userInteractionEnabled = YES;
    self.centerBtn.userInteractionEnabled = YES;
    HHAlertView *alert = [[HHAlertView alloc]initWithTitle:@"温馨提示" detailText:self.message cancelButtonTitle:@"确定" otherButtonTitles:nil];
    alert.mode = HHAlertViewModeWarning;
    [alert showWithBlock:^(NSInteger index) {
        
        if (index == 0) {
            if (self.drawLevel != 10) {
                [self lingJiangAlert];
            }
        }
    }];
    
    [alert show];

    [self.centerBtn setImage:[UIImage imageNamed:@"centerbtnNone@2x"] forState:UIControlStateNormal];
    [self getPageInfo];

}


//领奖
-(void)lingJiangAlert{
    
    
    NSString *URLStr = [NSString stringWithFormat:@"%@luckydraw/award?userId=%@&drawLevel=%ld&recId=%@",BaseUrl,[UserManager getDefaultUser].userId,self.drawLevel,self.recId];
    [ExpressRequest sendWithParameters:nil MethodStr:URLStr reqType:k_GET success:^(id object) {
        
        NSString * str = [object valueForKey:@"message"];

        [SVProgressHUD showInfoWithStatus:str];
        
    } failed:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];

}


- (void)startWithSeconds:(int)seconds
{
    [self.centerBtn setImage:[UIImage imageNamed:@"centerbtnNone@2x"] forState:UIControlStateNormal];

    __block typeof(self)bself = self;
    _timeLabel.hidden = NO;

    _IsEnd = NO;
    __block int32_t timeOutCount=seconds;
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1ull * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        OSAtomicDecrement32(&timeOutCount);
        bself.timeLabel.text =[NSString stringWithFormat:@"%d秒",timeOutCount];
        if (timeOutCount == 0) {
            NSLog(@"timersource cancel");
            _timeLabel.hidden = YES;
            _IsEnd = YES;
            [self.centerBtn setImage:[UIImage imageNamed:@"centerBtn.png"] forState:UIControlStateNormal];

            dispatch_source_cancel(timer);
        }
    });
    
    dispatch_source_set_cancel_handler(timer, ^{
        NSLog(@"timersource cancel handle block");
    });
    
    dispatch_resume(timer);
}


@end
