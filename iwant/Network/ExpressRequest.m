//
//  ExpressRequest.m
//  Express
//
//  Created by 张宾 on 15/7/15.
//  Copyright (c) 2015年 SCHT. All rights reserved.
//

#import "ExpressRequest.h"
//#import "NSString+RSA.h"

@implementation ExpressRequest


+ (void)sendDownLoadRequestWithParameters:(NSDictionary *)parameters
                                MethodStr:(NSString *)methodStr
                                  success:(RequestSuccessBlock)success failed:(RequestFailedBlock)failed
{
    if (![self checkNetReachablityOK]&&failed) {
        failed(S_NETWORK_UNABLE);
        return;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = TIME_OUT_INTER;
//    manager.responseSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json",
                                                        @"text/json",
                                                        @"application/x-msdownload",
                                                        @"text/javascript" ,
                                                        @"text/plain" ,
                                                        @"text/html", nil];
    manager.responseSerializer.stringEncoding = NSUTF8StringEncoding;
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    
    NSLog(@"发送数据：%@",parameters);
    
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
//    
//    NSString *jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
//    //    NSDictionary *dic = @{@"ENCRIPT":[[jsonStr encrptWithRSAPublicKey] base64EncodedStringWithOptions:0]};
//    NSDictionary *dic = @{@"json":jsonStr};
//    NSLog(@"dic===%@",dic);
    NSLog(@"methodStr===%@",URLWithMethod(methodStr));
    [manager POST:URLWithMethod(methodStr) parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"收到的数据:%@",responseObject);
        
        UIImage *image = (UIImage*)responseObject;
        UIImageView *imagev = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        imagev.image = image;
        
        if (success) {
            success(image);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"error==%@",error);
        //未收到数据。
        if (failed) {
            failed(S_SERVER_FAILURE);
        }
    }];
}

+ (void)sendWithParameters:(NSDictionary *)parameters
                 MethodStr:(NSString *)methodStr
                   reqType:(int)type
                   success:(RequestSuccessBlock)success failed:(RequestFailedBlock)failed
{
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    if (reach.currentReachabilityStatus == NotReachable) {
    
 
        failed(S_NETWORK_UNABLE);
        return;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = TIME_OUT_INTER;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:
                                                        @"application/json",
                                                        
                                                        @"text/html",
                                                        
                                                        @"image/jpeg",
                                                        
                                                        @"image/png",
                                                        
                                                        @"application/octet-stream",
                                                        
                                                        @"text/json",
                                                        @"text/plain" ,nil];
    manager.responseSerializer.stringEncoding = NSUTF8StringEncoding;
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;

    NSLog(@"发送数据：%@",parameters);
    
    
    
/*
//NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];

//NSString *jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
//    NSDictionary *dic = @{@"ENCRIPT":[[jsonStr encrptWithRSAPublicKey] base64EncodedStringWithOptions:0]};
//    NSDictionary *dic = @{@"json":jsonStr};
//    NSLog(@"jsonStr===%@",jsonStr);
//    NSLog(@"dic===%@",dic);
 */
    NSLog(@"methodStr===%@",URLWithMethod(methodStr));
    
    
    switch (type) {
        case k_POST:
        {
            [manager POST:URLWithMethod(methodStr) parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
                
                NSLog(@"%@",URLWithMethod(methodStr));
                
                NSLog(@"收到的数据:%@",responseObject);
                
                if (!responseObject) {
                    failed(@"获取服务器数据失败！(响应获取值为空)");
                }
                
                else if ([[responseObject objectForKey:@"success"] integerValue] == 1) {
                    if (success) {
                        if ([responseObject objectForKey:@"message"]) {
                            NSLog(@"success %@",[responseObject objectForKey:@"message"]);
                        }
                        success(responseObject);
                    }
                }
                else {
                    if (failed) {
                        //多设备登陆code
                        [[NSUserDefaults standardUserDefaults] setObject:[responseObject valueForKey:@"errCode"] forKey:@"logAuthCode"];
                        [[NSUserDefaults standardUserDefaults] setObject:[responseObject objectForKey:@"errCode"] forKey:@"errCode"];
                         [[NSUserDefaults standardUserDefaults] synchronize];
                        if ([responseObject objectForKey:@"message"]) {
                            NSLog(@"failed %@",[responseObject objectForKey:@"message"]);
                            failed([responseObject objectForKey:@"message"]);
                        }
                        else {
                            failed(@"服务器返回数据不合法！");
                        }
                        
                    }
                }
                
                
                
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"请求错误%@",error);
                //未收到数据。
                if (failed) {
                    failed(S_SERVER_FAILURE);
                }
            }];
            
        }
            break;
        case k_GET:
        {
             NSLog(@"get地址=====%@",methodStr);
            [manager GET:methodStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                
                NSLog(@"收到的数据:%@",responseObject);
                
                if (!responseObject) {
                    failed(@"获取服务器数据失败！(响应获取值为空)");
                }
                
                else if ([[responseObject objectForKey:@"success"] integerValue] == 1) {
                    if (success) {
                        if ([responseObject objectForKey:@"message"]) {
                            NSLog(@"success %@",[responseObject objectForKey:@"message"]);
                        }
                        success(responseObject);
                    }
                }
                else {
                    if (failed) {
                        if ([responseObject objectForKey:@"message"]) {
                            NSLog(@"failed %@",[responseObject objectForKey:@"message"]);
                            [[NSUserDefaults standardUserDefaults] setObject:[responseObject objectForKey:@"errCode"] forKey:@"errCode"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            failed([responseObject objectForKey:@"message"]);
                        }
                        else {
                            failed(@"服务器返回数据不合法！");
                        }
                        
                    }
                }
                
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
                NSLog(@"请求错误%@",error);
                NSLog(@"error.localizedDescription====%@",error.localizedDescription);
                //未收到数据。
                if (failed) {
                    failed(S_SERVER_FAILURE);
                }
                
            }];
            
        }
            break;
        case k_PUT:
        {
           
            [manager PUT:URLWithMethod(methodStr) parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
                
                NSLog(@"收到的数据:%@",responseObject);
                
                if (!responseObject) {
                    failed(@"获取服务器数据失败！(响应获取值为空)");
                }
                
                else if ([[responseObject objectForKey:@"success"] integerValue] == 1) {
                    if (success) {
                        if ([responseObject objectForKey:@"message"]) {
                            NSLog(@"success %@",[responseObject objectForKey:@"message"]);
                        }
                        success(responseObject);
                    }
                }
                else {
                    if (failed) {
                        if ([responseObject objectForKey:@"message"]) {
                            NSLog(@"failed %@",[responseObject objectForKey:@"message"]);
                            [[NSUserDefaults standardUserDefaults] setObject:[responseObject objectForKey:@"errCode"] forKey:@"errCode"];
                             [[NSUserDefaults standardUserDefaults] synchronize];
                            failed([responseObject objectForKey:@"message"]);
                        }
                        else {
                            failed(@"服务器返回数据不合法！");
                        }
                        
                    }
                }
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
                NSLog(@"请求错误%@",error);
                //未收到数据。
                if (failed) {
                    failed(S_SERVER_FAILURE);
                }
                
            }];
        }
            break;
        case k_DELETE:
        {
            [manager DELETE:methodStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                
                NSLog(@"收到的数据:%@",responseObject);
                
                if (!responseObject) {
                    failed(@"获取服务器数据失败！(响应获取值为空)");
                }
                
                else if ([[responseObject objectForKey:@"success"] integerValue] == 1) {
                    if (success) {
                        if ([responseObject objectForKey:@"message"]) {
                            NSLog(@"success %@",[responseObject objectForKey:@"message"]);
                        }
                        success(responseObject);
                    }
                }
                else {
                    if (failed) {
                        if ([responseObject objectForKey:@"message"]) {
                            NSLog(@"failed %@",[responseObject objectForKey:@"message"]);
                            failed([responseObject objectForKey:@"message"]);
                        }
                        else {
                            failed(@"服务器返回数据不合法！");
                        }
                        
                    }
                }
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
                NSLog(@"请求错误%@",error);
                //未收到数据。
                if (failed) {
                    failed(S_SERVER_FAILURE);
                }
                
                
            }];
        }
            break;
            
        default:
            break;
    }
    
    
}

