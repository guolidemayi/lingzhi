//
//  GLDPhotoItem.m
//  HLFamily
//
//  Created by 博学明辨 on 2019/10/11.
//  Copyright © 2019 王卫. All rights reserved.
//

#import "GLDPhotoItem.h"
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import <AVFoundation/AVTime.h>

@interface GLDPhotoItem()

@property (nonatomic, assign) BOOL isVideo;

@end
@implementation GLDPhotoItem

- (UIImage *)thumbImage {
    if (_isVideo) {
       return nil;
    }
    if ([_thumbView respondsToSelector:@selector(image)]) {
        return ((UIImageView *)_thumbView).image;
    }
    return nil;
}

- (void)setVideoUrl:(NSString *)videoUrl{
    _videoUrl = videoUrl;
    if (videoUrl) {
        self.isVideo = YES;
    }
}
- (BOOL)thumbClippedToTop {
    if (_thumbView) {
        if (_thumbView.layer.contentsRect.size.height < 1) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)shouldClipToTop:(CGSize)imageSize forView:(UIView *)view {
    if (imageSize.width < 1 || imageSize.height < 1) return NO;
    if (view.width < 1 || view.height < 1) return NO;
    return imageSize.height / imageSize.width > view.width / view.height;
}

@end
