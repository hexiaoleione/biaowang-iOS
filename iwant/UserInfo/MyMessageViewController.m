//
//  MyMessageViewController.m
//  iwant
//
//  Created by pro on 16/3/8.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "MyMessageViewController.h"
#import "Message.h"
#import "MessageCell.h"
#import "UserManager.h"
#import "SVProgressHUD.h"
#import "RequestManager.h"
#import "SVProgressHUD.h"
#import "MJRefresh.h"
#import "MainHeader.h"
#import "SysMsgPopView.h"
#import "D3View.h"
#define MAINSCREENBOUNDS [UIScreen mainScreen].bounds

#define FONT(A,IFBOLD)                IFBOLD ? [UIFont boldSystemFontOfSize:WINDOW_WIDTH > 320 ? A : A/1.3]: [UIFont systemFontOfSize:WINDOW_WIDTH > 320 ? A : A/1.3]
#define WINDOW_WIDTH                [[UIScreen mainScreen] bounds].size.width
#define WINDOW_HEIGHT               [[UIScreen mainScreen] bounds].size.height

@interface MyMessageViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_tableView;
    NSMutableArray *_messageArray;
    UITextView *_label;
    UIScrollView *_scroll;
    UILabel *_titleLabel;
    
    UILabel *_timelabel;
    
    UIButton *closeBtn;
    UIVisualEffectView *visualEffectView;
    UIButton *_closeedBtn;
    int _pageNo;
}

@end

@implementation MyMessageViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0x222231)];
    self.navigationController.navigationBar.translucent = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息中心";
    self.view.backgroundColor = [UIColor whiteColor];

    [self NavgationBar];
    [self configTableView];
    //消息内容
    [self creatLabel];
    [self loadDataArray:NO];

}
/*消息内容*/
- (void)creatLabel{
    [self setMohu];
    _scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, MAINSCREENBOUNDS.size.height, MAINSCREENBOUNDS.size.width, MAINSCREENBOUNDS.size.height /2)];
    _scroll.frame = CGRectMake(SCREEN_WIDTH/2, (SCREEN_HEIGHT - 64)/2, 0, 0);
    [self.view addSubview:_label];
    
    _scroll.layer.borderWidth = 1.5f;
    _scroll.layer.borderColor =[UIColor orangeColor].CGColor;
    
    _scroll.layer.cornerRadius = 5;
    _scroll.backgroundColor = [UIColor whiteColor];
    _scroll.showsVerticalScrollIndicator = FALSE;
    _label = [[UITextView alloc]initWithFrame:CGRectMake(5, 30, CGRectGetWidth(_scroll.frame) - 60, MAINSCREENBOUNDS.size.height / 2)];
    //    _label.lineBreakMode = UILineBreakModeWordWrap;
//    _label.numberOfLines = 0;
    _label.dataDetectorTypes = UIDataDetectorTypeAll;
    _label.editable = NO;
//    _label.userInteractionEnabled = NO;
    _label.font = FONT(17, NO);
    //    _label.layer.cornerRadius = 5;
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 30, MAINSCREENBOUNDS.size.width - 90, 50)];
    _titleLabel.font = FONT(20, NO);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    
    closeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //    [closeBtn  setTitle:@"关闭" forState:UIControlStateNormal];
    [closeBtn setTintColor:[UIColor blueColor]];
    //    closeBtn.backgroundColor = [UIColor whiteColor];
    closeBtn.frame = CGRectMake(SCREEN_WIDTH - 30, MAINSCREENBOUNDS.size.height/2, 30, 30);
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"closed"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(fadeOut) forControlEvents:UIControlEventTouchUpInside];
    closeBtn.hidden = YES;
    
    
    _timelabel = [[UILabel alloc]initWithFrame:CGRectMake(80,  CGRectGetMaxY(_label.frame)+30, 150, 30)];
    _timelabel.font = FONT(15, NO);
    _timelabel.textAlignment = NSTextAlignmentCenter;
    _timelabel.text = @"";
    
    
    
    
    _closeedBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_closeedBtn  setTitle:@"" forState:UIControlStateNormal];
    [_closeedBtn setTintColor:[UIColor blueColor]];
    //    [_closeedBtn setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    _closeedBtn.backgroundColor = [UIColor whiteColor];
    _closeedBtn.frame = CGRectMake(21, (SCREEN_HEIGHT - 64)/2 +(SCREEN_HEIGHT/2 + 30 )/2 -20 ,SCREEN_WIDTH - 42, 20);
    _closeedBtn.layer.cornerRadius = 18.0;
    _closeedBtn.alpha = 0.99;
    
    [_closeedBtn addTarget:self action:@selector(fadeOut) forControlEvents:UIControlEventTouchUpInside];
    _closeedBtn.hidden = YES;
    
    [self.view addSubview:_scroll];
    [_scroll addSubview:_titleLabel];
    [_scroll addSubview:_label];
    [self.view addSubview:closeBtn];
    [_scroll addSubview:_timelabel];
    
