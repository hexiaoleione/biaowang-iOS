//
//  RequestManager.m
//  Express
//
//  Created by 张宾 on 15/7/15.
//  Copyright (c) 2015年 SCHT. All rights reserved.
//


#import "RequestManager.h"
#import "UIImage+Persistence.h"
#import "User.h"
#import "UserManager.h"
#import "KeyChain.h"
#import "MyMD5.h"
#import "Courier.h"
#import "Wallet.h"
#import "myBlance.h"
#import "Ecoin.h"
#import "Message.h"
#import "Draw.h"
#import "PXAlertView.h"
#import "Crowd.h"
#import "CompanyNews.h"
#import "WXPay.h"
#import "Package.h"
#import "ShunFengBiaoShi.h"
#import "Evaluation.h"
#import "MainHeader.h"

@implementation RequestManager


+ (void)downloadFile:(NSInteger)field
             Success:(SuccessWithObjectBlock)success
              Failed:(FailedVoidBlock)failed
{
    NSDictionary *dic = @{k_FILE_ID:[NSNumber numberWithInteger:field]};
    
    [ExpressRequest sendDownLoadRequestWithParameters:dic MethodStr:M_DOWNLOAD success:^(id object) {
        if (object) {
            [(UIImage*)object saveToDocumentWithNameId:field];
        }
        if (success) {
            success(object);
        }
    } failed:^(NSString *error) {
        if (failed) {
            failed(error);
        }
    }];
}

+ (void)getSmsCodeWithMobile:(NSString *)mobile
                Success:(SuccessWithObjectBlock)success
                 Failed:(FailedErrorBlock)failed
{
    if (!ARG_SAVED_IDFV) {
        NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [KeyChain save:ARG_IDFV data:idfv];
    }
    NSString *URLStr = [NSString stringWithFormat:@"%@%@?mobile=%@&%@=%@",BaseUrl,API_SMSCODENEW,mobile,k_DEVICE_ID,ARG_SAVED_IDFV];
    
    [ExpressRequest sendWithParameters:nil MethodStr:URLStr reqType:k_GET success:^(id object) {
        NSString *code =[[object objectForKey:ARG_DATA] valueForKey:@"code"];
        success(code);
    } failed:^(NSString *error) {
        failed(error);
    }];
    }


+ (void)registWithMobile:(NSString *)mobile
                passWord:(NSString *)passWord
                deviceId:(NSString *)deviceId
         recommendMobile:(NSString *)recommendMobile
                 smsCode:(NSString *)smsCode
                cityCode:(NSString *)cityCode
                 success:(SuccessWithStringBlock)success
                  failed:(FailedErrorBlock)failed{
    if (!ARG_SAVED_IDFV) {
        NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [KeyChain save:ARG_IDFV data:idfv];
    }
    
    passWord = [MyMD5 md5:passWord];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",mobile],k_MOBILE,[NSString stringWithFormat:@"%@",passWord],k_PASSWORD,ARG_SAVED_IDFV,k_DEVICE_ID,recommendMobile,ARG_REC_Mobile,[NSString stringWithFormat:@"%@",smsCode],@"smsCode",cityCode,@"cityCode",nil];
    [ExpressRequest sendWithParameters:dic MethodStr:API_USERS reqType:k_POST success:^(id object) {
        NSDictionary *userDic = [object objectForKey:ARG_DATA][0];
        User *user = [[User alloc]initWithJsonDict:userDic];
        [UserManager saveUser:user];
        
        NSString *msg = [object valueForKey:ARG_MSG];
        
        success(msg);
    } failed:^(NSString *error) {
        failed(error);
    }];
}
+(void)userInfoWithUserId:(NSString *)userId
                 userName:(NSString *)userName
                     idCard:(NSString *)idCard
                 idCardPath:(NSString *)idCardPath
                    Success:(SuccessWithObjectBlock)success
                     Failed:(FailedErrorBlock)failed{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userId,k_USER_ID,userName,k_USER_NAME,idCard,k_ID_CARD,idCardPath,ARG_ID_PATH, nil];
    [ExpressRequest sendWithParameters:dic MethodStr:API_USERINFONEW
                               reqType:k_PUT
                               success:^(id object) {
                                   success(object);
//                                   NSDictionary *userDic = [object objectForKey:ARG_DATA][0];
//                                   User *user = [[User alloc]initWithJsonDict:userDic];
//                                   [UserManager saveUser:user];
                               }
                                failed:^(NSString *error) {
                                    failed(error);
                                }];
}

+(void)getuserinfoWithuserId:(NSString *)userId success:(SuccessWithStringBlock)success Failed:(FailedErrorBlock)failed
{
    NSString *URLStr = [NSString stringWithFormat:@"%@%@?%@=%@",BaseUrl,API_GETUSERINFO,K_ID,userId];

    [ExpressRequest sendWithParameters:nil MethodStr:URLStr reqType:k_GET success:^(id object) {
        NSDictionary *userDic = [object objectForKey:ARG_DATA][0];
//        NSDictionary *userDic1 = object;
//        NSString *sysString = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
//        NSString *path = [sysString stringByAppendingPathComponent:@"text.plist"];
//        NSLog(@"%@",path);
//        
//        [userDic1 writeToFile:path atomically:YES];
        
        User *user = [[User alloc]initWithJsonDict:userDic];
        [UserManager saveUser:user];
        
        NSString *msg = [object valueForKey:ARG_MSG];
        
        success(msg);
    } failed:^(NSString *error) {
        failed(error);
    }];
}

+(void)loginWithMobile:(NSString *)mobile
              Password:(NSString *)password
              deviceId:(NSString *)deviceId
               success:(SuccessWithStringBlock)success
                Failed:(FailedErrorBlock)failed{
    
    if (!ARG_SAVED_IDFV) {
        NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [KeyChain save:ARG_IDFV data:idfv];
    }
    
    password = [MyMD5 md5:password];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",mobile],k_MOBILE,[NSString stringWithFormat:@"%@",password],k_PASSWORD,ARG_SAVED_IDFV,k_DEVICE_ID, nil];
    [ExpressRequest sendWithParameters:dic MethodStr:API_USER_LOGIN reqType:k_POST success:^(id object) {
        NSDictionary *userDic = [object objectForKey:ARG_DATA][0];
        User *user = [[User alloc]initWithJsonDict:userDic];
        [UserManager saveUser:user];
        
        NSString *msg = [object valueForKey:ARG_MSG];
        
        success(msg);
    } failed:^(NSString *error) {
        failed(error);
    }];
}

+(void)getCommonAddressWithUserId:(NSString *)userId
                          success:(SuccessWithArrayBlock)success
                           Failed:(FailedErrorBlock)failed{
    NSString *URLStr = [NSString stringWithFormat:@"%@%@?%@=%@",BaseUrl,API_COM_ADDRESS,k_USER_ID,userId];
    
    [ExpressRequest sendWithParameters:nil MethodStr:URLStr reqType:k_GET success:^(id object) {
        NSMutableArray *backArray = [NSMutableArray array];
        NSArray *dataArray =[object objectForKey:ARG_DATA];
        for (NSDictionary *dic in dataArray) {
            Address *address = [[Address alloc]initWithJsonDict:dic];
            [backArray addObject:address];
        }
        success(backArray);
    } failed:^(NSString *error) {
        failed(error);
    }];
}
+(void)getCommonAddressToWithUserId:(NSString *)userId
                            success:(SuccessWithArrayBlock)success
                             Failed:(FailedErrorBlock)failed{
    NSString *URLStr = [NSString stringWithFormat:@"%@%@?%@=%@",BaseUrl,API_COM_ADDRESS_TO,k_USER_ID,userId];
    [ExpressRequest sendWithParameters:nil MethodStr:URLStr reqType:k_GET success:^(id object) {
        NSMutableArray *backArray = [NSMutableArray array];
        NSArray *dataArray =[object objectForKey:ARG_DATA];
        for (NSDictionary *dic in dataArray) {
            Address *address = [[Address alloc]initWithJsonDict:dic];
            [backArray addObject:address];
        }
        success(backArray);
    } failed:^(NSString *error) {
        failed(error);
    }];
}

+(void)addAddressWithUserId:(NSString *)userId
                addressType:(NSString *)addressType
                   cityCode:(NSString *)cityCode
                   cityName:(NSString *)cityName
                 personName:(NSString *)personName
                     mobile:(NSString *)mobile
                   areaName:(NSString *)areaName
                    address:(NSString *)address
                   latitude:(NSString *)latitude
                  longitude:(NSString *)longitude
                  ifDefault:(NSString *)ifDefault
                    success:(SuccessWithNSMutableArrayBlock)success
                     Failed:(FailedErrorBlock)failed{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userId,k_USER_ID,addressType,k_ADDRESS_TYPE,cityCode,k_CITY_CODE,cityName,ARG_CITY_NAME,personName,ARG_PERSON_NAME,mobile,k_MOBILE,areaName,ARG_AREA_NAME,address,k_ADDRESS,latitude,ARG_LAT,longitude,ARG_LON,ifDefault,ARG_IFDE,nil];
    [ExpressRequest sendWithParameters:dic MethodStr:API_ADD_ADDRESS reqType:k_POST success:^(id object) {
        NSMutableArray *arr = [NSMutableArray array];
        NSArray *addArr = [object objectForKey:ARG_DATA];
        for (NSDictionary *dic in addArr) {
            Address *address = [[Address alloc]initWithJsonDict:dic];
            [arr addObject:address];
        }
        success(arr);
    } failed:^(NSString *error) {
        failed(error);
    }];
}

+ (void)getDefaultAddressUserId:(NSString *)userId
                        success:(SuccessWithObjectBlock)success
                         Failed:(FailedErrorBlock)failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@?%@=%@",BaseUrl,API_DEFAULT_ADDERSS,k_USER_ID,userId];
    [ExpressRequest sendWithParameters:nil MethodStr:urlStr reqType:k_GET success:^(id object) {
        success(object);
    } failed:^(NSString *error) {
        failed(error);
    }];
}

+(void)addCourierWithcourierId:(NSString *)courierId
                        userId:(NSString *)userId
                      userName:(NSString *)userName
                    userMobile:(NSString *)userMobile
                   courierName:(NSString *)courierName
                 courierMobile:(NSString *)courierMobile
                         expId:(NSString *)expId
                       expName:(NSString *)expName
                     longitude:(NSString *)longitude
                      latitude:(NSString *)latitude
                      cityCode:(NSString *)cityCode
                       success:(SuccessWithNSMutableArrayBlock)success
                        Failed:(FailedErrorBlock)failed{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:courierId,k_COURIER_ID,userId,k_USER_ID,userName,k_USER_NAME,userMobile,ARG_USER_MOBILE,courierName,ARG_COURIER_NAME,courierMobile,ARG_COURIER_MOBILE,expId,ARG_EXP_ID,expName,ARG_EXP_NAME,longitude,ARG_LON,latitude,ARG_LAT,cityCode,k_CITY_CODE,nil];
    [ExpressRequest sendWithParameters:dic MethodStr:API_MY_COURIER reqType:k_POST success:^(id object) {
        NSMutableArray *arr = [NSMutableArray array];
        NSArray *addArr = [object objectForKey:ARG_DATA];

            Courier *courier = [[Courier alloc]initWithJsonDict:addArr[0]];
            [arr addObject:courier];

        success(arr);
    } failed:^(NSString *error) {
        failed(error);
    }];
}

+(void)getCourierListWithUserId:(NSString *)userId success:(SuccessWithNSMutableArrayBlock)success Failed:(FailedErrorBlock)failed{
    NSString *URLStr = [NSString stringWithFormat:@"%@%@?%@=%@",BaseUrl,API_MY_COURIER_LIST,k_USER_ID,userId];
    [ExpressRequest sendWithParameters:nil MethodStr:URLStr reqType:k_GET success:^(id object) {
        NSMutableArray *dataArray =[object objectForKey:ARG_DATA];
        success(dataArray);
    } failed:^(NSString *error) {
        failed(error);
    }];
}

