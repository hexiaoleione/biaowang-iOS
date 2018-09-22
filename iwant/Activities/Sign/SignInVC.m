//
//  SignInVC.m
//  SignInTest
//
//  Created by 公司 on 2016/12/18.
//  Copyright © 2016年 lcf. All rights reserved.
//

#import "SignInVC.h"

@interface SignInVC (){
    NSInteger days;  //7天一清空
    BOOL isSign;
}
@end

@implementation SignInVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 60)];
    label.textColor = [UIColor whiteColor];
    label.text = @"签到";
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
    
    if (SCREEN_HEIGHT<570) {
        self.disToBottom.constant = 22;
        self.disToTreeBottom.constant = -90;
        self.distanceHeight.constant = 16;
    }else{
    }
    
    [self creatData];
}
//页面内容加载
-(void)creatData{
    [SVProgressHUD show];
    
    NSString * urlStr =[NSString stringWithFormat:@"%@ecoin/signlist?userId=%@",BaseUrl,[UserManager getDefaultUser].userId];
    
    [ExpressRequest sendWithParameters:nil MethodStr:urlStr reqType:k_GET success:^(id object) {
        [SVProgressHUD dismiss];
        NSDictionary * dict = [object valueForKey:@"data"][0];
        //切圆角
        self.greenBgView.layer.cornerRadius = 3.0;
        self.greenBgView.clipsToBounds = YES;
        
        _firstLabel.text = [[dict objectForKey:@"everyDayEcoin"] stringValue];
        _secondLabel.text =[[dict objectForKey:@"everyDayEcoin"] stringValue];
        _thirdLabel.text = [[dict objectForKey:@"everyDayEcoin"] stringValue];
        _fourLabel.text = [[dict objectForKey:@"everyDayEcoin"] stringValue];
        _fiveLabel.text =[[dict objectForKey:@"everyDayEcoin"] stringValue];
        _sixLabel.text =[[dict objectForKey:@"everyDayEcoin"] stringValue];
        _sevenLabel.text =[[dict objectForKey:@"ecoin"] stringValue];
        
        days = [[dict objectForKey:@"days"] integerValue];
        self.daysLabel.text = [[dict objectForKey:@"number"] stringValue];
        self.ecoinTodayLabel.text = [[dict objectForKey:@"dayEcoin"] stringValue];
        self.ecionTotolLabel.text = [[dict objectForKey:@"userEcoin"] stringValue];
        self.daysLabel.textColor = UIColorFromRGB(0xfed442);
        self.ecoinTodayLabel.textColor = UIColorFromRGB(0xfed442);
        self.ecionTotolLabel.textColor = UIColorFromRGB(0xfed442);
        
        self.ruleOne.text = [NSString stringWithFormat:@"1.每天签到可得%@积分。",[[dict objectForKey:@"everyDayEcoin"] stringValue]];
        self.ruleTwo.text = [NSString stringWithFormat:@"2.连续签到%@天即可得到%@积分。",[[dict objectForKey:@"keepDay"] stringValue],[[dict objectForKey:@"ecoin"] stringValue]];
        if ([[dict objectForKey:@"ifSign"] boolValue]) {
            isSign = NO;
            self.ecoinTodayLabel.text =@"0";
        }else{
            isSign = YES;
        }
        [self setUI];
        
    } failed:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
}
-(void)setUI{
    [self changeflagStatus];
    [self setDayEnd:[@(days) stringValue]];
    [self setBtnStatus:isSign];
}
-(void) setImage:(UIImageView *)imgView isSign:(BOOL)isSign{
    imgView.image = isSign?[UIImage imageNamed:@"signYes"]:[UIImage imageNamed:@"signNo"];
}

-(void) changeflagStatus{
//    if (days>7) {
//        days = days%7;
//        if (days == 0) {
//            days = 7;
//        }
//    }else{
//        days = days%8;
//    }
//
    if(days != 0 && days % 7 ==0){
        days = 7;
    }else {
        days = days % 7;
    }
    for(int i = 1; i<8; i++){
        switch (i) {
            case 1:
                [self setImage:_firstImage isSign:NO];
                _firstLabel.hidden = YES;
                break;
            case 2:
                [self setImage:_secImage isSign:NO];
                _secondLabel.hidden = YES;
                break;
            case 3:
                [self setImage:_thirdImage isSign:NO];
                _thirdLabel.hidden = YES;
                break;
            case 4:
                [self setImage:_fourImage isSign:NO];
                _fourLabel.hidden = YES;
                break;
            case 5:
                [self setImage:_fiveImage isSign:NO];
                _fiveLabel.hidden = YES;
                break;
            case 6:
                [self setImage:_sixImage isSign:NO];
                _sixLabel.hidden = YES;
                break;
            case 7:
                [self setImage:_sevImage isSign:NO];
                _sevenLabel.hidden = YES;
                break;
            default:
                break;
        }
    }
    for (int i = 1; i<= days; i++) {
        switch (i) {
            case 1:
                [self setImage:_firstImage isSign:YES];
                _firstLabel.hidden = NO;
                break;
            case 2:
                [self setImage:_secImage isSign:YES];
                _secondLabel.hidden = NO;
                break;
            case 3:
                [self setImage:_thirdImage isSign:YES];
                _thirdLabel.hidden = NO;
                break;
            case 4:
                [self setImage:_fourImage isSign:YES];
                _fourLabel.hidden = NO;
                break;
            case 5:
                [self setImage:_fiveImage isSign:YES];
                _fiveLabel.hidden = NO;
                break;
            case 6:
                [self setImage:_sixImage isSign:YES];
                _sixLabel.hidden = NO;
                break;
            case 7:
                [self setImage:_sevImage isSign:YES];
                _sevenLabel.hidden = NO;
                break;
            default:
                break;
        }
    }
    
}
-(void) setDayEnd:(NSString *)signDay{
//    int value = [signDay intValue];
//    if(days > 0){
//        days = value%8;
//    }else{
//        days = value%8;
//    }
    if(days != 0 && days % 7 ==0){
        days = 7;
    }else {
        days = days % 7;
    }

}
-(void) setBtnStatus:(BOOL)hasSign{
    _signBtn.enabled = !hasSign;
    [_signBtn setImage:!hasSign?[UIImage imageNamed:@"可签到.png"]:[UIImage imageNamed:@"签到.png"]  forState: UIControlStateNormal];
}
- (IBAction)signBtn:(UIButton *)sender {
    isSign = YES;
    
    //ecoin/sign    签到按钮的请求   GET    传userId
    NSString * urlStr =[NSString stringWithFormat:@"%@ecoin/sign?userId=%@",BaseUrl,[UserManager getDefaultUser].userId];
    [ExpressRequest sendWithParameters:nil MethodStr:urlStr reqType:k_GET success:^(id object) {
        
        [self creatData];
        [SVProgressHUD showSuccessWithStatus:[object valueForKey:@"message"]];
        
    } failed:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
    
    [self setUI];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
