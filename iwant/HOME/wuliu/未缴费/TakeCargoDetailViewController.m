//
//  TakeCargoDetailViewController.m
//  iwant
//
//  Created by 公司 on 2017/6/22.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "TakeCargoDetailViewController.h"
#import "YMHeaderView.h"
#import "CarNumModel.h"
#import "CarNumCell.h"
@interface TakeCargoDetailViewController ()<YMHeaderViewDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>{
    NSString *_url_1;
    NSString *_url_2;
    NSString *_url_3;
    
    UIView * _bigView;//大的背景
}
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *limitTimeL;
@property (weak, nonatomic) IBOutlet UILabel *guiGeL;
@property (weak, nonatomic) IBOutlet UILabel *weightL;
@property (weak, nonatomic) IBOutlet UILabel *sizeL;
@property (weak, nonatomic) IBOutlet UILabel *takeCargoL;
@property (weak, nonatomic) IBOutlet UILabel *sendCargoL;
@property (weak, nonatomic) IBOutlet UILabel *sendNameL;
@property (weak, nonatomic) IBOutlet UILabel *sendPhoneL;
@property (weak, nonatomic) IBOutlet UILabel *start;
@property (weak, nonatomic) IBOutlet UILabel *startL;
@property (weak, nonatomic) IBOutlet UILabel *arriveNameL;
@property (weak, nonatomic) IBOutlet UILabel *arrivePhoneL;
@property (weak, nonatomic) IBOutlet UILabel *end;
@property (weak, nonatomic) IBOutlet UILabel *endL;
@property (weak, nonatomic) IBOutlet UILabel *noticeL;

@property (weak, nonatomic) IBOutlet YMHeaderView *imageView1;
@property (weak, nonatomic) IBOutlet YMHeaderView *imageView2;
@property (weak, nonatomic) IBOutlet YMHeaderView *imageView3;

@property (weak, nonatomic) IBOutlet UILabel *carNumL;
@property (weak, nonatomic) IBOutlet UITextField *carNumTextField;
@property (weak, nonatomic) IBOutlet UIButton *carNumBtn;
@property (weak, nonatomic) IBOutlet UIButton *takeCargoBtn;
//冷链车的特殊需求
@property (weak, nonatomic) IBOutlet UILabel *specialNeedL;


@property (strong, nonatomic) UITableView * carNumTableView;
@property (strong, nonatomic)  NSMutableArray *dataArray;

@end

