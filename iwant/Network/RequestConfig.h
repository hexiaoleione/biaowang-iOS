//
//  RequestConfig.h
//  Express
//
//  Created by 张宾 on 15/7/15.
//  Copyright (c) 2015年 SCHT. All rights reserved.
//

//#define  BaseUrl @"http://192.168.0.104:8080/appservice/webapi/" //周爽
//#define  BaseUrl @"http://192.168.0.105:8080/appservice/webapi/"   //张旭
//#define  BaseUrl @"http://192.168.0.188:8080/appservice/webapi/"    //志强
//#define BaseUrl @"http://116.90.87.32:/8888/appservice/webapi/" //新环境
//线上库
#define  BaseUrl @"http://www.efamax.com:8888/appservice-1.0-SNAPSHOT/webapi/"

#define URLWithMethod(aMethod) [NSString stringWithFormat:@"%@%@",BaseUrl,aMethod]
//#define URLWithMethod(aMethod) [NSString stringWithFormat:@"%@/Exp/ui!%@.action",BaseUrl,aMethod]

#pragma mark **********************************************
#pragma mark -- iwant 接口
#define k_POST                                    100//新增
#define k_GET                                     101//查询
#define k_PUT                                     102//更新
#define k_DELETE                                  103//删除

#define PUBLISH_SUCCESS                         @"publishSuccess"
#define API_USERS                               @"users/register"//注册
#define API_SMSCODE                             @"sms/smscode"//获取验证码
#define API_SMSCODENEW                          @"sms/smscodeSend" //注册获取验证码新
#define API_NEWSMSCODE                          @"sms/newMobileCode"//获取新手机号的验证码
#define API_CHANGENUM                           @"users/modifyMobile" //修改为新手机号
#define API_COM_GETPAYRESULT                    @"moneyinlog/findPayResultAndUserId" //（物流）公司端查询支付结果
#define API_USERINFO                            [NSString stringWithFormat:@"users/%@",[UserManager getDefaultUser].userId]//完善信息 users/userid
#define API_ACTIVITY_RULE                       @"activity/validRulesNew"   //新的活动列表
#define API_USERINFONEW                         @"users/realUser"//实名认证
#define API_SF_TOUBAO_FEILU                     @"downwind/task/dowInsurance" //顺风模块投保费率
#define API_WL_TOUBAO_FEILU                     @"logistics/task/logInsurance"  //物流模块投保费率
#define API_WL_CARNUMLIST                       @"logistics/task/carNumber"//获取车牌照号列表logistics/task/carNumber
#define API_WL_DELETECARNUM                     @"logistics/task/deleteCarNum"// 删除车牌号

#define API_USER_LOGIN                          @"users/userLogin"
#define API_GETUSERINFO                         @"users/user"
#define API_USERS_PAYPASSWORD                   @"users/paypassword"
#define API_COM_ADDRESS                         @"address/list"
#define API_COM_ADDRESS_TO                      @"address/list/receiver"
#define API_ADD_ADDRESS                         @"address"
#define API_MY_COURIER                          @"mycourier"
#define API_MY_COURIER_LIST                     @"mycourier/list"
#define API_THIRD_LOGIN                         @"users/thirdLogin"
#define API_THIRD_LOGIN_NEW                     @"users/weChatLogin"
#define API_EXPRESS                             @"express"
#define API_EXPRESS_LIST                        @"express/list"
#define API_Wallet_LIST                         @"wallet/list"
#define API_Wallet_BALANCE                      @"balance"
#define API_COUPON_LIST                         @"coupon/list"
#define API_Ecoin_LIST                          @"ecoin/list"
#define API_DEFAULT_ADDERSS                     @"express/default"
#define API_NEER_POINT                          @"mappoint/nearby"
#define API_FILE_UPLOAD                         @"file/idcard"
#define API_FORGET_PWD                          @"users/userPwd"
#define API_FORGET_SMS                          @"sms/forgetcode"
#define API_NEAR_COURIER                        @"nearbyCourier/list"
#define API_GetMessage_LIST                     @"system/list"
#define API_GET_UNREAD_MSG                      @"system/getUnReadSysMsg"//未读消息数
#define API_SAVE_EXPNO                          @"express/expno"
#define API_PAY_BLANCE                          @"express/pay/balance"
#define API_PAY_MOUNTH                          @"express/pay/month"
#define API_UPLOAD_PAY                          @"express/payparams"
#define API_ARRIVE_PAY                          @"express/pay/arrived"
#define API_COUPON_CHECK                        @"coupon/check"
#define API_FEEDBACK                            @"feedback"
#define API_MY_RECIVE                           @"express/list/receive"
#define API_VERSION                             @"version"
#define API_EVA                                 @"evaluation"
#define API_WITHDRAW                            @"withdraw"
#define API_WITHDRAW_MYLEFT                     @"withdraw/myLeft"

