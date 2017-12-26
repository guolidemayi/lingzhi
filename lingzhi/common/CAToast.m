//
//  Created by 吴凯强 on 16/6/2.
//  Copyright © 2016年 sendiyang. All rights reserved.
//

#import "CAToast.h"
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

typedef enum {
    POSITION_TOP,
    POSITION_CENTER,
    POSITION_BOTTOM
} Position;

@interface CAToast (private)

- (id)initWithText:(NSString *)text;

- (void)setDuration:(CGFloat)duration;

- (void)dismisToast;

- (void)toastTaped:(UIButton *)sender;

- (void)showAnimation;

- (void)hideAnimation;

- (void)showWithPosition:(Position)pos offset:(CGFloat)offset;

- (void)showFromTopOffset:(CGFloat)topOffset;

- (void)showFromBottomOffset:(CGFloat)bottomOffset;

@end

@implementation CAToast


- (id)initWithText:(NSString *)text {
    self = [super init];
    if (self) {
        message = [text copy];
        UIFont *font = WTFont(15);
//        CGSize textSize = [self getTextNeedSize:font text:text];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CGSize textSize = [message sizeWithFont:font constrainedToSize:CGSizeMake(DEVICE_WIDTH - 60, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
#pragma clang diagnostic pop
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, textSize.width + 12, textSize.height + 30)];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.textColor = [UIColor whiteColor];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.font = font;
        if ([text containsString:@"\n\n"]) {//直播报名特制
            textLabel.attributedText = [YXUniversal changeColorLabel:@"报名成功\n\n开课10分钟前将收到提醒" find:@"报名成功"  flMaxFont:12 flMinFont:15 maxColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKwirte] minColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKwirte]];
        }else{
            
            textLabel.text = message;
        }
        
        
        textLabel.numberOfLines = 0;
        contentView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, textLabel.frame.size.width + 20, textLabel.frame.size.height)];
        contentView.layer.cornerRadius = 5.0f;
        contentView.layer.borderWidth = 1.0f;
        contentView.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
        contentView.backgroundColor = [UIColor colorWithRed:0.0f
                                                      green:0.0f
                                                       blue:0.0f
                                                      alpha:0.7f];
        [contentView addSubview:textLabel];
        contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [contentView addTarget:self
                        action:@selector(toastTaped:)
              forControlEvents:UIControlEventTouchDown];
        contentView.alpha = 0.0f;
        _textLabel = textLabel;

        durationTime = DEFAULT_DISPLAY_DURATION;
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChanged:)
        //                                           name:UIDeviceOrientationDidChangeNotification                                                   object:[UIDevice currentDevice]];
    }
    return self;
}


- (CGSize)getTextNeedSize:(UIFont *)font text:(NSString *)text {
    CGSize retSize;

    NSDictionary *attribute = @{NSFontAttributeName: font};

    retSize = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, font.pointSize)
                                 options:\
                   NSStringDrawingTruncatesLastVisibleLine |
                                         NSStringDrawingUsesLineFragmentOrigin |
                                         NSStringDrawingUsesFontLeading
                              attributes:attribute
                                 context:nil].size;
    return retSize;
}


- (void)deviceOrientationDidChanged:(NSNotification *)notify {
    if (self != nil) {
        [self hideAnimation];
    }
}

- (void)dismissToast {
    [contentView removeFromSuperview];

}

- (void)setMsgTextAlignment:(NSTextAlignment)textAlignment {
    _textLabel.textAlignment = textAlignment;
}

- (void)toastTaped:(UIButton *)sender {
    [self hideAnimation];
}

- (void)setDuration:(CGFloat)duration {
    durationTime = duration;

}

- (void)showAnimation {
    [UIView beginAnimations:@"show" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.3];
    contentView.alpha = 1.0f;
    [UIView commitAnimations];
}

- (void)hideAnimation {
    [UIView beginAnimations:@"hide" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(dismissToast)];
    [UIView setAnimationDuration:0.3];
    contentView.alpha = 0.0f;
    [UIView commitAnimations];
}

