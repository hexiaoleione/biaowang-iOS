//
//  LogResouseAreaListViewController.m
//  iwant
//
//  Created by dongba on 16/9/14.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "LogResouseAreaListViewController.h"
#import "LogistSettingTableViewCell.h"
#import "CityViewController.h"
#import "MainHeader.h"
@interface LogResouseAreaListViewController ()


@property (strong, nonatomic)  NSMutableArray *dataArray;

@end

@implementation LogResouseAreaListViewController

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCostomeTitle:@"关注的地区"];
    [self setSelectView];
    [self setData];
}
- (void)setData{
   [ExpressRequest sendWithParameters:nil MethodStr:[NSString stringWithFormat:@"%@logistics/area/list?userId=%@&pageNo=1&pageSize=100",BaseUrl,[UserManager getDefaultUser].userId] reqType:k_GET success:^(id object) {
       self.dataArray = [object valueForKey:@"data"];
       [self.tableView reloadData];
       
   } failed:^(NSString *error) {
       [SVProgressHUD showErrorWithStatus:error];
   }];
}
- (void)setSelectView{
    UIView *bgView  = [UIView new];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.frame = CGRectMake(0, WINDOW_HEIGHT -80-64, WINDOW_WIDTH, 80);
    //阴影颜色
    bgView.layer.shadowColor = [UIColor blackColor].CGColor;
    //阴影横向和纵向的偏移值
    bgView.layer.shadowOffset = CGSizeMake(0, -5.0);
    //阴影透明度
    bgView.layer.shadowOpacity = 0.45;
    //  阴影半径大小
    bgView.layer.shadowRadius = 5.0;
    [self.view addSubview: bgView];
    UIButton *btn = [[UIButton alloc] init];
    [btn setBackgroundColor:COLOR_ORANGE_DEFOUT];
    [btn setTitle:@"添加地区" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(addArea) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    btn.y = 20;
    btn.size = CGSizeMake(300, 40);
    btn.layer.cornerRadius = 5.;
    btn.centerX = bgView.centerX;
    [bgView addSubview:btn];
}

//选择区域添加
- (void)addArea{
    CityViewController *cityVC =[[CityViewController alloc]init];
    cityVC.returnTextBlock = ^(NSString *address,NSString *citycode,NSString *towncode,NSString *cityname,NSString *townname){
        NSDictionary *dic = @{@"userId":[UserManager getDefaultUser].userId,
                              @"areaPlace":[address stringByReplacingOccurrencesOfString:townname withString:@""],
                              @"areaCityCode":citycode};
        [ExpressRequest sendWithParameters:dic MethodStr:@"logistics/area/add" reqType:k_POST success:^(id object) {
            [self setData];
        } failed:^(NSString *error) {
            [SVProgressHUD showErrorWithStatus:error];
        }];
        
        
        
    };
    [self.navigationController pushViewController:cityVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
        cell.imageView.image = [UIImage imageNamed:@"dingwei"];
    }
    
    NSDictionary *dic = self.dataArray[indexPath.section];
    
    cell.textLabel.text = [dic valueForKey:@"areaPlace"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [SVProgressHUD show];
    
    NSDictionary *dic = self.dataArray[indexPath.section];
    NSDictionary *pre = @{@"recId":[dic valueForKey:@"recId"]};
    [ExpressRequest sendWithParameters:pre MethodStr:[NSString stringWithFormat:@"logistics/area/delete/%@",[dic valueForKey:@"recId"] ] reqType:k_PUT success:^(id object) {
        [SVProgressHUD showSuccessWithStatus:[object valueForKey:@"message"]];
        [self setData];
    } failed:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
    
    
    
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