@implementation TakeCargoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.nameL.font = FONT(14, NO);
    self.limitTimeL.font = FONT(14, NO);
    self.guiGeL.font = FONT(14, NO);
    self.sizeL.font = FONT(14, NO);
    self.takeCargoL.font = FONT(14, NO);
    self.sendCargoL.font = FONT(14, NO);
    self.sendNameL.font = FONT(14, NO);
    self.sendPhoneL.font = FONT(14, NO);
    self.arriveNameL.font = FONT(14, NO);
    self.arrivePhoneL.font = FONT(14, NO);
    self.start.font = FONT(14, NO);
    self.end.font = FONT(14, NO);
    self.startL.font = FONT(14, NO);
    self.endL.font = FONT(14, NO);
    self.noticeL.font = FONT(17, NO);
    self.carNumL.font = FONT(14, NO);
    self.weightL.font = FONT(14, NO);
    self.specialNeedL.font = FONT(14, NO);

    self.imageView1.image = [UIImage imageNamed:@"WL_cargoImg"];
    self.imageView2.image = [UIImage imageNamed:@"WL_cargoImg"];
    self.imageView3.image = [UIImage imageNamed:@"WL_cargoImg"];

    _imageView1.layer.cornerRadius =0;
    _imageView2.layer.cornerRadius =0;
    _imageView3.layer.cornerRadius =0;
    _imageView1.delagate =self;
    _imageView2.delagate =self;
    _imageView3.delagate =self;
    [self setCostomeTitle:@"取货详情"];
    [self getCarNum];
    [self configSubViews];
}
-(void)configSubViews{
    self.nameL.text = [NSString stringWithFormat:@"物品名称：%@",self.model.cargoName];
    self.limitTimeL.text = [NSString stringWithFormat:@"要求到达时间：%@",self.model.arriveTime];
    self.guiGeL.text = [NSString stringWithFormat:@"总体积：%@",self.model.cargoVolume];
    if ([self.model.carType isEqualToString:@"cold"]) {
        self.specialNeedL.hidden = NO;
        self.specialNeedL.text = [NSString stringWithFormat:@"需求：%@",self.model.carName];
    }
    
    self.weightL.text = [NSString stringWithFormat:@"总重量：%@",self.model.cargoWeight];
    self.sizeL.text = [NSString stringWithFormat:@"件数：%@件",self.model.cargoSize];
    
    //温度要求问题
    if ([_model.carType isEqualToString:@"cold"]) {
        self.takeCargoL.text = [NSString stringWithFormat:@"温度要求：%@",self.model.tem];
        self.sendCargoL.hidden  = YES;
    }else{
        self.takeCargoL.text = self.model.takeCargo ?@"物流公司上门取货":@"发件人送到货场";
        self.sendCargoL.text = self.model.sendCargo ?@"物流公司送货上门":@"收件人自提";
    }
    
    self.startL.text = self.model.startPlace;
    self.endL.text = self.model.entPlace;
    self.sendNameL.text = [NSString stringWithFormat:@"发件人：%@",self.model.sendPerson];
    self.sendPhoneL.text = [NSString stringWithFormat:@"电话：%@",self.model.sendPhone];
    self.arriveNameL.text = [NSString stringWithFormat:@"收件人：%@",self.model.takeName];
    self.arrivePhoneL.text = [NSString stringWithFormat:@"电话：%@",self.model.takeMobile];
    
    //状态为8的时候用户还没有付款  不可上传图片
    if ([_model.status intValue]==3||[_model.status intValue]==4||[_model.status intValue]==5||[_model.status intValue]==8) {
        _imageView1.userInteractionEnabled = NO;
        _imageView2.userInteractionEnabled = NO;
        _imageView3.userInteractionEnabled = NO;
        _imageView1.delagate =self;
        _imageView2.delagate =self;
        _imageView3.delagate =self;
        [_imageView1 sd_setImageWithURL:[NSURL URLWithString:_model.firstPicture] placeholderImage:[UIImage imageNamed:@"WL_cargoImg"]];
        [_imageView2 sd_setImageWithURL:[NSURL URLWithString:_model.secondPicture] placeholderImage:[UIImage imageNamed:@"WL_cargoImg"]];
        [_imageView3 sd_setImageWithURL:[NSURL URLWithString:_model.thirdPicture] placeholderImage:[UIImage imageNamed:@"WL_cargoImg"]];
      }
    if ([_model.status intValue]==3||[_model.status intValue]==4||[_model.status intValue]==5) {
        self.takeCargoBtn.hidden = YES;
        self.noticeL.hidden  = YES;
        self.carNumBtn.hidden = YES;
        _carNumTextField.text = _model.carNumImg;
    }
}

#pragma mark  ---YMHeader  Delegate
- (void)headerView:(YMHeaderView *)headerView didSelectWithImage:(UIImage *)image{
    [SVProgressHUD showWithStatus:@"正在上传"];
    NSDictionary *dic = @{k_USER_ID:[UserManager getDefaultUser].userId,k_FILE_NAME:@"matImg.png"};
    NSDictionary *fileDic = @{@"data":image,@"fileName":@"matImg.png.png"};
    
    NSString *api;
    switch (headerView.tag) {
        case 0:
            api = @"file/first";
            break;
        case 1:
            api = @"file/second";
            break;
        case 2:
            api = @"file/third";
            break;
            
        default:
            break;
    }
    [ExpressRequest sendWithParameters:dic MethodStr:api
                               fileDic:fileDic
                               success:^(id object) {
                                   [SVProgressHUD showSuccessWithStatus:@"上传成功"];
                                   switch (headerView.tag) {
                                       case 0:
                                           _url_1 = [([object objectForKey:@"data"][0]) valueForKey:@"filePath"];
                                           break;
                                       case 1:
                                           _url_2 = [([object objectForKey:@"data"][0]) valueForKey:@"filePath"];
                                           break;
                                       case 2:
                                           _url_3 = [([object objectForKey:@"data"][0]) valueForKey:@"filePath"];
                                           break;
                                       default:
                                           break;
                                   }
                               } failed:^(NSString *error) {
                                   [SVProgressHUD showErrorWithStatus:error];
                               }];
}

