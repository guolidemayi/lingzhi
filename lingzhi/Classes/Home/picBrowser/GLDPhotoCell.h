//
//  GLDPhotoCell.h
//  HLFamily
//
//  Created by 博学明辨 on 2019/10/11.
//  Copyright © 2019 王卫. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@class GLDPhotoItem;
@interface GLDPhotoCell : UIScrollView

@property (nonatomic, strong)UIView *imageContainerView;
@property (nonatomic, strong, nullable)GLDPhotoItem *item;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong)UIImageView *imageView;
@property (nonatomic, strong)UIButton *playBut;

- (void)resizeSubviewSize;
@end

NS_ASSUME_NONNULL_END
