//
//  NSStringAdditionsm
//  ADFramework
//
//  Created by DuZexu on 12-11-30.
//  Copyright (c) 2012 DuZexu. All rights reserved.
//

#import "NSStringAdditions.h"
#import <CommonCrypto/CommonDigest.h>

#define APPID  @"1031426530"
@implementation NSString (Additions)

- (NSString*)MD5 {
    const char *cStr = [self UTF8String];
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(cStr, (int)self.length, md5Buffer);
    
    // Convert unsigned char buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
}

- (BOOL)isUpdate:(NSString *)version {
    NSString *v = [version stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSString *v_ = [self stringByReplacingOccurrencesOfString:@"." withString:@""];
    while (v.length != v_.length) {
        v.length > v_.length ? (v_=[v_ stringByAppendingString:@"0"]) : (v=[v stringByAppendingString:@"0"]);
    }
    return [v integerValue]>[v_ integerValue];
}

- (UIImage *)imagePath {
    if (!self.isEmpty) {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self]];
        if (data.length != 0) {
            UIImage *image = [UIImage imageWithData:data];
            return image;
        }
    }
    return nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSString *)URLWithString:(NSString *)URLString relativeToURL:(NSString *)baseURL{
    if (URLString == nil) {
        return nil;
    }
    return [[NSURL URLWithString:URLString relativeToURL:[NSURL URLWithString:baseURL]] absoluteString];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)urlEncoded {
    CFStringRef cfUrlEncodedString = CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                             (CFStringRef)self,NULL,
                                                                             (CFStringRef)@"!#$%&'()*+,/:;=?@[]",
                                                                             kCFStringEncodingUTF8);
    
    NSString *urlEncoded = [NSString stringWithString:(__bridge NSString *)cfUrlEncodedString];
    CFRelease(cfUrlEncodedString);
    return urlEncoded;
}