- (void)showWithPosition:(Position)pos offset:(CGFloat)offset {
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;   
    UIWindow *window = [AppDelegate shareDelegate].window;
    UIInterfaceOrientation currentOrient = [UIApplication sharedApplication].statusBarOrientation;
    switch (currentOrient) {
        case UIInterfaceOrientationPortrait:
            break;
        case UIInterfaceOrientationLandscapeRight:
            contentView.transform = CGAffineTransformRotate(window.transform, M_PI / 2);
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            contentView.transform = CGAffineTransformRotate(window.transform, M_PI);
            break;
        case UIInterfaceOrientationLandscapeLeft:
            contentView.transform = CGAffineTransformRotate(window.transform, -M_PI / 2);
            break;
        default:
            break;
    }

    switch (pos) {
        case POSITION_TOP:
            contentView.center = CGPointMake(window.center.x, offset + contentView.frame.size.height / 2);
            break;
        case POSITION_BOTTOM:
            contentView.center = CGPointMake(window.center.x, window.frame.size.height - (offset + contentView.frame.size.height / 2));
            break;
        case POSITION_CENTER:
            contentView.center = window.center;
        default:

            break;
    }
    [window addSubview:contentView];
    [self showAnimation];
    [self performSelectorOnMainThread:@selector(hideToastAfterDelay) withObject:nil waitUntilDone:NO];

}

- (void)hideToastAfterDelay {

    [self performSelector:@selector(hideAnimation) withObject:nil afterDelay:durationTime];
}

+ (void)showWithText:(NSString *)text {
    //[CAToast showWithText:text duration:DEFAULT_DISPLAY_DURATION];
    [CAToast showWithText:text bottomOffset:80];
}

+ (void)showWithText:(NSString *)text textAlignment:(NSTextAlignment)textAlignment {
    //[CAToast showWithText:text duration:DEFAULT_DISPLAY_DURATION];
    [CAToast showWithText:text bottomOffset:80 textAlignment:textAlignment];
}

+ (void)showWithText:(NSString *)text duration:(CGFloat)duration {
    CAToast *toast = [[CAToast alloc] initWithText:text];
    [toast setDuration:duration];
    [toast showWithPosition:POSITION_BOTTOM offset:80];
}

+ (void)showWithText:(NSString *)text topOffset:(CGFloat)topOffset {
    [CAToast showWithText:text topOffset:topOffset duration:DEFAULT_DISPLAY_DURATION];
}

+ (void)showWithText:(NSString *)text topOffset:(CGFloat)topOffset duration:(CGFloat)duration {
    CAToast *toast = [[CAToast alloc] initWithText:text];
    [toast setDuration:duration];
    [toast showWithPosition:POSITION_TOP offset:topOffset];
}

+ (void)showWithText:(NSString *)text bottomOffset:(CGFloat)bottomOffset {
    [CAToast showWithText:text bottomOffset:bottomOffset duration:DEFAULT_DISPLAY_DURATION];
}

+ (void)showWithText:(NSString *)text bottomOffset:(CGFloat)bottomOffset duration:(CGFloat)duration {
    CAToast *toast = [[CAToast alloc] initWithText:text];
    [toast setDuration:duration];
    [toast showWithPosition:POSITION_CENTER offset:bottomOffset];
}

+ (void)showWithText:(NSString *)text bottomOffset:(CGFloat)bottomOffset textAlignment:(NSTextAlignment)textAlignment {
    [CAToast showWithText:text bottomOffset:bottomOffset duration:DEFAULT_DISPLAY_DURATION textAlignment:textAlignment];
}

+ (void)showWithText:(NSString *)text bottomOffset:(CGFloat)bottomOffset duration:(CGFloat)duration textAlignment:(NSTextAlignment)textAlignment {
    CAToast *toast = [[CAToast alloc] initWithText:text];
    [toast setDuration:duration];
    [toast showWithPosition:POSITION_BOTTOM offset:bottomOffset];
    [toast setMsgTextAlignment:textAlignment];
}

@end
