//
//  ShareViewController.m
//  iwant
//
//  Created by 公司 on 2017/7/1.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "ShareViewController.h"
#import "ShareView.h"
@interface ShareViewController ()

@end

@implementation ShareViewController

- (instancetype)initWithDismissOpration:(void (^)(void))dismissfn
{
    self = [super init];
    if (self) {
        self.dismiss = dismissfn;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setCostomeTitle:@"分享"];
    ShareView *share =   [[ShareView alloc]initWithFrame:self.view.bounds type:_types dismissOpration:^{
      self.dismiss();
      [self.navigationController popViewControllerAnimated:YES];
        
    }];
    self.view = share;
    
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
