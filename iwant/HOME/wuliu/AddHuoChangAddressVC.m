//
//  AddHuoChangAddressVC.m
//  iwant
//
//  Created by 公司 on 2017/1/5.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "AddHuoChangAddressVC.h"
#import "HuoChangAdressVC.h"
#import "SearchResult.h"
#import "HuoChangModel.h"
#define SCALE(N)        N *(WINDOW_HEIGHT /736.0)

@interface AddHuoChangAddressVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,BMKSuggestionSearchDelegate,UITextFieldDelegate,BMKPoiSearchDelegate,UIAlertViewDelegate>
{
    UITableView * _tableView;
    NSArray * _dataArr;
    BMKSuggestionSearch *_searcher;
    SearchResult *_result;
    
    BMKPoiSearch *_poiSearch;
    
    BMKPoiResult *_searchResult;
    
    NSString * _ifDefault;

}
@property (nonatomic, retain) NSMutableArray *dataArray;


@end

@implementation AddHuoChangAddressVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChange:) name:UITextFieldTextDidChangeNotification object:self.searchTextFiled];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.searchTextFiled];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCostomeTitle:@"添加货场地址"];
    self.view.backgroundColor = BACKGROUND_COLOR;
    _ifDefault = @"0";
    
    self.localAdress.text =[[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCASTR];
    self.searchTextFiled.delegate = self;

    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.detailAdressTextField.bottom, SCREEN_WIDTH, SCREEN_HEIGHT -self.detailAdressTextField.bottom-64 )];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    _tableView.hidden = YES;

    [self initSearchManager];
    
}
-(void)initSearchManager{
    //初始化poi检索对象
    _poiSearch =[[BMKPoiSearch alloc]init];
    _poiSearch.delegate = self;
}
#pragma  mark- 建议查询检索
- (void)onGetSuggestionResult:(BMKSuggestionSearch*)searcher result:(BMKSuggestionResult*)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        NSLog(@"%@",result);
        _result = [[SearchResult alloc]init];
        _result.cityArr = result.cityList;
        _result.districtArr = result.districtList;
        _result.keyArr = result.keyList;
        _result.poiArr = result.poiIdList;
        _result.ptArr = result.ptList;
        _tableView.hidden = NO;
        [_tableView reloadData];
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}

#pragma mark- poi检索
//实现PoiSearchDeleage处理回调结果
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResultList errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        
        _searchResult = poiResultList;
        _tableView.hidden = NO;
        [_tableView reloadData];
        
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
        NSLog(@"起始点有歧义");
    } else {
        NSLog(@"抱歉，未找到结果");
    }
}
#pragma mark- poiDetail检索
-(void)onGetPoiDetailResult:(BMKPoiSearch *)searcher result:(BMKPoiDetailResult *)poiDetailResult errorCode:(BMKSearchErrorCode)errorCode
{
    if(errorCode == BMK_SEARCH_NO_ERROR){
        //在此处理正常结果
    }
}
#pragma mark-  TableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _searchResult.poiInfoList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ID"];
        
    }
    BMKPoiInfo *info = _searchResult.poiInfoList[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",info.name];
    NSRange range = [info.address rangeOfString:info.city];//判断字符串是否包含
    if (range.length >0)//包含
    {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",info.address];
    }else{
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@",info.city,info.address];
    }
    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCALE(60);
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    BMKPoiInfo *info = _searchResult.poiInfoList[indexPath.row];
//    if (_passBlock) {
        NSString *cityCode = [self getCityCode: info.city];
        if (cityCode == nil) {
            HHAlertView *alert = [[HHAlertView alloc] initWithTitle:@"" detailText:@"百度地图检索地址数据有误，请选择城市后再输入地址关键词进行搜索，请勿单独输入省名搜索" cancelButtonTitle:@"确定" otherButtonTitles:nil];
            alert.mode = HHAlertViewModeWarning;
            [alert show];
            return;
        }
        NSString *address = nil;
        NSRange range = [info.address rangeOfString:info.city];//判断字符串是否包含
        NSRange rangeP = [info.address rangeOfString:@"省"];
        if (range.length >0 || rangeP.length > 0)//包含
        {
            address = [NSString stringWithFormat:@"%@",info.address];
        }else{
            address = [NSString stringWithFormat:@"%@%@",info.city,info.address];
        }
        
//        _passBlock(address,[NSString stringWithFormat:@"%@",info.name],[NSString stringWithFormat:@"%f",info.pt.latitude],[NSString stringWithFormat:@"%f",info.pt.longitude],cityCode);
//    }
//    [self.navigationController popViewControllerAnimated:YES];
    
    
    _la = [NSString stringWithFormat:@"%f",info.pt.latitude];
    _lo = [NSString stringWithFormat:@"%f",info.pt.longitude];
    _cityCode = cityCode;
    self.searchTextFiled.text =[NSString stringWithFormat:@"%@%@",address,info.name];
    _tableView.hidden = YES;
}

