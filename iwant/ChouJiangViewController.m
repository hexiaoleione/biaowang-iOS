//
//  ChouJiangViewController.m
//  iwant
//
//  Created by 公司 on 2016/11/22.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "ChouJiangViewController.h"
#import "HYPWheelView.h"
#import  "EcoinWebViewController.h"
#import "ExchangeJiFenVC.h"
@interface ChouJiangViewController ()

@property (nonatomic, weak) HYPWheelView *wheelView;

@end

@implementation ChouJiangViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getPageInfo];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 60)];
    label.textColor = [UIColor whiteColor];
    label.text = @"抽奖";
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
    //奖池金额
//    [self getPageInfo];
    
    self.wheelView = [HYPWheelView wheelView];
    _wheelView.choujiangVc = self;
    _wheelView.x = 50*(SCREEN_WIDTH/375);
    _wheelView.y = self.ecionLabel.bottom + 20;
    _wheelView.width = _wheelView.height = SCREEN_WIDTH-2*_wheelView.x;
    _wheelView.block =^(){
        ExchangeJiFenVC * vc =[[ExchangeJiFenVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    };
    [self.scrollView addSubview:_wheelView];
}


//获取剩余的积分数
-(void)getPageInfo{
    
    NSString *URLStr = [NSString stringWithFormat:@"%@luckydraw/drawPage?userId=%@",BaseUrl,[UserManager getDefaultUser].userId];
    [ExpressRequest sendWithParameters:nil MethodStr:URLStr reqType:k_GET success:^(id object) {
        NSDictionary * dict = [object objectForKey:@"data"][0];
        
        self.ecionLabel.text = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"eCoin"] stringValue]];
        
        int min = [[dict objectForKey:@"luckyTime"] intValue];

        if ((min == 0) || (min == nil)) {
        
            self.wheelView.IsEnd = YES;
            self.wheelView.timeLabel.hidden = YES;
        }else{
//           self.wheelView.timeLabel.hidden = NO;
//           self.wheelView.IsEnd  = NO; 
            [self.wheelView startWithSeconds:min];
        }
        
    } failed:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
        
    }];    
}

- (IBAction)goToRuleWeb:(UIButton *)sender {
    
    EcoinWebViewController *vc = [[EcoinWebViewController alloc]init];
    vc.web_type = WEB_LUCK_RULE;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
@end