- (NSString*)trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSDictionary*)queryContentsUsingEncoding:(NSStringEncoding)encoding {
    NSCharacterSet* delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
    NSMutableDictionary* pairs = [NSMutableDictionary dictionary];
    NSScanner* scanner = [[NSScanner alloc] initWithString:self];
    while (![scanner isAtEnd]) {
        NSString* pairString = nil;
        [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
        [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
        NSArray* kvPair = [pairString componentsSeparatedByString:@"="];
        if (kvPair.count == 1 || kvPair.count == 2) {
            NSString* key = [[kvPair objectAtIndex:0]
                             stringByReplacingPercentEscapesUsingEncoding:encoding];
            NSMutableArray* values = [pairs objectForKey:key];
            if (nil == values) {
                values = [NSMutableArray array];
                [pairs setObject:values forKey:key];
            }
            if (kvPair.count == 1) {
                [values addObject:[NSNull null]];
                
            } else if (kvPair.count == 2) {
                NSString* value = [[kvPair objectAtIndex:1]
                                   stringByReplacingPercentEscapesUsingEncoding:encoding];
                [values addObject:value];
            }
        }
    }
    return [NSDictionary dictionaryWithDictionary:pairs];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)stringByAddingQueryDictionary:(NSDictionary*)query {
    NSMutableArray* pairs = [NSMutableArray array];
    for (NSString* key in [query keyEnumerator]) {
        NSString* value = [query objectForKey:key];
        value = [value stringByReplacingOccurrencesOfString:@"?" withString:@"%3F"];
        value = [value stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
        NSString* pair = [NSString stringWithFormat:@"%@=%@", key, value];
        [pairs addObject:pair];
    }
    
    NSString* params = [pairs componentsJoinedByString:@"&"];
    if ([self rangeOfString:@"?"].location == NSNotFound) {
        return [self stringByAppendingFormat:@"?%@", params];
        
    } else {
        return [self stringByAppendingFormat:@"&%@", params];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)stringByAddingURLEncodedQueryDictionary:(NSDictionary*)query {
    NSMutableDictionary* encodedQuery = [NSMutableDictionary dictionaryWithCapacity:[query count]];
    
    for (__strong NSString* key in [query keyEnumerator]) {
        NSParameterAssert([key respondsToSelector:@selector(urlEncoded)]);
        NSString* value = [query objectForKey:key];
        NSParameterAssert([value respondsToSelector:@selector(urlEncoded)]);
        value = [value urlEncoded];
        key = [key urlEncoded];
        [encodedQuery setValue:value forKey:key];
    }
    
    return [self stringByAddingQueryDictionary:encodedQuery];
}

- (BOOL)isEmpty {
    if ([[self trim] length] <= 0 || self == (id)[NSNull null] || self == nil) {
        return YES;
    }
    return NO;
}

#pragma mark - Contains
- (BOOL)contains:(NSString *)searchString {
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", searchString];
    return [searchPredicate evaluateWithObject:self];
}

- (BOOL)containsAnyInArray:(NSArray *)searchArray {
    // return NO if no objects
    if (searchArray.count == 0) { return NO; }
    
    // Check against objects until a match is found
    __block BOOL returnBOOL = NO;
    [searchArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            if ([self contains:(NSString *)obj]) {
                returnBOOL = YES;
                *stop = YES;
            }
        }
    }];
    
    return returnBOOL;
}

#pragma mark - Email Validation
- (BOOL)isValidEmail {
    return [self matchesRegex:@"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$"];
}

- (BOOL)isValidPassWord {
    return [self matchesRegex:@"^[A-Za-z0-9]{6,20}$"];
}

- (BOOL)isValidPhoneNumber {
    
//    return YES;
        /**
         * 手机号码
         * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
         * 联通：130,131,132,152,155,156,185,186
         * 电信：133,1349,153,180,189，177
         * 网络虚拟号 不能实名 173
         */
        NSString * MOBILE = @"^1(3[0-9]|5[0-9]|8[0-9])\\d{8}$";
        /**
         10         * 中国移动：China Mobile
         11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
         12         */
        NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
        /**
         15         * 中国联通：China Unicom
         16         * 130,131,132,152,155,156,185,186,145
         17         */
        NSString * CU = @"^1(3[0-2]|45|5[256]|8[56])\\d{8}$";
        /**
         20         * 中国电信：China Telecom
         21         * 133,1349,153,180,181,189,177,176,178
         22         */
        NSString * CT = @"^1((33|7[3678]|53|8[019])[0-9]|349)\\d{7}$";
        /**
         25         * 大陆地区固话及小灵通
         26         * 区号：010,020,021,022,023,024,025,027,028,029
         27         * 号码：七位或八位
         28         */
        // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
        
        NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
        NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
        NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
        NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
        
        if (([regextestmobile evaluateWithObject:self] == YES)
            || ([regextestcm evaluateWithObject:self] == YES)
            || ([regextestct evaluateWithObject:self] == YES)
            || ([regextestcu evaluateWithObject:self] == YES))
        {
            return YES;
        }
        else
        {
            return NO;
        }
}

- (BOOL)isValidIDCardNumber
{
    if (self.length != 18) {
        return  NO;
    }
    NSArray* codeArray = [NSArray arrayWithObjects:@"7",@"9",@"10",@"5",@"8",@"4",@"2",@"1",@"6",@"3",@"7",@"9",@"10",@"5",@"8",@"4",@"2", nil];
    NSDictionary* checkCodeDic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1",@"0",@"X",@"9",@"8",@"7",@"6",@"5",@"4",@"3",@"2", nil]  forKeys:[NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", nil]];
    
    NSScanner* scan = [NSScanner scannerWithString:[self substringToIndex:17]];
    
    int val;
    BOOL isNum = [scan scanInt:&val] && [scan isAtEnd];
    if (!isNum) {
        return NO;
    }
    int sumValue = 0;
    
    for (int i =0; i<17; i++) {
        sumValue+=[[self substringWithRange:NSMakeRange(i , 1) ] intValue]* [[codeArray objectAtIndex:i] intValue];
    }
    
    NSString* strlast = [checkCodeDic objectForKey:[NSString stringWithFormat:@"%d",sumValue%11]];
    
    if ([strlast isEqualToString: [[self substringWithRange:NSMakeRange(17, 1)]uppercaseString]]) {
        return YES;
    }
    return  NO;
}

