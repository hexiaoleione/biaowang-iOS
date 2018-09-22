//
//  CompanyLookZBViewController.m
//  iwant
//
//  Created by 公司 on 2016/12/6.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "CompanyLookZBViewController.h"
#import "CompanyOrderView.h"
#import "GoodsInfoView.h"//货物信息
#import "Logist.h"
@interface CompanyLookZBViewController (){
    UIScrollView *_scrollView;
    //留言
    UITextView *_commentTextField;
    
    //货场地址
    UITextView * _huochangAdressTextField;

    //货物信息
    GoodsInfoView *_topView;
}
@property(nonatomic,strong)Logist * model;

@end


@implementation CompanyLookZBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setCostomeTitle:@"报价详情"];
    [self creatData];
}

-(void)creatData{
    
    [SVProgressHUD show];
    NSString * urlStr =[NSString stringWithFormat:@"%@logistics/task/quotationInfo?recId=%@",BaseUrl,self.recId];
    [ExpressRequest sendWithParameters:nil MethodStr:urlStr reqType:k_GET success:^(id object) {
        [SVProgressHUD dismiss];
        NSDictionary  * dict =[object objectForKey:@"data"][0];
        self.model = [[Logist alloc]initWithJsonDict:dict];
        [self configSubViews];
        
        
    } failed:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
}

- (void)configSubViews{
    self.view.backgroundColor = [UIColor whiteColor];
    _scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    _scrollView.contentSize = CGSizeMake(WINDOW_WIDTH, 900.0);
    _scrollView.backgroundColor = BACKGROUND_COLOR;
    [self.view addSubview:_scrollView];
    
    //货物信息
    _topView = [[[NSBundle mainBundle] loadNibNamed:@"GoodsInfoView" owner:nil options:nil] lastObject];
    [_topView setViewsWithModel:_model];
    _topView.top = 10;
    _topView.left = 8;
    _topView.width = WINDOW_WIDTH-16;
    [_scrollView addSubview:_topView];
    _topView.layer.cornerRadius = 5;
    _topView.clipsToBounds = YES;
    
    //备注
    UILabel *liuyanLabel = [UILabel new];
    liuyanLabel.font = [UIFont systemFontOfSize:14];
    liuyanLabel.text = @"备注：";
    [liuyanLabel sizeToFit];
    liuyanLabel.top =_topView.bottom + 15;
    liuyanLabel.left = 10;
    liuyanLabel.height = 20;
    [_scrollView addSubview:liuyanLabel];
    
    _commentTextField = [[UITextView alloc]init];
    _commentTextField.userInteractionEnabled = NO;
    _commentTextField.font = [UIFont fontWithName:@"Arial" size:13.0];//设置字体名字和字体
    _commentTextField.text = _model.luMessage;
    _commentTextField.layer.borderColor = [[UIColor colorWithRed:215.0 / 255.0 green:215.0 / 255.0 blue:215.0 / 255.0 alpha:1] CGColor];
    
    _commentTextField.layer.borderWidth = 0.6f;
    _commentTextField.layer.cornerRadius = 6.0f;
    _commentTextField.top = liuyanLabel.bottom +10;
    _commentTextField.left = 10;
    _commentTextField.width = WINDOW_WIDTH - 20;
    _commentTextField.height = 60;
    [_scrollView addSubview:_commentTextField];
    
    //货场地址
    UILabel * huochangAdress = [UILabel new];
    huochangAdress.font = [UIFont systemFontOfSize:14];
    huochangAdress.text = @"货场地址：";
    [huochangAdress sizeToFit];
    huochangAdress.top = _commentTextField.bottom +15;
    huochangAdress.left = 10;
    huochangAdress.height = 20;
    [_scrollView addSubview:huochangAdress];
    
    _huochangAdressTextField = [[UITextView alloc]init];
    _huochangAdressTextField.font = [UIFont fontWithName:@"Arial" size:14.0];
    _huochangAdressTextField.userInteractionEnabled = NO;
    _huochangAdressTextField.text = _model.yardAddress;
    _huochangAdressTextField.layer.borderColor =  [[UIColor colorWithRed:215.0 / 255.0 green:215.0 / 255.0 blue:215.0 / 255.0 alpha:1] CGColor];
    _huochangAdressTextField.layer.borderWidth = 0.6f;
    _huochangAdressTextField.layer.cornerRadius = 6.0f;
    _huochangAdressTextField.top = huochangAdress.bottom+10;
    _huochangAdressTextField.left = 10;
    _huochangAdressTextField.width = SCREEN_WIDTH - 20;
    _huochangAdressTextField.height = 60;
    [_scrollView addSubview:_huochangAdressTextField];

    UILabel *baojiaLabel = [UILabel new];
    baojiaLabel.font = [UIFont systemFontOfSize:14];
    baojiaLabel.text = @"报价：";
    [baojiaLabel sizeToFit];
    baojiaLabel.top =_huochangAdressTextField.bottom + 15;
    baojiaLabel.left = 10;
    baojiaLabel.height = 20;
    [_scrollView addSubview:baojiaLabel];
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