#define API_tranfermoney                        @"tranfermoney"
#define API_tranfermoney_MYLEFT                 @"tranfermoney/myLeft"
#define API_ADD_REMOVE                          @"address/remove"
#define API_SYS_DELE                            @"system/delete"
#define API_SYS_DELE_ALL                        @"system/deleteAll"
#define API_EXPRESS_DELETE                      @"express/delete"
#define API_COURIEREXPRESS_DELETE               @"express/delete/courier"
#define API_SYS_READ                            @"system/read"
#define API_LUCK_INFO                           @"luckydraw/daily"
#define API_DRAW_NUM                            @"luckydraw/draw"
#define API_LOG_AUTH                            @"sms/loginauth"
#define API_CHECK_LOG                           @"sms/checkloginauth"
#define API_THIRD_CHECK                         @"users/thirdloginbinding"
#define API_ADVERTISE                           @"advertise"
#define API_CROWD                               @"crowdfunding/info"
#define API_COMPANY_NEWS                        @"companynews"
#define A_WXPAY                                 @"express/pay/wechat/pre"
#define A_DISCOUNT                              @"alipay/discount"
#define API_WX_PER                              @"wechat/recharge/pre"
#define API_PAY_RESULT                          @"moneyinlog/result"
#define API_MAPPOINT                            @"mappoint/keyword"
#define API_COURIER_AUTH                        @"users/authenticate/courier" //快递员认证
#define API_MY_UNDER                            @"users/perAgentUserList"//推广的收入
#define API_EXP_PICK_LIST                       @"express/mypickup"
#define API_EXP_PICK_DATE                       @"express/mypickbydate"
#define API_EXP_DAY_WEAK                        @"income/express/dayweekmonth"
#define API_RECHANGE_CHANCE                     @"recharge/chance"
#define API_WITH_DRAW                           @"withdraw/default"
#define API_CREDIT_USERCREDIT                   @"credit/userCredit"
#define API_USERS_COURIERSCOREANDLV             @"users/courierScoreAndLV"
#define API_USER_BALANCE_WALLETINFO             @"user/balance/walletinfo"
//顺风专递
#define API_PUBLISH_WIND_TASK                    @"downwind/task/publish"
#define API_PUBLISH_TASK                         @"downwind/task/publishTask"//限时发布加保险逻辑的限时
//顺风新街口
#define API_PUBLISH_SF_TASK                      @"downwind/task/publishTaskNew"  //顺风接口
#define API_PUBLISH_LimitTime                    @"downwind/task/driverFindLimitDowWind"
#define API_GETPRICE_BYType                      @"downwind/task/getPriceByType"   //智能推荐
#define API_FILE_DOWNWIND                        @"file/downwind"//上传物品图片
#define API_RESET_PWD                            @"users/resetpaypassword"
#define API_UPLOAD_EXP_DETAIL                   @"express/payparams/v2"
#define API_GET_EXP_NO                          @"express/list/childexp"
#define A_WXPAY_CHANGE                          @"express/pay/wechat/pre/v2"
#define API_CARA_AUTH                           @"users/authenticate/caravanguardauthenticate"
#define API_DRIVER_DRIVERROUTELIST              @"driver/driverRouteList"

