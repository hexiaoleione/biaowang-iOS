//
//  LDPickViewController.m
//  iwant
//
//  Created by dongba on 16/8/25.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "LDPickViewController.h"
#import "MainHeader.h"

@interface LDPickViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>


@property (strong, nonatomic)  UIPickerView *pickerView;


@property (copy, nonatomic)  NSString *selectedStr;

@end



@implementation LDPickViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *topView = [UIView new];
    topView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    topView.layer.borderWidth = 1;
    topView.backgroundColor = BACKGROUND_COLOR;
    topView.frame = CGRectMake(0, 0, WINDOW_WIDTH, 40);
    [self.view addSubview:topView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancleBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancleBtn.frame = CGRectMake(5, 5, 100, 30);
    [cancleBtn addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancleBtn];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    sureBtn.frame = CGRectMake(WINDOW_WIDTH - 105, 5, 100, 30);
    [sureBtn addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
    
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, self.view.width, 150)];
    //初始化数据
    
//    self.dataArray = @[
//  @[@"红色",@"红色",@"红色",@"红色",@"红色",@"红色"]
//  ];
    //设置pickerView的代理和数据源
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    
    [self.view addSubview:_pickerView];
    
}

- (void)cancle{
    self.view.hidden = YES;
}

- (void)sure{
    self.view.hidden = YES;
    _block(_selectedStr ? _selectedStr : _dataArray[0][0]);
}

#pragma mark - pickerView的代理方法
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return  _dataArray.count;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger row = 0;
    row = [(NSArray *)self.dataArray[component] count];
   
    return row;
}
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    NSString *title = self.dataArray[component][row];
    
    return  title;
}
//设置每一列的宽度
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    CGFloat width = 0.0f;
    switch (component)
    {
        case 0:
            width = pickerView.frame.size.width/2;
            break;
        case 1:
            width = pickerView.frame.size.width/4;
            break;
        case 2:
            width = pickerView.frame.size.width/4;
            break;
    }
    return width;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
 
    _selectedStr = _dataArray[component][row];
    //设置label的font
//    self.label.font = [UIFont fontWithName:self.fontNames[[pickerView selectedRowInComponent:0]] size:[self.fontSizes[[pickerView selectedRowInComponent:1]] integerValue]];
//    
//    self.label.textColor = [self.fontColors[[pickerView selectedRowInComponent:2]] objectForKey:@"color"];
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
