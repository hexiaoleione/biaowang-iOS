//
//  desuntil.h
//
//  Created by 刘欣 on 15-6-5.
//  Copyright (c) 2015年 刘欣. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h> 
@interface DesUtils : NSObject

+ (NSString *) doCipher:(NSString *)sTextIn key:(NSString *)sKey context:(CCOperation)encryptOrDecrypt;
+ (NSString *) encryptStr:(NSString *) str keys:(NSString*)_key;
+ (NSString *) decryptStr:(NSString	*) str keys:(NSString*)_key;

+ (NSString *)hexStringFromString:(NSData *)myD;

+ (NSData *) stringToHexData:(NSString*)str;

+ (NSString *)stringFromHexString:(NSString *)hexString;

//16进制字符串转16进制数组
+ (NSData *)getByte16FromString:(NSString *)str length:(NSInteger)length;

@end