#define API_DOWNWIND_TASK_DOWNWINDTASK          @"downwind/task/downwindTask"
#define API_DOWNWIND_TASK_DRIVERFIND_DOWNWINDTASK   @"downwind/task/driverFindDownwindTask"

#define API_DOWNWIND_TASK_ROBORDER            @"downwind/task/robOrder"

#define API_express_grabExpress               @"express/grabExpress"
#define API_DRIVER_TAKEReplayMoney            @"driver/tackReplayMoney" //我已收款  代收款
#define API_DOWNWIND_TASK_ONREADY             @"downwind/task/onReady"//我已就位
#define API_DOWNWIND_DRIVER_REMOVEDOW         @"driver/removeDow"//货物违规按钮//路径driver/removeDow
#define API_DOWNWIND_FEEDBACK_ACCUSATION      @"feedback/accusation"  //用户投诉//路径 feedback/accusation
#define API_DRIVER_CUSTOMERCHOOSE              @"driver/customerChoose" //货物违规后用户选择同意或不同意
#define API_DRIVER_CANCEL                     @"driver/diverCance"   //镖师取消新接口

#define API_DOWNWIND_TASK_GETTASK             @"downwind/task/getTask"
#define API_DOWNWIND_TASK_GETTASKBYTYPE       @"downwind/task/getTaskByType" //用户查看限时 顺风
#define API_DRIVER_DOWNWINDTASKROUTELIST      @"driver/downwindTaskRouteList"
#define API_DRIVER_DOWNWINDTASKROUTELISTTYPE  @"driver/downwindTaskRouteListType"//镖师查看接的限时 顺风
#define API_DRIVER_DRIVERISTAKE                @"driver/driverIsTake"
#define API_DRIVER_DRIVERTRUETAKE              @"driver/driverTrueTake"
#define API_DRIVER_REFUNDREIMBURSE             @"driver/refundReimburse"   //镖师取消
#define API_EVALUTION_DRIVEREVALUATE           @"evaluation/driverEvaluate"

#define API_DRIVER_DRIVERDETAIL                @"driver/driverDetail"
#define API_ADD_EVALUATE                       @"evaluation/addEvaluateToDriver"
#define API_DRIVER_ROUT                        @"driver/driverRouteToOne"
#define API_DRIVER_BREAK                       @"driver/backOfDriverRoute"
#define API_SEND_EXPRESS                       @"express/newExpress"
#define API_express_expressList                @"express/expressList"
#define API_UPLOAD_HEAD                        @"file/head"//上传头像
#define API_COURIER_CHECK                      @"check/addCheckInfo"
#define API_CANCELDOWNWINDTASK                 @"downwind/task/cancelDownwindtask"  //用户取消发布
#define API_LOCAT_UPLOAD                       @"location/upload"
#define API_LOCAT_NEARBY                       @"location/nearby"//获取附近镖师、快递员
#define API_LOCAT_LATEST                       @"location/latest"//获取司机或快递员最新经纬度
#define API_LOCATION_LIST                      @"driver/driverRoutePath"//获取镖师轨迹点经纬度
#define LBAPI_PERAGENT_COUNT                   @"users/perAgentCount"//人人代理推广人数

#define API_WL_HUOCHANG_LIST                    @"logistics/task/logComAddList"//获取货场地址列表
#define API_WL_HUOCHANG_ADD                     @"logistics/task/addComAdd"//添加货场地址
#define API_WL_HUOCHANG_DELECT                  @"logistics/task/updateComAdd"//修改、删除，设置为默认货场地址
#define API_WL_HUOCHANG_DEFAULT                 @"logistics/task/defaultComAdd"//获取默认货场地址
#define API_WL_AddInsurance                     @"logistics/task/logAddInsurance"//添加货物价值(投保需要做的操作)

#pragma mark -- iwant 参数

#define APP_VERSION                              @"version"

#define ARG_DATA                                 @"data"
#define ARG_MSG                                  @"message"
#define ARG_ERR                                  @"errCode"