- (BOOL)isValidUserName {
    if ([self stringContainsEmoji]) {
        return NO;
    }
    BOOL valid = YES;
    NSInteger count = 0;
    for (int i = 0; i<self.length; i++) {
        char commitChar = [self characterAtIndex:i];
        NSString *temp = [self substringWithRange:NSMakeRange(i,1)];
        const char *u8Temp = [temp UTF8String];
        if (3==strlen(u8Temp)){
            NSLog(@"字符串中含有中文");
            count++;
        }else if((commitChar>64)&&(commitChar<91)){
            NSLog(@"字符串中含有大写英文字母");
            count++;
        }else if((commitChar>96)&&(commitChar<123)){
            NSLog(@"字符串中含有小写英文字母");
            count++;
        }else if((commitChar>47)&&(commitChar<58)){
            NSLog(@"字符串中含有数字");
            count++;
        }else{
            valid = NO;
        }
    }
    if (count < 1 || count > 20) {
        valid = NO;
    }
    return valid;
}

- (BOOL)isOnlyNumAndAlpa
{
    int alength = (int)[self length];
    for (int i = 0; i<alength; i++) {
        char commitChar = [self characterAtIndex:i];
        NSString *temp = [self substringWithRange:NSMakeRange(i,1)];
        const char *u8Temp = [temp UTF8String];
        if (3==strlen(u8Temp)){
            NSLog(@"字符串中含有中文");
        }else if((commitChar>64)&&(commitChar<91)){
            NSLog(@"字符串中含有大写英文字母");
        }else if((commitChar>96)&&(commitChar<123)){
            NSLog(@"字符串中含有小写英文字母");
        }else if((commitChar>47)&&(commitChar<58)){
            NSLog(@"字符串中含有数字");
        }else{
            return NO;
        }
    }
    return YES;

    NSString *regex = @"[a-z][A-Z][0-9]";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:self];

}

- (BOOL)stringContainsEmoji {
    __block BOOL returnValue = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
             
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    
    return returnValue;
}

- (BOOL)isOnlyNum
{
//    return [self matchesRegex:@"^[1-9][0-9]*[.]{0,1}[0-9]{1,2}$"];
     return [self matchesRegex:@"^[1-9]\\d*$"];
    
}

- (BOOL)isFloatNumber{
    return [self matchesRegex:@"^[1-9]\\d*\\.\\d*|0\\.\\d*[1-9]\\d*$"]||[self matchesRegex:@"^[1-9]\\d*$"];
}


#pragma mark - REGEX
- (BOOL)matchesRegex:(NSString *)regexString {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexString options:NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *match = [regex firstMatchInString:self options:0 range:NSMakeRange(0, self.length)];
    return match ? YES : NO;
}

+(BOOL)isNeedUpDate{
    //iTunes页面的所有内容
    NSString *strOnline = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/e-fa-wo-yao-iwant/id1031426530?l=zh&ls=1&mt=8"] encoding:NSUTF8StringEncoding error:nil];
    if (strOnline != nil && [strOnline length] > 0 && [strOnline rangeOfString:@"version"].length==7) {
        NSString *locaVersion =[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
        NSString *onlineVersion =[[strOnline substringToIndex:[strOnline rangeOfString:@","].location] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        if ([locaVersion isEqualToString:onlineVersion]) {
            return YES;
        }
    }
    return NO;
}

@end
