//
//  desuntil.h
//
//  Created by 刘欣 on 15-6-5.
//  Copyright (c) 2015年 刘欣. All rights reserved.
//

#import "DesUtils.h"
#import <CommonCrypto/CommonDigest.h>

@implementation DesUtils

+ (NSString *) encryptStr:(NSString *) str keys:(NSString*)_key
{
	return [DesUtils doCipher:str key:_key context:kCCEncrypt].uppercaseString;
}
+ (NSString *) decryptStr:(NSString	*) str keys:(NSString*)_key
{
	return [DesUtils doCipher:str key:_key context:kCCDecrypt];
}
+ (NSString *)doCipher:(NSString *)sTextIn key:(NSString *)sKey
			   context:(CCOperation)encryptOrDecrypt {
    NSStringEncoding EnC = NSUTF8StringEncoding;
	
    NSData * dTextIn = nil;
    if (encryptOrDecrypt == kCCDecrypt) {    
        //16进制字符串转16进制data
        dTextIn = [DesUtils getByte16FromString:sTextIn length:[sTextIn length]/2];
    }
    else{
        
        //字符串编码成data
        dTextIn = [sTextIn dataUsingEncoding:EnC];
        //字符串data转为16进制字符串
        sTextIn = [DesUtils hexStringFromString:dTextIn];
        
        //补位  不足8的整数位的以0补足8的整数位
        int tLengh = (int)(sTextIn.length*sizeof(unsigned char)+7)/8*8;
        int inLen = tLengh - (int)sTextIn.length/2;
        for (int i = 0; i < inLen; i++) {
            sTextIn = [NSString stringWithFormat:@"%@00",sTextIn];
        }
       
        //16进制字符串转16进制data
        dTextIn = [DesUtils getByte16FromString:sTextIn length:[sTextIn length]/2];
    }
    NSData * dKey = [DesUtils getByte16FromString:sKey length:[sKey length]/2];
    
    uint8_t *bufferPtr1 = NULL;
    size_t bufferPtrSize1 = 0;    
    size_t movedBytes1 = 0;
    //uint8_t iv[kCCBlockSizeDES];
	//memset((void *) iv, 0x0, (size_t) sizeof(iv));
	Byte iv[] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
    bufferPtrSize1 = ([sTextIn length] + kCCKeySizeDES) & ~(kCCKeySizeDES -1);
    bufferPtr1 = malloc(bufferPtrSize1 * sizeof(uint8_t));
    memset((void *)bufferPtr1, 0x00, bufferPtrSize1);
    
	CCCrypt(encryptOrDecrypt, // CCOperation op    
			kCCAlgorithmDES, // CCAlgorithm alg    
			0x0000, // CCOptions options
			[dKey bytes],//[dKey bytes], // const void *key
			kCCKeySizeDES,//[dKey length], // size_t keyLength
			iv, // const void *iv    
			[dTextIn bytes],//[dTextIn bytes], // const void *dataIn
			[dTextIn length],//[dTextIn length],  // size_t dataInLength
			(void *)bufferPtr1, // void *dataOut    
			bufferPtrSize1,     // size_t dataOutAvailable 
			&movedBytes1);      // size_t *dataOutMoved    
    
	
    NSString * sResult = nil;
    if (encryptOrDecrypt == kCCDecrypt){
        NSData* d = [NSData dataWithBytes:bufferPtr1
                                   length:movedBytes1];
        //因为加密补位了，解密要把补的位去掉
        NSString* r = [[DesUtils dataToHexString:d] stringByReplacingOccurrencesOfString:@"00" withString:@""];

        sResult = [DesUtils stringFromHexString:r];

    }
    else {
        
        NSData *dResult = [NSData dataWithBytes:bufferPtr1 length:movedBytes1];
        
        sResult = [DesUtils hexStringFromString:dResult];
    }
    return sResult;
}

//字符串data转16进制字符串
+ (NSString *)hexStringFromString:(NSData *)myD{
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
        
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr]; 
    } 
    return hexStr; 
}

+ (NSData *) stringToHexData:(NSString*)str
{
    NSInteger len = [str length] / 2;    // Target length
    unsigned char *buf = malloc(len);
    unsigned char *whole_byte = buf;
    char byte_chars[3] = {'\0','\0','\0'};
    
    int i;
    for (i=0; i < [str length] / 2; i++) {
        byte_chars[0] = [str characterAtIndex:i*2];
        byte_chars[1] = [str characterAtIndex:i*2+1];
        *whole_byte = strtol(byte_chars, NULL, 16);
        whole_byte++;
    }
    
    NSData *data = [NSData dataWithBytes:buf length:len];
    free( buf );
    
    return data;

}

// 十六进制转换为普通字符串的。
+ (NSString *)stringFromHexString:(NSString *)hexString { //
    
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    
    return unicodeString;
}

//16进制字符串转16进制数组
+ (NSData *)getByte16FromString:(NSString *)str length:(NSInteger)length{

    SignedByte bytes[length];
    for (int i=0; i<length;i++) {
    int j=i*2;
    NSString *tmp=[str substringWithRange:NSMakeRange(j, 2)];
    unsigned int anInt;
    NSScanner * scanner = [[NSScanner alloc] initWithString:tmp];
    [scanner scanHexInt:&anInt];
    bytes[i]=anInt;
    }
    return [NSData dataWithBytes:bytes length:length];
}

+ (NSString *) dataToHexString:(NSData*)d
{
    NSUInteger          len = [d length];
    char *              chars = (char *)[d bytes];
    NSMutableString *   hexString = [[NSMutableString alloc] init];
    
    for(NSUInteger i = 0; i < len; i++ )
        [hexString appendString:[NSString stringWithFormat:@"%0.2hhx", chars[i]]];
    
    return hexString;
}

@end
