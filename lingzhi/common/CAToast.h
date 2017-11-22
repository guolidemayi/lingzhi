#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define DEFAULT_DISPLAY_DURATION 2.0f

@interface CAToast : NSObject {

    NSString *message;
    UIButton *contentView;
    CGFloat durationTime;
    UILabel *_textLabel;
}

+ (void)showWithText:(NSString *)text;

+ (void)showWithText:(NSString *)text duration:(CGFloat)duration;

+ (void)showWithText:(NSString *)text topOffset:(CGFloat)topOffset;

+ (void)showWithText:(NSString *)text topOffset:(CGFloat)topOffset duration:(CGFloat)duration;

+ (void)showWithText:(NSString *)text bottomOffset:(CGFloat)bottomOffset;

+ (void)showWithText:(NSString *)text bottomOffset:(CGFloat)bottomOffset duration:(CGFloat)duration;

+ (void)showWithText:(NSString *)text textAlignment:(NSTextAlignment)textAlignment;



@end