+(void)thirdLoginWithOpenId:(NSString *)openId
                accessToken:(NSString *)accessToken
                nickName:(NSString *)nickName
                sex:(NSString *)sex
                headImageUrl:(NSString *)headImageUrl
                unionId:(NSString *)unionId
                success:(SuccessWithObjectBlock)success
                Failed:(FailedErrorBlock)failed
{
    if (!ARG_SAVED_IDFV) {
        NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [KeyChain save:ARG_IDFV data:idfv];
    }
//    NSDictionary *dic = @{ARG_OPEN_ID:openId,ARG_ACCESS_TOKEN:accessToken,ARG_NIKE_NAME:nickName,@"sex":sex,ARG_HEADIMG_URL:headImageUrl,ARG_UNIONID:unionId};
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:openId,ARG_OPEN_ID, accessToken,ARG_ACCESS_TOKEN,nickName,ARG_NIKE_NAME,sex,@"sex",headImageUrl,ARG_HEADIMG_URL,unionId,ARG_UNIONID,ARG_SAVED_IDFV,k_DEVICE_ID, nil];
    [ExpressRequest sendWithParameters:dic MethodStr:API_THIRD_LOGIN reqType:k_POST success:^(id object) {
        NSNumber *errCode = [object objectForKey:@"errCode"];
        NSDictionary *userDic = [object objectForKey:ARG_DATA][0];
        User *user = [[User alloc]initWithJsonDict:userDic];
        if ([errCode intValue] == 0) {
             [UserManager saveUser:user];
        }
        success(object);
        
    } failed:^(NSString *error) {
        failed(error);
    }];
}

//+(void)newThirdLoginWithOpenId:(NSString *)openId
//                   accessToken:(NSString *)accessToken
//                      nickName:(NSString *)nickName
//                           sex:(NSString *)sex
//                  headImageUrl:(NSString *)headImageUrl
//                       unionId:(NSString *)unionId
//                       success:(SuccessWithObjectBlock)success
//                        Failed:(FailedErrorBlock)failed;
//{
//    if (!ARG_SAVED_IDFV) {
//        NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
//        [KeyChain save:ARG_IDFV data:idfv];
//    }
//    //    NSDictionary *dic = @{ARG_OPEN_ID:openId,ARG_ACCESS_TOKEN:accessToken,ARG_NIKE_NAME:nickName,@"sex":sex,ARG_HEADIMG_URL:headImageUrl,ARG_UNIONID:unionId};
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:openId,ARG_OPEN_ID, accessToken,ARG_ACCESS_TOKEN,nickName,ARG_NIKE_NAME,sex,@"sex",headImageUrl,ARG_HEADIMG_URL,unionId,ARG_UNIONID,ARG_SAVED_IDFV,k_DEVICE_ID, nil];
//    [ExpressRequest sendWithParameters:dic MethodStr:API_THIRD_LOGIN_NEW reqType:k_POST success:^(id object) {
//        NSNumber *errCode = [object objectForKey:@"errCode"];
//        NSDictionary *userDic = [object objectForKey:ARG_DATA][0];
//        User *user = [[User alloc]initWithJsonDict:userDic];
//        if ([errCode intValue] == 0) {
//            [UserManager saveUser:user];
//        }
//        success(object);
//        
//    } failed:^(NSString *error) {
//        failed(error);
//    }];
//}


/**
 *  发布快递
 */
+(void)sendMailWithUserId:(NSString *)userId
                 userName:(NSString *)userName
               personName:(NSString *)personName
             personNameTo:(NSString *)personNameTo
                   mobile:(NSString *)mobile
                 mobileTo:(NSString *)mobileTo
                 areaName:(NSString *)areaName
               areaNameTo:(NSString *)areaNameTo
                  address:(NSString *)address
                addressTo:(NSString *)addressTo
                 latitude:(NSString *)latitude
                longitude:(NSString *)longitude
                 fromCity:(NSString *)fromCity
             fromCityName:(NSString *)fromCityName
                 fromTown:(NSString *)fromTown
                   toCity:(NSString *)toCity
               toCityName:(NSString *)toCityName
                    expId:(NSString *)expId
                  pointId:(NSString *)pointId
                courierId:(NSString *)courierId
              courierName:(NSString *)courierName
            courierMobile:(NSString *)courierMobile
                 assigned:(NSString *)assigned
                   status:(NSString *)status
                  success:(SuccessWithNSMutableArrayBlock)success
                   Failed:(FailedErrorBlock)failed{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         userId,k_USER_ID,
                         userName,k_USER_NAME,
                         personName,ARG_PERSON_NAME,
                         personNameTo,ARG_PERSON_NAME_TO,
                         mobile,k_MOBILE,
                         mobileTo,ARG_MOBILE_TO,
                         areaName,ARG_AREA_NAME,
                         areaNameTo,ARG_AREA_NAME_TO,
                         address,k_ADDRESS,
                         addressTo,ARG_ADDRESS_TO,
                         latitude,k_COURIER_LAT,
                         longitude,k_COURIER_LON,
                         fromCity,A_FROM_CITY,
                         fromCityName,A_FROM_CITY_NAME,
                         fromTown,A_FROM_TOWN,
                         toCity,A_TO_CITY,
                         toCityName,A_TO_CITY_NAME,
                         expId,ARG_EXP_ID,
                         pointId,A_POINT_ID,
                         courierId,k_COURIER_ID,
                         courierName,ARG_COURIER_NAME,
                         courierMobile,ARG_COURIER_MOBILE,
                         assigned,A_ASSIGNED,
                         status,k_STATUS,nil];
    
    [ExpressRequest sendWithParameters:dic MethodStr:API_EXPRESS reqType:k_POST success:^(id object) {
        success(object);
        NSLog(@"%@",object);
    } failed:^(NSString *error) {
        failed(error);
    }];

}
/*
+(void)sendMailWithUserId:(NSString *)userId
                 userName:(NSString *)userName
               personName:(NSString *)personName
             personNameTo:(NSString *)personNameTo
                   mobile:(NSString *)mobile
                 mobileTo:(NSString *)mobileTo
                 areaName:(NSString *)areaName
               areaNameTo:(NSString *)areaNameTo
                  address:(NSString *)address
                addressTo:(NSString *)addressTo
                 latitude:(NSString *)latitude
                longitude:(NSString *)longitude
                 fromCity:(NSString *)fromCity
             fromCityName:(NSString *)fromCityName
                   toCity:(NSString *)toCity
               toCityName:(NSString *)toCityName
                    expId:(NSString *)expId
                  pointId:(NSString *)pointId
                courierId:(NSString *)courierId
              courierName:(NSString *)courierName
            courierMobile:(NSString *)courierMobile
                 assigned:(NSString *)assigned
                   status:(NSString *)status
                  success:(SuccessWithNSMutableArrayBlock)success
                   Failed:(FailedErrorBlock)failed{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         userId,k_USER_ID,
                         userName,k_USER_NAME,
                         personName,ARG_PERSON_NAME,
                         personNameTo,ARG_PERSON_NAME_TO,
                         mobile,k_MOBILE,
                         mobileTo,ARG_MOBILE_TO,
                         areaName,ARG_AREA_NAME,
                         areaNameTo,ARG_AREA_NAME_TO,
                         address,k_ADDRESS,
                         addressTo,ARG_ADDRESS_TO,
                         latitude,k_COURIER_LAT,
                         longitude,k_COURIER_LON,
                         fromCity,A_FROM_CITY,
                         fromCityName,A_FROM_CITY_NAME,
                         toCity,A_TO_CITY,
                         toCityName,A_TO_CITY_NAME,
                         expId,ARG_EXP_ID,
                         pointId,A_POINT_ID,
                         courierId,k_COURIER_ID,
                         courierName,ARG_COURIER_NAME,
                         courierMobile,ARG_COURIER_MOBILE,
                         assigned,A_ASSIGNED,
                         status,status,nil];
    
    [ExpressRequest sendWithParameters:dic MethodStr:API_EXPRESS reqType:k_POST success:^(id object) {
        success(object);
        NSLog(@"%@",object);
    } failed:^(NSString *error) {
        failed(error);
    }];
}
*/
+(void)getExpListWithUserId:(NSString *)userId
                     pageNo:(int)pageNo
                   pageSize:(NSString *)pageSize
                    success:(SuccessWithNSMutableArrayBlock)success
                     Failed:(FailedErrorBlock)failed{
    NSString *URL = [NSString stringWithFormat:@"%@%@?%@=%@&%@=%d&%@=%@",BaseUrl,API_EXPRESS_LIST,k_USER_ID,userId,k_PAGE_NO,pageNo,k_PAGE_SIEZ,pageSize];
    [ExpressRequest sendWithParameters:nil MethodStr:URL reqType:k_GET success:^(id object) {
        if (success) {
            NSMutableArray *arr = [object objectForKey:@"data"];
            success(arr);
        }
    } failed:^(NSString *error) {
        if (failed) {
            failed(error);
        }
    }];
}
//钱包余额
+(void)getWalletBlanceWithUserId:(NSString *)userId Success:(SuccessWithObjectBlock)success Failed:(FailedErrorBlock)failed
{
    
    NSString *URLStr = [NSString stringWithFormat:@"%@%@?%@=%@",BaseUrl,API_Wallet_BALANCE,k_USER_ID,userId];
    
    [ExpressRequest sendWithParameters:nil MethodStr:URLStr reqType:k_GET success:^(id object) {
        NSArray *array = [object objectForKey:@"data"];
        
        myBlance *model = [[myBlance alloc]initWithJsonDict:array[0]];
        if (success) {
            success(model);
        }
    } failed:^(NSString *error) {
        if (failed) {
            failed(error);
        }
    }];
}

//钱包历史
+(void)walletHistoryWithuserId:(NSString *)userId pageNo:(NSString *)pageNo pageSize:(NSString*)pageSize Success:(SuccessWithArrayBlock)success Failed:(FailedErrorBlock)failed
{
    
    NSString *URLStr = [NSString stringWithFormat:@"%@%@?%@=%@&%@=%@&%@=%@",BaseUrl,API_Wallet_LIST,k_USER_ID,userId,k_PAGE_NO,pageNo,k_PAGE_SIEZ,pageSize];
   
    [ExpressRequest sendWithParameters:nil MethodStr:URLStr reqType:k_GET success:^(id object) {
        NSMutableArray *proArray = [NSMutableArray array];
        NSArray *dataArray = [(NSDictionary*)object objectForKey:@"data"];
        for (NSDictionary *dic in dataArray) {
            Wallet *model = [[Wallet alloc]initWithJsonDict:dic];
            [proArray addObject:model];
        }
        
        if (success) {
            success(proArray);
        }
    } failed:^(NSString *error) {
        if (failed) {
            failed(error);
        }
    }];
}
//我的现金券
+(void)getCouponWithuserId:(NSString *)userId
                  pageSize:(NSString *)pageSize
                    pageNo:(NSString *)pageNo
                   Success:(SuccessWithArrayBlock)success
                    Failed:(FailedErrorBlock)failed
{
    
    NSString *URLStr = [NSString stringWithFormat:@"%@%@?%@=%@&%@=%@&%@=%@",BaseUrl,API_COUPON_LIST,k_USER_ID,userId,k_PAGE_SIEZ,pageSize,k_PAGE_NO,pageNo];
    
    [ExpressRequest sendWithParameters:nil MethodStr:URLStr reqType:k_GET success:^(id object) {
        NSMutableArray *proArray = [NSMutableArray array];
        NSArray *dataArray = [(NSDictionary*)object objectForKey:@"data"];
        for (NSDictionary *dic in dataArray) {
            Wallet *model = [[Wallet alloc]initWithJsonDict:dic];
            [proArray addObject:model];
        }
        
        if (success) {
            success(proArray);
        }
    } failed:^(NSString *error) {
        if (failed) {
            failed(error);
        }
    }];
}
//积分历史
+(void)getEcoinHistoryWithuserId:(NSString *)userId
                        pageSize:(NSString *)pageSize
                          pageNo:(NSString *)pageNo
                         Success:(SuccessWithArrayBlock)success
                          Failed:(FailedErrorBlock)failed
{
    
    NSString *URLStr = [NSString stringWithFormat:@"%@%@?%@=%@&%@=%@&%@=%@",BaseUrl,API_Ecoin_LIST,k_USER_ID,userId,k_PAGE_SIEZ,pageSize,k_PAGE_NO,pageNo];
    
    [ExpressRequest sendWithParameters:nil MethodStr:URLStr reqType:k_GET success:^(id object) {
        NSMutableArray *proArray = [NSMutableArray array];
        NSArray *dataArray = [(NSDictionary*)object objectForKey:@"data"];
        for (NSDictionary *dic in dataArray) {
            Ecoin *model = [[Ecoin alloc]initWithJsonDict:dic];
            [proArray addObject:model];
        }
        
        if (success) {
            success(proArray);
        }
    } failed:^(NSString *error) {
        if (failed) {
            failed(error);
        }
    }];

}
+(void)getNearPointWithLatitude:(NSString *)latitude
                        longitude:(NSString *)longitude
                        Success:(SuccessWithArrayBlock)success
                         Failed:(FailedErrorBlock)failed{
    NSString *URLStr = [NSString stringWithFormat:@"%@%@?%@=%@&%@=%@",BaseUrl,API_NEER_POINT,ARG_LAT,latitude,ARG_LON,longitude];
    [ExpressRequest sendWithParameters:nil MethodStr:URLStr reqType:k_GET success:^(id object) {
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dic in [object objectForKey:ARG_DATA]) {
            Courier *courier = [[Courier alloc]initWithJsonDict:dic];
            [array addObject:courier];
        }
        success(array);
    } failed:^(NSString *error) {
        failed(error);
    }];
}
+(void)uploadPictureWithUserId:(NSString *)userId fileName:(NSString *)fileName file:(id)file Success:(SuccessWithDictionaryBlock)success Failed:(FailedErrorBlock)failed{
        UIImage *image = file;
        NSDictionary *dic = @{k_USER_ID:userId,k_FILE_NAME:fileName};
        NSDictionary *fileDic = @{@"data":image,@"fileName":fileName};
        [ExpressRequest sendWithParameters:dic MethodStr:API_FILE_UPLOAD
                                   fileDic:fileDic
                                   success:^(id object) {
                                       success(object);
                                   } failed:^(NSString *error) {
                                       failed(error);
                                   }];


}

