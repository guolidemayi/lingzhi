//
//  GLD_PictureView.m
//  yxvzb
//
//  Created by yiyangkeji on 2017/5/4.
//  Copyright © 2017年 sendiyang. All rights reserved.
//

#import "GLD_PictureView.h"
#import "GLD_PictureImg.h"

@interface GLD_PictureView ()<GLD_PictureImgDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) NSArray * imageArray;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UILabel * numberLabel;
@end
@implementation GLD_PictureView
- (instancetype)initWithImageArray:(NSArray *)imageArray currentIndex:(NSInteger)index{
    
    GLD_PictureView *pictureView = [[GLD_PictureView alloc]init];
    
        pictureView.imageArray = imageArray;
        pictureView.index = index;
        [pictureView setUpView];
            
    return pictureView;
}
//--getter
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _scrollView.backgroundColor = [UIColor blackColor];
        _scrollView.delegate = self;
        //这里
        _scrollView.contentSize = CGSizeMake((DEVICE_WIDTH + 2*10) * self.imageArray.count, DEVICE_HEIGHT);
        
        _scrollView.scrollEnabled = YES;
        _scrollView.pagingEnabled = YES;
        [self addSubview:_scrollView];
        [self numberLabel];
    }
    return _scrollView;
}
- (UILabel *)numberLabel{
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, DEVICE_WIDTH, 40)];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        _numberLabel.textColor = [YXUniversal colorWithHexString:COLOR_YX_DRAKBLUE];
        _numberLabel.text = [NSString stringWithFormat:@"%zd/%zd",self.index +1,self.imageArray.count];
        [self addSubview:_numberLabel];
    }
    return _numberLabel;
}
- (void)setUpView{
    int index = 0;
    for (NSString *str in self.imageArray) {
        GLD_PictureImg * imageView = [[GLD_PictureImg alloc]init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.delegate = self;
        imageView.yy_imageURL = [NSURL URLWithString:str];
        imageView.tag = index;
        [self.scrollView addSubview:imageView];
        index ++;
    }
    
}
#pragma mark ---UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/DEVICE_WIDTH;
    self.index = index;
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([NSStringFromClass(obj.class) isEqualToString:@"GLD_PictureImg"]) {
            GLD_PictureImg * imageView = (GLD_PictureImg *) obj;
            [imageView resetView];
        }
    }];
    self.numberLabel.text = [NSString stringWithFormat:@"%zd/%zd",self.index+1,self.imageArray.count];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    //主要为了设置每个图片的间距，并且使 图片铺满整个屏幕，实际上就是scrollview每一页的宽度是 屏幕宽度+2*Space  居中。图片左边从每一页的 Space开始，达到间距且居中效果。
    _scrollView.bounds = CGRectMake(0, 0, DEVICE_WIDTH + 2 * 10,DEVICE_HEIGHT);
    _scrollView.center = self.center;
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.frame = CGRectMake(10 + (DEVICE_WIDTH+20) * idx, 0,DEVICE_WIDTH,DEVICE_HEIGHT);
    }];
}
- (void)show{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
    [window addSubview:self];
    
    self.transform = CGAffineTransformMakeScale(0, 0);
    [UIView animateWithDuration:.5 animations:^{
        self.transform = CGAffineTransformIdentity;
    }completion:^(BOOL finished) {
        self.scrollView.contentOffset = CGPointMake((DEVICE_WIDTH+20) * self.index, 0);
    }];
}
- (void)dismiss{
    self.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:.5 animations:^{
        self.transform = CGAffineTransformMakeScale(0.0000000001, 0.00000001);
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}
#pragma mark ---STImageViewDelegate
- (void)gld_ImageVIewSingleClick:(GLD_PictureImg *)imageView{
    [self dismiss];
}


@end 
