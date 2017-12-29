//
//  GLD_PhotoView.h
//  yxvzb
//
//  Created by yiyangkeji on 2017/4/10.
//  Copyright © 2017年 sendiyang. All rights reserved.
//
//用于选取图片 并上传到指定服务器
#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, photoStats) {
    
    gld_photoViewPhoto = 1007,
    gld_photoViewAlbumPhoto
};
@protocol GLD_PhotoViewDelegate <NSObject>

- (void)gld_PhotoView:(photoStats)stats;

@end
@interface GLD_PhotoView : UIView

@property (nonatomic, weak)id<GLD_PhotoViewDelegate> delegate;
//创建photoView
+ (instancetype)showPhotoViewInView:(UIView *)view;
//展示photoView
- (void)showPhotoView:(NSString *)imgStr;

@end
