//
//  NSString+BLExtension.m
//  FinanceDaDao
//
//  Created by yzla50010 on 16/7/7.
//  Copyright © 2016年 yizhilu. All rights reserved.
//

#import "NSString+BLExtension.h"

#import <CommonCrypto/CommonDigest.h>


@implementation NSString (BLExtension)

+(NSString *)getMinuteSecondWithSecond:(NSTimeInterval)time{
    
    int minute = (int)time / 60;
    int second = (int)time % 60;
    
    if (second > 9) { //2:10
        return [NSString stringWithFormat:@"%d:%d",minute,second];
    }
    
    //2:09
    return [NSString stringWithFormat:@"%d:0%d",minute,second];
}


+ (NSString *)readFromCachesDirectory:(NSString*)filename
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    
    NSString *CachesDirectory = [paths objectAtIndex:0];
    
    NSString *path = [CachesDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",filename]];
    //    NSData *data = [NSData dataWithContentsOfFile:path];
    
    //    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    
    return path;
}


+ (NSString *)deletSpaceInString:(NSString *)text
{
    NSString *content = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]; // 去首尾空格
    NSString *replace = [content stringByReplacingOccurrencesOfString:@" " withString:@""];// 去全部空格
    //    NSString *replacePoint = [replace stringByReplacingOccurrencesOfString:@"." withString:@""];// 去全部空格
    
    return replace;
}


+ (NSString *)userNameString
{
    NSString *nameString;
    

    return nameString;
}



+ (NSString *)cutOutString:(NSString *)string Char:(NSString *)chars
{
    NSArray *strings = [string componentsSeparatedByCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"。."]];
    
    NSString *periodString = [strings firstObject];
    
    return periodString;
}

- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
        
}

- (CGSize)sizeWithFont:(UIFont *)font
{
    return [self sizeWithFont:font maxW:MAXFLOAT];
}

#pragma mark - 解析HTML
+ (NSString *)flattenHTML:(NSString *)html trimWhiteSpace:(BOOL)trim
{
    NSScanner *theScanner = [NSScanner scannerWithString:html];
    NSString *text = nil;
    
    while ([theScanner isAtEnd] == NO)
    {
        

        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        html = [html stringByReplacingOccurrencesOfString:[ NSString stringWithFormat:@"%@>", text] withString:@""];
        
        if ([html containsString:@"</p><p>"]) {
            NSString *replace = [html stringByReplacingOccurrencesOfString:@"</p><p>" withString:@"\n"];
            
            html = replace;
        }
        if ([html containsString:@"&nbsp;"])
        {
            NSString *replace = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
            html = replace;
        }
        if ([html containsString:@"_ueditor_page_break_tag_"])
        {
            NSString *replace = [html stringByReplacingOccurrencesOfString:@"_ueditor_page_break_tag_" withString:@" "];
            
            html = replace;
        }
        
        
    }
    return trim ? [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] : html;
}



+ (NSString *)setCount:(int)count title:(NSString *)title
{
    // 数字不为0
    if (count < 10000)
    { // 不足10000：直接显示数字，比如786、7986
        title = [title stringByAppendingString:[NSString stringWithFormat:@" %d", count]];
    }
    else
    { // 达到10000：显示xx.x万，不要有.0的情况
        double wan = count / 10000.0;
        title = [title stringByAppendingString:[NSString stringWithFormat:@" %.1f万", wan]];
        // 将字符串里面的.0去掉
        title = [title stringByReplacingOccurrencesOfString:@" .0" withString:@""];
    }
    
    return title;
}

/** md5 一般加密 */

+ (NSString *)MD5String:(NSString *)string
{
    const char *myPasswd = [string UTF8String];
    
    unsigned char mdc[16];
    
    CC_MD5(myPasswd, (CC_LONG)strlen(myPasswd), mdc);
    
    NSMutableString *md5String = [NSMutableString string];
    
    for (int i = 0; i< 16; i++)
    {
        [md5String appendFormat:@"%02x",mdc[i]];
    }
    
    return md5String;
    
}

/** md5 NB(牛逼的意思)加密*/
+ (NSString *)MD5StringNB:(NSString *)string
{
    const char *myPasswd = [string UTF8String];
    
    unsigned char mdc[16];
    
    CC_MD5(myPasswd, (CC_LONG)strlen(myPasswd), mdc);
    
    NSMutableString *md5String = [NSMutableString string];
    
    [md5String appendFormat:@"%02x",mdc[0]];
    
    for (int i = 1; i< 16; i++)
    {
        [md5String appendFormat:@"%02x",mdc[i]^mdc[0]];
    }
    
    return md5String;
}

/** * 随机生成字符串 */
+ (NSString *)generateRandomString
{
//    char data[32];
//    
//    for (int x=0;x<32;data[x++] = (char)('A' + (arc4random_uniform(26))));
//    NSString *randomString = [[NSString alloc] initWithBytes:data length:8 encoding:NSUTF8StringEncoding];
    
    
    NSString *string = [[NSString alloc]init];
    for (int i = 0; i < 32; i++)
    {
        int number = arc4random() % 36;
        if (number < 10)
        {
            int figure = arc4random() % 10;
            NSString *tempString = [NSString stringWithFormat:@"%d", figure];
            string = [string stringByAppendingString:tempString];
        }
        else
        {
            int figure = (arc4random() % 26) + 'a';
            char character = figure;
            NSString *tempString = [NSString stringWithFormat:@"%c", character];
            string = [string stringByAppendingString:tempString];
        }
    }
    
    return string;
}



#pragma mark ---- 判断邮箱格式  ----
+ (BOOL)CheckInputEmail:(NSString *)email
{
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    
    return [emailTest evaluateWithObject:email];
    
}



#pragma mark ---- 密码 6 ~ 16位  ----
+ (BOOL)CheckInputPassword:(NSString *)text
{
   // NSString *Regex = @"\\w{6,16}";
    
    
    NSString *Regex = @"(?!^\\d+$)(?!^[a-zA-Z]+$)(?!^[_#@]+$).{6,}";

    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    BOOL isCheck = [emailTest evaluateWithObject:text];
   
    if ([text length] > 16) isCheck = !isCheck;
    
    return isCheck;
    
}

#pragma mark ---- 英文数字. 下划线, 横线  ----
+ (BOOL)checkUserNameWithChar:(NSString *)text
{
    NSString *Regex = @"^[a-zA-Z0-9_\\-\u4e00-\u9fa5]+$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    BOOL isCheck = [emailTest evaluateWithObject:text];
    return isCheck;
}

#pragma mark ---- 手机号码验证 MODIFIED BY HELENSONG ----
+ (BOOL)mobileNumber:(NSString *)mobileNum
{
    if (mobileNum.length != 11)
    {
        return NO;
    }
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[6, 7, 8], 18[0-9], 170[0-9]
     * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     * 联通号段: 130,131,132,155,156,185,186,145,176,1709
     * 电信号段: 133,153,180,181,189,177,1700
     */
    NSString *MOB_ILE = @"^1((3[0-9]|4[57]|5[0-35-9]|7[0678]|8[0-9])\\d{8}$)";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     */
    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
    /**
     * 中国联通：China Unicom
     * 130,131,132,155,156,185,186,145,176,1709
     */
    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
    /**
     * 中国电信：China Telecom
     * 133,153,180,181,189,177,1700
     */
    NSString *CT = @"(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
    
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOB_ILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}



@end