+(void)forgetPWDmobile:(NSString *)mobile
           newPassword:(NSString *)newPassword
               success:(SuccessWithStringBlock)success
                Failed:(FailedErrorBlock)failed{
    newPassword = [MyMD5 md5:newPassword];
     NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:mobile,k_MOBILE,newPassword,A_NEW_PWD, nil];
    [ExpressRequest sendWithParameters:dic MethodStr:API_FORGET_PWD reqType:k_PUT success:^(id object) {
        success(object);
    } failed:^(NSString *error) {
        failed(error);
    }];
}

+(void)forgetSMSCodeMobile:(NSString *)mobile
                   success:(SuccessWithStringBlock)success
                    Failed:(FailedErrorBlock)failed{
    NSString *URLStr = [NSString stringWithFormat:@"%@%@?%@=%@",BaseUrl,API_FORGET_SMS, k_MOBILE,mobile];
    [ExpressRequest sendWithParameters:nil MethodStr:URLStr reqType:k_GET success:^(id object) {
        NSDictionary *dic = [object objectForKey:@"data"][0];
        success((NSString *)[dic valueForKey:@"code"]);
    } failed:^(NSString *error) {
        failed(error);
    }];
}
+(void)getNearCourierListlatitude:(NSString *)latitude
                        longitude:(NSString *)longitude
                         cityCode:(NSString *)cityCode
                          success:(SuccessWithNSMutableArrayBlock)success
                           Failed:(FailedErrorBlock)failed{
    NSString *URLStr = [NSString stringWithFormat:@"%@%@?%@=%@&%@=%@&%@=%@",BaseUrl,API_NEAR_COURIER,ARG_LAT,latitude,ARG_LON,longitude,k_CITY_CODE,cityCode];
    [ExpressRequest sendWithParameters:nil MethodStr:URLStr reqType:k_GET success:^(id object) {
        NSMutableArray *array = [NSMutableArray array];
        NSMutableArray *dataArray =[object objectForKey:ARG_DATA];
        for (NSDictionary *dic in dataArray) {
            Courier *cour = [[Courier alloc]initWithJsonDict:dic];
            [array addObject:cour];
        }
        
        success(array);
    } failed:^(NSString *error) {
        failed(error);
    }];
}
+(void)getMessageWithuserId:(NSString *)userId pageNo:(NSString *)pageNo pageSize:(NSString*)pageSize Success:(SuccessWithArrayBlock)success Failed:(FailedErrorBlock)failed

{
    
    NSString *URLStr = [NSString stringWithFormat:@"%@%@?%@=%@&%@=%@&%@=%@",BaseUrl,API_GetMessage_LIST,k_USER_ID,userId,k_PAGE_NO,pageNo,k_PAGE_SIEZ,pageSize];
    
    [ExpressRequest sendWithParameters:nil MethodStr:URLStr reqType:k_GET success:^(id object) {
        NSMutableArray *proArray = [NSMutableArray array];
        NSArray *dataArray = [(NSDictionary*)object objectForKey:@"data"];
        for (NSDictionary *dic in dataArray) {
            Message *model = [[Message alloc]initWithJsonDict:dic];
            [proArray addObject:model];
        }
        
        if (success) {
            success(proArray);
        }
    } failed:^(NSString *error) {
        if (failed) {
            failed(error);
        }
    }];
}
+(void)saveExpNoBillCode:(NSString *)billCode
                   expNo:(NSString *)expNo
                 success:(SuccessWithObjectBlock)success
                  Failed:(FailedErrorBlock)failed{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:billCode,A_BILL_CODE,expNo,A_EXP_NO, nil];
    [ExpressRequest sendWithParameters:dic MethodStr:API_SAVE_EXPNO reqType:k_PUT success:^(id object) {
        success(object);
    } failed:^(NSString *error) {
        failed (error);
    }];
}

+(void)payByyueBillCode:(NSString *)billCode
                matName:(NSString *)matName
                matType:(NSString *)matType
           insuranceFee:(NSString *)insuranceFee
            insureMoney:(NSString *)insureMoney
           needPayMoney:(NSString *)needPayMoney
              shipMoney:(NSString *)shipMoney
           userCouponId:(NSString *)userCouponId
                 weight:(NSString *)weight
                 userId:(NSString *)userId
                success:(SuccessWithObjectBlock)success
                 Failed:(FailedErrorBlock)failed{
    NSDictionary *dic = @{A_BILL_CODE:billCode,
                          A_MAT_NAME :matName,
                          A_MAT_TYPE :matType,
                          K_insuranceFee :insuranceFee,
                          K_insureMoney :insureMoney,
                          A_NEED_PAY :needPayMoney,
                          A_SHIP:shipMoney,
                          @"userCouponId":userCouponId,
                          K_weight :weight,
                          k_USER_ID:userId};
    [ExpressRequest sendWithParameters:dic MethodStr:API_PAY_BLANCE reqType:k_PUT success:^(id object) {
        success(object);
    } failed:^(NSString *error) {
        failed(error);
    }];
}
+(void)payByyuejieBillCode:(NSString *)billCode
                   matName:(NSString *)matName
                   matType:(NSString *)matType
              insuranceFee:(NSString *)insuranceFee
               insureMoney:(NSString *)insureMoney
              needPayMoney:(NSString *)needPayMoney
                 shipMoney:(NSString *)shipMoney
                    weight:(NSString *)weight
                   success:(SuccessWithObjectBlock)success Failed:(FailedErrorBlock)failed{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:billCode,A_BILL_CODE,matName,A_MAT_NAME,matType,A_MAT_TYPE,insuranceFee,K_insuranceFee,insureMoney,K_insureMoney,needPayMoney,A_NEED_PAY,shipMoney,A_SHIP,weight, K_weight ,nil];
    [ExpressRequest sendWithParameters:dic MethodStr:API_PAY_MOUNTH reqType:k_PUT success:^(id object) {
        success(object);
    } failed:^(NSString *error) {
        failed(error);
    }];
}
+(void)uploadPayBillCode:(NSString *)billCode
                 matName:(NSString *)matName
                 matType:(NSString *)matType
            insuranceFee:(NSString *)insuranceFee
             insureMoney:(NSString *)insureMoney
            needPayMoney:(NSString *)needPayMoney
               shipMoney:(NSString *)shipMoney
                  weight:(NSString *)weight
                 success:(SuccessWithObjectBlock)success Failed:(FailedErrorBlock)failed{
    NSDictionary *dic = @{A_BILL_CODE:billCode,
                          A_MAT_NAME :matName,
                          A_MAT_TYPE :matType,
                          K_insuranceFee :insuranceFee,
                          K_insureMoney :insureMoney,
                          A_NEED_PAY :needPayMoney,
                          A_SHIP:shipMoney,
                          K_weight :weight};
    [ExpressRequest sendWithParameters:dic MethodStr:API_UPLOAD_PAY reqType:k_PUT success:^(id object) {
        success(object);
    } failed:^(NSString *error) {
        failed(error);
    }];
    
}

+(void)arrayPayBillCode:(NSString *)billCode
                matName:(NSString *)matName
                matType:(NSString *)matType
           insuranceFee:(NSString *)insuranceFee
            insureMoney:(NSString *)insureMoney
           needPayMoney:(NSString *)needPayMoney
              shipMoney:(NSString *)shipMoney
                 weight:(NSString *)weight
                success:(SuccessWithObjectBlock)success
                 Failed:(FailedErrorBlock)failed{
    NSDictionary *dic = @{A_BILL_CODE:billCode,
                          A_MAT_NAME :matName,
                          A_MAT_TYPE :matType,
                          K_insuranceFee :insuranceFee,
                          K_insureMoney :insureMoney,
                          A_NEED_PAY :needPayMoney,
                          A_SHIP:shipMoney,
                          K_weight :weight};
    [ExpressRequest sendWithParameters:dic MethodStr:API_ARRIVE_PAY reqType:k_PUT success:^(id object) {
        success(object);
    } failed:^(NSString *error) {
        failed(error);
    }];
}
+(void)checkOutTicketBillCode:(NSString *)BillCode NeedPayMoney:(NSString *)needPayMoney userCouponId:(NSString *)userCouponId
                      success:(SuccessWithObjectBlock)success
                       Failed:(FailedErrorBlock)failed{
    NSString *URLStr = [NSString stringWithFormat:@"%@%@?%@=%@&%@=%@&%@=%@",BaseUrl,API_COUPON_CHECK,A_BILL_CODE,BillCode,A_NEED_PAY,needPayMoney,A_USER_COP,userCouponId];
    [ExpressRequest sendWithParameters:nil MethodStr:URLStr reqType:k_GET success:^(id object) {
        success(object);
    } failed:^(NSString *error) {
        failed(error);
    }];
}
//我的反馈
+(void)feedbackWithuserId:(NSString *)userId typeId:(NSString *)typeId content:(NSString *)content Success:(SuccessWithObjectBlock)success Failed:(FailedErrorBlock)failed
{
    
    
    NSDictionary *dic = @{k_USER_ID:userId,K_TYPEID:typeId,K_CONTENT:content};
    
    [ExpressRequest sendWithParameters:dic MethodStr:API_FEEDBACK reqType:k_POST success:^(id object) {
        success(object);
        NSLog(@"%@",object);
    } failed:^(NSString *error) {
        failed(error);
    }];
    
    
}

+(void)myReciveUserId:(NSString *)userId pageSize:(NSString *)pageSize pageNo:(int)pageNo Success:(SuccessWithNSMutableArrayBlock)success
               Failed:(FailedErrorBlock)failed{
    NSString *URLStr = [NSString stringWithFormat:@"%@%@?%@=%@&%@=%@&%@=%d",BaseUrl,API_MY_RECIVE,k_USER_ID,userId,k_PAGE_SIZE,pageSize,k_PAGE_NO,pageNo];
    [ExpressRequest sendWithParameters:nil MethodStr:URLStr reqType:k_GET success:^(id object) {
        if (success) {
            NSMutableArray *arr = [object objectForKey:@"data"];
            success(arr);
        }
    } failed:^(NSString *error) {
        failed(error);
    }];
}
+(void)getVersionUserId:(NSString *)userId typeId:(NSString *)typeId
                content:(NSString *)content Success:(SuccessWithDictionaryBlock)success
                 Failed:(FailedErrorBlock)failed{
    NSString *URLStr = [NSString stringWithFormat:@"%@%@",BaseUrl,API_VERSION];
    [ExpressRequest sendWithParameters:nil MethodStr:URLStr reqType:k_GET success:^(id object) {
        if (success) {
            NSMutableArray *arr = [object objectForKey:@"data"];
            NSDictionary *dic = arr[0];
            success(dic);
        }
    } failed:^(NSString *error) {
        failed(error);
    }];

}
+(void)assWithBusinessId:(NSString *)businessId
               evaTypeId:(NSString *)evaTypeId
                   score:(NSString *)score
              evaContent:(NSString *)evaContent
                 Success:(SuccessWithObjectBlock)success
                  Failed:(FailedErrorBlock)failed{
    NSDictionary *dic = @{k_BUSINESS_ID:businessId,A_EVA_TYPE:evaTypeId,A_SCORE:score,A_EVALUE:evaContent};
    [ExpressRequest sendWithParameters:dic MethodStr:API_EVA reqType:k_POST success:^(id object) {
        success(object);
    } failed:^(NSString *error) {
        failed(error);
    }];
}
+(void)AliWithdrawCashWithuserId:(NSString *)userId applyMoney:(NSString *)applyMoney aliPayNickName:(NSString *)aliPayNickName aliPayAccount:(NSString *)aliPayAccount Success:(SuccessWithObjectBlock)success Failed:(FailedErrorBlock)failed

