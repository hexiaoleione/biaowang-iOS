//
//  FindGoodsTableViewCell.h
//  iwant
//
//  Created by 公司 on 2016/11/28.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ClickBlock) (id sender);


@interface FindGoodsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeLabel; //时间
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;  //距离
@property (weak, nonatomic) IBOutlet UILabel *destinationLabel;  //目的地
@property (weak, nonatomic) IBOutlet UILabel *goodsName;  //货物名称

@property (weak, nonatomic) IBOutlet UILabel *weightLabel;   //货物重量
@property (weak, nonatomic) IBOutlet UILabel *squareLabel;   //货物体积
@property (weak, nonatomic) IBOutlet UILabel *quHuo;    //是否上门取货
@property (weak, nonatomic) IBOutlet UILabel *songHuo;   //是否送货上门
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;   //查看详情

@property (copy, nonatomic)  ClickBlock block;
@end
