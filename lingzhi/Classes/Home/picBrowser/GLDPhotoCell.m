//
//  GLDPhotoCell.m
//  HLFamily
//
//  Created by 博学明辨 on 2019/10/11.
//  Copyright © 2019 王卫. All rights reserved.
//

#import "GLDPhotoCell.h"
#import "UIImageView+WebCache.h"
#import "GLDPhotoItem.h"

@interface GLDPhotoCell ()<UIScrollViewDelegate>



@end
@implementation GLDPhotoCell


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.delegate = self;
        self.bouncesZoom = YES;
        self.maximumZoomScale = 3;
        self.multipleTouchEnabled = YES;
        self.alwaysBounceVertical = NO;
        self.showsVerticalScrollIndicator = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.frame = [UIScreen mainScreen].bounds;
        
        _imageContainerView = [UIView new];
        _imageContainerView.clipsToBounds = YES;
        [self addSubview:_imageContainerView];
        
        _imageView = [UIImageView new];
        _imageView.clipsToBounds = YES;
        _imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
        [_imageContainerView addSubview:_imageView];
        [self addSubview:self.playBut];
    }
    return self;
}

- (void)setItem:(GLDPhotoItem *)item{
    _item = item;
    self.playBut.hidden = YES;
    if (!item) return;
    if (item.isVideo) {
        if (item.thumbImage) {
            self.imageView.image = item.thumbImage;
        }else{
            WS(weakSelf);
            if(IsExist_String(item.largeImage))
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:item.largeImage] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                
                [weakSelf resizeSubviewSize];
            }];
        }
        self.playBut.hidden = NO;
        return;
    }
    
    if(!IsExist_String(item.largeImage)){
        self.imageView.image = item.thumbImage;
        [self resizeSubviewSize];return;
    }
    WS(weakSelf);
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:item.largeImage] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        [weakSelf resizeSubviewSize];
    }];
    
}
- (void)resizeSubviewSize{
    
    _imageContainerView.origin = CGPointZero;
       _imageContainerView.width = self.width;
       
    UIImage *image = _imageView.image;
    if (image.size.height / image.size.width > self.height / self.width) {
        _imageContainerView.height = floor(image.size.height / (image.size.width / self.width));//向下取整（舍弃小数）
    } else {
        CGFloat height = image.size.height / image.size.width * self.width;
        if (height < 1 || isnan(height)) height = self.height;
        height = floor(height);
        _imageContainerView.height = height;
        _imageContainerView.centerY = self.height / 2;
    }
    if (_imageContainerView.height > self.height && _imageContainerView.height - self.height <= 1) {
        _imageContainerView.height = self.height;
    }
    self.contentSize = CGSizeMake(self.width, MAX(_imageContainerView.height, self.height));
    [self scrollRectToVisible:self.bounds animated:NO];
    
    if (_imageContainerView.height <= self.height) {
        self.alwaysBounceVertical = NO;
    } else {
        self.alwaysBounceVertical = YES;//垂直方向反弹效果
    }
    //关闭动画效果
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _imageView.frame = _imageContainerView.bounds;
    [CATransaction commit];
    if (_item.isVideo) {
        self.playBut.hidden = NO;
        self.playBut.center = _imageContainerView.center;
    }else{
        self.playBut.hidden = YES;
    }
    
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imageContainerView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    UIView *subView = _imageContainerView;
    
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
}
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [UIImageView new];
    }
    return _imageView;
}
//- (UIButton *)playBut{
//    if (!_playBut) {
//        _playBut = [UIButton new];
////        _playBut.backgroundColor = [UIColor colorWithHexString:@"#FFFFEE" alpha:.5];
//        [_playBut setBackgroundImage:@"kaishi".image forState:UIControlStateNormal];
//        [_playBut setBackgroundImage:@"zanting".image forState:UIControlStateSelected];
//        _playBut.size = CGSizeMake(W(50), W(50));
//    }
//    return _playBut;
//}
@end
