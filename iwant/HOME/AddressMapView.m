//
//  AddressView.m
//  iwant
//
//  Created by 公司 on 2017/3/16.
//  Copyright © 2017年 FatherDong. All rights reserved.
//

#import "AddressMapView.h"

@implementation AddressMapView

-(void)awakeFromNib{
    [super awakeFromNib];
}

-(CGSize)getSizeByString:(NSString *)string AndFontSize:(CGFloat)font{
    CGSize size = [string boundingRectWithSize:CGSizeMake(999, 25) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size;
    size.width += 5;
    return size;
}


@end