+ (void)sendWithParameters:(NSDictionary *)parameters
                 MethodStr:(NSString *)methodStr
                   fileDic:(NSDictionary *)fileDic
                   success:(RequestSuccessBlock)success failed:(RequestFailedBlock)failed
{
    if (![self checkNetReachablityOK]&&failed) {
        failed(S_NETWORK_UNABLE);
        return;
    }
    
    
    NSData *imageData = UIImageJPEGRepresentation(fileDic[@"data"], 1.0f);
    if (imageData.length>100*1024) {
        if (imageData.length>1024*1024) {//1M以及以上
            imageData=UIImageJPEGRepresentation(fileDic[@"data"], 0.1);
        }else if (imageData.length>512*1024) {//0.5M-1M
            imageData=UIImageJPEGRepresentation(fileDic[@"data"], 0.5);
        }else if (imageData.length>200*1024) {//0.25M-0.5M
            imageData=UIImageJPEGRepresentation(fileDic[@"data"], 0.9);
        }
    }

    NSString *fileName = fileDic[@"fileName"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 15;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json",
                                                        @"text/json",
                                                        @"text/javascript" ,
                                                        @"text/plain" ,
                                                        @"text/html", nil];
    manager.responseSerializer.stringEncoding = NSUTF8StringEncoding;
    NSLog(@"上传图片-发送数据：%@",parameters);

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",URLWithMethod(methodStr));

    NSDictionary *dic =@{@"json":jsonStr};
    [manager POST:URLWithMethod(methodStr) parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //[formData appendPartWithFormData:imageData name:fileName];
        [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"multipart/form-data"];
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"收到的数据:%@",responseObject);
        
        if ([[responseObject objectForKey:@"success"] integerValue] == 1) {
            if (success) {
                if ([responseObject objectForKey:@"message"]) {
                    NSLog(@"success %@",[responseObject objectForKey:@"message"]);
                }
                success(responseObject);
            }
        }
        else {
            if (failed) {
                if ([responseObject objectForKey:@"message"]) {
                    NSLog(@"failed %@",[responseObject objectForKey:@"message"]);
                    failed([responseObject objectForKey:@"message"]);
                }
                else {
                    failed(responseObject);
                }
                
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //未收到数据。
        if (failed) {
            failed(S_SERVER_FAILURE);
        }
    }];
}


+ (BOOL)checkNetReachablityOK
{
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        return NO;
    }
    else
        return YES;
}

+ (void)StartNetReachablityListen
{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [[NSNotificationCenter defaultCenter] postNotificationName:WIFI_START object:nil];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                [[NSNotificationCenter defaultCenter] postNotificationName:WWAN_START object:nil];
                break;
            case AFNetworkReachabilityStatusUnknown:
                break;
            default:
                break;
        }
    }];
}



@end
