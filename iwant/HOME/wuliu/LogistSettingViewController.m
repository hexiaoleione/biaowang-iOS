//
//  LogistSettingViewController.m
//  iwant
//
//  Created by dongba on 16/9/1.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "LogistSettingViewController.h"
#import "LogistSettingTableViewCell.h"
#import "LogistDingdianViewController.h"
#import "LogResouseAreaListViewController.h"

@interface LogistSettingViewController ()<UITableViewDelegate,UITableViewDataSource>



@end

@implementation LogistSettingViewController

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = BACKGROUND_COLOR;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCostomeTitle:@"关注信息"];
    [self setDataArray ];
    [self configSubviews];
}

- (void)configSubviews{
    [self.view addSubview:self.tableView];
}

- (void)setDataArray{
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  TableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
//section头部间距
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH - 20, 10)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
//section底部间距
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH - 20, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LogistSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LogistSettingTableViewCell" owner:nil options:nil] lastObject];
    }
    cell.imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"focus_img_%d",(int)indexPath.section]];
    switch (indexPath.section) {
        case 0:
            cell.title.text = @"附近货源";
            cell.subTitle.text = @"关注当前位置附近货源";
            break;
        case 1:
            cell.title.text = @"定点货源";
            cell.subTitle.text = @"关注关注城市之间的货源";
            break;
        case 2:
            cell.title.text = @"地区货源";
            cell.subTitle.text = @"关注指定区域货源";
            break;
            
        default:
            break;
    }
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 59;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
//    OfferViewController *offerVC = [OfferViewController new];
    //    [self.navigationController popViewControllerAnimated:YES];
    switch (indexPath.section) {
        case 0:{
            [self.navigationController popViewControllerAnimated:YES];
            if (_block) {
                _block(nil);
            }
            
        }
            break;
        case 1:{
            LogistDingdianViewController *vc = [[LogistDingdianViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:{
            LogResouseAreaListViewController *vc = [[LogResouseAreaListViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
    
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
