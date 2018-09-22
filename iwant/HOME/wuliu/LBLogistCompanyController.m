//
//  LBLogistCompanyController.m
//  iwant
//
//  Created by dongba on 16/10/25.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "LBLogistCompanyController.h"

#import "BiaoshiInfoTableViewCell.h"

@interface LBLogistCompanyController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *legalPerson;
@property (weak, nonatomic) IBOutlet UILabel *freightCount;
@property (weak, nonatomic) IBOutlet UILabel *companyName;
@property (weak, nonatomic) IBOutlet UIImageView *companyImage;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic ,strong) NSMutableArray *dataArr;

@end

@implementation LBLogistCompanyController

- (NSMutableArray *)dataArr{

    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self createUI];
}

- (void)initData{

    self.dataArr =[NSMutableArray arrayWithArray:@[@"微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付",@"微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付",@"微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付",@"微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付",@"微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付",@"微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付",@"微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付",@"微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付",@"微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付微服私访到付",@""]] ;
}

- (void)createUI{

    [self.tableView registerNib:[UINib nibWithNibName:@"BiaoshiInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"logistCompanyCell"];
    [self.tableView setEstimatedRowHeight:60];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArr.count;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    return 50;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    BiaoshiInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"logistCompanyCell" forIndexPath:indexPath];
    cell.contentLabel.text = self.dataArr[indexPath.row];
    [cell addStar:cell.starView score:2];
    return cell;
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