//    [self.view addSubview:_closeedBtn];
}
- (void)setMohu{
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    visualEffectView.frame = self.view.bounds;
    visualEffectView.alpha = 0.4;
    [self.view addSubview:visualEffectView];
    visualEffectView.hidden = YES;
}
- (void)loadDataArray:(BOOL)isAdd{
        if (isAdd) {
            _pageNo++;
        }else{
            _pageNo = 1;
        }
    [RequestManager getMessageWithuserId:[UserManager getDefaultUser].userId pageNo:[NSString stringWithFormat:@"%d",_pageNo] pageSize:@"20" Success:^(NSArray *result) {
        if (_pageNo == 1) {
            _messageArray = [NSMutableArray arrayWithArray:result];
        }else{
            [_messageArray addObjectsFromArray:result];
        }
        if (_messageArray.count == 0) {
            _tableView.hidden = YES;
        }
        [_tableView reloadData];
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
    }
  Failed:^(NSString *error) {
        
      [SVProgressHUD showErrorWithStatus:error];
      [_tableView.header endRefreshing];
      [_tableView.footer endRefreshing];
      

    }];
    
    
}

- (void)configTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    __weak MyMessageViewController *weakSelf = self;
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf loadDataArray:NO];
    }];
    [_tableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf loadDataArray:YES];
    }];
    [_tableView.header beginRefreshing];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,80)];
    _tableView.tableFooterView = v;
        
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 200, SCREEN_WIDTH, 100)];
    textLabel.text = @"暂无更多消息";
    textLabel.font = FONT(30, NO);;//采用系统默认文字设置大小
    
    textLabel.textColor = [UIColor grayColor];
    textLabel.textAlignment = NSTextAlignmentCenter;
    
    
    [self.view addSubview:textLabel];
    [self.view addSubview:_tableView];


}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _messageArray.count;
    
//    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell"];
    
    if (!cell) {
        
        cell = [[MessageCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"messageCell"];
    }
    Message *model = _messageArray[indexPath.row];
    cell.tag = indexPath.row;
    if (model.ifReaded ) {
        cell.imageView.image = [UIImage imageNamed:@"message_0"];
    }else{
        cell.imageView.image = [UIImage imageNamed:@"message_1"];
    }
    
    cell.textLabel.text = model.messageTitle;
    cell.detailTextLabel.text = model.messageDesc ;
    cell.detailTextLabel.font = FONT(15, NO);
    cell.timeLabel.text = [model.sendTime substringToIndex:10];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Message *model = _messageArray[indexPath.row];
    [RequestManager readMessageWithMessageId:model.messageId
                                     Success:^{
                                                     NSLog(@"第%@+1条信息标记为已读",model.messageId);
                                         [self loadDataArray :NO];
                                     } Failed:^(NSString *error) {
                                         nil;
                                     }];
    [self showPopview:model];
}