- (IBAction)takeCargoSureBtn:(UIButton *)sender {
    
    if (_carNumTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请填写正确的车牌号"];
        return;
    }
    if ((_url_1.length>0) || (_url_2.length>0) || (_url_3.length>0)) {
        [SVProgressHUD show];
        NSDictionary *dic = @{@"recId":_model.recId,@"firstPicture":_url_1?_url_1:@"",@"secondPicture":_url_2?_url_2:@"",@"thirdPicture":_url_3?_url_3:@"",@"carNumImg":_carNumTextField.text};
        [ExpressRequest sendWithParameters:dic MethodStr:@"logistics/task/recive" reqType:k_POST success:^(id object) {
            [SVProgressHUD showSuccessWithStatus:[object valueForKey:@"message"]];
            [self.navigationController popViewControllerAnimated:YES];
        } failed:^(NSString *error) {
            [SVProgressHUD showSuccessWithStatus:error];
        }];
    }else{
        if ([_model.status intValue] == 8) {
            [SVProgressHUD showInfoWithStatus:@"请通知用户付款后再发货"];
        }else{
            [SVProgressHUD showInfoWithStatus:@"请上传货物照片！"];
        }
    }
}

#pragma mark ---- 车牌号码

- (IBAction)carNumBtnClick:(UIButton *)sender {
    [self showHistoryNum ];
}

-(void)getCarNum{
    //获取车牌照号列表logistics/task/carNumber    API_WL_CARNUMLIST
    [ExpressRequest sendWithParameters:nil MethodStr:[NSString stringWithFormat:@"%@%@?userId=%@",BaseUrl,API_WL_CARNUMLIST,[UserManager getDefaultUser].userId] reqType:k_GET success:^(id object) {
        NSArray *dataArr = [object objectForKey:@"data"];
        if (dataArr) {
            _carNumBtn.hidden = NO;
            self.dataArray = [[NSMutableArray alloc]init];
            for (NSDictionary * dic in dataArr) {
                CarNumModel * model = [[CarNumModel alloc]initWithJsonDict:dic];
                [self.dataArray addObject:model];
            }
        }else{
            _carNumBtn.hidden = YES;
        }
        [_carNumTableView reloadData];
    } failed:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
}

-(void)showHistoryNum{
    _carNumTableView = [[UITableView alloc]initWithFrame:CGRectMake(_carNumTextField.x , _carNumTextField.bottom, 175, 150) style:UITableViewStylePlain];
    _carNumTableView.bottom = _carNumTextField.top;
    if (SCREEN_WIDTH == 320) {
        _carNumTableView = [[UITableView alloc]initWithFrame:CGRectMake(_carNumTextField.x , _carNumTextField.bottom, 175, 150) style:UITableViewStylePlain];
    }
    _carNumTableView.backgroundColor = [UIColor whiteColor];
    _carNumTableView.layer.cornerRadius = 3;
    _carNumTableView.layer.masksToBounds = YES;
    _carNumTableView.delegate = self;
    _carNumTableView.dataSource = self;
    _carNumTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _bigView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bigBg:)];
    recognizer.delegate = self;
    [_bigView addGestureRecognizer:recognizer];
    _bigView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.4];
    [UIView animateWithDuration:.35 animations:^{
        _bigView.y = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [_bigView addSubview:_carNumTableView];
            [self.view addSubview:_bigView];
        }
    }];
}

-(void)bigBg:(UITapGestureRecognizer *)tap{
    [UIView animateWithDuration:.35 animations:^{
        _bigView.y = SCREEN_HEIGHT;
        _carNumTableView.y = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        if (finished) {
            [_carNumTableView removeFromSuperview];
            [_bigView removeFromSuperview];
        }
    }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isDescendantOfView:_carNumTableView]) {
        return NO;
    }
    return YES;
}
#pragma tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CarNumCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CarNumCell" owner:nil options:nil] firstObject];
    }
    CarNumModel * model = _dataArray[indexPath.row];
    [cell setModel:model];
    cell.Block =^{
        //       logistics/task/deleteCarNum 删除车牌号
        [ExpressRequest sendWithParameters:nil MethodStr:[NSString stringWithFormat:@"%@%@?recId=%@",BaseUrl,API_WL_DELETECARNUM,model.recId] reqType:k_GET success:^(id object) {
            [_dataArray removeObjectAtIndex:indexPath.row];
            [_carNumTableView reloadData];
        } failed:^(NSString *error) {
            [SVProgressHUD showErrorWithStatus:error];
        }];
    };
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    CarNumModel * model = _dataArray[indexPath.row];
    _carNumTextField.text = model.carNum;
    
    [UIView animateWithDuration:.35 animations:^{
        _carNumTableView.y = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        if (finished) {
            [_carNumTableView removeFromSuperview];
            [_bigView removeFromSuperview];
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
