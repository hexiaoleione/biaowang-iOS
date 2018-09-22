//
//  CityViewController.m
//  Express
//
//  Created by user on 15/7/23.
//  Copyright (c) 2015年 SCHT. All rights reserved.
//

#import "CityViewController.h"
#import "Business.h"
#import "Province.h"
#import "MainHeader.h"

@interface CityViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSString *strProvince;
    NSString *strCity;
    NSString *strCountry;
    NSString *citycode;
    
}
@property(nonatomic,strong)NSMutableArray *arrProvince;
@property(nonatomic,strong)NSMutableArray *arrCity;
@property(nonatomic,strong)NSMutableArray *arrCounty;
@property(nonatomic,strong)UITableView *tableProvince;
@property(nonatomic,strong)UITableView *tableCity;
@property(nonatomic,strong)UITableView *tableCounty;
@end

@implementation CityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setCostomeTitle:@"城市列表"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _arrProvince = [[NSMutableArray alloc] initWithCapacity:0];
    _arrCity = [[NSMutableArray alloc] initWithCapacity:0];
    _arrCounty = [[NSMutableArray alloc] initWithCapacity:0];
    [self getProvinceData];
    [self.view addSubview:self.tableProvince];
    [_tableProvince  mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(self.view.frame.size.width/3);
        make.height.equalTo(self.view);
        make.top.mas_equalTo(0);
    }];
    
    [self.view addSubview:self.tableCity];
    [_tableCity  mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.view.frame.size.width/3);
        make.width.mas_equalTo(self.view.frame.size.width/3);
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(64);
    }];
    [self.view addSubview:self.tableCounty];
    [_tableCounty  mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(2*self.view.frame.size.width/3);
        make.width.mas_equalTo(self.view.frame.size.width/3);
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(64);
    }];

}
-(void)getProvinceData{
    //    获取txt文件路径
    NSString *txtPath = [[NSBundle mainBundle]  pathForResource:@"wr_province" ofType:@"txt"];
    //    将txt到string对象中，编码类型为NSUTF8StringEncoding
    NSString *string = [[NSString  alloc] initWithContentsOfFile:txtPath encoding:NSUTF8StringEncoding error:nil];
    NSArray *contentsArray = [string componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];

    
    for (NSString *strcode in contentsArray) {
        Province *province = [Province new];
        NSArray *lines = [strcode componentsSeparatedByString:@"	"];
        if (lines.count <2) {
            continue;
        }
        NSLog(@"lines===%@",lines);
        
        province.provcode = [lines objectAtIndex:0];
        province.provcode =  [province.provcode  stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        province.provname = [lines objectAtIndex:1];
        province.provname =  [province.provname  stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        [_arrProvince addObject:province];
        NSLog(@"%@",lines);
        NSLog(@"%@",[lines objectAtIndex:1]);

    }
}

-(void)getCityData:(NSString *)provcode{
    [_arrCity removeAllObjects];
    NSString *txtPath = [[NSBundle mainBundle]  pathForResource:@"wr_city" ofType:@"txt"];
    //    将txt到string对象中，编码类型为NSUTF8StringEncoding
    NSString *string = [[NSString  alloc] initWithContentsOfFile:txtPath encoding:NSUTF8StringEncoding error:nil];
    NSArray *contentsArray = [string componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    for (NSString *strcode in contentsArray) {
        NSRange range = [strcode rangeOfString:provcode];//判断字符串是否包含
        
        //if (range.location ==NSNotFound)//不包含
        if (range.length >0)//包含
        {
        }
        else//不包含
        {
            continue;
        }
        City *city = [City new];
        NSArray *lines = [strcode componentsSeparatedByString:@"	"];
        if (lines.count <4) {
            continue;
        }
        NSLog(@"lines===%@",lines);
        
        city.citycode = [lines objectAtIndex:0];
        city.citycode =  [city.citycode  stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        city.cityname = [lines objectAtIndex:1];
        city.cityname =  [city.cityname  stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        city.provcode = [lines objectAtIndex:2];
        city.provcode =  [city.provcode  stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        city.bdcode = [lines objectAtIndex:3];
        city.bdcode =  [city.bdcode  stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        NSLog(@"%@----%@",provcode,city.provcode);
        if ([provcode isEqualToString:city.provcode]) {
             [_arrCity addObject:city];
        }

    }
    NSLog(@"count====%ld",_arrCity.count);
      [_tableCity reloadData];
}
-(void)getCountryData:(NSString *)citycode{
    [_arrCounty removeAllObjects];
    NSString *txtPath = [[NSBundle mainBundle]  pathForResource:@"wr_town" ofType:@"txt"];
    //    将txt到string对象中，编码类型为NSUTF8StringEncoding
    NSString *string = [[NSString  alloc] initWithContentsOfFile:txtPath encoding:NSUTF8StringEncoding error:nil];
    NSArray *contentsArray = [string componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    for (NSString *strcode in contentsArray) {
        
        
        NSRange range = [strcode rangeOfString:citycode];//判断字符串是否包含
        
        //if (range.location ==NSNotFound)//不包含
        if (range.length >0)//包含
        {
        }
        else//不包含
        {
            continue;
        }
        Country *country = [Country new];
        NSArray *lines = [strcode componentsSeparatedByString:@"	"];
        if (lines.count <4) {
            continue;
        }
        NSLog(@"lines===%@",lines);
        
        country.countrycode = [lines objectAtIndex:0];
        country.countrycode =  [country.countrycode  stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        
        country.countryname = [lines objectAtIndex:1];
        country.countryname =  [country.countryname  stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        
        country.provcode = [lines objectAtIndex:2];
        country.provcode =  [country.provcode  stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        
        country.citycode = [lines objectAtIndex:3];
        country.citycode =  [country.citycode  stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        if ([citycode isEqualToString:country.citycode]) {
            [_arrCounty addObject:country];
        }
        
        [_tableCounty reloadData];
    }
}
#pragma mark -- 配置界面
- (UITableView *)tableProvince{
    if (!_tableProvince) {
        _tableProvince = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableProvince.dataSource = self;
        _tableProvince.delegate = self;

    }
  
    return _tableProvince;
}
- (UITableView *)tableCity{
    if (!_tableCity) {
        _tableCity = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableCity.dataSource = self;
        _tableCity.delegate = self;
        
    }
    
    return _tableCity;
}
- (UITableView *)tableCounty{
    if (!_tableCounty) {
        _tableCounty = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableCounty.dataSource = self;
        _tableCounty.delegate = self;
        
    }
    
    return _tableCounty;
}

#pragma mark - UITableViewDataSource && UITableViewDelegate

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tableProvince) {
        return _arrProvince.count;
    }else if(tableView == _tableCity){
        return _arrCity.count;
    }else if(tableView == _tableCounty){
   
        return _arrCounty.count;
    }
    return 1;// _expressArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CityCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (tableView == _tableProvince) {
        Province *province = [_arrProvince objectAtIndex:indexPath.row];
       cell.textLabel.text = province.provname;
        cell.textLabel.font = [UIFont systemFontOfSize:12];
    }else if(tableView == _tableCity){
        City *city = [_arrCity objectAtIndex:indexPath.row];
        cell.textLabel.text = city.cityname;
        cell.textLabel.font = [UIFont systemFontOfSize:12];
    }else if(tableView == _tableCounty){
        Country *country = [_arrCounty objectAtIndex:indexPath.row];
        cell.textLabel.text = country.countryname;
        cell.textLabel.font = [UIFont systemFontOfSize:12];
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tableProvince) {
         Province *province = [_arrProvince objectAtIndex:indexPath.row];
        [self getCityData:province.provcode];
        strProvince = province.provname;
      
    }else if(tableView == _tableCity){
        City *city = [_arrCity objectAtIndex:indexPath.row];
        [self getCountryData:city.citycode];
        strCity = city.cityname;
        citycode = city.citycode;
    }else if(tableView == _tableCounty){
        Country *country = [_arrCounty objectAtIndex:indexPath.row];
        strCountry = country.countryname;
        NSString *address = [NSString stringWithFormat:@"%@%@%@",strProvince,strCity,strCountry];
        NSString *towncode = country.countrycode;
        NSString *townname = country.countryname;
        if (self.returnTextBlock != nil) {
            self.returnTextBlock(address,citycode,towncode,strCity,townname);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)returnText:(ReturnTextBlock)block {
    self.returnTextBlock = block;
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
