//
//  Created by 郭勇 on 16/3/29.
//  Copyright © 2016年 医洋科技. All rights reserved.
//

#import "YXUniversal.h"
#import "WTFont.h"
#import "UILabel+StringFrame.h"
#import "sys/utsname.h"

@implementation YXUniversal


+ (UIColor *)colorWithHexString:(NSString *)color {
    return [YXUniversal colorWithHexString:color alpha:1.0];
}

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha {
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];

    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }

    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];

    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;

    //r
    NSString *rString = [cString substringWithRange:range];

    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];

    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];

    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];

    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:alpha];
}

//UIColor转换UIIMage
+ (UIImage *)createImageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

/**
 *  富文本
 *
 *  @param cash     需要显示的字符串
 *  @param find     包含的内容
 *  @param number   变色的字符串
 *  @param maxColor 字符串的颜色
 *  @param minColor 需要变色的颜色
 *
 *  @return 处理好的一段富文本信息
 */

+ (NSMutableAttributedString *)changeIndexColorLabel:(NSString *)cash find:(NSString *)find number:(NSString *)number maxColor:(UIColor *)maxColor minColor:(UIColor *)minColor {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:cash];
    //找出包含的字符串 位置长度
    NSRange range = [cash rangeOfString:find];
    if (range.location != NSNotFound) {
        [str addAttribute:NSForegroundColorAttributeName value:maxColor range:NSMakeRange(0, range.location + range.length)];
        [str addAttribute:NSForegroundColorAttributeName value:minColor range:NSMakeRange(range.location + range.length, number.length)];
        [str addAttribute:NSForegroundColorAttributeName value:maxColor range:NSMakeRange(range.location + range.length + number.length, cash.length - (range.location + range.length + number.length))];

    } else {
        NSLog(@"Not Found");
    }
    return str;
}


+ (NSMutableAttributedString *)changeColorLabel:(NSString *)cash find:(NSString *)find flMaxFont:(float)flMaxFont flMinFont:(float)flMinFont maxColor:(UIColor *)maxColor minColor:(UIColor *)minColor {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:cash];
    NSRange range = [cash rangeOfString:find options:NSCaseInsensitiveSearch];
    if (range.location != NSNotFound) {
        [str addAttribute:NSFontAttributeName value:WTFont(flMaxFont) range:NSMakeRange(0, cash.length)];
        [str addAttribute:NSForegroundColorAttributeName value:maxColor range:NSMakeRange(0, cash.length)];
        [str addAttribute:NSFontAttributeName value:WTFont(flMinFont) range:NSMakeRange(range.location, find.length)];
        [str addAttribute:NSForegroundColorAttributeName value:minColor range:NSMakeRange(range.location, find.length)];
    } else {
        NSLog(@"Not Found");
        [str addAttribute:NSFontAttributeName value:WTFont(flMaxFont) range:NSMakeRange(0, cash.length)];
    }
    return str;
}

+ (CGFloat)calculateCellHeight:(CGFloat)originHeight width:(CGFloat)width text:(NSString *)text font:(CGFloat)font {
//    UILabel *labelQ = [[UILabel alloc] init];
//    labelQ.text = text;
//    labelQ.font = WTFont(font);
//    CGSize sizeQuestion = [labelQ boundingRectWithSize:CGSizeMake(width * DEVICEWIDTH_SCALE, 0)];

    NSDictionary *attribute = @{NSFontAttributeName: WTFont(font)};
    
    CGSize retSize = [text boundingRectWithSize:CGSizeMake(W(width), MAXFLOAT)
                                             options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                          attributes:attribute
      
                                        context:nil].size;
    CGFloat height = retSize.height;
    if (iPhone6Plus) {
        if (height > 200) {
            height -= 20;
        }
    }
    return height;

}


+ (CGFloat)calculateLabelHeight:(CGFloat)originHeight width:(CGFloat)width text:(NSString *)text font:(UIFont *)font {
//    CGFloat height = 0;

    UILabel *labelQ = [[UILabel alloc] init];
    labelQ.text = text;
    labelQ.font = font;
    CGSize sizeQuestion = [labelQ boundingRectWithSize:CGSizeMake(width, originHeight)];

//    if (sizeQuestion.height > originHeight) {
//        height = sizeQuestion.height - originHeight;
//    }

    return sizeQuestion.height;
}

+ (CGFloat)calculateLabelWidth:(CGFloat)originHeight text:(NSString *)text font:(UIFont *)font {
    UILabel *labelQ = [[UILabel alloc] init];
    labelQ.text = text;
    labelQ.font = font;
    CGSize sizeQuestion = [labelQ boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, originHeight)];

    return sizeQuestion.width;

}

#pragma mark - 获得系统信息

/*得到当前设置的语言*/
+ (NSString *)currentLanguage {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    NSString *currentLanguage = [languages objectAtIndex:0];
    return currentLanguage;
}

+ (NSString *)getDeviceInfo {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return deviceString;
}

/*手机号码验证 */
+ (BOOL)isValidateMobile:(NSString *)mobile {
    BOOL result = NO;
    if (IsExist_String(mobile))//校验是否为空
    {
        //校验是否符合手机号格式
        //手机号以13， 15，18开头，八个 \d 数字字符
        NSString *phoneRegex = @"^1[3|4|5|7|8|9][0-9]\\d{8}$";//@"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
        //    NSLog(@"phoneTest is %@",phoneTest);

        result = [phoneTest evaluateWithObject:mobile];
    }

    return result;
}

//邮箱地址的正则表达式
+ (BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

/**
 * 把时间戳转换成格式为yyyy年M月dd的string
 */
+ (NSString *)intervalToDate:(long long int)interval withFormat:(NSString *)format {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval / 1000];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:date];
}

//获取时间戳
+ (NSString *)getTimeStap {
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a = [dat timeIntervalSince1970] * 1000;
    NSString *timeString = [NSString stringWithFormat:@"%0.f", a];
    return timeString;
}


//处理数据
+ (void)saveDefaultValue:(id)value key:(NSString *)key {
    if (value) {
        [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    }
}

+ (id)readDefaultValue:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}
//验证身份证
+(BOOL)checkUserIDCard:(NSString *)userID
{
    //长度不为18的都排除掉
    if (userID.length!=18) {
        return NO;
    }
    
    //校验格式
    NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    BOOL flag = [identityCardPredicate evaluateWithObject:userID];
    
    if (!flag) {
        return flag;    //格式错误
    }else {
        //格式正确在判断是否合法
        //将前17位加权因子保存在数组里
        NSArray * idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
        
        //这是除以11后，可能产生的11位余数、验证码，也保存成数组
        NSArray * idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
        
        //用来保存前17位各自乖以加权因子后的总和
        NSInteger idCardWiSum = 0;
        for(int i = 0;i < 17;i++){
            NSInteger subStrIndex = [[userID substringWithRange:NSMakeRange(i, 1)] integerValue];
            NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
            idCardWiSum+= subStrIndex * idCardWiIndex;
        }
        
        //计算出校验码所在数组的位置
        NSInteger idCardMod=idCardWiSum%11;
        
        //得到最后一位身份证号码
        NSString * idCardLast= [userID substringWithRange:NSMakeRange(17, 1)];
        
        //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
        if(idCardMod==2){
            if([idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"]){
                return YES;
            }else{
                return NO;
            }
        }else{
            //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
            if([idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]]){
                return YES;
            }else{
                return NO;
            }
        }
    }
}
@end
