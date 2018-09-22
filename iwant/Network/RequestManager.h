//
//  RequestManager.h
//  Express
//
//  Created by 张宾 on 15/7/15.
//  Copyright (c) 2015年 SCHT. All rights reserved.
//




#import <Foundation/Foundation.h>
#import "Promote.h"
#import "CourierBisiness.h"
#import "ShunFeng.h"
#import "ExpressRequest.h"
//区分返回的数据类型；
typedef void(^SuccessWithIntBlock)(NSInteger result);
typedef void(^SuccessWithArrayBlock)(NSArray *result);
typedef void(^SuccessWithDictionaryBlock)(NSDictionary *result);
typedef void(^SuccessWithMutableDictionaryBlock)(NSMutableDictionary *result);
typedef void(^SuccessWithNSMutableArrayBlock)(NSMutableArray *result);
typedef void(^SuccessWithStringBlock)(NSString *reslut);
typedef void(^SuccessWithBoolBlock)(BOOL result);
typedef void(^SuccessWithObjectBlock)(id object);
typedef void(^SuccessVoidBlock)();

typedef void(^FailedVoidBlock)();       //不带error的

typedef void(^SuccessBlock)(id object);     //带原始数据
typedef void(^FailedErrorBlock)(NSString *error); //带error的

@interface RequestManager : NSObject
/**
 *  下载图片
 */
+ (void)downloadFile:(NSInteger)field
Success:(SuccessWithObjectBlock)success
              Failed:(FailedVoidBlock)failed;
/**
 *  注册
 *
 *  @param mobile   手机号
 *  @param smsCode  验证码
 *  @param passWord 密码
 *  @param deviceId 设备ID
 *  @param  cityCode   城市编码
 */
+ (void)registWithMobile:(NSString *)mobile
                passWord:(NSString *)passWord
                deviceId:(NSString *)deviceId
         recommendMobile:(NSString *)recommendMobile
                 smsCode:(NSString *)smsCode
                cityCode:(NSString *)cityCode
                 success:(SuccessWithStringBlock)success
                  failed:(FailedErrorBlock)failed;

/**
 *  获取验证码
 *
 */
+ (void)getSmsCodeWithMobile:(NSString *)mobile
                Success:(SuccessWithObjectBlock)success
                 Failed:(FailedErrorBlock)failed;
/**
 *  完善信息
 *
 *  @param userName   <#userName description#>
 *  @param idCard     <#idCard description#>
 *  @param idCardPath <#idCardPath description#>
 *  @param success    <#success description#>
 *  @param failed     <#failed description#>
 */
+(void)userInfoWithUserId:(NSString *)userId
                 userName:(NSString *)userName
                   idCard:(NSString *)idCard
               idCardPath:(NSString *)idCardPath
                  Success:(SuccessWithObjectBlock)success
                   Failed:(FailedErrorBlock)failed;

/**
 *获取用户信息
 *
 */

+(void)getuserinfoWithuserId:(NSString *)userId  success:(SuccessWithStringBlock)success
                      Failed:(FailedErrorBlock)failed;




/**
 *  登陆
 *
 *  @param mobile   <#mobile description#>
 *  @param password <#password description#>
 *  @param deviceId <#deviceId description#>
 *  @param success  <#success description#>
 *  @param failed   <#failed description#>
 */
+ (void)loginWithMobile:(NSString *)mobile
               Password:(NSString *)password
               deviceId:(NSString *)deviceId
                success:(SuccessWithStringBlock)success
                 Failed:(FailedErrorBlock)failed;
/**
 *  获取发件人常用地址
 */
+(void)getCommonAddressWithUserId:(NSString *)userId
                          success:(SuccessWithArrayBlock)success
                           Failed:(FailedErrorBlock)failed;
/**
 *  获取收件人常用地址
 */
+(void)getCommonAddressToWithUserId:(NSString *)userId
                          success:(SuccessWithArrayBlock)success
                           Failed:(FailedErrorBlock)failed;

/**
 *  添加地址
 */
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
                     Failed:(FailedErrorBlock)failed;
/**
 *  删除地址
 */