{
    NSDictionary *dic = @{k_USER_ID:userId,K_applyMoney:applyMoney,K_aliPayNickName:aliPayNickName,K_aliPayAccount:aliPayAccount};
    
    [ExpressRequest sendWithParameters:dic MethodStr:API_WITHDRAW reqType:k_POST success:^(id object) {
        success(object);
        NSLog(@"%@",object);
    } failed:^(NSString *error) {
        failed(error);
    }];
    
}
//可提现余额
+(void)GetAliWithdrawMoneyWithuserId:(NSString *)userId Success:(SuccessWithObjectBlock)success Failed:(FailedErrorBlock)failed
{
    NSString *URLStr = [NSString stringWithFormat:@"%@%@?%@=%@",BaseUrl,API_WITHDRAW_MYLEFT,k_USER_ID,userId];
    
    [ExpressRequest sendWithParameters:nil MethodStr:URLStr reqType:k_GET success:^(id object) {
        NSArray *array = [object objectForKey:@"data"];
        
        myBlance *model = [[myBlance alloc]initWithJsonDict:array[0]];
        if (success) {
            success(model);
        }
    } failed:^(NSString *error) {
        if (failed) {
            failed(error);
        }
    }];
    
    
}
//钱包转账
+(void)TransferWithuserId:(NSString *)userId mobileTo:(NSString *)mobileTo tradeMoney:(NSString *)tradeMoney Success:(SuccessWithObjectBlock)success Failed:(FailedErrorBlock)failed
{
    
    NSDictionary *dic = @{k_USER_ID:userId,K_mobileTo:mobileTo,K_tradeMoney:tradeMoney};
    
    [ExpressRequest sendWithParameters:dic MethodStr:API_tranfermoney reqType:k_POST success:^(id object) {
        success(object);
        NSLog(@"%@",object);
    } failed:^(NSString *error) {
        failed(error);
    }];
    
}
//获取可转账金额
+(void)getTranfermoneyWithuserId:(NSString *)userId Success:(SuccessWithObjectBlock)success Failed:(FailedErrorBlock)failed
{
    
    NSString *URLStr = [NSString stringWithFormat:@"%@%@?%@=%@",BaseUrl,API_tranfermoney_MYLEFT,k_USER_ID,userId];
    
    [ExpressRequest sendWithParameters:nil MethodStr:URLStr reqType:k_GET success:^(id object) {
        NSArray *array = [object objectForKey:@"data"];
        
        myBlance *model = [[myBlance alloc]initWithJsonDict:array[0]];
        if (success) {
            success(model);
        }
    } failed:^(NSString *error) {
        if (failed) {
            failed(error);
        }
    }];
    
    
}

+ (void)getDefaultAddressUserId:(NSString *)userId
                       cityCode:(NSString *)cityCode
                       latitude:(NSString *)latitude
                      longitude:(NSString *)longitude
                        success:(SuccessWithObjectBlock)success
                         Failed:(FailedErrorBlock)failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@?%@=%@&%@=%@&%@=%@&%@=%@",BaseUrl,API_DEFAULT_ADDERSS,k_USER_ID,userId,ARG_LAT,latitude,ARG_LON,longitude,k_CITY_CODE,cityCode];
    [ExpressRequest sendWithParameters:nil MethodStr:urlStr reqType:k_GET success:^(id object) {
        success(object);
    } failed:^(NSString *error) {
        failed(error);
    }];
}

+(void)getCourierListWithUserId:(NSString *)userId
                       cityCode:(NSString *)cityCode
                       latitude:(NSString *)latitude
                      longitude:(NSString *)longitude
                        success:(SuccessWithNSMutableArrayBlock)success
                         Failed:(FailedErrorBlock)failed{
    NSString *URLStr = [NSString stringWithFormat:@"%@%@?%@=%@&%@=%@&%@=%@&%@=%@",BaseUrl,API_MY_COURIER_LIST,k_USER_ID,userId,ARG_LAT,latitude,ARG_LON,longitude,k_CITY_CODE,cityCode];
    [ExpressRequest sendWithParameters:nil MethodStr:URLStr reqType:k_GET success:^(id object) {
        NSMutableArray *dataArray =[object objectForKey:ARG_DATA];
        success(dataArray);
    } failed:^(NSString *error) {
        failed(error);
    }];
}

+(void)deleteAddressWithAddressId:(NSString *)addressId
                          success:(SuccessWithNSMutableArrayBlock)success
                           Failed:(FailedErrorBlock)failed{
    NSString *URLStr = [NSString stringWithFormat:@"%@%@?%@=%@",BaseUrl,API_ADD_REMOVE,k_ADDRESS_ID,addressId];
    [ExpressRequest sendWithParameters:nil MethodStr:URLStr reqType:k_GET success:^(id object) {
        NSMutableArray *dataArray =[object objectForKey:ARG_DATA];
        success(dataArray);
    } failed:^(NSString *error) {
        failed(error);
    }];
}

+(void)changeAddressWithAddressId:(NSString *)addressId
                        cityCode:(NSString *)cityCode
                        cityName:(NSString *)cityName
                      personName:(NSString *)personName
                          mobile:(NSString *)mobile
                        areaName:(NSString *)areaName
                         address:(NSString *)address
                        latitude:(NSString *)latitude
                       longitude:(NSString *)longitude
                         success:(SuccessWithNSMutableArrayBlock)success
                          Failed:(FailedErrorBlock)failed{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:cityCode,k_CITY_CODE,cityName,ARG_CITY_NAME,personName,ARG_PERSON_NAME,mobile,k_MOBILE,areaName,ARG_AREA_NAME,address,k_ADDRESS,latitude,ARG_LAT,longitude,ARG_LON,nil];
    ;
    [ExpressRequest sendWithParameters:dic MethodStr:[NSString stringWithFormat:@"%@/%@",API_ADD_ADDRESS,addressId] reqType:k_PUT success:^(id object) {
        NSMutableArray *arr = [NSMutableArray array];
        NSArray *addArr = [object objectForKey:ARG_DATA];
        for (NSDictionary *dic in addArr) {
            Address *address = [[Address alloc]initWithJsonDict:dic];
            [arr addObject:address];
        }
        success(arr);
    } failed:^(NSString *error) {
        failed(error);
    }];
    
}

+(void)deleteMessageWithMessageId:(NSString *)messageId
                          Success:(SuccessVoidBlock)success
                           Failed:(FailedErrorBlock)failed{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys: messageId,A_MSG_ID,nil];
    [ExpressRequest sendWithParameters:dic MethodStr:[NSString stringWithFormat:@"%@/%@",API_SYS_DELE,messageId] reqType:k_PUT success:^(id object) {
        success();
    } failed:^(NSString *error) {
        failed(error);
    }];

}

+(void)readMessageWithMessageId:(NSString *)messageId
                        Success:(SuccessVoidBlock)success
                         Failed:(FailedErrorBlock)failed{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys: messageId,A_MSG_ID,nil];
    [ExpressRequest sendWithParameters:dic MethodStr:[NSString stringWithFormat:@"%@/%@",API_SYS_READ,messageId] reqType:k_PUT success:^(id object) {
        success();
    } failed:^(NSString *error) {
        failed(error);
    }];
}

+(void)getLuckInfoWithUserId:(NSString *)userId
                     success:(SuccessWithObjectBlock)success
                      Failed:(FailedErrorBlock)failed{
    NSString *URLStr = [NSString stringWithFormat:@"%@%@?%@=%@",BaseUrl,API_LUCK_INFO,k_USER_ID,userId];
    [ExpressRequest sendWithParameters:nil MethodStr:URLStr reqType:k_GET success:^(id object) {
//        NSDictionary *dic = [object objectForKey:@"data"][0];
//        Draw *draw = [[Draw alloc]initWithJsonDict:dic];
//        success(draw);
        success(object);
    } failed:^(NSString *error) {
        failed(error);
    }];
}
+(void)uploadLuckResultWithUserId:(NSString *)userId
                          drawNum:(NSString *)drawNum
                          success:(SuccessWithStringBlock)success
                           Failed:(FailedErrorBlock)failed{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userId,k_USER_ID,drawNum,A_DRAW_NUM,nil];
    [ExpressRequest sendWithParameters:dic MethodStr:API_DRAW_NUM reqType:k_POST success:^(id object) {
        NSString *str = [(NSDictionary *)object valueForKey:@"message"];
        success(str);
    } failed:^(NSString *error){
        failed(error);
    }];
}

+(void)loginauthMobile:(NSString *)mobile
               success:(SuccessWithStringBlock)success
                Failed:(FailedErrorBlock)failed{
    NSString *URLstr = [NSString stringWithFormat:@"%@%@?mobile=%@",BaseUrl,API_LOG_AUTH,mobile];
    [ExpressRequest sendWithParameters:nil MethodStr:URLstr reqType:k_GET success:^(id object) {
        success(object);
    } failed:^(NSString *error) {
        failed(error);
    }];
}

+(void)checkloginauthMobile:(NSString *)mobile
                       code:(NSString *)code
                   deviceId:(NSString *)deviceId
                    success:(SuccessWithStringBlock)success
                     Failed:(FailedErrorBlock)failed{
    if (!ARG_SAVED_IDFV) {
        NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [KeyChain save:ARG_IDFV data:idfv];
    }
    NSDictionary *dic = @{k_MOBILE:mobile,@"code":code,k_DEVICE_ID:ARG_SAVED_IDFV };
    [ExpressRequest sendWithParameters:dic MethodStr:API_CHECK_LOG reqType:k_POST success:^(id object) {
        NSDictionary *userDic = [object objectForKey:ARG_DATA][0];
        User *user = [[User alloc]initWithJsonDict:userDic];
        [UserManager saveUser:user];
        success(object);
    } failed:^(NSString *error) {
        failed(error);
    }];
}

+(void)thirdCheckWithOpenId:(NSString *)openId
                accessToken:(NSString *)accessToken
                   nickName:(NSString *)nickName
                        sex:(NSString *)sex
               headImageUrl:(NSString *)headImageUrl
                    unionId:(NSString *)unionId
                     mobile:(NSString *)mobile
                       code:(NSString *)code
            recommendMobile:(NSString *)recommendMobile
                   cityCode:(NSString *)cityCode
                    success:(SuccessWithObjectBlock)success
                     Failed:(FailedErrorBlock)failed{
    
    if (!ARG_SAVED_IDFV) {
        NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [KeyChain save:ARG_IDFV data:idfv];
    }
     NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                          openId,ARG_OPEN_ID,
                          accessToken,ARG_ACCESS_TOKEN,
                          nickName,ARG_NIKE_NAME,
                          sex,@"sex",
                          headImageUrl,ARG_HEADIMG_URL,
                          unionId,ARG_UNIONID,
                          ARG_SAVED_IDFV,k_DEVICE_ID,
                          mobile,k_MOBILE,
                          code,@"code",
                          cityCode,@"cityCode",
                          nil];
    [ExpressRequest sendWithParameters:dic MethodStr:API_THIRD_CHECK reqType:k_POST success:^(id object) {
        NSNumber *errNumber = [object objectForKey:@"errCode"];
        NSInteger errcode = [errNumber integerValue];
        if (errcode == 0) {
            NSDictionary *userDic = [object objectForKey:ARG_DATA][0];
            User *user = [[User alloc]initWithJsonDict:userDic];
            [UserManager saveUser:user];
        }
        success(object);
    } failed:^(NSString *error) {
        failed(error);
    }];
    
}

+(void)getAdsWithUserId:(NSString *)userId
               deviceId:(NSString *)deviceId
                success:(SuccessWithObjectBlock)success
                 Failed:(FailedErrorBlock)failed{
    if (!ARG_SAVED_IDFV) {
        NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [KeyChain save:ARG_IDFV data:idfv];
    }
    NSString *URLStr =[NSString stringWithFormat:@"%@%@?%@=%@&%@=%@",BaseUrl,API_ADVERTISE,k_USER_ID,userId,k_DEVICE_ID,ARG_SAVED_IDFV];
    [ExpressRequest sendWithParameters:nil MethodStr:URLStr reqType:k_GET success:^(id object) {
        NSNumber *errNumber = [object objectForKey:@"errCode"];
        NSInteger errcode = [errNumber integerValue];
        NSString *message = [object objectForKey:@"message"];
        if (errcode ==0) {
            success(object);
        }else{
            success(message);
        }
        
    } failed:^(NSString *error) {
        failed(error);
    }];
}

