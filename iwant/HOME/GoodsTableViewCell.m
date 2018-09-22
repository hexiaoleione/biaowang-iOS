//
//  GoodsTableViewCell.m
//  iwant
//
//  Created by pro on 16/4/29.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

typedef enum status_type{
    PRE_PAY = 0,
    PAYED,
    GET_BILL,
    PICKED,
    CANCLED,
    SUCCESSED,
    DELETE,
    EVALUTED,
    USERCANCEL,
    HUOWUWEIGUI
}STATUS_TYPE;

#import "GoodsTableViewCell.h"
#import "YLGIFImage.h"
#define WINDOW_WIDTH                [[UIScreen mainScreen] bounds].size.width
@interface GoodsTableViewCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gifHeight;
@property (weak, nonatomic) IBOutlet UIImageView *limitImg;

@property (weak, nonatomic) IBOutlet UIImageView *StateGif;
@property (weak, nonatomic) IBOutlet UILabel *limitTime;

@property (weak, nonatomic) IBOutlet UILabel *publishTime;
@property (weak, nonatomic) IBOutlet UILabel *matName;
@property (weak, nonatomic) IBOutlet UILabel *driverName;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UIImageView *imageview;

- (IBAction)cancel:(id)sender;
@end

@implementation GoodsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];    

}
-(void)setModel:(ShunFeng *)model
{
    
    
    _publishTime.text = [NSString stringWithFormat:@"%@",model.publishTime];
    _matName.text = [NSString stringWithFormat:@"物品名称:%@",model.matName];
    _imageview.image = [UIImage imageNamed:@"right_bar1"];

    switch ([model.status integerValue]) {
            
        case PAYED:
            _titleLable.text = @"等待接镖";
            _StateGif.image = [YLGIFImage imageNamed:@"zhuangtai1.gif"];
            _cancelBtn.hidden = NO;
            _driverName.text = [NSString stringWithFormat:@"收件人:%@",model.personNameTo];

            break;
        case GET_BILL:
            _titleLable.text = @"等待取镖";
            _cancelBtn.hidden = NO;
            _StateGif.image = [YLGIFImage imageNamed:@"zhuangtai1.gif"];
            _driverName.text = [NSString stringWithFormat:@"镖师:%@",model.driverName];

            break;
        case PICKED:
            _titleLable.text = @"押镖中";
            _StateGif.image = [YLGIFImage imageNamed:@"zhuangtai2.gif"];
            _driverName.text = [NSString stringWithFormat:@"镖师:%@",model.driverName];

            break;
        case CANCLED:
            if (model.ifAgree.length >0) {
            _titleLable.text = @"货物违规取消";
            }else{
            _titleLable.text = @"镖师取消押镖";
            }
            _titleLable.textColor = [UIColor redColor];


            _StateGif.image = [YLGIFImage imageNamed:@"镖师取消订单.gif"];
            _driverName.text = [NSString stringWithFormat:@"镖师:%@",model.driverName];

            break;
        case SUCCESSED:
            _titleLable.text = @"押镖完成(待评价)";
            
            _StateGif.image = [YLGIFImage imageNamed:@"zhangtai3.gif"];
            _driverName.text = [NSString stringWithFormat:@"镖师:%@",model.driverName];

            break;
        case EVALUTED:
            _titleLable.text = @"押镖完成(完成评价)";
            _StateGif.image = [YLGIFImage imageNamed:@"zhangtai3.gif"];
            _driverName.text = [NSString stringWithFormat:@"镖师:%@",model.driverName];

            break;
         case USERCANCEL:
            _titleLable.text = @"已取消发布";
            _titleLable.textColor = [UIColor redColor];
            _StateGif.image = [YLGIFImage imageNamed:@"镖师取消订单.gif"];
            _driverName.text = [NSString stringWithFormat:@"收件人:%@",model.personNameTo];
            break;
        case HUOWUWEIGUI:
            _titleLable.text =@"货物违规";
            _titleLable.textColor = [UIColor blueColor];
            _StateGif.image = [YLGIFImage imageNamed:@"镖师取消订单.gif"];
            _driverName.text = [NSString stringWithFormat:@"镖师:%@",model.driverName];
            
        default:
            break;
    }
    if (WINDOW_WIDTH == 414) {
        self.gifHeight.constant = 35;
    }
    
    if (model.limitTime.length>0 && ![model.limitTime isEqualToString:@""]) {
        _limitImg.hidden = NO;
//        _limitTime.hidden = NO;
//        _limitTime.text = [NSString stringWithFormat:@"限时%@到达",model.limitTime];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (IBAction)cancel:(id)sender {
    
    if ([_delegate respondsToSelector:@selector(cancel:AtIndexPath:)]) {
        [_delegate cancel:sender AtIndexPath:self.a];
    }
    
    
}
@end
