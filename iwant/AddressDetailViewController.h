//
//  AddressDetailViewController.h
//  Express
//
//  Created by 张宾 on 15/7/28.
//  Copyright (c) 2015年 SCHT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Address.h"
@interface AddressDetailViewController : UIViewController

@property(nonatomic,strong)Address *addressToModify;
@property(nonatomic,assign)BOOL isModify;//修改编辑
//@property(nonatomic,strong)NSString *addressType;//收、发
@property (assign, nonatomic)  BOOL isRecive;//YES-收件人 NO-发件人
@end