+(void)deleteAddressWithAddressId:(NSString *)addressId
                          success:(SuccessWithNSMutableArrayBlock)success
                           Failed:(FailedErrorBlock)failed;
/**
 *  修改快递员
 */
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
                          Failed:(FailedErrorBlock)failed;
/**
 *  默认地址和快递员
 */
+ (void)getDefaultAddressUserId:(NSString *)userId
                        success:(SuccessWithObjectBlock)success
                         Failed:(FailedErrorBlock)failed;
/**
 *  添加快递员
 */
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
                        Failed:(FailedErrorBlock)failed;

/**
 *  快递员列表（废弃）
 */
+(void)getCourierListWithUserId:(NSString *)userId
                        success:(SuccessWithNSMutableArrayBlock)success
                         Failed:(FailedErrorBlock)failed;
/**
 *  第三方登录
 */
+(void)thirdLoginWithOpenId:(NSString *)openId
                accessToken:(NSString *)accessToken
                nickName:(NSString *)nickName
                sex:(NSString *)sex
                headImageUrl:(NSString *)headImageUrl
                unionId:(NSString *)unionId
                success:(SuccessWithObjectBlock)success
                 Failed:(FailedErrorBlock)failed;
///**
// *  第三方登录（新接口0927）
// */
//+(void)newThirdLoginWithOpenId:(NSString *)openId
//                accessToken:(NSString *)accessToken
//                   nickName:(NSString *)nickName
//                        sex:(NSString *)sex
//               headImageUrl:(NSString *)headImageUrl
//                    unionId:(NSString *)unionId
//                    success:(SuccessWithObjectBlock)success
//                        Failed:(FailedErrorBlock)failed;

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
                   Failed:(FailedErrorBlock)failed;

/**
 *  我的快递列表
 */
+(void)getExpListWithUserId:(NSString *)userId
                     pageNo:(int)pageNo
                   pageSize:(NSString *)pageSize
                    success:(SuccessWithNSMutableArrayBlock)success
                     Failed:(FailedErrorBlock)failed;

/*
 *钱包余额
 */

+(void)getWalletBlanceWithUserId:(NSString *)userId
                         Success:(SuccessWithObjectBlock)success
                          Failed:(FailedErrorBlock)failed;


/*
 *钱包历史
 */
+(void)walletHistoryWithuserId:(NSString *)userId  pageNo:(NSString *)pageNo pageSize:(NSString*)pageSize Success:(SuccessWithArrayBlock)success
                        Failed:(FailedErrorBlock)failed;


/*
 *我的优惠券
 */
+(void)getCouponWithuserId:(NSString *)userId
                  pageSize:(NSString *)pageSize
                    pageNo:(NSString *)pageNo
                   Success:(SuccessWithArrayBlock)success
                    Failed:(FailedErrorBlock)failed;


/*
 *积分历史
 */
+(void)getEcoinHistoryWithuserId:(NSString *)userId
                        pageSize:(NSString *)pageSize
                          pageNo:(NSString *)pageNo
                         Success:(SuccessWithArrayBlock)success
                          Failed:(FailedErrorBlock)failed;                        

/**
 *  附近网点
 */
+(void)getNearPointWithLatitude:(NSString *)latitude
                      longitude:(NSString *)longitude
                        Success:(SuccessWithArrayBlock)success
                         Failed:(FailedErrorBlock)failed;
/**
 *  上传照片
 */
+(void)uploadPictureWithUserId:(NSString *)userId
                fileName:(NSString *)fileName
                    file:(id)file
                 Success:(SuccessWithDictionaryBlock)success
                  Failed:(FailedErrorBlock)failed;
/**
 *  忘记密码
 */
+(void)forgetPWDmobile:(NSString *)mobile
           newPassword:(NSString *)newPassword
               success:(SuccessWithStringBlock)success
                Failed:(FailedErrorBlock)failed;
/**
 *  忘记密码发短信
 */
+(void)forgetSMSCodeMobile:(NSString *)mobile
                   success:(SuccessWithStringBlock)success
                    Failed:(FailedErrorBlock)failed;
/**
 *  附近快递员
 */
