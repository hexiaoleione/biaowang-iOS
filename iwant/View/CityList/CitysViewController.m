//
//  ViewController.m
//  CityListDemo
//
//  Created by md on 16/6/1.
//  Copyright © 2016年 HKQ. All rights reserved.
//

#import "CitysViewController.h"
#import "CityTableViewCell.h"


#define kDocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

@interface CitysViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    NSMutableArray *totalArr;
    UITableView *mTableView;
    NSMutableDictionary *cityDict;//
    NSMutableArray *searchArr;//搜索到的内容
    NSMutableArray *citys;
    NSMutableArray *saveArr;//要保存的数据
    UISearchBar *mSearchBar;
}


@end

@implementation CitysViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //搜索按钮
    mSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 50)];
    mSearchBar.delegate = self;
    mSearchBar.placeholder = @"请输入城市中文名或者拼音";
    mSearchBar.searchBarStyle = UISearchBarStyleDefault;
    //在键盘上部添加一个隐藏按钮
    UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    inputView.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(inputView.frame.size.width-50, 0, 50, inputView.frame.size.height);
    [btn setTitle:@"🔽" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn addTarget:self action:@selector(onHideKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [inputView addSubview:btn];
    mSearchBar.inputAccessoryView = inputView;
    [self.view addSubview:mSearchBar];
    
    totalArr = [[NSMutableArray alloc] initWithCapacity:10];
    cityDict = [[NSMutableDictionary alloc] init];
    citys = [[NSMutableArray alloc] init];
    searchArr = [[NSMutableArray alloc] init];
    saveArr = [[NSMutableArray alloc] init];
    
    //创建一个tableView
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, mSearchBar.frame.size.height+20, self.view.frame.size.width, self.view.frame.size.height - 20 - 50)];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    mTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:mTableView];
    //获取本地数据
    [self LoadFromLocal];
    if (totalArr.count > 0) {
        citys = totalArr;
        //将首字母相同的放在一起
        [self getAllCitys];
        [mTableView reloadData];
    }
}
- (void)onHideKeyboard {
    [self.view endEditing:NO];
}

#pragma mark - 将首字母相同的放在一起
- (void)getAllCitys
{
    //遍历
    for (CityModel *model in totalArr) {
        NSMutableArray *letterArr = cityDict[model.m_letter];
        //判断数组里是否有元素，如果为nil，则实例化该数组，并在cityDict字典中插入一条新的数据
        if (letterArr == nil) {
            letterArr = [[NSMutableArray alloc] init];
            [cityDict setObject:letterArr forKey:model.m_letter];
        }
        //将新数据放到数组里
        [letterArr addObject:model];
    }
}

#pragma mark - 获得所有的key值并排序，并返回排好序的数组
- (NSArray *)getCityDictAllKeys
{
    //获得cityDict字典里的所有key值，
    NSArray *keys = [cityDict allKeys];
    //打印
//    NSLog(@"keys = %@",[keys sortedArrayUsingSelector:@selector(compare:)]);
    //按升序进行排序（A B C D……）
    return [keys sortedArrayUsingSelector:@selector(compare:)];
}

#pragma mark - tableView--delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

//引入索引的一个代理方法
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSArray *keys = [self getCityDictAllKeys];//获得所有的key值
    return keys;
}
//section上的标题（A B C D……Z）
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray *keys = [self getCityDictAllKeys];//获得所有的key值（A B C D……Z）
    return keys[section];
}
//section的个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSArray *keys = [self getCityDictAllKeys];//获得所有的key值
    return keys.count;
}
//每个section对应的cell的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *keys = [self getCityDictAllKeys];//获得所有的key值
    NSString *keyStr = keys[section];//（A B C D……Z）
    NSArray *array = [cityDict objectForKey:keyStr];//所有section下key值所对应的value的值
    return array.count;
}
//返回cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cell";
    CityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[CityTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify];
    }
    NSArray *keys = [self getCityDictAllKeys];//获得所有的key值
    NSString *keyStr = keys[indexPath.section];
    NSArray *array = [cityDict objectForKey:keyStr];//所有section下key值所对应的value的值,array就是value值，存放的是model模型
    CityModel *model = [array objectAtIndex:indexPath.row];
    [cell contentCityTableViewCell:model];
    return cell;
}
//点击每个cell触发的事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *keys = [self getCityDictAllKeys];//获得所有的key值
    NSString *keyStr = keys[indexPath.section];
    NSArray *array = [cityDict objectForKey:keyStr];//所有section下key值所对应的value的值,array就是value值，存放的是model模型
    CityModel *model = [array objectAtIndex:indexPath.row];
    
    if (_block) {
        _block(model.city_name);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
#pragma mark - UISearchBar - delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    BOOL isSearch = YES;//有编辑内容时为YES
    if (searchText.length <= 0) {
        isSearch = NO;//被清空时为NO
    }
    NSString *searchStr = mSearchBar.text;
    [searchArr removeAllObjects];//清空searchDataArr，防止显示之前搜索的结果内容
    //把这个文本与数据源进行比较
    //把数据源中类似的数据取出，存入searchDataArr
    for (NSInteger i= 0;i < totalArr.count ; i ++)
    {
        CityModel *model = totalArr[i];
        searchStr = [searchStr lowercaseString];//转换成小写
        BOOL isHas = [model.city_name hasPrefix:searchStr];//判断model.city_name是否以字符串searchStr开头
        if(isHas)
        {
            [searchArr addObject:model];
        }else{
            isHas = [model.city_pinyin hasPrefix:searchStr];
            if (isHas) {
                [searchArr addObject:model];
            }
        }
    }
    if (searchStr.length>0) {
        [cityDict removeAllObjects];
        //遍历
        for (CityModel *model in searchArr) {
            NSMutableArray *letterArr = cityDict[model.m_letter];
            //判断数组里是否有元素，如果为nil，则实例化该数组，
            if (letterArr == nil) {
                letterArr = [[NSMutableArray alloc] init];
                [cityDict setObject:letterArr forKey:model.m_letter];
            }
            [letterArr addObject:model];
        }
        
    }else{
        //遍历
        for (CityModel *model in totalArr) {
            NSMutableArray *letterArr = cityDict[model.m_letter];
            //判断数组里是否有元素，如果为nil，则实例化该数组，
            if (letterArr == nil) {
                letterArr = [[NSMutableArray alloc] init];
                [cityDict setObject:letterArr forKey:model.m_letter];
            }
            [letterArr addObject:model];
        }
    }
    [mTableView reloadData];
}

#pragma mark - 返回按钮触发事件
- (void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 获取本地数据
- (void)LoadFromLocal {
    //先清空数组里的元素
    [totalArr removeAllObjects];
    [saveArr removeAllObjects];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"MyCitylist" ofType:@"plist"];
    //获取本地数据,放到数组里
    NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:path];
    for (NSDictionary *info in array) {
        [saveArr addObject:info];
    }
    for (NSDictionary *mDictionary in saveArr) {
        CityModel *model = [[CityModel alloc] init];
        model.city_id = [mDictionary objectForKey:@"city_id"];
        model.city_name = [mDictionary objectForKey:@"city_name"];
        model.city_pinyin = [mDictionary objectForKey:@"city_pinyin"];
        model.short_name = [mDictionary objectForKey:@"short_name"];
        model.short_pinyin = [mDictionary objectForKey:@"short_pinyin"];
        NSString *letterStr = [[model.city_pinyin substringWithRange:NSMakeRange(0, 1)] uppercaseString];//获取首字母并转换成大写
        model.m_letter = letterStr;
        [totalArr addObject:model];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
