//
//  DanBaoViewController.h
//  iwant
//
//  Created by 公司 on 2016/11/28.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import "BaseViewController.h"
#import "Baojia.h"
#import "Logist.h"
@interface DanBaoViewController : BaseViewController

/*物流公司Id*/
@property (copy, nonatomic)  NSString *comId;

/*报价金额*/
@property (strong, nonatomic)  NSString *money;

/*物流单数据模型*/
@property (strong, nonatomic)  Logist *model;


@property (nonatomic,nonatomic)Baojia * baojiaModel;

@property (nonatomic,copy) NSString * recId;  //物流 WUBID

@property (nonatomic,assign) BOOL isZhiFu;  //直接按流程跳转过来支付
@property (weak, nonatomic) IBOutlet UIView *toubaoView;

@end
