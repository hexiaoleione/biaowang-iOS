//
//  AboutViewController.m
//  e发快递（测试）
//
//  Created by pro on 15/9/27.
//  Copyright (c) 2015年 pro. All rights reserved.
//

#import "AboutViewController.h"
#import "InforWebViewController.h"
#import "FeedBackViewController.h"
#import "Masonry.h"
#import "MainHeader.h"
#define RATIO   WINDOW_HEIGHT/736.0
@interface AboutViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_array;
    
}
@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self NavgationBar];
    [self configSubviews];
    _array = @[@"公司介绍",@"法律声明及条款",@"意见反馈",@"联系我们"];
}


- (void)configSubviews
{
    UIImage *image = [UIImage imageNamed:@"猴子"];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(44);
        make.height.mas_equalTo(image.size.height);
        make.width.mas_equalTo(image.size.width);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    UILabel *label = [[UILabel alloc]init];
    NSString *locaVersion =[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    label.text =  [NSString stringWithFormat:@"V%@",locaVersion];
    label.textColor = [UIColor redColor];
    label.font = [UIFont systemFontOfSize:25];
    [self.view addSubview:label];
    label.textAlignment = NSTextAlignmentCenter;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.top.mas_equalTo(imageView.mas_bottom);
        make.height.mas_equalTo(30);
    }];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.mas_equalTo(imageView.mas_bottom).with.offset(30);
        make.bottom.equalTo(self.view);
    }];
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
    static NSString *identifier = @"AboutCellIdentifier";
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
            infoVC.info_type = INFO_COMPANY;
            [self.navigationController pushViewController:infoVC animated:YES];
            break;
        case 1:
            infoVC.info_type = INFO_LAW;
            [self.navigationController pushViewController:infoVC animated:YES];
            break;
        case 2:{
            FeedBackViewController * vc =[[FeedBackViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:{
             [Utils callAction:@"01052873062"];
        }
            break;
        default:
            break;
    }
}

#pragma mark - navBar
- (void)NavgationBar {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 60)];
    label.textColor = [UIColor whiteColor];
    label.text = @"关于镖王";
    label.textAlignment = 1;
    self.navigationItem.titleView = label;
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(backToMenuView)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

- (void)backToMenuView
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