+(void)getCrowdWithUserId:(NSString *)userId
                  success:(SuccessWithObjectBlock)success
                   Failed:(FailedErrorBlock)failed{
    NSString *URLStr = [NSString stringWithFormat:@"%@%@/%@",BaseUrl,API_CROWD,userId];
    [ExpressRequest sendWithParameters:nil MethodStr:URLStr reqType:k_GET success:^(id object) {
        NSDictionary *dic = [object valueForKey:@"data"][0];
        Crowd *model = [[Crowd alloc]initWithJsonDict:dic];
        success(model);
    } failed:^(NSString *error) {
        failed(error);
    }];
}
+(void)getCompNewsWithsuccess:(SuccessWithNSMutableArrayBlock)success
                       Failed:(FailedErrorBlock)failed{
    NSString *URLStr = [NSString stringWithFormat:@"%@%@",BaseUrl,API_COMPANY_NEWS];
    [ExpressRequest sendWithParameters:nil MethodStr:URLStr reqType:k_GET success:^(id object) {
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *dic in [object valueForKey:@"data"]) {
             CompanyNews *model = [[CompanyNews alloc]initWithJsonDict:dic];
            [arr addObject:model];
        }
       
        success(arr);
    } failed:^(NSString *error) {
        failed(error);
    }];
}

+(void)getWXPreWithBillCode:(NSString *)billCode
                    matName:(NSString *)matName
                    matType:(NSString *)matType
               insuranceFee:(NSString *)insuranceFee
                insureMoney:(NSString *)insureMoney
               needPayMoney:(NSString *)needPayMoney
                  shipMoney:(NSString *)shipMoney
                     weight:(NSString *)weight
                    success:(SuccessWithDictionaryBlock)success
                     Failed:(FailedErrorBlock)failed{
    
    NSDictionary *dic = @{A_BILL_CODE:billCode,
                          A_MAT_NAME :matName,
                          A_MAT_TYPE :matType,
                          K_insuranceFee :insuranceFee,
                          K_insureMoney :insureMoney,
                          A_NEED_PAY :needPayMoney,
                          A_SHIP:shipMoney,
                          K_weight :weight};
    [ExpressRequest sendWithParameters:dic MethodStr:A_WXPAY_CHANGE
                               reqType:k_PUT
                               success:^(id object) {
                                   NSDictionary *preDic = [object objectForKey:ARG_DATA][0];
//                                   WXPay *pay =
//                                   [[WXPay alloc] initWithJsonDict:preDic];
//                                   WXPay *pay = [[WXPay alloc]init];
//                                   [pay setValuesForKeysWithDictionary:preDic];
                                   success(preDic);
                               }
                                failed:^(NSString *error) {
                                    failed(error);
                                }];
    
}
+(void)getAliPayDiscountUserId:(NSString *)userId
                       success:(SuccessWithStringBlock)success
                        Failed:(FailedErrorBlock)failed{
    NSString *URLStr = [NSString stringWithFormat:@"%@%@?%@=%@",BaseUrl,A_DISCOUNT,k_USER_ID,userId];
    
    [ExpressRequest sendWithParameters:nil MethodStr:URLStr reqType:k_GET success:^(id object) {
        NSString *discount =[([object objectForKey:ARG_DATA][0]) valueForKey:@"discount"];
        success(discount);
    }
     failed:^(NSString *error) {
         failed(error);
     }];
}

+(void)getRechargePreUserId:(NSString *)userId
              rechargeMoney:(NSString *)rechargeMoney
            recommandMobile:(NSString *)recommandMobile
                    success:(SuccessWithDictionaryBlock)success
                     Failed:(FailedErrorBlock)failed{
    NSDictionary *dic = @{k_USER_ID:userId,
                          A_RECHARGE_MONEY :rechargeMoney,
                          A_RECOMMAND_MOBILE :recommandMobile};
    [ExpressRequest sendWithParameters:dic MethodStr:API_WX_PER reqType:k_POST success:^(id object) {
        NSDictionary *preDic = [object objectForKey:ARG_DATA][0];
        success(preDic);
    } failed:^(NSString *error) {
        failed(error);
    }];
}
+(void)getPayResultWithBillCode:(NSString *)BillCode
                        success:(SuccessWithDictionaryBlock)success
                         Failed:(FailedErrorBlock)failed{
    NSString *URLStr = [NSString stringWithFormat:@"%@%@?%@=%@",BaseUrl,API_PAY_RESULT,A_BILL_CODE,BillCode];
    
    [ExpressRequest sendWithParameters:nil MethodStr:URLStr reqType:k_GET success:^(id object) {
        NSDictionary *preDic = [object objectForKey:ARG_DATA][0];
        success(preDic);
    } failed:^(NSString *error) {
        failed(error);
    }];

}

+(void)searchPointName:(NSString *)Name
              cityCode:(NSString *)cityCode
              latitude:(NSString *)latitude
             longitude:(NSString *)longitude
                 expId:(NSString *)expId
               success:(SuccessWithArrayBlock)success
                Failed:(FailedErrorBlock)failed{
    NSDictionary *dic = @{A_NAME:Name,
                          ARG_EXP_ID:expId,
                          k_CITY_CODE :cityCode,
                          ARG_LON :longitude,
                          ARG_LAT:latitude};
    [ExpressRequest sendWithParameters:dic MethodStr:API_MAPPOINT reqType:k_POST success:^(id object) {
        NSArray *nameArr = [object objectForKey:ARG_DATA];
        success(nameArr);
    } failed:^(NSString *error) {
        failed(error);
    }];
}

+(void)courierAuthUserId:(NSString *)userId
               pointName:(NSString *)pointName
             pointNumber:(NSString *)pointNumber
              pointPhone:(NSString *)pointPhone
                   expId:(NSString *)expId
                 expName:(NSString *)expName
           courierNumber:(NSString *)courierNumber
                latitude:(NSString *)latitude
               longitude:(NSString *)longitude
                cityCode:(NSString *)cityCode
                 success:(SuccessWithArrayBlock)success
                  Failed:(FailedErrorBlock)failed{
    NSDictionary *dic = @{k_USER_ID:userId,
                          A_POINT_NAME :pointName,
                          A_POINT_NO:pointNumber,
                          ARG_EXP_ID:expId,
                          A_POINT_PHONE:pointPhone,
                          ARG_EXP_NAME:expName,
                          ARG_COUR_NO:courierNumber,
                          ARG_LON:longitude,
                          k_CITY_CODE:cityCode,
                          ARG_LAT:latitude};
    [ExpressRequest sendWithParameters:dic MethodStr:API_COURIER_AUTH reqType:k_POST success:^(id object) {
        NSArray *nameArr = [object objectForKey:ARG_DATA];
        success(nameArr);
    } failed:^(NSString *error) {
        failed(error);
    }];
}


#pragma mark --- 顺风快递
/**
 * 发布顺风任务
 */
/**
 * 发布顺风任务
 */
+(void)SendtailWindMissionWithUserId:(NSString *)userId
                            latitude:(NSString *)latitude
                           longitude:(NSString *)longitude
                          personName:(NSString *)personName
                              mobile:(NSString *)mobile
                             address:(NSString *)address
                            cityCode:(NSString *)cityCode
                            townCode:(NSString *)townCode
                            deviceId:(NSString *)deviceId
                        fromLatitude:(NSString *)fromLatitude
                       fromLongitude:(NSString *)fromLongitude
                        personNameTo:(NSString *)personNameTo
                            mobileTo:(NSString *)mobileTo
                           addressTo:(NSString *)addressTo
                          cityCodeTo:(NSString *)cityCodeTo
                          toLatitude:(NSString *)toLatitude
                         toLongitude:(NSString *)toLongitude
                             matName:(NSString *)matName
                         matImageUrl:(NSString *)matImageUrl
                           matRemark:(NSString *)matRemark
                           matWeight:(NSString *)matWeight
                              length:(NSString *)length
                               width:(NSString *)width
                              height:(NSString *)height
                             whether:(NSString *)whether
                             premium:(NSString *)premium
                      ifReplaceMoney:(NSString *)ifReplaceMoney
                        replaceMoney:(NSString *)replaceMoney
                           matVolume:(NSString *)matVolume
                           carLength:(NSString *)carLength
                             useTime:(NSString *)useTime
                             success:(SuccessWithNSMutableArrayBlock)success Failed:(FailedErrorBlock)failed

{
    if (!ARG_SAVED_IDFV) {
        NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [KeyChain save:ARG_IDFV data:idfv];
    }
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         userId,k_USER_ID,
                         latitude,k_COURIER_LAT,
                         longitude,k_COURIER_LON,
                         personName,ARG_PERSON_NAME,
                         mobile,k_MOBILE,
                         address,k_ADDRESS,
                         cityCode,k_CITY_CODE,
                         townCode,k_TOWN_CODE,
                         ARG_SAVED_IDFV,k_PUBLISH_DEVICE_ID,
                         fromLatitude,K_fromLatitude,
                         fromLongitude,K_fromLongitude,
                         personNameTo,ARG_PERSON_NAME_TO,
                         mobileTo,K_mobileTo,
                         addressTo,K_addressTo,
                         cityCodeTo,K_cityCodeTo,
                         toLatitude,K_toLatitude,
                         toLongitude,K_toLongitude,
                         matName,K_matName,
                         matImageUrl,K_matImageUrl,
                         matRemark,K_matRemark,
                         matWeight,K_matWeight,
                         length,@"length",
                         width,@"wide",
                         height,@"high",
                         whether,@"whether",
                         premium,@"premium",
                         ifReplaceMoney,@"ifReplaceMoney",
                         replaceMoney,@"replaceMoney",
                         matVolume,@"matVolume",
                         carLength,@"carLength",
                         useTime,@"useTime",
                         nil];
    
    [ExpressRequest sendWithParameters:dic MethodStr:API_PUBLISH_SF_TASK reqType:k_POST success:^(id object) {
        success([object valueForKey:@"data"]);
        NSLog(@"%@",object);
    } failed:^(NSString *error) {
        failed(error);
    }];
    
    
}

/**
 * 发布限时顺风任务
 */
+(void)SendtailLimitMissionWithUserId:(NSString *)userId
                             latitude:(NSString *)latitude
                            longitude:(NSString *)longitude
                           personName:(NSString *)personName
                               mobile:(NSString *)mobile
                              address:(NSString *)address
                             cityCode:(NSString *)cityCode
                             townCode:(NSString *)townCode
                             deviceId:(NSString *)deviceId
                         fromLatitude:(NSString *)fromLatitude
                        fromLongitude:(NSString *)fromLongitude
                         personNameTo:(NSString *)personNameTo
                             mobileTo:(NSString *)mobileTo
                            addressTo:(NSString *)addressTo
                           cityCodeTo:(NSString *)cityCodeTo
                           toLatitude:(NSString *)toLatitude
                          toLongitude:(NSString *)toLongitude
                              matName:(NSString *)matName
                          matImageUrl:(NSString *)matImageUrl
                            matRemark:(NSString *)matRemark
                            matWeight:(NSString *)matWeight
                               length:(NSString *)length
                                width:(NSString *)width
                               height:(NSString *)height
                            limitTime:(NSString *)limitTime
                              whether:(NSString *)whether
                              premium:(NSString *)premium
                       ifReplaceMoney:(NSString *)ifReplaceMoney
                         replaceMoney:(NSString *)replaceMoney
                              carType:(NSString *)carType
                              success:(SuccessWithNSMutableArrayBlock)success Failed:(FailedErrorBlock)failed

{
    if (!ARG_SAVED_IDFV) {
        NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [KeyChain save:ARG_IDFV data:idfv];
    }
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         userId,k_USER_ID,
                         latitude,k_COURIER_LAT,
                         longitude,k_COURIER_LON,
                         personName,ARG_PERSON_NAME,
                         mobile,k_MOBILE,
                         address,k_ADDRESS,
                         cityCode,k_CITY_CODE,
                         townCode,k_TOWN_CODE,
                         ARG_SAVED_IDFV,k_PUBLISH_DEVICE_ID,
                         fromLatitude,K_fromLatitude,
                         fromLongitude,K_fromLongitude,
                         personNameTo,ARG_PERSON_NAME_TO,
                         mobileTo,K_mobileTo,
                         addressTo,K_addressTo,
                         cityCodeTo,K_cityCodeTo,
                         toLatitude,K_toLatitude,
                         toLongitude,K_toLongitude,
                         matName,K_matName,
                         matImageUrl,K_matImageUrl,
                         matRemark,K_matRemark,
                         matWeight,K_matWeight,
                         length,@"length",
                         width,@"wide",
                         height,@"high",
                         limitTime,@"limitTime",
                         whether,@"whether",
                         premium,@"premium",
                         ifReplaceMoney,@"ifReplaceMoney",
                         replaceMoney,@"replaceMoney",
                         carType,@"carType",
                         nil];
    
    [ExpressRequest sendWithParameters:dic MethodStr:API_PUBLISH_TASK reqType:k_POST success:^(id object) {
        success([object valueForKey:@"data"]);
        NSLog(@"%@",object);
    } failed:^(NSString *error) {
        failed(error);
    }];
    
    
}
/**
 * 上传物品照片
 */