#define ARG_IDFV                                 @"IDVF"
#define ARG_SAVED_IDFV                           [KeyChain load:ARG_IDFV]  
#define ARG_ID_PATH                              @"idCardPath"
#define ARG_CITY_NAME                            @"cityName"
#define ARG_PERSON_NAME                          @"personName"
#define ARG_PERSON_NAME_TO                       @"personNameTo"
#define ARG_AREA_NAME                            @"areaName"
#define ARG_AREA_NAME_TO                         @"areaNameTo"
#define ARG_ADDRESS_TO                           @"addressTo"
#define ARG_LAT                                  @"latitude"
#define ARG_LON                                  @"longitude"
#define ARG_IFDE                                 @"ifDefault"
#define ARG_USER_MOBILE                          @"userMobile"
#define ARG_COURIER_NAME                         @"courierName"
#define ARG_COURIER_MOBILE                       @"courierMobile"
#define A_POINT_ID                               @"pointId"
#define ARG_EXP_ID                               @"expId"
#define ARG_EXP_NAME                             @"expName"
#define ARG_COUR_NO                              @"courierNumber"
#define ARG_OPEN_ID                              @"openId"
#define ARG_ACCESS_TOKEN                         @"accessToken"
#define ARG_NIKE_NAME                            @"nickName"
#define ARG_HEADIMG_URL                          @"headImageUrl"
#define ARG_UNIONID                              @"unionId"
#define ARG_MOBILE_TO                            @"mobileTo"
#define ARG_REC_Mobile                           @"recommendMobile"

#define A_FROM_TOWN                              @"fromTown"
#define A_FROM_CITY                              @"fromCity"
#define A_FROM_CITY_NAME                         @"fromCityName"
#define A_TO_CITY                                @"toCity"
#define A_TO_CITY_NAME                           @"toCityName"   
#define A_ASSIGNED                               @"assigned"//指定类型 N-未指定(抢单) U-用户指定 P-网点指定
#define A_NEW_PWD                                @"newPassword"
#define A_BILL_CODE                              @"billCode"
#define A_EXP_NO                                 @"expNo"
#define A_MAT_NAME                               @"matName"
#define A_MAT_TYPE                               @"matType"
#define A_NEED_PAY                               @"needPayMoney"
#define A_SHIP                                   @"shipMoney"
#define A_USER_COP                               @"userCouponName"
#define A_SCORE                                  @"score"
#define A_EVALUE                                 @"evaContent"
#define A_EVA_TYPE                               @"evaTypeId"
#define A_MSG_ID                                 @"messageId"
#define A_DRAW_NUM                               @"drawNum"
#define A_RECHARGE_MONEY                         @"rechargeMoney"//充值金额
#define A_RECOMMAND_MOBILE                       @"recommandMobile"//推荐人手机号
#define A_NAME                                   @"name"//检索关键字
#define A_POINT_NAME                             @"pointName"//网点名称
#define A_POINT_NO                               @"pointNumber"//快递员审核时上传的网点id
#define A_POINT_PHONE                            @"pointPhone"//网点座机
#define A_BANK_CARD_NO                           @"bankCard"//银行卡号
#define API_DRIVER_DRIVEROUTE                    @"driver/driverRoute"
#define A_CHECK_NAME                           @"checkName"//待审核名称
#define A_CHECK_IDCARD                         @"checkIdCard"//待审核身份证
#define A_CHECK_PATH                           @"chenkPath"//待审核路径
#define A_CHECK_TYPE                            @"checkType"//认证类型 1-快递员 2-镖师

#pragma mark *********************************************
/**********Method********/
//***客户端 ReqMethodForUser

//接口名字
//getCourierListByUser

#define M_saveDailyDraw             @"saveDailyDraw"//每日抽奖
#define M_dalyDraw                  @"dailyDraw"//每日抽奖
#define M_updatePayPrepared         @"updatePayPrepared"//货到付款
#define M_updatePayAgreement        @"updatePayAgreement"//月结支付接口
#define M_FINISH_LiSTUSER         @"getCourierListByUser"//快递员列表
//addMyCourier
#define M_FINISH_ADDMYCOURIER         @"addMyCourier"//填加快递员


