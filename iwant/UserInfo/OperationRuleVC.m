//
//  OperationRuleVC.m
//  iwant
//
//  Created by 公司 on 2017/3/27.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "OperationRuleVC.h"
#import "InforWebViewController.h"
#define RATIO   WINDOW_HEIGHT/736.0

@interface OperationRuleVC ()<UITableViewDelegate,UITableViewDataSource>{

    UITableView * _tableView;
    NSArray * _array;
}

@end

@implementation OperationRuleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setCostomeTitle:@"操作指南"];
    _array = @[@"功能介绍",@"用户发单手册",@"镖师接单手册",@"物流接单手册",@"其他功能详解",@"操作视频"];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
self.view.backgroundColor = _tableView.backgroundColor;

}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60 *RATIO;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"qqq";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = [_array objectAtIndex:indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    InforWebViewController *infoVC = [[InforWebViewController alloc]init];
    switch (indexPath.row) {
        case 0:
            infoVC.info_type = INFO_APP_INTRODUCE;
            break;
        case 1:
            infoVC.info_type = INFO_USERER_RULE;
            break;
        case 2:
            infoVC.info_type = INFO_DRIVER_RULE;
            break;
        case 3:
            infoVC.info_type = INFO_WULIU_RULE;
            break;
        case 4:
            infoVC.info_type = INFO_ELSE_RULE;
            break;
        case 5:
            infoVC.info_type = INFO_VIDEO;
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:infoVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