#pragma mark- 城市名城市code相互转换
//根据城市名找citycode
-(NSString *)getCityCode:(NSString *)city{
    //    获取txt文件路径
    NSString *txtPath = [[NSBundle mainBundle]  pathForResource:@"wr_city" ofType:@"txt"];
    //    将txt到string对象中，编码类型为NSUTF8StringEncoding
    NSString *string = [[NSString  alloc] initWithContentsOfFile:txtPath encoding:NSUTF8StringEncoding error:nil];
    NSArray *contentsArray = [string componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    for (NSString *strcode in contentsArray) {
        
        NSArray *lines = [strcode componentsSeparatedByString:@"	"];
        if (lines.count <2) {
            continue;
        }
        NSRange range = [strcode rangeOfString:city];//判断字符串是否包含
        if (range.length >0)//包含
        {
            NSString *provcode = [lines objectAtIndex:0];
            provcode =  [provcode  stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            return provcode;
        }
        else//不包含
        {
            continue;
        }
    }
    return nil;
}


#pragma mark- textFieldDelegate

- (void)textFieldChange:(NSNotification *)info{
    
    UITextField  * field = info.object;
    if (field.tag == 0) {
        
  
    NSLog(@"字改变了:%@",_searchTextFiled.text);
//    if ([_addresslabel isFirstResponder]) {
//        return;
//    }
    //poi发起检索
    if ([_searchTextFiled.text isEqualToString:@""]) {
        _searchResult = nil;
        [_tableView reloadData];
        return;
    }
    BMKCitySearchOption *option = [[BMKCitySearchOption alloc]init];
    option.pageIndex = 0;
    option.pageCapacity = 20;
    option.keyword = _searchTextFiled.text;
    option.city = [[NSUserDefaults standardUserDefaults] valueForKey:USER_CITY];
    BOOL flag =  [_poiSearch poiSearchInCity:option];
    if(flag)
    {
        NSLog(@"周边检索发送成功");
    }
    else
    {
        NSLog(@"周边检索发送失败");
    }
    }
}



//监听搜索框
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    if (textField != _addresslabel) {
        NSLog(@"点击了搜索");
        BMKSuggestionSearchOption* option = [[BMKSuggestionSearchOption alloc] init];
        option.cityname = [[NSUserDefaults standardUserDefaults] valueForKey:USER_CITY];
        option.keyword  = textField.text;
        BOOL flag = [_searcher suggestionSearch:option];
        if(flag)
        {
            NSLog(@"建议检索发送成功");
            [_tableView reloadData];
        }
        else
        {
            NSLog(@"建议检索发送失败");
        }
        
//    }
    [textField resignFirstResponder];
    
    return YES;
}

//使用当前位置
- (IBAction)localAddressBtn:(UIButton *)sender {
    
    self.searchTextFiled.text = self.localAdress.text;
    _la =[[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCATION_LAT];
    _lo =[[NSUserDefaults standardUserDefaults] valueForKey:USER_LOCATION_LON];
    _cityCode = [[NSUserDefaults standardUserDefaults] valueForKey:USER_CITY_CODE];
}
- (IBAction)switchChange:(UISwitch *)sender {
    if (sender.on) {
        _ifDefault =@"1";
    }else{
        _ifDefault = @"0";
    }

}

//确认添加
- (IBAction)makeSureAdd:(UIButton *)sender {
    if (![self checkPrem]) {
        return;
    }

    NSString *URLStr = [NSString stringWithFormat:@"%@",API_WL_HUOCHANG_ADD];
    NSDictionary * dic = @{@"userId":[UserManager getDefaultUser].userId,
                           @"locationAddress":self.searchTextFiled.text,
                           @"address":self.detailAdressTextField.text,
                           @"cityCode":_cityCode,
                           @"latitude":_la,
                           @"longitude":_lo,
                           @"ifDefault":_ifDefault,
                           @"ifDelete":@"0"};
    [ExpressRequest sendWithParameters:dic MethodStr:URLStr reqType:k_POST success:^(id object) {
//        NSString * message = [object valueForKey:@"message"];
//        [SVProgressHUD showSuccessWithStatus:message];
//
        [self.navigationController popViewControllerAnimated:YES];
    } failed:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
}

-(BOOL)checkPrem{
    if (self.searchTextFiled.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入关键字搜索"];
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