+(void)uploadmatNameWithUserId:(NSString *)userId fileName:(NSString *)fileName file:(id)file Success:(SuccessWithDictionaryBlock)success Failed:(FailedErrorBlock)failed
{
    UIImage *image = file;
    NSDictionary *dic = @{k_USER_ID:userId,k_FILE_NAME:fileName};
    NSDictionary *fileDic = @{@"data":image,@"fileName":fileName};
    [ExpressRequest sendWithParameters:dic MethodStr:API_FILE_DOWNWIND
                               fileDic:fileDic
                               success:^(id object) {
                                   success(object);
                               } failed:^(NSString *error) {
                                   failed(error);
                               }];
    
    
}

+(void)getMyunderUserId:(NSString *)userId pageNo:(NSInteger )pageNo pageSize:(NSInteger)pageSize
                Success:(SuccessWithNSMutableArrayBlock)success
                 Failed:(FailedErrorBlock)failed{
    NSString *URLStr = [NSString stringWithFormat:@"%@users/perAgentUserListNew?%@=%@&pageNo=%ld&pageSize=%ld",BaseUrl,k_USER_ID,userId,(long)pageNo,(long)pageSize];
    
    [ExpressRequest sendWithParameters:nil MethodStr:URLStr reqType:k_GET success:^(id object) {
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:20];
        NSArray *dataArr = [object objectForKey:ARG_DATA];
        for (NSDictionary *dic in dataArr) {
            Promote *model = [[Promote alloc]initWithJsonDict:dic];
            [arr addObject:model];
        }
        success(arr);
    } failed:^(NSString *error) {
        failed(error);
    }];

}

+(void)getExpPickListWithUserId:(NSString *)userId
                     pageNo:(int)pageNo
                   pageSize:(NSString *)pageSize
                    success:(SuccessWithNSMutableArrayBlock)success
                     Failed:(FailedErrorBlock)failed{
    NSString *URL = [NSString stringWithFormat:@"%@%@/%@/%d/%@",BaseUrl,API_EXP_PICK_LIST,userId,pageNo,pageSize];
    [ExpressRequest sendWithParameters:nil MethodStr:URL reqType:k_GET success:^(id object) {
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:20];
        NSArray *dataArr = [object valueForKey:@"data"];
        for (NSDictionary *dic in dataArr) {
            Package *model = [[Package alloc]initWithJsonDict:dic];
            [arr addObject:model];
        }
         success(arr);
        
    } failed:^(NSString *error) {
        if (failed) {
            failed(error);
        }
    }];
}

/**
 * 我的接单 按日期查询
 */
+(void)getExpPickListByDate:(NSString *)date
                     userId:(NSString *)userId
                    success:(SuccessWithNSMutableArrayBlock)success
                     Failed:(FailedErrorBlock)failed{
    NSString *URL = [NSString stringWithFormat:@"%@%@?%@=%@&%@=%@",BaseUrl,API_EXP_PICK_DATE,k_USER_ID,userId,@"date",date];
    [ExpressRequest sendWithParameters:nil MethodStr:URL reqType:k_GET success:^(id object) {
//        NSArray* keys = [[object valueForKey:@"data"][0] allKeys];
//        BOOL result = [[BGFMDB intance] createTableWithTableName:@"jiedan" keys:keys];//建表语句
//        if (result) {
//            NSLog(@"创表成功");
//        } else {
//            NSLog(@"创表失败");
//        }
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:20];
        NSArray *dataArr = [object valueForKey:@"data"];
        for (NSDictionary *dic in dataArr) {
            Package *model = [[Package alloc]initWithJsonDict:dic];
//            BOOL result = [[BGFMDB intance] insertIntoTableName:@"jiedan" Dict:dic];//插入语句
//            if (result) {
//                NSLog(@"插入成功");
//            } else {
//                NSLog(@"插入失败");
//            }
            [arr addObject:model];
        }
        success(arr);
        
    } failed:^(NSString *error) {
        if (failed) {
            failed(error);
        }
    }];
}

/**
 * 我的接单 按日期查询
 */
+(void)getExpDayWeakMonthWithDate:(NSString *)date
                           userId:(NSString *)userId
                          success:(SuccessWithObjectBlock)success Failed:(FailedErrorBlock)failed{
    NSString *URL = [NSString stringWithFormat:@"%@%@?%@=%@&%@=%@",BaseUrl,API_EXP_DAY_WEAK,k_USER_ID,userId,@"date",date];
    [ExpressRequest sendWithParameters:nil MethodStr:URL reqType:k_GET success:^(id object) {
        NSDictionary *dic = [object valueForKey:@"data"][0];
        CourierBisiness *model = [[CourierBisiness alloc]initWithJsonDict:dic];
        success(model);
        
    } failed:^(NSString *error) {
        if (failed) {
            failed(error);
        }
    }];
}
/**
 * 用户保存支付密码
 */
+(void)SavepaypasswordWithuserId:(NSString *)userId payPassword:(NSString *)payPassword deviceId:(NSString *)deviceId success:(SuccessWithStringBlock)success Failed:(FailedErrorBlock)failed
{
    
    if (!ARG_SAVED_IDFV) {
        NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [KeyChain save:ARG_IDFV data:idfv];
    }
    payPassword = [MyMD5 md5:payPassword];

    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userId,k_USER_ID,[NSString stringWithFormat:@"%@",payPassword],k_PAYPASSWORD,ARG_SAVED_IDFV,k_DEVICE_ID, nil];
    [ExpressRequest sendWithParameters:dic MethodStr:API_USERS_PAYPASSWORD reqType:k_POST success:^(id object) {
        NSDictionary *userDic = [object objectForKey:ARG_DATA][0];
        User *user = [[User alloc]initWithJsonDict:userDic];
        [UserManager saveUser:user];
        
        NSString *msg = [object valueForKey:ARG_MSG];
        
        success(msg);
    } failed:^(NSString *error) {
        failed(error);
    }];

    
}
/**
 * 用户获取每天的充值机会
 */
+(void)getRechargechangeuserId:(NSString *)userId
                       success:(SuccessWithObjectBlock)success
                        Failed:(FailedErrorBlock)failed{
    
    NSString *URL = [NSString stringWithFormat:@"%@%@?%@=%@",BaseUrl,API_RECHANGE_CHANCE,k_USER_ID,userId];
    [ExpressRequest sendWithParameters:nil MethodStr:URL reqType:k_GET success:^(id object) {
        NSDictionary *dic = [object valueForKey:@"data"][0];
        CourierBisiness *model = [[CourierBisiness alloc]initWithJsonDict:dic];
        success(model);
        
        
    } failed:^(NSString *error) {
        if (failed) {
            failed(error);
        }
    }];

    
    
}

/**
 *  获取提现默认账号
 */
+ (void)getWithDrawDefaultWithUserId:(NSString *)userId
                             success:(SuccessWithDictionaryBlock)success
                              Failed:(FailedErrorBlock)failed{
    
    NSString *URL = [NSString stringWithFormat:@"%@%@?%@=%@",BaseUrl,API_WITH_DRAW,k_USER_ID,userId];
    [ExpressRequest sendWithParameters:nil MethodStr:URL reqType:k_GET success:^(id object) {
        NSDictionary *dic = [object valueForKey:@"data"][0];
        
        success(dic);
        
        
    } failed:^(NSString *error) {
        if (failed) {
            failed(error);
        }
    }];
}

+ (void)resetPWDWithDrawDefaultWithUserId:(NSString *)userId
                                   idCard:(NSString *)idCard
                              payPassword:(NSString *)payPassword
                                  success:(SuccessWithDictionaryBlock)success
                                   Failed:(FailedErrorBlock)failed{
    NSString *payPwd = [MyMD5 md5:payPassword];
    NSDictionary *dic= @{k_USER_ID:userId,k_ID_CARD:idCard,k_PAYPASSWORD:payPwd};
    [ExpressRequest sendWithParameters:dic MethodStr:API_RESET_PWD reqType:k_POST success:^(id object) {
        NSDictionary *userDic = [object objectForKey:ARG_DATA][0];
        User *user = [[User alloc]initWithJsonDict:userDic];
        [UserManager saveUser:user];
        success(dic);
    } failed:^(NSString *error) {
        if (failed) {
            failed(error);
        }
    }];
}
+(void)getuserCreditWithuserId:(NSString *)userId   success:(SuccessWithDictionaryBlock)success
                        Failed:(FailedErrorBlock)failed{
    NSString *URL = [NSString stringWithFormat:@"%@%@?%@=%@",BaseUrl,API_CREDIT_USERCREDIT,k_USER_ID,userId];
    [ExpressRequest sendWithParameters:nil MethodStr:URL reqType:k_GET success:^(id object) {
        NSDictionary *dic = [object valueForKey:@"data"][0];
        
        success(dic);
        
        
    } failed:^(NSString *error) {
        if (failed) {
            failed(error);
        }
    }];
    
    
}



+ (void)uploadExpDetailWithParams:(NSDictionary *)params
                          success:(SuccessWithDictionaryBlock)success
                           Failed:(FailedErrorBlock)failed{
    [ExpressRequest sendWithParameters:params MethodStr:API_UPLOAD_EXP_DETAIL reqType:k_PUT success:^(id object) {
        success(object);
    } failed:^(NSString *error) {
        if (failed) {
            failed(error);
        }
    }];
}

+ (void)getExpNoWithBusinessId:(NSString *)businessId
                       success:(SuccessWithNSMutableArrayBlock)success
                        Failed:(FailedErrorBlock)failed{
    NSString *URLStr = [NSString stringWithFormat:@"%@%@?businessId=%@",BaseUrl,API_GET_EXP_NO,businessId];
    [ExpressRequest sendWithParameters:nil MethodStr:URLStr reqType:k_GET success:^(id object) {
        NSMutableArray *arr = [object valueForKey:@"data"];
        success(arr);
    } failed:^(NSString *error) {
        if (failed) {
            failed(error);
        }
    }];
}

/**
 * 快递员补贴政策和评分
 */
+(void)getcouierSorceAndLVWithuserId:(NSString *)userId success:(SuccessWithDictionaryBlock)success Failed:(FailedErrorBlock)failed
{
    
    NSString *URL = [NSString stringWithFormat:@"%@%@?%@=%@",BaseUrl,API_USERS_COURIERSCOREANDLV,k_USER_ID,userId];
    [ExpressRequest sendWithParameters:nil MethodStr:URL reqType:k_GET success:^(id object) {
        NSDictionary *dic = [object valueForKey:@"data"][0];
        
        success(dic);
        
        
    } failed:^(NSString *error) {
        if (failed) {
            failed(error);
        }
    }];
}

/**
 * 请求用户钱包数据
 */
+(void)getuserwalletDataWithuserId:(NSString *)userId success:(SuccessWithDictionaryBlock)success Failed:(FailedErrorBlock)failed
{
    
    
    NSString *URL = [NSString stringWithFormat:@"%@%@?%@=%@",BaseUrl,API_USER_BALANCE_WALLETINFO,k_USER_ID,userId];
    [ExpressRequest sendWithParameters:nil MethodStr:URL reqType:k_GET success:^(id object) {
        NSDictionary *dic = [object valueForKey:@"data"][0];
        
        success(dic);
        
        
    } failed:^(NSString *error) {
        if (failed) {
            failed(error);
        }
    }];
}
/**
 * 请求快递员钱包数据
 */
+(void)getcourierwalletDataWithuserId:(NSString *)userId success:(SuccessWithDictionaryBlock)success Failed:(FailedErrorBlock)failed
{
    
    
    NSString *URL = [NSString stringWithFormat:@"%@%@?%@=%@",BaseUrl,API_USER_BALANCE_WALLETINFO,k_USER_ID,userId];
    [ExpressRequest sendWithParameters:nil MethodStr:URL reqType:k_GET success:^(id object) {
        NSDictionary *dic = [object valueForKey:@"data"][0];
        
        success(dic);
        
        
    } failed:^(NSString *error) {
        if (failed) {
            failed(error);
        }
    }];

    
}



+(void)uploadCreaditCardNoWithUserId:(NSString *)userId
                          bankCard:(NSString *)bankCard
                             success:(SuccessWithDictionaryBlock)success
                              Failed:(FailedErrorBlock)failed{
    NSDictionary *dic = @{k_USER_ID:userId,A_BANK_CARD_NO:bankCard};
    [ExpressRequest sendWithParameters:dic
                             MethodStr:API_CARA_AUTH
                               reqType:k_POST
                               success:^(id object) {
                                   if (success) {
                                       success(object);
                                   }
                               } failed:^(NSString *error) {
                                   if (failed) {
                                       failed(error);
                                   }
                               }];
}

