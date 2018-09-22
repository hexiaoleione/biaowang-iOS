//
//  SearchResultViewController.h
//  Express
//
//  Created by 张宾 on 15/8/26.
//  Copyright (c) 2015年 SCHT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultViewController : UIViewController
@property(nonatomic,strong)NSMutableDictionary *jsonDic;
/*webView的地址*/
@property (strong, nonatomic)  NSString *url;
@end
