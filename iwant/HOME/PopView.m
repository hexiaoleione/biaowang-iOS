//
//  PopView.m
//  Express
//
//  Created by user on 15/9/6.
//  Copyright (c) 2015年 SCHT. All rights reserved.
//

#import "PopView.h"
#import "UIImage+Persistence.h"
#import "UIImageView+download.h"
#import "MainHeader.h"
@implementation PopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundImages];
        
       _imgHead = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 80, 80)];
        _labelAddress = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 20)];
        _label_person_num = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, frame.size.width-100, 20)];
        _label_person_num.font = [UIFont systemFontOfSize:12];
        _label_dis = [[UILabel alloc] initWithFrame:CGRectMake(100, 40, frame.size.width-50, 20)];
        _label_dis.font = [UIFont systemFontOfSize:12];
        _label_num = [[UILabel alloc] initWithFrame:CGRectMake(100, 60, frame.size.width-100, 20)];
        _label_num.font = [UIFont systemFontOfSize:12];
        
        _ratingView = [[ZYRatingView alloc]initWithFrame:CGRectMake(100, 85, 70, 10)];
        _label_compy = [[UILabel alloc] initWithFrame:CGRectMake(10, 105, frame.size.width-10, 20)];
        _label_Arm = [[UILabel alloc] initWithFrame:CGRectMake(10,130, frame.size.width-10, 20)];
        _label_Arm.font = [UIFont systemFontOfSize:12];
        _button_Send = [[UIButton alloc] initWithFrame:CGRectMake((frame.size.width-80)/2, 150, 80, 30)];
        [_button_Send setTitle:@"发布" forState:UIControlStateNormal];
        _button_Send.layer.cornerRadius = 5;
        _button_Send.backgroundColor = [UIColor colorWithRed:0 green:0.78 blue:0.98 alpha:1];
        [self addSubview:_imgHead];
        //[self addSubview:_labelAddress];
        [self addSubview:_label_person_num];
        [self addSubview:_label_dis];
        [self addSubview:_label_num];
        [self addSubview:_label_compy];
        [self addSubview:_label_Arm];
        [self addSubview:_button_Send];
        
        
        [self addSubview:_ratingView];
        [_ratingView setImagesDeselected:@"0.png" partlySelected:@"1.png" fullSelected:@"2.png" andDelegate:nil];
        [_ratingView displayRating:1];
        _ratingView.userInteractionEnabled = NO;
        
       
    }
    return self;
}
- (void)setBackgroundImages {
   

    
    UIImageView *leftCap = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 200)];
    UIImage *imageLeft = [UIImage imageNamed:@"callout_left"];
    imageLeft = [imageLeft stretchableImageWithLeftCapWidth:floorf(imageLeft.size.width/2) topCapHeight:floorf(imageLeft.size.height/2)];
    leftCap.image = imageLeft;//[UIImage imageNamed:@"callout_left"];
    [self addSubview:leftCap];
    
    UIImageView *rightCap = [[UIImageView alloc] initWithFrame:CGRectMake(20 + 240, 0, 20, 200)];
    UIImage *imageRight = [UIImage imageNamed:@"callout_right"];
    imageRight = [imageRight stretchableImageWithLeftCapWidth:floorf(imageRight.size.width/2) topCapHeight:floorf(imageRight.size.height/2)];
    rightCap.image = imageRight;//[UIImage imageNamed:@"callout_left"];

    [self addSubview:rightCap];
    
    UIImageView *anchor = [[UIImageView alloc] initWithFrame:CGRectMake(20 + 109, 0, 22, 200)];
    UIImage *imageAnchor = [UIImage imageNamed:@"callout_anchor"];
    imageAnchor = [imageAnchor stretchableImageWithLeftCapWidth:floorf(imageAnchor.size.width/2) topCapHeight:floorf(imageAnchor.size.height/2)];
    anchor.image = imageAnchor;//[UIImage imageNamed:@"callout_left"];

    //anchor.image = [UIImage imageNamed:@"callout_anchor"];;
    [self addSubview:anchor];
    
    CGRect leftFrame  = CGRectMake(20, 0, 109, 200);
    CGRect rightFrame = CGRectMake(20 + 240 - 109, 0, 109, 200);
    
    UIImageView *leftBG = [[UIImageView alloc] initWithFrame:leftFrame];
    UIImage *imageLeftBG = [UIImage imageNamed:@"callout_bg"];
    imageLeftBG = [imageLeftBG stretchableImageWithLeftCapWidth:floorf(imageLeftBG.size.width/2) topCapHeight:floorf(imageLeftBG.size.height/2)];
    leftBG.image = imageLeftBG;//[UIImage imageNamed:@"callout_left"];
    [self addSubview:leftBG];
    
    UIImageView *rightBG = [[UIImageView alloc] initWithFrame:rightFrame];
    UIImage *imageRightBG = [UIImage imageNamed:@"callout_bg"];
    imageRightBG = [imageRightBG stretchableImageWithLeftCapWidth:floorf(imageRightBG.size.width/2) topCapHeight:floorf(imageRightBG.size.height/2)];
    rightBG.image = imageRightBG;//[UIImage imageNamed:@"callout_left"];

    [self addSubview:rightBG];
    
    self.layer.cornerRadius = 5;
    self.layer.shadowColor = [UIColor blueColor].CGColor;
    self.layer.shadowRadius = 5;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowOpacity = 0.5;
}