+(void)getNearCourierListlatitude:(NSString *)latitude
                  longitude:(NSString *)longitude
                   cityCode:(NSString *)cityCode
                    success:(SuccessWithNSMutableArrayBlock)success
                     Failed:(FailedErrorBlock)failed;
/***
 *我的消息
 */
+(void)getMessageWithuserId:(NSString *)userId pageNo:(NSString *)pageNo pageSize:(NSString*)pageSize Success:(SuccessWithArrayBlock)success Failed:(FailedErrorBlock)failed;
/**
 *  我的消息标记为已读
 */
+(void)readMessageWithMessageId:(NSString *)messageId
                        Success:(SuccessVoidBlock)success
                         Failed:(FailedErrorBlock)failed;
/**
 *  删除消息
 */
+ (void)deleteMessageWithMessageId:(NSString *)messageId
                           Success:(SuccessVoidBlock)success
                            Failed:(FailedErrorBlock)failed;
/**
 *  保存单号
 */
+(void)saveExpNoBillCode:(NSString *)billCode
                   expNo:(NSString *)expNo
                 success:(SuccessWithObjectBlock)success
                  Failed:(FailedErrorBlock)failed;
/**
 *  使用余额支付
 */
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
                 Failed:(FailedErrorBlock)failed;
/**
 *  月结
 */
+ (void)payByyuejieBillCode:(NSString *)billCode
                    matName:(NSString *)matName
                    matType:(NSString *)matType
               insuranceFee:(NSString *)insuranceFee
                insureMoney:(NSString *)insureMoney
               needPayMoney:(NSString *)needPayMoney
                  shipMoney:(NSString *)shipMoney
                     weight:(NSString *)weight
                    success:(SuccessWithObjectBlock)success
                     Failed:(FailedErrorBlock)failed;
/**
 *  上传订单
 */
+(void)uploadPayBillCode:(NSString *)billCode
                matName:(NSString *)matName
                matType:(NSString *)matType
                insuranceFee:(NSString *)insuranceFee
                insureMoney:(NSString *)insureMoney
                needPayMoney:(NSString *)needPayMoney
                shipMoney:(NSString *)shipMoney
                  weight:(NSString *)weight
                 success:(SuccessWithObjectBlock)success
                  Failed:(FailedErrorBlock)failed;
/**
 *  使用到付
 */
+(void)arrayPayBillCode:(NSString *)billCode
                matName:(NSString *)matName
                matType:(NSString *)matType
           insuranceFee:(NSString *)insuranceFee
            insureMoney:(NSString *)insureMoney
           needPayMoney:(NSString *)needPayMoney
              shipMoney:(NSString *)shipMoney
                 weight:(NSString *)weight
                success:(SuccessWithObjectBlock)success
                Failed:(FailedErrorBlock)failed;

/**
 *  检查快递券是否可用
 */
+(void)checkOutTicketBillCode:(NSString *)BillCode NeedPayMoney:(NSString *)needPayMoney userCouponId:(NSString *)userCouponId success:(SuccessWithObjectBlock)success
                       Failed:(FailedErrorBlock)failed;

/****
 *我的反馈
***/
+(void)feedbackWithuserId:(NSString *)userId typeId:(NSString *)trpeId content:(NSString *)content Success:(SuccessWithObjectBlock)success
                   Failed:(FailedErrorBlock)failed;
/**
 *  我的收件
 */
+(void)myReciveUserId:(NSString *)userId pageSize:(NSString *)pageSize pageNo:(int)pageNo Success:(SuccessWithNSMutableArrayBlock)success
               Failed:(FailedErrorBlock)failed;
/**
 *  获取版本信息
 */
+(void)getVersionUserId:(NSString *)userId typeId:(NSString *)typeId
                content:(NSString *)content Success:(SuccessWithDictionaryBlock)success
                 Failed:(FailedErrorBlock)failed;
/**
 *  评价
 */
+(void)assWithBusinessId:(NSString *)businessId
               evaTypeId:(NSString *)evaTypeId
                   score:(NSString *)score
              evaContent:(NSString *)evaContent
                 Success:(SuccessWithObjectBlock)success
                  Failed:(FailedErrorBlock)failed;

