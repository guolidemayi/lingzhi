#import <Foundation/Foundation.h>

@interface YXUniversal : NSObject

/**
 *16进制颜色显示
 */
+ (UIColor *)colorWithHexString:(NSString *)color;

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

//UIColor转换UIIMage
+ (UIImage *)createImageWithColor:(UIColor *)color;

//更改label颜色
+ (NSMutableAttributedString *)changeColorLabel:(NSString *)cash find:(NSString *)find flMaxFont:(float)flMaxFont flMinFont:(float)flMinFont maxColor:(UIColor *)maxColor minColor:(UIColor *)minColor;

+ (NSMutableAttributedString *)changeIndexColorLabel:(NSString *)cash find:(NSString *)find number:(NSString *)number maxColor:(UIColor *)maxColor minColor:(UIColor *)minColor;

//计算Label改变高度（比例页面）
//oringHeight   label初始高度
//width         label初始宽度
//text          label text
//font          label font
+ (CGFloat)calculateCellHeight:(CGFloat)originHeight width:(CGFloat)width text:(NSString *)text font:(CGFloat)font;

//计算Label改变高度（正常页面）
//oringHeight   label初始高度
//width         label初始宽度
//text          label text
//font          label font
+ (CGFloat)calculateLabelHeight:(CGFloat)originHeight width:(CGFloat)width text:(NSString *)text font:(UIFont *)font;

+ (CGFloat)calculateLabelWidth:(CGFloat)originHeight text:(NSString *)text font:(UIFont *)font;

/*得到当前设置的语言*/
+ (NSString *)currentLanguage;

+ (NSString *)getDeviceInfo;


/*手机号码验证 */
+ (BOOL)isValidateMobile:(NSString *)mobile;

//邮箱地址的正则表达式
+ (BOOL)isValidateEmail:(NSString *)email;
//验证身份证
+(BOOL)checkUserIDCard:(NSString *)userID;

/**
 * 把时间戳转换成格式为yyyy年M月dd的string
 */
+ (NSString *)intervalToDate:(long long int)interval withFormat:(NSString *)format;

//获取时间戳
+ (NSString *)getTimeStap;

//处理数据
+ (void)saveDefaultValue:(id)value key:(NSString *)key;

+ (id)readDefaultValue:(NSString *)key;


@end
