//
//  WechatPayHeader.h
//  PayDemo
//
//  Created by 张宾 on 15/9/21.
//  Copyright © 2015年 张宾. All rights reserved.
//

#import "WXApi.h"
#import "WXApiObject.h"

#define APP_ID          @"wx2a86c51f04882974"               //APPID
//wx64de64a4b4d09d5a
//wxbd06466c2e0d1834
#define APP_SECRET      @"516867e7a9d402e9d53a200f90bdf69c"
//#define APP_SECRET      @"C6D143C36BEB99255917995AFC75ABE5" //appsecret
//商户号，填写商户对应参数
#define MCH_ID          @"1268673701"
//1263435801
//1242746802
//商户API密钥，填写相应参数
#define PARTNER_ID      @"SanChuanHuiTong20151022Efa888888"
//1q2w3e4r5t6y7u8i9o0pwlj20150902p
//TianNetCasTian1234TianNetCasTian
//支付结果回调页面
#define NOTIFY_URL      @"https://kd.efamax.com/weixin!getDetail.action"
//#define NOTIFY_URL      @"https://kd.efamax.com/payNotifyUrl.jsp"
//获取服务器端支付数据地址（商户自定义）
#define SP_URL          @"https://kd.efamax.com/weixin!getDetail.action"