/**
 *提现
 */
+(void)AliWithdrawCashWithuserId:(NSString *)userId applyMoney:(NSString *)applyMoney aliPayNickName:(NSString *)aliPayNickName aliPayAccount:(NSString *)aliPayAccount

                         Success:(SuccessWithObjectBlock)success
                          Failed:(FailedErrorBlock)failed;

/***
 *可提现余额
 ***/

+(void)GetAliWithdrawMoneyWithuserId:(NSString *)userId   Success:(SuccessWithObjectBlock)success
                              Failed:(FailedErrorBlock)failed;
/*
 *钱包转账
 */
+(void)TransferWithuserId:(NSString *)userId mobileTo:(NSString *)mobileTo tradeMoney:(NSString *)tradeMoney  Success:(SuccessWithObjectBlock)success
Failed:(FailedErrorBlock)failed;

/*
 *获取可转账金额
 */
+(void)getTranfermoneyWithuserId:(NSString *)userId   Success:(SuccessWithObjectBlock)success
                          Failed:(FailedErrorBlock)failed;
/**
 *  默认地址和快递员填充(改)
 */

+ (void)getDefaultAddressUserId:(NSString *)userId cityCode:(NSString *)cityCode latitude:(NSString *)latitude longitude:(NSString *)longitude
                        success:(SuccessWithObjectBlock)success
                         Failed:(FailedErrorBlock)failed;
/**
 *  快递员列表（改）
 */
+(void)getCourierListWithUserId:(NSString *)userId
                       cityCode:(NSString *)cityCode
                       latitude:(NSString *)latitude
                      longitude:(NSString *)longitude
                        success:(SuccessWithNSMutableArrayBlock)success
                         Failed:(FailedErrorBlock)failed;
/**
 *  获取抽奖信息
 */
+(void)getLuckInfoWithUserId:(NSString *)userId
                     success:(SuccessWithObjectBlock)success
                      Failed:(FailedErrorBlock)failed;
/**
 *  抽奖点击请求
 */
+(void)uploadLuckResultWithUserId:(NSString *)userId
                          drawNum:(NSString *)drawNum
                          success:(SuccessWithStringBlock)success
                           Failed:(FailedErrorBlock)failed;
/**
 *  多设备登录 短信授权请求
 */
+(void)loginauthMobile:(NSString *)mobile
               success:(SuccessWithStringBlock)success
                Failed:(FailedErrorBlock)failed;
/**
 *  验证码放在后台验证
 */
+(void)checkloginauthMobile:(NSString *)mobile
                       code:(NSString *)code
                   deviceId:(NSString *)deviceId
                    success:(SuccessWithStringBlock)success
                     Failed:(FailedErrorBlock)failed;

/**
 *  第三方登录绑定手机号
 */
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
                     Failed:(FailedErrorBlock)failed;
/**
 *  获取广告信息
 */
+(void)getAdsWithUserId:(NSString *)userId
                deviceId:(NSString *)deviceId
                success:(SuccessWithObjectBlock)success
                Failed:(FailedErrorBlock)failed;

/**
 *  获取众筹信息
 */
+(void)getCrowdWithUserId:(NSString *)userId
                  success:(SuccessWithObjectBlock)success
                   Failed:(FailedErrorBlock)failed;
/**
 *  获取公司动态
 */
+(void)getCompNewsWithsuccess:(SuccessWithNSMutableArrayBlock)success
                   Failed:(FailedErrorBlock)failed;
/**
 *  请求微信支付参数
 */
+(void)getWXPreWithBillCode:(NSString *)billCode
                    matName:(NSString *)matName
                    matType:(NSString *)matType
                    insuranceFee:(NSString *)insuranceFee
                    insureMoney:(NSString *)insureMoney
                    needPayMoney:(NSString *)needPayMoney
                    shipMoney:(NSString *)shipMoney
                    weight:(NSString *)weight
                    success:(SuccessWithDictionaryBlock)success
                     Failed:(FailedErrorBlock)failed;
/**
 *  支付宝打折
 */
+(void)getAliPayDiscountUserId:(NSString *)userId
                       success:(SuccessWithStringBlock)success
                        Failed:(FailedErrorBlock)failed;