#define M_FINISH_WEIXIN          @"doWeiXinRequest"//获取服务器签名prepayid（微信）
#define M_DO_WEIXINPAY           @"doWeiXin"//获取服务器支付状态（微信）
#define M_WEIXINPAY              @"weixinPayResult"//上传给服务器微信支付结果
#define M_GETSYSTEMMSG           @"getSystemMsg"  //系统消息
#define M_REGIST            @"regist"           //1.	注册
#define M_USER_INFO         @"userInfo"          //2.	获取个人信息
#define M_SAVE_USER_INFO    @"saveUserInfo"    //3.	完善个人信息
#define M_MODIFY_EMAIL      @"modifyEmail"        //4.	修改邮箱
#define M_LOGIN             @"login"              //5.	登录
#define M_ECOIN             @"ecoin"              //7.	获取积分
#define M_SAVE_BUSINESS     @"saveBusiness"       //8.	保存和发布快递信息
#define M_MY_PACKAGE        @"myPackage"          //9.	我的快递信息
#define M_MY_ADDRESS        @"myAddress"          //10.	获取常用地址信息
#define M_SAVE_MY_ADDRESS   @"saveMyAddress"      //11.	保存地址信息
#define M_DELETE_MY_ADDRESS   @"deleteMyAddress"     //12.	删除地址信息
#define M_COURIER_POSITION   @"getNearbyCouriers"    //17.	获取快递员地址
#define M_FEEDBACK            @"feedBack"               //意见反馈
#define M_MODIFY_PASSWORD      @"modifyPassword"        //修改密码
#define M_FORGOT_PASSRORD      @"forgetPassword"        //忘记密码

#define M_DELETE_MY_BUSINESS    @"deleteMyBusiness" //14.	删除未发布快递订单


#define M_DELETE_BUSINESS    @"userDelete" //zw	删除已完成快递订单




#define M_UN_DELETE_MY_BUSINESS  @"unDeleteMyBusiness" //15.	还原删除的快递订单
#define M_UN_PUBLIST_MY_BUSINESS @"unPublishedMyBusiness" //16.	取消发布快递订单：
#define M_SENDFORGETPASSWORDSMS  @"sendForgetPasswordSms" //发送忘记密码验证短信

#define M_RESETPASSWORD  @"resetPassword" //重置密码
#define M_SAVE_EVALUTION  @"saveEvalution" //评价
#define M_PAY_OFFLINE   @"payOffline" //线下支付
#define M_CHECKSMSCODE  @"checkSmsCode"
#define M_GET_EVALUTION  @"getEvalution"
#define M_SAVE_PLAN_EINISH_DATE @"savePlanFinishDate"
#define M_FINISH    @"finish"

#define M_GET_ECOIN_HIS         @"getEcoinHis"
//***通用接口


//收件箱的接口
#define M_MESSAGE_ACTION  @"getMessageList"    //1.	收件箱

//savePlanFinishDate
#define M_SAVE_PLANFIN  @"savePlanFinishDate"    //	延期订单

//finish
#define M_FINISH_PLANFIN  @"finish"    //	收件人 确认订单

//getMyPublish

#define M_FINISH_GETMYPUBLISH  @"getMyPublish"    //	我的发布

#define M_FINISH_GETBUSINESS @"getBusinessById"    //	



#define M_MOBILE_CHECK  @"mobileCheck"    //1.	发送短信校验码
#define M_UPLOAD        @"upload"         //2.	上传文件
#define M_PROV_LIST     @"provList"       //3.	获取省份列表
#define M_CITY_LIST     @"cityList"       //4.	获取地市列表
#define M_DOWNLOAD      @"download"       //5.	获取文件或图片
#define M_MODIFY_MOBILE @"modifyMobile"   //修改绑定手机

/**********Method********/