-(void)loadDic:(Courier *)courier{
    
   // [_imgHead imageWithId:courier.headId PlaceHolder:@"account_pic"];
    UIImage *expImage = [UIImage imageNamed:courier.expCode];
    if (!expImage) {
        expImage = [UIImage imageNamed:@"wu"];
    }
    _imgHead.image = expImage;
    _label_compy.text = courier.expName;
//    _label_person_num.text = [NSString stringWithFormat:@"快递员编号:%d",(int)courier.userId];
    _label_person_num.text = [NSString stringWithFormat:@"快递员姓名:%@",courier.userName];
    float lat =  [[NSUserDefaults standardUserDefaults] doubleForKey:USER_LOCATION_LAT];
    float lon =   [[NSUserDefaults standardUserDefaults]doubleForKey:USER_LOCATION_LON];
    BMKMapPoint pf = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(lat, lon));
    BMKMapPoint pe = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(courier.latitude, courier.longitude));
    CLLocationDistance dis = BMKMetersBetweenMapPoints(pf, pe);
    NSString *strDis;
    if (dis > 1000) {
        strDis = [NSString stringWithFormat:@"%0.1f千米",dis/1000];
    }else{
        strDis = [NSString stringWithFormat:@"%0.1f米",dis];
    }
    _label_dis.text = [NSString stringWithFormat:@"距离:%@",strDis];

  
    _label_num.text = [NSString stringWithFormat:@"接单次数:%ld",courier.count];
     [_ratingView displayRating:[courier.score floatValue]];
    _label_Arm.text = [NSString stringWithFormat:@"%@(编号:%@)",courier.pointName,courier.pointId];
   // _labelAddress.text = courier.
    
    
    //网点
    if (!courier.userId || courier.userId == 0) {
        _label_person_num.text = [NSString stringWithFormat:@"网点名称:%@",courier.pointName];
        _label_person_num.frame = CGRectMake(100, 20, self.frame.size.width-100, 40);
        _label_person_num.numberOfLines = 0;
        _label_num.text = [NSString stringWithFormat:@"联系电话:%@",courier.mobile];
        
//        _button_Send.hidden = YES;
        [_button_Send setTitle:@"联系网点" forState:UIControlStateNormal];
        _button_Send.frame = CGRectMake((self.frame.size.width-80)/2, 160, 80, 30);
        
        _ratingView.hidden = YES;
        _label_dis.text = [NSString stringWithFormat:@"距离:%@",strDis];
        _label_dis.frame = CGRectMake(100, 90, 180, 10);
        _label_Arm.text = [NSString stringWithFormat:@"地址:%@",courier.address];
        _label_Arm.frame =CGRectMake(10,130, self.frame.size.width-10, 40);
        _label_Arm.numberOfLines = 0;
    }
    
    
    
}

@end
