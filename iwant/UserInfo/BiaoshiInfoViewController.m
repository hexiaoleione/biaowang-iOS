//
//  BiaoshiInfoViewController.m
//  iwant
//
//  Created by dongba on 16/5/26.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "BiaoshiInfoViewController.h"
#import "BiaoshiInfoTableViewCell.h"
#import "ZYRatingView.h"
#define margin 18 *WINDOW_WIDTH /414.0
#define RATIO_H   (WINDOW_HEIGHT - 64.0) /(736.0 - 64.0)
#define RATIO_W   WINDOW_WIDTH /414.0
@interface BiaoshiInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    int _pageNo;
    
    
    NSMutableArray *_modelArray;
    
    UIImageView *imageV;
    
    ZYRatingView *starsView;
    
}
@property (strong, nonatomic)  UILabel *nameLabel;

@property (strong, nonatomic)  UILabel *timesLabel;

@property (strong, nonatomic)  UILabel *evaluateLabel;

@property (strong, nonatomic)  UIImageView *sexImg;

@property (strong, nonatomic)  UIImageView *realImg;

@property (strong, nonatomic)  UITableView *tableView;

@property (strong, nonatomic)  NSArray *dataArray;


@end

@implementation BiaoshiInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCostomeTitle:@"镖师信息"];
    _pageNo = 1;

    [self fillInfo];
    [self initSubViews];
}

- (void)fillInfo{
    [RequestManager getdriverdetailWithdriverId:_userId Success:^(id object) {
        _model =object;
        _nameLabel.text = _model.userName;
        [_nameLabel sizeToFit];
        _sexImg.left  = _nameLabel.right + 5;
        _realImg.left = _sexImg.right + 5;
        
        _timesLabel.text = [NSString stringWithFormat:@"押镖次数 ：%@次",_model.driverRouteCount];
        
       [starsView displayRating:[self.model.synthesisEvaluate floatValue] *2];
        [imageV sd_setImageWithURL:[NSURL URLWithString:_model.userHeadPath] placeholderImage:[UIImage imageNamed:@"headerView"]];
    }
        Failed:^(NSString *error) {
        
        }];
}

-(void)loadData:(BOOL)isAdd
{
    if (!isAdd) {
        _pageNo = 1;
    }else{
        _pageNo++;
    }
    
    
    [RequestManager getEvalutionDriverEvaLuteWithDriverId:_userId pageNo:[NSString stringWithFormat:@"%d",_pageNo] pageSize:@"5" Success:^(NSArray *result) {
        [self endRefresh];
        if (_pageNo == 1) {
            _modelArray = [NSMutableArray array];
            [_modelArray addObjectsFromArray:result];
        }else{
            [_modelArray addObjectsFromArray:result];
        }
        
        [_tableView reloadData];
        
    }
        Failed:^(NSString *error) {
                                         
                    [self endRefresh];
            NSLog(@"请求交易记录有误:%@",error);
        }];
}

