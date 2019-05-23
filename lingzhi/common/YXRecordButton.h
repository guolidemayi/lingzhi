#import <UIKit/UIKit.h>


//播放状态枚举值

typedef NS_ENUM(NSInteger, recordStats) {
    record = -1,  //luyin
    play = 0,
    sotp = 1,
    playPause = 2,
    continu = 3,
};

@interface YXRecordButton : UIButton

+ (instancetype)creatButWithTitle:(NSString *)title andImageStr:(NSString *)imgStr andFont:(NSInteger)font andTextColorStr:(NSString *)colorStr;
@end
