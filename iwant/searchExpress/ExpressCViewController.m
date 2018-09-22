//
//  ExpressCViewController.m
//  Express
//
//  Created by user on 15/8/11.
//  Copyright (c) 2015年 SCHT. All rights reserved.
//

#import "ExpressCViewController.h"
#import "ExpCompany.h"
#import "UserManager.h"
#import "MainHeader.h"
@interface ExpressCViewController () <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    NSMutableArray *_companyArray;
    
    NSMutableArray *_favorityArray;
    NSMutableArray *_otherArray;
    
}

@property (strong,nonatomic) NSArray *names;
@property (strong,nonatomic) NSMutableArray *mutableCompanyArray;
@property (strong,nonatomic) NSMutableArray *mutableFavoriteArray;
@property (strong,nonatomic) NSMutableArray *mutableOtherArray;


@property (strong,nonatomic)NSMutableArray *mutableKeys;
@property (strong, nonatomic) UITableView *table;
@property (strong, nonatomic) UISearchBar *search;
-(void)resetSearch;
-(void)handleSearchForTerm:(NSString *)searchTerm;
//处理搜索，即把不包含searchTerm的值从可变数组中删除
@end

@implementation ExpressCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"常用快递公司";
     self.view.backgroundColor  = [UIColor whiteColor];
    [self configNavgationBar];
    
    [self makeCompanyArray];
    
    [self configSubview];
    
    [self resetSearch];
    //重置
    [_table reloadData];
}

- (void)configSubview
{
    _search = [[UISearchBar alloc]initWithFrame:CGRectZero];
    _search.searchBarStyle  = UISearchBarStyleDefault;
    _search.delegate = self;
    _search.placeholder = @"请输入快递公司";
    _search.keyboardType = UIKeyboardTypeASCIICapable;
    [self.view addSubview:_search];
    [_search mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    _table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _table.delegate = self;
    _table.dataSource = self;
    [self.view addSubview:_table];
    
    [_table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(0);
        make.top.mas_equalTo(50);
    }];
    
}

- (void)makeCompanyArray
{
    NSString *txtPath = [[NSBundle mainBundle]  pathForResource:@"expcomp" ofType:@"txt"];
    //    将txt到string对象中，编码类型为NSUTF8StringEncoding
    NSString *string = [[NSString  alloc] initWithContentsOfFile:txtPath encoding:NSUTF8StringEncoding error:nil];
    NSArray *contentsArray = [string componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
//    _companyArray = [NSMutableArray array];
    _favorityArray = [NSMutableArray array ];
    _otherArray = [NSMutableArray array ];
    for (NSString *strcode in contentsArray) {
        ExpCompany *company = [[ExpCompany alloc]init];
        NSArray *lines = [strcode componentsSeparatedByString:@","];
        if (lines.count<3) {
            continue;
        }
        
        company.expCode = [lines objectAtIndex:0];
        company.expCode =  [company.expCode  stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        company.nameWord = [lines objectAtIndex:1];
        company.nameWord =  [company.nameWord  stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        company.expName = [lines objectAtIndex:2];
        company.expName =  [company.expName  stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        company.favorite = [lines objectAtIndex:4];
        company.favorite =  [company.favorite  stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        
        
        if ([company.favorite isEqualToString:@"Y"]) {
            [_favorityArray addObject:company];
        }
        
        else
        {
            [_otherArray addObject:company];
        }
        
        NSMutableArray *array = [NSMutableArray arrayWithArray:_favorityArray];
        [array addObjectsFromArray:_otherArray];
//        [UserManager saveCompanyArray:array];
        
//        [_companyArray addObject:company];
    }
    
    _mutableFavoriteArray = [_favorityArray mutableCopy];
    _mutableOtherArray = [_otherArray mutableCopy];
//    _mutableCompanyArray = [_companyArray mutableCopy];

}


- (void)viewDidUnload
{
    [self setTable:nil];
    [self setSearch:nil];
    [super viewDidUnload];
    self.mutableCompanyArray=nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
         return @"常用快递公司";
    }
    else
        return @"其他快递公司";
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _mutableFavoriteArray.count;
    }
    else {
        return _mutableOtherArray.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSUInteger rowNumber=[indexPath row];
    
    static NSString * tableIdentifier=@"CellFromNib";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
        
    }
    if (indexPath.section ==0) {
        cell.textLabel.text=[(ExpCompany*)[_mutableFavoriteArray objectAtIndex:rowNumber] expName];
    }
    else {
        cell.textLabel.text=[(ExpCompany*)[_mutableOtherArray objectAtIndex:rowNumber] expName];
    }
        
    return cell;
}


-(void)resetSearch
{
//    [_mutableCompanyArray removeAllObjects];
    
//    _mutableCompanyArray = [_companyArray mutableCopy];
    [_mutableFavoriteArray removeAllObjects];
    [_mutableOtherArray removeAllObjects];
    
    _mutableFavoriteArray =[_favorityArray mutableCopy];
    _mutableOtherArray = [_otherArray mutableCopy];
    
}
-(void)handleSearchForTerm:(NSString *)searchTerm
{
//    [_mutableCompanyArray removeAllObjects];
    [_mutableFavoriteArray removeAllObjects];
    [_mutableOtherArray removeAllObjects];
    
    
    for (ExpCompany *company in _favorityArray)
    {
        if ([company.expName rangeOfString:[searchTerm lowercaseString]].location!=NSNotFound) {
            
            [_mutableFavoriteArray addObject:company];
        }
    }
    
    for (ExpCompany *company in _otherArray)
    {
        if ([company.expName rangeOfString:[searchTerm lowercaseString]].location!=NSNotFound) {
            
            [_mutableOtherArray addObject:company];
        }
    }
    
    
    
    for (ExpCompany *company in _favorityArray)
    {
        if ([company.nameWord rangeOfString:[searchTerm lowercaseString]].location!=NSNotFound) {
            
            [_mutableFavoriteArray addObject:company];
        }
    }
    
    for (ExpCompany *company in _otherArray)
    {
        if ([company.nameWord rangeOfString:[searchTerm lowercaseString]].location!=NSNotFound) {
            
            [_mutableOtherArray addObject:company];
        }
    }
    
    [_table reloadData];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
    if (self.returnCompanyBlock) {
        self.returnCompanyBlock((ExpCompany*)[indexPath.section==0?_mutableFavoriteArray:_mutableOtherArray objectAtIndex:indexPath.row]);
    }
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_search resignFirstResponder];
    return indexPath;
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
//    NSString *searchTerm=[searchBar text];
//    [self handleSearchForTerm:searchTerm];
    [_search resignFirstResponder];
    
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{//搜索条输入文字修改时触发
    if([searchText length]==0)
    {//如果无文字输入
        [self resetSearch];
        [_table reloadData];
        return;
    }
    
    [self handleSearchForTerm:searchText];
    //有文字输入就把关键字传给handleSearchForTerm处理
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{//取消按钮被按下时触发
    [self resetSearch];
    //重置
    searchBar.text=@"";
    //输入框清空
    [_table reloadData];
    [_search resignFirstResponder];
    //重新载入数据，隐藏软键盘
    
}



#pragma mark -- bar
- (void)configNavgationBar {
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(backToMenuView)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

- (void)backToMenuView
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
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