/**********参数key，value*****/


#define k_PAGE_NO       @"pageNo"
#define k_PAGE_SIZE      @"pageSize"




#define k_DAYS_ID       @"days"
#define k_TOTAL_FEE     @"total_fee" //微信支付总额
#define k_OUT_TRADE_NO  @"out_trade_no"//微信支付快递单号
#define k_USER_ID       @"userId"
#define K_ID @"id"

/*月结参数*/
#define K_weight @"weight"
#define K_counts @"counts"
#define K_money @"money"//运费
#define K_insureMoney @"insureMoney"//保价
#define K_payPrepared @"payPrepared"
#define K_insuranceFee @"insuranceFee"//保额
#define K_pointPhone @"pointPhone"


//courierId
#define k_PUBLISH_DEVICE_ID   @"publshDeviceId"  //发布者deviceID
#define k_COURIER_ID       @"courierId"
#define k_DEVICE_ID     @"deviceId"
#define k_FILE_NAME     @"fileName"
#define k_MOBILE        @"mobile"
#define k_FILE_ID       @"fileId"
#define k_PROV_CODE     @"provCode"
#define k_SMS_CODE      @"smsCode"
#define k_EMAIL         @"email"
#define k_PASSWORD      @"password"
#define k_PAYPASSWORD      @"payPassword"
#define k_INVITE_ID     @"inviteId"
#define k_BIRTHDAY      @"birthday"
#define k_HEAD_ID       @"headId"
#define k_USER_NAME     @"userName"
#define k_ID_CARD       @"idCard"
#define k_ID_CARD_FILE_ID @"idCardFileId"
#define k_STATUS        @"status"
#define k_PAGE          @"page"
#define k_DATE          @"dt"
#define k_ORIENT        @"orient"
#define k_PAGE_SIEZ     @"pageSize"
#define k_ADDRESS_ID    @"addressId"
#define k_ADDRESS_TAG   @"addressTag"
#define k_CITY_CODE     @"cityCode"
#define k_TOWN_CODE     @"townCode"
#define k_ADDRESS       @"address"
#define k_DEFAULT_ADDRESS @"defaultAddress"
#define k_COURIER_TYPE   @"expType"
#define k_COURIER_CODE   @"cityCode"
#define k_COURIER_LAT    @"latitude"
#define k_COURIER_LON    @"longitude"
#define k_CONTENT       @"content"
#define k_OLDOASSWORD   @"oldPassword"
#define k_BUSINESS_ID   @"businessId"
#define k_USER_TYPE     @"userType"
#define k_ADDRESS_TYPE  @"addressType"
#define k_USEROLE_TYPE @"userType"
#define K_TYPEID @"typeId"
#define K_CONTENT @"content"
#define K_DRIVERID @"driverId"
#define K_applyMoney @"applyMoney"
#define K_aliPayNickName @"aliPayNickName"
#define K_aliPayAccount @"aliPayAccount"
#define K_mobileTo @"mobileTo"
#define K_tradeMoney @"tradeMoney"
#define K_fromLatitude @"fromLatitude"
#define K_fromLongitude @"fromLongitude"
#define K_cityCodeTo @"cityCodeTo"
#define K_toLatitude @"toLatitude"
#define K_toLongitude @"toLongitude"
#define K_matImageUrl @"matImageUrl"
#define K_matRemark @"matRemark"
#define K_addressTo @"addressTo"
#define K_matName @"matName"
#define K_matWeight @"matWeight"
#define K_leaveTime @"leaveTime"
#define K_transportationId @"transportationId"
#define K_remark @"remark"
#define K_recId @"recId"
#define K_dealPassword @"dealPassword"

//缺少发快递相关参数key

#define TIME_OUT_INTER 60

//#define S_NETWORK_UNABLE @"网络连接失败！"
//#define S_SERVER_FAILURE @"连接服务器错误！"

#define S_NETWORK_UNABLE @"当前网络不给力！请更换网络"
#define S_SERVER_FAILURE @"当前网络不给力！请更换网络"


