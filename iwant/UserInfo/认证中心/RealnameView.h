//
//  RealnameView.h
//  iwant
//
//  Created by dongba on 16/5/25.
//  Copyright © 2016年 FatherDong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^clickBlock) (int tag);//0-姓名提示按钮点击 1-扫描银行卡按钮点击 2-下一步按钮点击
@interface RealnameView : UIView
/*持卡人*/
@property (weak, nonatomic)  UITextField *nameFiled;
/*卡号*/
@property (weak, nonatomic)  UITextField *cardNoFiled;
/*按钮点击block*/
@property (copy, nonatomic)  clickBlock block;
/*name*/
- (void)setName:(NSString *)name;
/*cardNo*/
- (void)setCardNo:(NSString *)cardNo;
@end