/**
 *  获取微信充值参数
 */
+(void)getRechargePreUserId:(NSString *)userId
              rechargeMoney:(NSString *)rechargeMoney
            recommandMobile:(NSString *)recommandMobile
                    success:(SuccessWithDictionaryBlock)success
                     Failed:(FailedErrorBlock)failed;
/**
 *  查询支付或充值结果
 */
+(void)getPayResultWithBillCode:(NSString *)BillCode
                        success:(SuccessWithDictionaryBlock)success
                         Failed:(FailedErrorBlock)failed;
/**
 *  根据关键字查询网点名称
 */
+(void)searchPointName:(NSString *)Name
              cityCode:(NSString *)cityCode
              latitude:(NSString *)latitude
             longitude:(NSString *)longitude
                 expId:(NSString *)expId
               success:(SuccessWithArrayBlock)success
                Failed:(FailedErrorBlock)failed;
/**
 *  申请快递员认证
 */
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
                  Failed:(FailedErrorBlock)failed;

/**
 * 推广的快递员列表
 */
+(void)getMyunderUserId:(NSString *)userId pageNo:(NSInteger)pageNo pageSize:(NSInteger)pageSize
                Success:(SuccessWithNSMutableArrayBlock)success
                 Failed:(FailedErrorBlock)failed;

/**
 * 我的接单列表
 */
+(void)getExpPickListWithUserId:(NSString *)userId
                         pageNo:(int)pageNo
                       pageSize:(NSString *)pageSize
                        success:(SuccessWithNSMutableArrayBlock)success
                         Failed:(FailedErrorBlock)failed;

/**
 * 我的接单 按日期查询
 */
+(void)getExpPickListByDate:(NSString *)date
                     userId:(NSString *)userId
                    success:(SuccessWithNSMutableArrayBlock)success
                     Failed:(FailedErrorBlock)failed;

/**
 * 我的接单 按日期查询 日收入 日单 周收入 周单 月收入 月单
 */
+(void)getExpDayWeakMonthWithDate:(NSString *)date
                           userId:(NSString *)userId
                          success:(SuccessWithObjectBlock)success Failed:(FailedErrorBlock)failed;
/**
 * 用户保存支付密码
 */
+(void)SavepaypasswordWithuserId:(NSString *)userId payPassword:(NSString *)payPassword deviceId:(NSString *)deviceId success:(SuccessWithStringBlock)success
                          Failed:(FailedErrorBlock)failed;

/**
 * 用户获取每天的充值机会
 */
+(void)getRechargechangeuserId:(NSString *)userId success:(SuccessWithObjectBlock)success Failed:(FailedErrorBlock)failed;

/**
 *  获取提现默认账号
 */
+ (void)getWithDrawDefaultWithUserId:(NSString *)userId
                             success:(SuccessWithDictionaryBlock)success
                              Failed:(FailedErrorBlock)failed;
/**
 *  重置充值提现密码
 */
+ (void)resetPWDWithDrawDefaultWithUserId:(NSString *)userId
                                   idCard:(NSString *)idCard
                              payPassword:(NSString *)payPassword
                             success:(SuccessWithDictionaryBlock)success
                              Failed:(FailedErrorBlock)failed;

/**
 *  一键快递批量上传快递信息
 */
+ (void)uploadExpDetailWithParams:(NSDictionary *)params
                          success:(SuccessWithDictionaryBlock)success
                           Failed:(FailedErrorBlock)failed;

/**
 *  查询每一单的子快递单号
 */
+ (void)getExpNoWithBusinessId:(NSString *)businessId
                          success:(SuccessWithNSMutableArrayBlock)success
                           Failed:(FailedErrorBlock)failed;

#pragma mark --- 顺风快递
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
                             success:(SuccessWithNSMutableArrayBlock)success Failed:(FailedErrorBlock)failed;

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
                              success:(SuccessWithNSMutableArrayBlock)success Failed:(FailedErrorBlock)failed;


/**
 * 上传物品图片
 */
