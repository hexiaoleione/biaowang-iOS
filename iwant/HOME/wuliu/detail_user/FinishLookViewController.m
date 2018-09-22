//
//  FinishLookViewController.m
//  iwant
//
//  Created by 公司 on 2016/12/5.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "FinishLookViewController.h"
#import "Logist.h"
#import "Baojia.h"
#import "DanBaoViewController.h"
#import "GoodsInfoView.h"
#import "companyInfoView.h"
#import "FinishDetailView.h"

#import "detailGoodsInfo.h"
#import "detailCompanyInfo.h"
#import "OfferViewController.h"
@interface FinishLookViewController (){

    UIScrollView *_scrollView;
    detailGoodsInfo * _goodsInfoView;
    detailCompanyInfo * _companyInfoView;
   
    FinishDetailView * _detailView;
}
@property(nonatomic,strong)Logist * model;
@property(nonatomic,strong)Baojia * baojiaModel;
@end

@implementation FinishLookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setCostomeTitle:@"订单详情"];
    [self creatData];
}
-(void)creatData{

    [SVProgressHUD show];
    NSString * urlStr =[NSString stringWithFormat:@"%@logistics/task/quotationInfo?recId=%@",BaseUrl,self.recId];
    [ExpressRequest sendWithParameters:nil MethodStr:urlStr reqType:k_GET success:^(id object) {
        [SVProgressHUD dismiss];
        NSDictionary  * dict =[object objectForKey:@"data"][0];
        self.model = [[Logist alloc]initWithJsonDict:dict];
        self.baojiaModel = [[Baojia alloc]initWithJsonDict:dict];
        [self configSubviews];
        
    } failed:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
}


- (void)configSubviews{
    
    _detailView = [[[NSBundle mainBundle] loadNibNamed:@"FinishDetailView" owner:nil options:nil] lastObject];
    [_detailView setViewsWithLogistModel:_model withBaojiaModel:_baojiaModel];
    _detailView.frame = self.view.frame;
    [self.view addSubview:_detailView ];
    __weak FinishLookViewController *weakSelf = self;

    _detailView.Block = ^(NSInteger tag) {
        if (tag == 0) {
            //重选报价公司
            [weakSelf selectAgainClick:nil];
        }else{
            //担保交易
            [weakSelf btnClick:nil];
        }
    };
    
    if ([_model.status intValue] == 7) {
        _detailView.rightConstraint.constant =  (SCREEN_WIDTH-_detailView.goOnBtn.width)/2;
        _detailView.goOnBtn.hidden = NO;
    }
    
    if ([_model.status intValue] == 8) {
        _detailView.selectAgainBtn.hidden = NO;
        _detailView.goOnBtn.hidden = NO;
    }
    
    UIButton *baodanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [baodanBtn addTarget:self action:@selector(baodanBtn) forControlEvents:UIControlEventTouchUpInside];
    baodanBtn.frame = CGRectMake(0, 0, 80, 30);
    [baodanBtn setTitle:@"下载保单" forState:UIControlStateNormal];
    baodanBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:baodanBtn];
    if (_model.pdfURL.length !=0) {
        self.navigationItem.rightBarButtonItem = menuButton;
    }
}

//保单
-(void)baodanBtn{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_model.pdfURL]];
}

#pragma mark --- 继续担保交易
-(void)btnClick:(UIButton *)btn{
    DanBaoViewController * danbaoVC = [[DanBaoViewController alloc]init];
    danbaoVC.recId = self.recId;
    [self .navigationController pushViewController:danbaoVC animated:YES];
}
#pragma mark --- 重选报价公司
-(void)selectAgainClick:(UIButton *)btn{
    NSLog(@"重选报价公司");
    OfferViewController *offerVC = [OfferViewController new];
    offerVC.wlbID = _model.recId;
    offerVC.model = _model;
    [self.navigationController pushViewController:offerVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
