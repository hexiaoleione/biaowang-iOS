//
//  RouteAnnotation.h
//  iwant
//
//  Created by dongba on 16/6/25.
//  Copyright © 2016年 FatherDong. All rights reserved.
//



@interface RouteAnnotation : BMKPointAnnotation
{
    int _type; ///<0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点
    int _degree; //角度 方向值
}

@property (nonatomic) int type;
@property (nonatomic) int degree;




@end
