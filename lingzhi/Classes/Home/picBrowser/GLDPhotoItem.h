//
//  GLDPhotoItem.h
//  HLFamily
//
//  Created by 博学明辨 on 2019/10/11.
//  Copyright © 2019 王卫. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLDPhotoItem : NSObject

@property (nonatomic, strong) UIView *thumbView;
@property (nonatomic, assign) CGSize largeImageSize;
@property (nonatomic, strong) NSString *largeImage;

@property (nonatomic, readonly) BOOL thumbClippedToTop;
@property (nonatomic, readonly) UIImage *thumbImage;

@property (nonatomic, strong)NSString *videoUrl;
@property (nonatomic, assign, readonly) BOOL isVideo;

@end

NS_ASSUME_NONNULL_END
