//
//  AdView.m
//  iwant
//
//  Created by 公司 on 2017/4/25.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "AdView.h"
#import "ActivityNewVC.h"
#import "MainHeader.h"
@interface AdView()<SDCycleScrollViewDelegate>{
    NSMutableArray * _imagesURLStrings;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *adViewWidthConstraint;
@end

@implementation AdView
-(void)awakeFromNib{
    [super awakeFromNib];
    self.adViewWidthConstraint.constant = 302*RATIO_WIDTH;
    [ExpressRequest sendWithParameters:nil MethodStr:[NSString stringWithFormat:@"%@activity/getAdvert",BaseUrl] reqType:k_GET success:^(id object) {
        NSArray * arr = [object objectForKey:@"data"];
        _imagesURLStrings = [[NSMutableArray alloc]init];

        for (NSDictionary * dict in arr) {
            [_imagesURLStrings addObject:[dict valueForKey:@"pointName"]];
        }
        _viewBG.layer.cornerRadius = 5;
        _viewBG.layer.masksToBounds = YES;
        _cycleScrollView.pageControlBottomOffset = - 10;
        _cycleScrollView.delegate = self;
        _cycleScrollView.imageURLStringsGroup = (NSArray *)_imagesURLStrings ;
        _cycleScrollView.layer.cornerRadius = 5;
        _cycleScrollView.layer.masksToBounds = YES;
        [self.viewBG addSubview:_cycleScrollView];
        

    } failed:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
}

- (IBAction)cancelBtn:(UIButton *)sender {
    [self removeFromSuperview];
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"%ld",index);
    if (_Block) {
        _Block();
    }
    [self removeFromSuperview];
}

@end
