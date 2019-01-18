//
//  MD5Util.m
//  EasyPay
//
//  Created by 刘欣 on 15/5/12.
//  Copyright (c) 2015年 刘欣. All rights reserved.
//

#import "MD5Utils.h"
#import <CommonCrypto/CommonDigest.h>
#import "DesUtils.h"

@implementation MD5Utils

 +(NSString*) md5:(NSString*)value AndKey:(NSString*)key{
     CC_MD5_CTX md5;
     CC_MD5_CTX md51;
     CC_MD5_Init(&md5);
     CC_MD5_Init(&md51);
     
     int length = 64;
     
     const char* keybytes = [key UTF8String];
     const char* valueStr = [value UTF8String];
     
     NSString* key1Str = @"";
     NSString* key2Str = @"";

     for (int i = 0; i < 64; i++) {
         if (i < strlen(keybytes)) {
             
             key1Str = [key1Str stringByAppendingString:@"00"];
             key2Str = [key2Str stringByAppendingString:@"00"];

             continue;
         }
         
         
         key1Str = [key1Str stringByAppendingString:@"36"];
         key2Str = [key2Str stringByAppendingString:@"5c"];

     }
     
     SignedByte key1bytes[length];
     for (int i=0; i<length;i++) {
         int j=i*2;
         NSString *tmp=[key1Str substringWithRange:NSMakeRange(j, 2)];
         unsigned int anInt;
         NSScanner * scanner = [[NSScanner alloc] initWithString:tmp];
         [scanner scanHexInt:&anInt];
         key1bytes[i]=anInt;
     }
     
     SignedByte key2bytes[length];

     for (int i=0; i<length;i++) {
         int j=i*2;
         NSString *tmp=[key2Str substringWithRange:NSMakeRange(j, 2)];
         unsigned int anInt;
         NSScanner * scanner = [[NSScanner alloc] initWithString:tmp];
         [scanner scanHexInt:&anInt];
         key2bytes[i]=anInt;
     }
     
     for (int i = 0; i < strlen(keybytes); i++) {
         key1bytes[i] = (Byte)(keybytes[i] ^ 0x36);
         key2bytes[i] = (Byte)(keybytes[i] ^ 0x5C);
	    }
     
     CC_MD5_Update(&md5, key1bytes, (CC_LONG)sizeof(key1bytes));
     CC_MD5_Update(&md5, valueStr, (CC_LONG)strlen(valueStr));
 
     unsigned char digest[CC_MD5_DIGEST_LENGTH];
     unsigned char digest1[CC_MD5_DIGEST_LENGTH];
     CC_MD5_Final(digest, &md5);
     
     //第二次加密
     CC_MD5_Update(&md51, key2bytes, (CC_LONG)sizeof(key2bytes));
     CC_MD5_Update(&md51, digest, 16);
     CC_MD5_Final(digest1, &md51);
     
     NSString* md51Str = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                         digest1[0], digest1[1],
                         digest1[2], digest1[3],
                         digest1[4], digest1[5],
                         digest1[6], digest1[7],
                         digest1[8], digest1[9],
                         digest1[10], digest1[11],
                         digest1[12], digest1[13],
                         digest1[14], digest1[15]];

     return md51Str;
 }

@end