-(void)showPopview:(Message *)model{
    SysMsgPopView *msgView = [[[NSBundle mainBundle] loadNibNamed:@"SysMsgPopView" owner:nil options:nil] lastObject];
    msgView.backgroundColor = [UIColor redColor];
    __weak SysMsgPopView *weakMsgView = msgView;
    msgView.block = ^(id sender){
        [weakMsgView d3_fadeOut:0.4 completion:nil];
    };
    msgView.frame  = CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT);
    [msgView setModel:model];
    [msgView d3_fadeIn:0.4 completion:nil];
    [[UIApplication sharedApplication].keyWindow addSubview:msgView];
    
}

#pragma mark - bar
- (void)NavgationBar {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 60)];
    label.textColor = [UIColor whiteColor];
    label.text = @"我的消息";
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self  action:@selector(backToMenuView)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"全部删除" style:UIBarButtonItemStylePlain target:self action:@selector(delete)];
    rightBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
}

- (void)delete{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您确认要删除吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [SVProgressHUD show];
        //    NSDictionary *dic = @{k_USER_ID:[UserManager getDefaultUser].userId};
        [ExpressRequest sendWithParameters:nil MethodStr:[NSString stringWithFormat:@"%@/%@",API_SYS_DELE_ALL,[UserManager getDefaultUser].userId] reqType:k_PUT success:^(id object) {
            _messageArray = nil;
            [_tableView setHidden:YES];
            [SVProgressHUD dismiss];
        } failed:^(NSString *error) {
            [SVProgressHUD showErrorWithStatus:error];
        }];
    }];
    [alert addAction:cancelAction];
    [alert addAction:sureAction];
    [self presentViewController:alert animated:YES completion:nil ];
    
    
}

- (void)backToMenuView
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

//直接使用[self setInfoViewFrame:YES];//or NO (以下infoView为自定义的view)
- (void)creatPopoverView :(Message *)model{
    visualEffectView.hidden = NO;
    _titleLabel.text = model.messageTitle;
    _titleLabel.numberOfLines = 0;
    _label.text = model.messageDesc;
    _timelabel.text = model.sendTime;
    
    [UIView animateWithDuration:0.3f animations:^{
        CGSize size = [self sizeWithText:model.messageDesc font:[UIFont systemFontOfSize:17] maxSize:CGSizeMake(SCREEN_WIDTH- 70, 199999)];
        _scroll.frame = CGRectMake(0,MAINSCREENBOUNDS.size.height *0.1 , MAINSCREENBOUNDS.size.width -80, SCREEN_HEIGHT*0.7);
        _scroll.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT *0.4);
        _scroll.contentSize = CGSizeMake(CGRectGetWidth(_scroll.frame), size.height +80 + 100);
        _label.frame = CGRectMake(20,75, CGRectGetWidth(_scroll.frame) - 40, size.height +50);
    } completion:^(BOOL finished) {
        _closeedBtn.hidden = NO;
        closeBtn.hidden = NO;
        closeBtn.frame = CGRectMake(CGRectGetMaxX(_scroll.frame) - 30, _scroll.frame.origin.y, 30, 30);
    }];
    /*
     UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定"
     style:UIBarButtonItemStylePlain
     target:self
     action:@selector(fadeOut)];
     self.navigationItem.rightBarButtonItem = leftBarButtonItem;
     */
}

-(void) fadeOut
{
    [UIView animateWithDuration:0.3f animations:^{
        _scroll.frame = CGRectMake(SCREEN_WIDTH / 2, (SCREEN_HEIGHT - 64)/2, 0, 0);
        closeBtn.hidden = YES;
        visualEffectView.hidden = YES;
        _closeedBtn.hidden = YES;
    } completion:^(BOOL finished) {
//        self.navigationItem.rightBarButtonItem = nil;
    }];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TRUE;
}
//删除cell
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Message *model = _messageArray[indexPath.row];
    [RequestManager deleteMessageWithMessageId:model.messageId Success:^{
        [SVProgressHUD showSuccessWithStatus:@"删除成功"];
         [_messageArray removeObjectAtIndex:indexPath.row];
        [_tableView reloadData];
    }
    Failed:^(NSString *error) {
         [SVProgressHUD showErrorWithStatus:error];
    }];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
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