+(void)uploadmatNameWithUserId:(NSString *)userId
                      fileName:(NSString *)fileName
                          file:(id)file
                       Success:(SuccessWithDictionaryBlock)success
                        Failed:(FailedErrorBlock)failed;

/**
 * 用户信用等级
 */
+(void)getuserCreditWithuserId:(NSString *)userId
                       success:(SuccessWithDictionaryBlock)success
                        Failed:(FailedErrorBlock)failed;

/**
 * 快递员补贴政策和评分
 */
+(void)getcouierSorceAndLVWithuserId:(NSString *)userId
                             success:(SuccessWithDictionaryBlock)success
                              Failed:(FailedErrorBlock)failed;

/**
 * 请求用户钱包数据
 */
+(void)getuserwalletDataWithuserId:(NSString *)userId  success:(SuccessWithDictionaryBlock)success
                        Failed:(FailedErrorBlock)failed;

/**
 * 请求快递员钱包数据
 */

+(void)getcourierwalletDataWithuserId:(NSString *)userId success:(SuccessWithDictionaryBlock)success
                               Failed:(FailedErrorBlock)failed;
/**
 * 上传银行卡号
 */
+(void)uploadCreaditCardNoWithUserId:(NSString *)userId
                            bankCard:(NSString *)bankCard
                             success:(SuccessWithDictionaryBlock)success
                              Failed:(FailedErrorBlock)failed;
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
                           Failed:(FailedErrorBlock)failed;

/**
 * 顺风行程列表（用户界面看到的）
 */
+(void)getWindTripListWithuserId:(NSString *)userId
                          pageNo:(NSString *)pageNo
                        pageSize:(NSString*)pageSize
                        sortType:(NSString *)sortType
                         Success:(SuccessWithArrayBlock)success
                          Failed:(FailedErrorBlock)failed;

/**
 * 顺风快递列表展示（镖师界面看到的）
 */
+(void)getWindExpressListWithuserId:(NSString *)userId
                             pageNo:(NSString *)pageNo
                           pageSize:(NSString*)pageSize
                           sortType:(NSString *)sortType
                            Success:(SuccessWithArrayBlock)success
                             Failed:(FailedErrorBlock)failed;


/**
 * 镖师抢单接口
 */
+(void)biaoshiqiangdanWithuserId:(NSString *)userId recId:(NSString *)recId  success:(SuccessWithNSMutableArrayBlock)success
                          Failed:(FailedErrorBlock)failed;

/**
 * （我的顺风）货主所有已支付订单列表
*/
+(void)GetHuozhuTaskWithuserId:(NSString *)userId pageNo:(NSString *)pageNo pageSize:(NSString*)pageSize Success:(SuccessWithArrayBlock)success Failed:(FailedErrorBlock)failed;

/**
 * （限时镖）货主所有已支付订单列表
 */
+(void)GetHuozhuLimitTaskWithuserId:(NSString *)userId pageNo:(NSString *)pageNo pageSize:(NSString*)pageSize Success:(SuccessWithArrayBlock)success Failed:(FailedErrorBlock)failed;

/**
 * （顺风镖）货主所有已支付订单列表
 */
+(void)GetHuozhuShuFengTaskWithuserId:(NSString *)userId pageNo:(NSString *)pageNo pageSize:(NSString*)pageSize Success:(SuccessWithArrayBlock)success Failed:(FailedErrorBlock)failed;


/**
 * （我的顺风）镖师查询所有已抢单订单列表
 */
+(void)GetBiaoShiTaskRouteWithuserId:(NSString *)userId pageNo:(NSString *)pageNo pageSize:(NSString*)pageSize Success:(SuccessWithArrayBlock)success Failed:(FailedErrorBlock)failed;

/**
 * （限时镖）镖师查询所有已抢单订单列表
 */
+(void)GetBiaoShiLimitTaskRouteWithuserId:(NSString *)userId pageNo:(NSString *)pageNo pageSize:(NSString*)pageSize Success:(SuccessWithArrayBlock)success Failed:(FailedErrorBlock)failed;

/**
 * （顺风镖）镖师查询所有已抢单订单列表
 */