/**
 * 镖师发布顺风行程
 */

+(void)sendtailWindTripWithuserid:(NSString *)userId
                         cityCode:(NSString *)cityCode
                         latitude:(NSString *)latitude
                        longitude:(NSString *)longitude
                       cityCideTo:(NSString *)cityCideTo
                          address:(NSString *)address
                        addressTo:(NSString *)addressTo
                        leaveTime:(NSString *)leaveTime
                 transportationId:(NSString *)transportationId
                           remark:(NSString *)remark
                     fromLatitude:(NSString *)fromLatitude
                    fromLongitude:(NSString *)fromLongitude
                       toLatitude:(NSString *)toLatitude
                      toLongitude:(NSString *)toLongitude
                          success:(SuccessWithNSMutableArrayBlock)success
                           Failed:(FailedErrorBlock)failed
{
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         userId,k_USER_ID,
                         cityCode,k_CITY_CODE,
                         latitude,k_COURIER_LAT,
                         longitude,k_COURIER_LON,
                         cityCideTo,K_cityCodeTo,  
                         address,k_ADDRESS,
                         addressTo,K_addressTo,
                         leaveTime,K_leaveTime,
                         transportationId,K_transportationId,
                         remark,K_remark,
                         fromLatitude,K_fromLatitude,fromLongitude,K_fromLongitude,
                             toLatitude,K_toLatitude,toLongitude,K_toLongitude
                         ,nil];

    [ExpressRequest sendWithParameters:dic MethodStr:API_DRIVER_DRIVEROUTE reqType:k_POST success:^(id object) {
        success(object);
        NSLog(@"%@",object);
    } failed:^(NSString *error) {
        failed(error);
    }];
    
}

/**
 * 顺风行程列表（用户界面看到的）
 */
+(void)getWindTripListWithuserId:(NSString *)userId
                          pageNo:(NSString *)pageNo
                        pageSize:(NSString *)pageSize
                        sortType:(NSString *)sortType
                         Success:(SuccessWithArrayBlock)success
                          Failed:(FailedErrorBlock)failed
{
    
    NSString *URLStr = [NSString stringWithFormat:@"%@%@?%@=%@&%@=%@&%@=%@&sortType=%@",BaseUrl,API_DRIVER_DRIVERROUTELIST,k_USER_ID,userId,k_PAGE_NO,pageNo,k_PAGE_SIEZ,pageSize,sortType];
    
    [ExpressRequest sendWithParameters:nil MethodStr:URLStr reqType:k_GET success:^(id object) {
        NSMutableArray *proArray = [NSMutableArray array];
        NSArray *dataArray = [(NSDictionary*)object objectForKey:@"data"];
        for (NSDictionary *dic in dataArray) {
            ShunFeng *model = [[ShunFeng alloc]initWithJsonDict:dic];
            [proArray addObject:model];
        }
        
        if (success) {
            success(proArray);
        }
    } failed:^(NSString *error) {
        if (failed) {
            failed(error);
        }
    }];
}

/**
 * 顺风快递列表（镖师界面看到的）
 */
+(void)getWindExpressListWithuserId:(NSString *)userId
                             pageNo:(NSString *)pageNo
                           pageSize:(NSString *)pageSize
                           sortType:(NSString *)sortType
                            Success:(SuccessWithArrayBlock)success
                             Failed:(FailedErrorBlock)failed
{
    
    NSString *URLStr = [NSString stringWithFormat:@"%@%@?%@=%@&%@=%@&%@=%@&sortType=%@",BaseUrl,API_DOWNWIND_TASK_DOWNWINDTASK,k_USER_ID,userId,k_PAGE_NO,pageNo,k_PAGE_SIEZ,pageSize,sortType];
    
    [ExpressRequest sendWithParameters:nil MethodStr:URLStr reqType:k_GET success:^(id object) {
        NSMutableArray *proArray = [NSMutableArray array];
        NSArray *dataArray = [(NSDictionary*)object objectForKey:@"data"];
        for (NSDictionary *dic in dataArray) {
            ShunFengBiaoShi *model = [[ShunFengBiaoShi alloc]initWithJsonDict:dic];
            [proArray addObject:model];
        }
        
        if (success) {
            success(proArray);
        }
    } failed:^(NSString *error) {
        if (failed) {
            failed(error);
        }
    }];
}
/**
 * 镖师抢单接口
 */
+(void)biaoshiqiangdanWithuserId:(NSString *)userId recId:(NSString *)recId success:(SuccessWithNSMutableArrayBlock)success Failed:(FailedErrorBlock)failed
{
    
    NSString *URLStr = [NSString stringWithFormat:@"%@%@?%@=%@&%@=%@",BaseUrl,API_DOWNWIND_TASK_ROBORDERNwew,k_USER_ID,userId,K_recId,recId];
    [ExpressRequest sendWithParameters:nil MethodStr:URLStr reqType:k_GET success:^(id object) {
       
        success(object);
        
    } failed:^(NSString *error) {
        failed(error);
        
        
    }];

}
/**
 * （我的顺风 限时镖）货主所有已支付订单列表
 */
+(void)GetHuozhuLimitTaskWithuserId:(NSString *)userId pageNo:(NSString *)pageNo pageSize:(NSString *)pageSize Success:(SuccessWithArrayBlock)success Failed:(FailedErrorBlock)failed
{
    
    NSString *URLStr = [NSString stringWithFormat:@"%@%@?%@=%@&type=limit&%@=%@&%@=%@",BaseUrl,API_DOWNWIND_TASK_GETTASKBYTYPE,k_USER_ID,userId,k_PAGE_NO,pageNo,k_PAGE_SIEZ,pageSize];
    
    [ExpressRequest sendWithParameters:nil MethodStr:URLStr reqType:k_GET success:^(id object) {
        NSMutableArray *proArray = [NSMutableArray array];
        NSArray *dataArray = [(NSDictionary*)object objectForKey:@"data"];
        for (NSDictionary *dic in dataArray) {
            ShunFeng *model = [[ShunFeng alloc]initWithJsonDict:dic];
            [proArray addObject:model];
        }
        
        if (success) {
            success(proArray);
        }
    } failed:^(NSString *error) {
        if (failed) {
            failed(error);
        }
    }];
}

/**
 * （我的顺风 顺风镖）货主所有已支付订单列表
 */
+(void)GetHuozhuShuFengTaskWithuserId:(NSString *)userId pageNo:(NSString *)pageNo pageSize:(NSString *)pageSize Success:(SuccessWithArrayBlock)success Failed:(FailedErrorBlock)failed
{
    
    NSString *URLStr = [NSString stringWithFormat:@"%@%@?%@=%@&type=wind&%@=%@&%@=%@",BaseUrl,API_DOWNWIND_TASK_GETTASKBYTYPE,k_USER_ID,userId,k_PAGE_NO,pageNo,k_PAGE_SIEZ,pageSize];
    
    [ExpressRequest sendWithParameters:nil MethodStr:URLStr reqType:k_GET success:^(id object) {
        NSMutableArray *proArray = [NSMutableArray array];
        NSArray *dataArray = [(NSDictionary*)object objectForKey:@"data"];
        for (NSDictionary *dic in dataArray) {
            ShunFeng *model = [[ShunFeng alloc]initWithJsonDict:dic];
            [proArray addObject:model];
        }
        
        if (success) {
            success(proArray);
        }
    } failed:^(NSString *error) {
        if (failed) {
            failed(error);
        }
    }];
}

/**
 * （我的顺风）货主所有已支付订单列表
 */

+(void)GetHuozhuTaskWithuserId:(NSString *)userId pageNo:(NSString *)pageNo pageSize:(NSString *)pageSize Success:(SuccessWithArrayBlock)success Failed:(FailedErrorBlock)failed
{
    
    NSString *URLStr = [NSString stringWithFormat:@"%@%@?%@=%@&type=wind&%@=%@&%@=%@",BaseUrl,API_DOWNWIND_TASK_GETTASK,k_USER_ID,userId,k_PAGE_NO,pageNo,k_PAGE_SIEZ,pageSize];
    
    [ExpressRequest sendWithParameters:nil MethodStr:URLStr reqType:k_GET success:^(id object) {
        NSMutableArray *proArray = [NSMutableArray array];
        NSArray *dataArray = [(NSDictionary*)object objectForKey:@"data"];
        for (NSDictionary *dic in dataArray) {
            ShunFeng *model = [[ShunFeng alloc]initWithJsonDict:dic];
            [proArray addObject:model];
        }
        
        if (success) {
            success(proArray);
        }
    } failed:^(NSString *error) {
        if (failed) {
            failed(error);
        }
    }];
}

/**
 * （我的顺风）镖师查询所有已抢单订单列表
 */
+(void)GetBiaoShiTaskRouteWithuserId:(NSString *)userId pageNo:(NSString *)pageNo pageSize:(NSString *)pageSize Success:(SuccessWithArrayBlock)success Failed:(FailedErrorBlock)failed
{
    
    NSString *URLStr = [NSString stringWithFormat:@"%@%@?%@=%@&%@=%@&%@=%@",BaseUrl,API_DRIVER_DOWNWINDTASKROUTELIST,k_USER_ID,userId,k_PAGE_NO,pageNo,k_PAGE_SIEZ,pageSize];
    
    [ExpressRequest sendWithParameters:nil MethodStr:URLStr reqType:k_GET success:^(id object) {
        NSMutableArray *proArray = [NSMutableArray array];
        NSArray *dataArray = [(NSDictionary*)object objectForKey:@"data"];
        for (NSDictionary *dic in dataArray) {
            ShunFengBiaoShi *model = [[ShunFengBiaoShi alloc]initWithJsonDict:dic];
            [proArray addObject:model];
        }
        
        if (success) {
            success(proArray);
        }
    } failed:^(NSString *error) {
        if (failed) {
            failed(error);
        }
    }];

}
/**
 * （限时镖）镖师查询所有已抢单订单列表
 */
+(void)GetBiaoShiLimitTaskRouteWithuserId:(NSString *)userId pageNo:(NSString *)pageNo pageSize:(NSString *)pageSize Success:(SuccessWithArrayBlock)success Failed:(FailedErrorBlock)failed
{
    NSString *URLStr = [NSString stringWithFormat:@"%@%@?%@=%@&type=limit&%@=%@&%@=%@",BaseUrl,API_DRIVER_DOWNWINDTASKROUTELISTTYPE,k_USER_ID,userId,k_PAGE_NO,pageNo,k_PAGE_SIEZ,pageSize];
    
    [ExpressRequest sendWithParameters:nil MethodStr:URLStr reqType:k_GET success:^(id object) {
        NSMutableArray *proArray = [NSMutableArray array];
        NSArray *dataArray = [(NSDictionary*)object objectForKey:@"data"];
        for (NSDictionary *dic in dataArray) {
            ShunFengBiaoShi *model = [[ShunFengBiaoShi alloc]initWithJsonDict:dic];
            [proArray addObject:model];
        }
        
        if (success) {
            success(proArray);
        }
    } failed:^(NSString *error) {
        if (failed) {
            failed(error);
        }
    }];
    
}
/**
 * （顺风镖）镖师查询所有已抢单订单列表
 */
+(void)GetBiaoShiShunFengTaskRouteWithuserId:(NSString *)userId pageNo:(NSString *)pageNo pageSize:(NSString *)pageSize Success:(SuccessWithArrayBlock)success Failed:(FailedErrorBlock)failed
{
    
  NSString *URLStr = [NSString stringWithFormat:@"%@%@?%@=%@&type=wind&%@=%@&%@=%@",BaseUrl,API_DRIVER_DOWNWINDTASKROUTELISTTYPE,k_USER_ID,userId,k_PAGE_NO,pageNo,k_PAGE_SIEZ,pageSize];
    
    [ExpressRequest sendWithParameters:nil MethodStr:URLStr reqType:k_GET success:^(id object) {
        NSMutableArray *proArray = [NSMutableArray array];
        NSArray *dataArray = [(NSDictionary*)object objectForKey:@"data"];
        for (NSDictionary *dic in dataArray) {
            ShunFengBiaoShi *model = [[ShunFengBiaoShi alloc]initWithJsonDict:dic];
            [proArray addObject:model];
        }
        
        if (success) {
            success(proArray);
        }
    } failed:^(NSString *error) {
        if (failed) {
            failed(error);
        }
    }];
    
}


/**
 * 镖师确定取货并给（收件人）发送确认密码
*/

