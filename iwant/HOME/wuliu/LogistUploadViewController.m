//
//  LogistUploadViewController.m
//  iwant
//
//  Created by dongba on 16/9/2.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "LogistUploadViewController.h"
#import "YMHeaderView.h"
#import "CompanyOrderView.h"
#import "GoodsInfoView.h"
#import "CarNumModel.h"
#import "CarNumCell.h"

@interface LogistUploadViewController ()<YMHeaderViewDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>{
    UIScrollView *_scrollView;
    NSString *_url_1;
    NSString *_url_2;
    NSString *_url_3;
    GoodsInfoView *_topView; //货物信息
    YMHeaderView *_imageV;
    UIButton * _showHistoryBtn;
    UIView * _bigView;//大的背景
    UITextField * _carNumTextField;
}
@property (strong, nonatomic) UITableView * carNumTableView;
@property (strong, nonatomic)  NSMutableArray *dataArray;

@end

@implementation LogistUploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self setCostomeTitle:@"我要出发啦"];
    [self getCarNum];
    [self configSubviews];
}

- (void)configSubviews{
    self.view.backgroundColor = BACKGROUND_COLOR;
    _scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    _scrollView.contentSize = CGSizeMake(WINDOW_WIDTH, 736.);
    [self.view addSubview:_scrollView];
    
    _topView = [[[NSBundle mainBundle] loadNibNamed:@"GoodsInfoView" owner:nil options:nil] lastObject];
    [_topView setViewsWithModel:_model];
    _topView.top = 5;
    _topView.width = WINDOW_WIDTH;
    [_scrollView addSubview:_topView];
    
    UILabel *uploadLabel = [UILabel new];
    uploadLabel.text = @"出发前请拍摄至少一张货物图片";
    uploadLabel.textColor = [UIColor redColor];
    [_scrollView addSubview:uploadLabel];
    
    uploadLabel.top = _topView.bottom + 20;
    [uploadLabel sizeToFit];
    uploadLabel.left = 30;
    
    CGFloat bianchang = 85;
    CGFloat temp = (WINDOW_WIDTH - bianchang *3)/4;
    for (int i = 0; i<3; i++) {
        _imageV = [[YMHeaderView alloc]initWithFrame:CGRectMake((temp+bianchang)*i+temp, uploadLabel.bottom +20, bianchang, bianchang)];
        
        _imageV.image = [UIImage imageNamed:@"物品"];
        _imageV.layer.cornerRadius =5;
        _imageV.tag = i;
        _imageV.userInteractionEnabled = YES;
        _imageV.delagate =self;
        [_scrollView addSubview:_imageV];
        //状态为8的时候用户还没有付款  不可上传图片
         if ([_model.status intValue]==3||[_model.status intValue]==4||[_model.status intValue]==5||[_model.status intValue]==8) {
             _imageV.userInteractionEnabled = NO;
             switch (i) {
                 case 0:
                     [_imageV sd_setImageWithURL:[NSURL URLWithString:_model.firstPicture] placeholderImage:[UIImage imageNamed:@"物品"]];
                     break;
                 case 1:
                     [_imageV sd_setImageWithURL:[NSURL URLWithString:_model.secondPicture] placeholderImage:[UIImage imageNamed:@"物品"]];
                     break;
                 case 2:
                     [_imageV sd_setImageWithURL:[NSURL URLWithString:_model.thirdPicture] placeholderImage:[UIImage imageNamed:@"物品"]];
                     break;
                     
                 default:
                     break;
             }
         }
    }
    
    
    UILabel * carNumL =[[UILabel alloc]initWithFrame:CGRectMake(20, uploadLabel.bottom + bianchang + 35, 80, 35)];
    carNumL.font = FONT(15, NO);
    carNumL.text = @"车牌照号：";
    [_scrollView addSubview:carNumL];
    _carNumTextField = [[UITextField alloc]initWithFrame:CGRectMake(carNumL.right+5, uploadLabel.bottom + bianchang + 35, SCREEN_WIDTH/2, 35)];
    _carNumTextField.placeholder = @"请填写车牌照号";
    _carNumTextField.backgroundColor = [UIColor whiteColor];
    _carNumTextField.font = FONT(15, NO);
    _carNumTextField.layer.cornerRadius = 2;
    _carNumTextField.layer.masksToBounds = YES;
    _carNumTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_scrollView addSubview:_carNumTextField];
    
    _showHistoryBtn = [[UIButton alloc]initWithFrame:CGRectMake(_carNumTextField.right +3,uploadLabel.bottom + bianchang + 35 , 35, 35)];
    [_showHistoryBtn addTarget:self action:@selector(showHistoryNum) forControlEvents:UIControlEventTouchUpInside];
    [_showHistoryBtn setImage:[UIImage imageNamed:@"xiala"] forState:UIControlStateNormal];
    [_scrollView addSubview:_showHistoryBtn];
    
    
    UIButton *btn = [[UIButton alloc] init];
    [btn setBackgroundColor:COLOR_ORANGE_DEFOUT];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"确认取货" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.layer.cornerRadius = 10;
    btn.size = CGSizeMake(110, 33);
    btn.centerX =_scrollView.centerX;
    btn.top = _carNumTextField.bottom+30;
    [_scrollView addSubview:btn];
    [btn addTarget:self action:@selector(submitPic) forControlEvents:UIControlEventTouchUpInside];
    
    if ([_model.status intValue]==3||[_model.status intValue]==4||[_model.status intValue]==5) {
        
        btn.hidden = YES;
        uploadLabel.hidden  = YES;
        _showHistoryBtn.hidden = YES;
        _carNumTextField.text = _model.carNumImg;
    }    
}
-(void)getCarNum{
    //获取车牌照号列表logistics/task/carNumber    API_WL_CARNUMLIST
    [ExpressRequest sendWithParameters:nil MethodStr:[NSString stringWithFormat:@"%@%@?userId=%@",BaseUrl,API_WL_CARNUMLIST,[UserManager getDefaultUser].userId] reqType:k_GET success:^(id object) {
        NSArray *dataArr = [object objectForKey:@"data"];
        if (dataArr) {
            _showHistoryBtn.hidden = NO;
            self.dataArray = [[NSMutableArray alloc]init];
            for (NSDictionary * dic in dataArr) {
                CarNumModel * model = [[CarNumModel alloc]initWithJsonDict:dic];
                [self.dataArray addObject:model];
            }
        }else{
            _showHistoryBtn.hidden = YES;
        }
        [_carNumTableView reloadData];
    } failed:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
}

-(void)showHistoryNum{
     _carNumTableView = [[UITableView alloc]initWithFrame:CGRectMake(_carNumTextField.x , _carNumTextField.bottom, 160, 150) style:UITableViewStylePlain];
    _carNumTableView.bottom = _carNumTextField.top;
    if (SCREEN_WIDTH == 320) {
    _carNumTableView = [[UITableView alloc]initWithFrame:CGRectMake(_carNumTextField.x , _carNumTextField.bottom, 160, 150) style:UITableViewStylePlain];
    }
   _carNumTableView.backgroundColor = [UIColor whiteColor];
   _carNumTableView.layer.cornerRadius = 3;
   _carNumTableView.layer.masksToBounds = YES;
   _carNumTableView.delegate = self;
   _carNumTableView.dataSource = self;

   _bigView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bigBg:)];
    recognizer.delegate = self;
    [_bigView addGestureRecognizer:recognizer];
    _bigView.backgroundColor = [UIColor clearColor];
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
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CarNumCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CarNumCell" owner:nil options:nil] firstObject];
    }
    CarNumModel * model = _dataArray[indexPath.row];
    [cell setModel:model];
    cell.block =^{
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
    
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

- (void)submitPic{
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
