#import <UIKit/UIKit.h>

@interface YXButton : UIButton

@property(assign, nonatomic) BOOL isMore;

@property(nonatomic, strong) UIImageView * _Nullable imgV;
@property(nonatomic, strong) UILabel * _Nullable label;

+ (instancetype _Nullable )creatButWithTitle:(nullable NSString *)title andImageStr:(nullable NSString *)imgStr andFont:(NSInteger)font andTextColorStr:(NSString *_Nullable)colorStr;
@end
