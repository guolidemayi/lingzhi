//
//  GLD_PictureImg.h
//  yxvzb
//
//  Created by yiyangkeji on 2017/5/4.
//  Copyright © 2017年 sendiyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GLD_PictureImg;
@protocol GLD_PictureImgDelegate <NSObject>

- (void)gld_ImageVIewSingleClick:(GLD_PictureImg *)imageView;

@end
@interface GLD_PictureImg : UIImageView
@property (nonatomic, weak)id<GLD_PictureImgDelegate>delegate;
- (void)resetView;
@end