+(void)sendDriverPickpasswordWithrecId:(NSString *)recId Withlat:(NSString *)lat withLon:(NSString *)lon withCarNum:(NSString *)carNumber  success:(SuccessWithNSMutableArrayBlock)success Failed:(FailedErrorBlock)failed
{
    if (!ARG_SAVED_IDFV) {
        NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [KeyChain save:ARG_IDFV data:idfv];
    }
    NSString *URLStr = [NSString stringWithFormat:@"%@%@?%@=%@&orderDeviceId=%@&tackLatitude=%@&tackLongitude=%@&carNumber=%@",BaseUrl,API_DRIVER_DRIVERISTAKE,K_recId,recId,ARG_SAVED_IDFV,lat,lon,carNumber];
    [ExpressRequest sendWithParameters:nil MethodStr:URLStr reqType:k_GET success:^(id object) {
        
        success(object);
        
    } failed:^(NSString *error) {
        failed(error);
        
        
    }];

}


/**
 * 镖师核对交易密码
 */
+(void)ChecktransactionpasswordWithrecId:(NSString *)recId Withlat:(NSString *)lat withLon:(NSString *)lon dealPassword:(NSString *)dealPassword success:(SuccessWithObjectBlock)success Failed:(FailedErrorBlock)failed
{
    if (!ARG_SAVED_IDFV) {
        NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [KeyChain save:ARG_IDFV data:idfv];
    }
    NSString *URLStr = [NSString stringWithFormat:@"%@%@?%@=%@&%@=%@&checkDeviceId=%@&arriveLatitude=%@&arriveLongitude=%@",BaseUrl,API_DRIVER_DRIVERTRUETAKE,K_recId,recId,K_dealPassword,dealPassword,ARG_SAVED_IDFV,lat,lon];
    [ExpressRequest sendWithParameters:nil MethodStr:URLStr reqType:k_GET success:^(id object) {
        
        success(object);
        
    } failed:^(NSString *error) {
        failed(error);
        
        
    }];
    
}

/**
 * 删除快递订单
 */
+(void)DeleteExpressWithbillCode:(NSString *)billCode Success:(SuccessVoidBlock)success Failed:(FailedErrorBlock)failed
{
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys: billCode,A_BILL_CODE,nil];
    [ExpressRequest sendWithParameters:dic MethodStr:[NSString stringWithFormat:@"%@",API_EXPRESS_DELETE] reqType:k_PUT success:^(id object) {
        success();
    } failed:^(NSString *error) {
        failed(error);
    }];

}

/**
 * 顺风镖师取消订单
 */

+(void)refundReimburseWithrecId:(NSString *)recId success:(SuccessWithNSMutableArrayBlock)success Failed:(FailedErrorBlock)failed
{
    NSString *URLStr = [NSString stringWithFormat:@"%@%@?%@=%@&type=1",BaseUrl,API_DRIVER_CANCEL,K_recId,recId];
    [ExpressRequest sendWithParameters:nil MethodStr:URLStr reqType:k_GET success:^(id object) {
        
        success(object);
        
    } failed:^(NSString *error) {
        failed(error);
        
        
    }];
    
}


/**
 * 快递员删除订单请求
 */
+(void)CourierDeleteExpressWithbillCode:(NSString *)billCode Success:(SuccessVoidBlock)success Failed:(FailedErrorBlock)failed
{
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys: billCode,A_BILL_CODE,nil];
    [ExpressRequest sendWithParameters:dic MethodStr:[NSString stringWithFormat:@"%@",API_COURIEREXPRESS_DELETE] reqType:k_PUT success:^(id object) {
        success();
    } failed:^(NSString *error) {
        failed(error);
    }];
}
/**
 * 用户查看镖师的被评价列表信息
 */
+(void)getEvalutionDriverEvaLuteWithDriverId:(NSString *)driverId pageNo:(NSString *)pageNo pageSize:(NSString*)pageSize  Success:(SuccessWithArrayBlock)success Failed:(FailedErrorBlock)failed

{
    
    
    NSString *URLStr = [NSString stringWithFormat:@"%@%@?%@=%@&%@=%@&%@=%@",BaseUrl,API_EVALUTION_DRIVEREVALUATE,K_DRIVERID,driverId,k_PAGE_NO,pageNo,k_PAGE_SIEZ,pageSize];
    
    
    [ExpressRequest sendWithParameters:nil MethodStr:URLStr reqType:k_GET success:^(id object) {
        NSMutableArray *proArray = [NSMutableArray array];
        NSArray *dataArray = [(NSDictionary*)object objectForKey:@"data"];
        for (NSDictionary *dic in dataArray) {
            Evaluation *model = [[Evaluation alloc]initWithJsonDict:dic];
            [proArray addObject:model];
        }
        
        if (success) {
            success(proArray);
        }
    } failed:^(NSString *error) {
        if (failed) {
            failed(error);
        }
    }];

}

/**
 * 获取镖师详细信息
 */
+(void)getdriverdetailWithdriverId:(NSString *)driverId Success:(SuccessWithObjectBlock)success Failed:(FailedErrorBlock)failed
{
    
    
    NSString *URLStr = [NSString stringWithFormat:@"%@%@?%@=%@",BaseUrl,API_DRIVER_DRIVERDETAIL,K_DRIVERID,driverId];
    
    [ExpressRequest sendWithParameters:nil MethodStr:URLStr reqType:k_GET success:^(id object) {
        NSArray *array = [object objectForKey:@"data"];
        
        Evaluation *model = [[Evaluation alloc]initWithJsonDict:array[0]];
        if (success) {
            success(model);
        }
    } failed:^(NSString *error) {
        if (failed) {
            failed(error);
        }
    }];
}

/**
 * 获取快递员可抢单列表
 */

+(void)getnearlyExpressListWithlatitude:(NSString *)latitude longitude:(NSString *)longitude cityCode:(NSString *)cityCode pageNo:(NSString *)pageNo pageSize:(NSString*)pageSize   Success:(SuccessWithArrayBlock)success Failed:(FailedErrorBlock)failed;
{
    
    
    NSString *URLStr = [NSString stringWithFormat:@"%@%@?%@=%@&%@=%@&%@=%@&%@=%@&%@=%@",BaseUrl,API_express_expressList,ARG_LAT,latitude,ARG_LON,longitude,k_CITY_CODE,cityCode,k_PAGE_NO,pageNo,k_PAGE_SIEZ,pageSize];
    
    
    [ExpressRequest sendWithParameters:nil MethodStr:URLStr reqType:k_GET success:^(id object) {
        NSMutableArray *proArray = [NSMutableArray array];
        NSArray *dataArray = [(NSDictionary*)object objectForKey:@"data"];
        for (NSDictionary *dic in dataArray) {
            Courier *model = [[Courier alloc]initWithJsonDict:dic];
            [proArray addObject:model];
        }
        
        
        if (success) {
            success(proArray);
        }
    } failed:^(NSString *error) {
        if (failed) {
            failed(error);
        }
    }];
    
}
/**
 * 快递员抢单
 */
+(void)CourierQiangdanWithuserId:(NSString *)userId businessId:(NSString *)businessId success:(SuccessWithNSMutableArrayBlock)success Failed:(FailedErrorBlock)failed
{
    
    NSString *URLStr = [NSString stringWithFormat:@"%@%@?%@=%@&%@=%@",BaseUrl,API_express_grabExpress,k_USER_ID,userId,k_BUSINESS_ID,businessId];
    [ExpressRequest sendWithParameters:nil MethodStr:URLStr reqType:k_GET success:^(id object) {
        
        success(object);
        
    } failed:^(NSString *error) {
        failed(error);
        
        
    }];

}
/**
 * 用户取消顺风订单
 */
+(void)cancelDownWindtaskWithrecId:(NSString *)recId  success:(SuccessWithNSMutableArrayBlock)success
                            Failed:(FailedErrorBlock)failed;
{
    
    
    NSString *URLStr = [NSString stringWithFormat:@"%@%@?%@=%@",BaseUrl,API_CANCELDOWNWINDTASK,K_recId,recId];
    [ExpressRequest sendWithParameters:nil MethodStr:URLStr reqType:k_GET success:^(id object) {
        
        success(object);
        
    } failed:^(NSString *error) {
        failed(error);
        
        
    }];
    
    
    
}

+(void)getPerAgentCountWithUserId:(NSString *)userId  success:(SuccessWithStringBlock)success
                           Failed:(FailedErrorBlock)failed{

    NSString *URLStr = [NSString stringWithFormat:@"%@%@?%@=%@",BaseUrl,LBAPI_PERAGENT_COUNT,k_USER_ID,userId];
    [ExpressRequest sendWithParameters:nil MethodStr:URLStr reqType:k_GET success:^(id object) {
        
        success(object[@"data"][0]);
        
    } failed:^(NSString *error) {
        failed(error);
    }];
}

+(void)getUserBalanceWithUserId:(NSString *)userId  success:(SuccessWithStringBlock)success
                         Failed:(FailedErrorBlock)failed{
    NSString *URLStr = [NSString stringWithFormat:@"%@user/balance/getUserBalance?%@=%@",BaseUrl,k_USER_ID,userId];
    [ExpressRequest sendWithParameters:nil MethodStr:URLStr reqType:k_GET success:^(id object) {
        success(object[@"data"][0][@"perAgentSum"]);
    } failed:^(NSString *error) {
    }];
}

+(void)getUserAppVersionWithUserID:(NSString *)userId success:(SuccessWithStringBlock)success Failed:(FailedErrorBlock)failed{
    NSString * URLStr = [NSString stringWithFormat:@"%@%@",BaseUrl,APP_VERSION];
    [ExpressRequest sendWithParameters:nil MethodStr:URLStr reqType:k_GET success:^(id object) {
        success(object[@"data"][0][@"iosVersion"]);
    } failed:^(NSString *error) {
        failed(error);
    }];
}

/**
 * 获取新手机号验证码
 */
+(void)getNewMobileCode:(NSString *)newMobile success:(SuccessWithStringBlock)success Failed:(FailedErrorBlock)failed{
    NSString * urlString = [NSString stringWithFormat:@"%@%@?mobile=%@",BaseUrl,API_NEWSMSCODE,newMobile];
    
    [ExpressRequest sendWithParameters:nil MethodStr:urlString reqType:k_GET success:^(id object) {
        
        success([object[@"data"][0][@"code"] stringValue]);

    } failed:^(NSString *error) {
        failed(error);
    }];
    
}
/**
 * 更改新手机号
 */
+(void)changeNewMobileWithUserId:(NSString *)userId oldPassword:(NSString *)oldPassword mobile:(NSString *)mobile newMobile:(NSString *)newMobile idCode:(NSString *)idCode success:(SuccessWithStringBlock)success Failed:(FailedErrorBlock)failed{

    NSDictionary *dic = @{@"userId":userId,
                          @"oldPassword" :oldPassword,
                          @"mobile" :mobile,
                          @"newMobile" :newMobile,
                          @"idCard" :idCode
                          };
    
    [ExpressRequest sendWithParameters:dic MethodStr:API_CHANGENUM reqType:k_PUT success:^(id object) {
        success(object);
    } failed:^(NSString *error) {
        failed(error);
    }];

}

/**
 * 物流公司查看附近货源
 */
+(void)getNearGoodSourceListWithUserId:(NSString *)userId cityCode:(NSString *)cityCode pageNo:(NSString *)pageNo  Success:(SuccessWithObjectBlock)success Failed:(FailedErrorBlock)failed{
    NSString * urlStr =[NSString stringWithFormat:@"%@logistics/task/look/nearBy?userId=%@&cityCode=%@&pageNo=%@&pageSize=20",BaseUrl,userId,cityCode,pageNo];
    [ExpressRequest sendWithParameters:nil MethodStr:urlStr reqType:k_GET success:^(id object) {
//        NSMutableArray * arr = [NSMutableArray array];
    } failed:^(NSString *error) {
        
    }];
}
/*
 //积分历史
 +(void)getEcoinHistoryWithuserId:(NSString *)userId
 pageSize:(NSString *)pageSize
 pageNo:(NSString *)pageNo
 Success:(SuccessWithArrayBlock)success
 Failed:(FailedErrorBlock)failed
 {
 
 NSString *URLStr = [NSString stringWithFormat:@"%@%@?%@=%@&%@=%@&%@=%@",BaseUrl,API_Ecoin_LIST,k_USER_ID,userId,k_PAGE_SIEZ,pageSize,k_PAGE_NO,pageNo];
 
 [ExpressRequest sendWithParameters:nil MethodStr:URLStr reqType:k_GET success:^(id object) {
 NSMutableArray *proArray = [NSMutableArray array];
 NSArray *dataArray = [(NSDictionary*)object objectForKey:@"data"];
 for (NSDictionary *dic in dataArray) {
 Ecoin *model = [[Ecoin alloc]initWithJsonDict:dic];
 [proArray addObject:model];
 }
 
 if (success) {
 success(proArray);
 }
 } failed:^(NSString *error) {
 if (failed) {
 failed(error);
 }
 }];
 
 }
 
 */

@end