-(void)initSubViews{
    
    CGFloat imageEdge = 75 *RATIO_W;//image边长
    CGFloat labelWidth = 60 *RATIO_W;
    CGFloat labelMargin = 4 *RATIO_H;
    CGFloat labelHeiight = (imageEdge - labelMargin *4)/3;
    CGFloat btnEdge = 36 *RATIO_W;
    
    UIView *headerView = [UIView new];
    headerView.frame = CGRectMake(0, 0, WINDOW_WIDTH, imageEdge +2*margin);
    [self.view addSubview:headerView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    imageV = [[UIImageView alloc]initWithFrame:CGRectMake(margin, margin, imageEdge, imageEdge)];
    [imageV sd_setImageWithURL:[NSURL URLWithString:self.model.userHeadPath] placeholderImage:[UIImage imageNamed:@"user-1"]];
    imageV.layer.cornerRadius = imageEdge *0.5;
    imageV.layer.masksToBounds = YES;
    [headerView addSubview:imageV];
    
    _nameLabel = [UILabel new];
    _nameLabel.font = FONT(16, NO);
    _nameLabel.frame = CGRectMake(CGRectGetMaxX(imageV.frame)+margin, margin + labelMargin, labelWidth, labelHeiight);
    _nameLabel.text = [NSString stringWithFormat:@"%@",self.model.userName];
    [headerView addSubview:_nameLabel];
    _timesLabel = [UILabel new];
    _timesLabel.font = FONT(14, NO);
    _timesLabel.textColor = [UIColor grayColor];
    _timesLabel.frame = CGRectMake(_nameLabel.x, _nameLabel.bottom + labelMargin, labelWidth *3, labelHeiight);
    _timesLabel.text =[NSString stringWithFormat:@"押镖次数 ：%@次",self.model.driverRouteCount] ;
    [headerView addSubview:_timesLabel];
    
    _sexImg =[[UIImageView alloc]init];
    _sexImg.left = _nameLabel.right +labelMargin;
    _sexImg.size = CGSizeMake(labelHeiight, labelHeiight);
    _sexImg.top = _nameLabel.top;
    _sexImg.image = [UIImage imageNamed:@"female"];
    [headerView addSubview:_sexImg];
    
    _realImg =[[UIImageView alloc]init];
    _realImg.left = _sexImg.right +labelMargin;
    _realImg.size = CGSizeMake(labelHeiight *3, labelHeiight);
    _realImg.top = _sexImg.top;
    _realImg.image = [UIImage imageNamed:@"real"];
    [headerView addSubview:_realImg ];
    
    
    _evaluateLabel = [UILabel new];
    _evaluateLabel.font = FONT(14, NO);
    _evaluateLabel.textColor = [UIColor grayColor];
    _evaluateLabel.frame = CGRectMake(_nameLabel.x, _timesLabel.bottom+labelMargin, labelWidth + labelMargin *4, labelHeiight);
    _evaluateLabel.adjustsFontSizeToFitWidth = YES;
    _evaluateLabel.text = @"综合评价 ：";
    [headerView addSubview:_evaluateLabel];
    
    starsView = [[ZYRatingView alloc]initWithFrame:CGRectMake(_evaluateLabel.right, _evaluateLabel.top + 2, labelHeiight *5, labelHeiight)];
    starsView.centerY = _evaluateLabel.centerY;
    [starsView setImagesDeselected:@"star_zero" partlySelected:@"star_one" fullSelected:@"star_one" andDelegate:nil];
    [starsView displayRating:[self.model.synthesisEvaluate floatValue] *2];
    starsView.userInteractionEnabled = NO;
    [headerView addSubview:starsView];
    
    
//    UIButton *_sendMsgBtn = [UIButton buttonWithType:0];
//    _sendMsgBtn.frame = CGRectMake(0, 0, btnEdge, btnEdge);
//    _sendMsgBtn.bottom = _evaluateLabel.bottom;
//    _sendMsgBtn.right = WINDOW_WIDTH - btnEdge - labelMargin - margin;
//    _sendMsgBtn.centerY = _timesLabel.centerY;
//    [_sendMsgBtn setImage:[UIImage imageNamed:@"tongxun"] forState:0];
//    [_sendMsgBtn addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
//    [headerView addSubview:_sendMsgBtn];
    
    
    UIButton *_callBtn = [UIButton buttonWithType:0];
    _callBtn.frame = CGRectMake(0, 0, btnEdge, btnEdge);
    _callBtn.bottom = _evaluateLabel.bottom;
    _callBtn.right = WINDOW_WIDTH - margin;
    _callBtn.centerY = _timesLabel.centerY;
    [_callBtn setImage:[UIImage imageNamed:@"phoneBtn"] forState:0];
    [_callBtn addTarget:self action:@selector(call:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:_callBtn];
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(headerView.frame), WINDOW_WIDTH, WINDOW_HEIGHT - CGRectGetHeight(headerView.frame) - 64) style:UITableViewStylePlain];
    _tableView.backgroundColor = COLOR_(245, 245, 245, 1);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    __weak BiaoshiInfoViewController *weakSelf = self;
    
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf loadData:NO];
    }];
    [_tableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf loadData:YES];
    }];
    [_tableView.header beginRefreshing];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_tableView setEstimatedRowHeight:120*RATIO_H];
    _tableView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:_tableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)sendMessage:(UIButton *)sender{
    
}

- (void)call:(UIButton *)sender{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",_model.driverMobile];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
}

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cell";
    
    BiaoshiInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BiaoshiInfoTableViewCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = tableView.backgroundColor;
    }
    Evaluation *model = _modelArray[indexPath.row];
    cell.timeLabel.text = model.updateTime;
    cell.contentLabel.text = model.driverContent;
    [cell addStar:cell.starView score:[model.driverScore floatValue]];
//  cell.contentLabel.text =_dataArray[indexPath.row];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView cellForRowAtIndexPath:indexPath];
}
-(void)endRefresh{
    [_tableView.header endRefreshing];
    [_tableView.footer endRefreshing];
}

@end