+(void)GetBiaoShiShunFengTaskRouteWithuserId:(NSString *)userId pageNo:(NSString *)pageNo pageSize:(NSString*)pageSize Success:(SuccessWithArrayBlock)success Failed:(FailedErrorBlock)failed;

/**
 * 镖师确定取货并给（收件人）发送确认密码
 */
+(void)sendDriverPickpasswordWithrecId:(NSString *)recId Withlat:(NSString *)lat withLon:(NSString *)lon withCarNum:(NSString *)carNumer success:(SuccessWithNSMutableArrayBlock)success
                                Failed:(FailedErrorBlock)failed;

/**
 * 镖师核对交易密码
 */
+(void)ChecktransactionpasswordWithrecId:(NSString *)recId Withlat:(NSString *)lat withLon:(NSString *)lon  dealPassword:(NSString *)dealPassword success:(SuccessWithObjectBlock)success

                                  Failed:(FailedErrorBlock)failed;

/**
 * 用户删除快递订单
 */

+(void)DeleteExpressWithbillCode:(NSString *)billCode  Success:(SuccessVoidBlock)success
                          Failed:(FailedErrorBlock)failed;


/**
 * 顺风镖师取消订单
*/
+(void)refundReimburseWithrecId:(NSString *)recId  success:(SuccessWithNSMutableArrayBlock)success
                         Failed:(FailedErrorBlock)failed;

/**
 * 快递员删除订单请求
 */
+(void)CourierDeleteExpressWithbillCode:(NSString *)billCode  Success:(SuccessVoidBlock)success
                          Failed:(FailedErrorBlock)failed;

/**
 * 获取镖师详细信息
 */
+(void)getdriverdetailWithdriverId:(NSString *)driverId Success:(SuccessWithObjectBlock)success Failed:(FailedErrorBlock)failed;

/**
 * 用户查看镖师的被评价列表信息
 */

+(void)getEvalutionDriverEvaLuteWithDriverId:(NSString *)driverId pageNo:(NSString *)pageNo pageSize:(NSString*)pageSize  Success:(SuccessWithArrayBlock)success Failed:(FailedErrorBlock)failed;


/**
 * 获取快递员可抢单列表
 */
+(void)getnearlyExpressListWithlatitude:(NSString *)latitude longitude:(NSString *)longitude cityCode:(NSString *)cityCode pageNo:(NSString *)pageNo pageSize:(NSString*)pageSize  Success:(SuccessWithArrayBlock)success Failed:(FailedErrorBlock)failed;

/**
 * 快递员抢单
 */

+(void)CourierQiangdanWithuserId:(NSString *)userId businessId:(NSString *)businessId  success:(SuccessWithNSMutableArrayBlock)success
                          Failed:(FailedErrorBlock)failed;


/**
 * 用户取消顺风订单
 */
+(void)cancelDownWindtaskWithrecId:(NSString *)recId  success:(SuccessWithNSMutableArrayBlock)success
                         Failed:(FailedErrorBlock)failed;


/**
 * 人人代理推广人数
 */
+(void)getPerAgentCountWithUserId:(NSString *)userId  success:(SuccessWithStringBlock)success
                            Failed:(FailedErrorBlock)failed;


/**
 * 获取用户钱包余额
 */
+(void)getUserBalanceWithUserId:(NSString *)userId  success:(SuccessWithStringBlock)success
                           Failed:(FailedErrorBlock)failed;

/**
 * 检测版本更新
 */
+(void)getUserAppVersionWithUserID:(NSString *)userId success:(SuccessWithStringBlock)success Failed:(FailedErrorBlock)failed;

/**
 * 获取新手机号验证码
 */
+(void)getNewMobileCode:(NSString *)newMobile
               success:(SuccessWithStringBlock)success
                Failed:(FailedErrorBlock)failed;
/**
 * 修改为新手机号
 */
+(void)changeNewMobileWithUserId:(NSString *)userId oldPassword:(NSString *)oldPassword mobile:(NSString *)mobile newMobile:(NSString *)newMobile idCode:(NSString *)idCode success:(SuccessWithStringBlock)success Failed:(FailedErrorBlock)failed;
/**
 *获取优惠信息广告图片和链接
 */
//+




@end
