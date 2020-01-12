//
//  GLDPhotoGroupBrowser.m
//  HLFamily
//
//  Created by 博学明辨 on 2019/10/11.
//  Copyright © 2019 王卫. All rights reserved.
//

#import "GLDPhotoGroupBrowser.h"
#import "GLDPhotoCell.h"
#import "UIImage+Extension.h"
#import "UIView+Extend.h"
#import "CALayer+Extension.h"

#define kPadding 20

@interface GLDPhotoGroupBrowser ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIImageView *background;
@property (nonatomic, strong) UIImageView *blurBackground;

@property (nonatomic, strong) NSArray *groupItems;

@property (nonatomic, strong)UIScrollView *scrollView;

@property (nonatomic, strong)UIView *contentView;

@property (nonatomic, strong) UIPageControl *pager;

@property (nonatomic, strong)UIView *toContainerView;

@property (nonatomic, assign) NSInteger fromItemIndex;

@property (nonatomic, strong)UIView *fromView;

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong)NSMutableArray *cells;

@property (nonatomic, assign) BOOL isPresented;


@property (nonatomic, strong)UIImage *snapshorImageHideFromView;
@property (nonatomic, strong)UIImage *snapshotImage;

@property (nonatomic, assign) BOOL playerHasPlay;//已经设置播放器
@end

@implementation GLDPhotoGroupBrowser

- (instancetype)initWithGroupItems:(NSArray *)items{

    if (self = [super init]) {
        
        
        self.backgroundColor = [UIColor clearColor];
        self.frame = [UIScreen mainScreen].bounds;
        self.clipsToBounds = YES;
        self.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        tap2.delegate = self;
        tap2.numberOfTapsRequired = 2;
        [tap requireGestureRecognizerToFail: tap2];
        [self addGestureRecognizer:tap2];
        
        
        self.groupItems = items.copy;
        [self addSubview:self.background = [self getBgImageV]];
        [self addSubview:self.blurBackground = [self getBgImageV]];
//        _blurBackground.image = [UIImage imageWithColor:[UIColor blackColor]];
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.scrollView];
        [self.contentView addSubview:self.pager];
        
    }
    return self;
}


#pragma interface

- (void)dismiss{
    if ([self.delegate respondsToSelector:@selector(scrollToIndex:)]){
        [self.delegate scrollToIndex:-1];return;
    };
    [self dismissAnimated:YES completion:nil];
}

- (void)presentFromImageView:(UIView *)fromView
                 toContainer:(UIView *)toContainer
                    animated:(BOOL)animated
                 currentPage:(NSInteger)currentPage
                  completion:(void (^)(void))completion {
    
    
    
    _fromView = fromView;
    _toContainerView = toContainer;
    
    
    if (currentPage < 0) currentPage = 0;
    _fromItemIndex = currentPage;
    
    
    _snapshotImage = [_toContainerView snapshotImageAfterScreenUpdates:NO];
    BOOL fromViewHidden = fromView.hidden;
    fromView.hidden = YES;
    _snapshorImageHideFromView = [_toContainerView snapshotImage];
    fromView.hidden = fromViewHidden;
    _background.image = _snapshorImageHideFromView;
    
    self.size = _toContainerView.size;
    self.blurBackground.alpha = 0;
    self.pager.alpha = 0;
    self.pager.numberOfPages = self.groupItems.count;
    self.pager.currentPage = currentPage;
    [_toContainerView addSubview:self];
    _blurBackground.image = [_snapshorImageHideFromView imageByBlurDark];
    
    _scrollView.contentSize = CGSizeMake(_scrollView.width * self.groupItems.count, _scrollView.height);
    [_scrollView scrollRectToVisible:CGRectMake(_scrollView.width * _pager.currentPage, 0, _scrollView.width, _scrollView.height) animated:NO];
    [self scrollViewDidScroll:_scrollView];
    
    GLDPhotoCell *cell = [self cellForPage:self.currentPage];
    GLDPhotoItem *item = _groupItems[self.currentPage];
    
    cell.item = item;
    
    if (!cell.item) {
          cell.imageView.image = item.thumbImage;
          [cell resizeSubviewSize];
      }
    
    //
    WS(weakSelf);
    if (item.thumbClippedToTop) {
       CGRect fromFrame = [_fromView convertRect:_fromView.bounds toView:cell];
        CGRect originFrame = cell.imageContainerView.frame;
        CGFloat scale = fromFrame.size.width / cell.imageContainerView.width;
        
        cell.imageContainerView.centerX = CGRectGetMidX(fromFrame);
        cell.imageContainerView.height = fromFrame.size.height / scale;
        [cell.imageContainerView.layer setValue:@(scale) forKeyPath:@"transform.scale"];
        cell.imageContainerView.centerY = CGRectGetMidY(fromFrame);
        
        float oneTime = animated ? 0.25 : 0;
        [UIView animateWithDuration:oneTime delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
            weakSelf.blurBackground.alpha = 1;
        }completion:NULL];
        
        _scrollView.userInteractionEnabled = NO;
        [UIView animateWithDuration:oneTime delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [cell.imageContainerView.layer setValue:@(1) forKeyPath:@"transform.scale"];
            cell.imageContainerView.frame = originFrame;
            weakSelf.pager.alpha = 1;
        }completion:^(BOOL finished) {
            weakSelf.isPresented = YES;
            [weakSelf scrollViewDidScroll:weakSelf.scrollView];
            weakSelf.scrollView.userInteractionEnabled = YES;
            [weakSelf hidePager];
            if (completion) completion();
        }];
    }else{
        CGRect fromFrame = [_fromView convertRect:_fromView.bounds toView:cell.imageContainerView];
        
        cell.imageContainerView.clipsToBounds = NO;
        cell.imageView.frame = fromFrame;
        cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        float oneTime = animated ? 0.18 : 0;
        [UIView animateWithDuration:oneTime*2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
            weakSelf.blurBackground.alpha = 1;
        }completion:NULL];
        
        _scrollView.userInteractionEnabled = NO;
        [UIView animateWithDuration:oneTime delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
            cell.imageView.frame = cell.imageContainerView.bounds;
            [cell.imageContainerView.layer setValue:@(1.01) forKeyPath:@"transform.scale"];
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:oneTime delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
                
                [cell.imageContainerView.layer setValue:@(1.0) forKeyPath:@"transform.scale"];
                weakSelf.pager.alpha = 1;
            }completion:^(BOOL finished) {
                cell.imageContainerView.clipsToBounds = YES;
                weakSelf.isPresented = YES;
                [self scrollViewDidScroll:weakSelf.scrollView];
                weakSelf.scrollView.userInteractionEnabled = YES;
                [self hidePager];
                if (completion) completion();
            }];
        }];
    }
}

- (void)dismissAnimated:(BOOL)animated completion:(void (^)(void))completion {
    [UIView setAnimationsEnabled:YES];
    
    NSInteger currentPage = self.currentPage;
    GLDPhotoCell *cell = [self cellForPage:currentPage];
    GLDPhotoItem *item = _groupItems[currentPage];
    cell.playBut.hidden = YES;
    UIView *fromView = nil;
    if (_fromItemIndex == currentPage) {
        fromView = _fromView;
    } else {
        fromView = item.thumbView;
    }
    
   
    _isPresented = NO;
    BOOL isFromImageClipped = fromView.layer.contentsRect.size.height < 1;
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    if (isFromImageClipped) {
        CGRect frame = cell.imageContainerView.frame;
        cell.imageContainerView.layer.anchorPoint = CGPointMake(0.5, 0);
        cell.imageContainerView.frame = frame;
    }
//    cell.progressLayer.hidden = YES;
    [CATransaction commit];

    if (fromView == nil) {
        self.background.image = _snapshotImage;
        [UIView animateWithDuration:animated ? 0.25 : 0 delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut animations:^{
            self.alpha = 0.0;
            [cell.imageContainerView.layer setValue:@(0.95) forKeyPath:@"transform.scale"];
            self.scrollView.alpha = 0;
            self.pager.alpha = 0;
            self.blurBackground.alpha = 0;
        }completion:^(BOOL finished) {
            [cell.imageContainerView.layer setValue:@(1.0) forKeyPath:@"transform.scale"];
            [self removeFromSuperview];
            if (completion) completion();
        }];
        return;
    }
    
    if (_fromItemIndex != currentPage) {
        _background.image = _snapshotImage;
        [_background.layer addFadeAnimationWithDuration:0.25 curve:UIViewAnimationCurveEaseOut];
    } else {
        _background.image = _snapshorImageHideFromView;
    }

    
//    if (isFromImageClipped) {
//        [cell scrollToTopAnimated:NO];
//    }
    
    [UIView animateWithDuration:animated ? 0.2 : 0 delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut animations:^{
        self.pager.alpha = 0.0;
        self.blurBackground.alpha = 0.0;
        if (isFromImageClipped) {
            
            CGRect fromFrame = [fromView convertRect:fromView.bounds toView:cell];
            CGFloat scale = fromFrame.size.width / cell.imageContainerView.width * cell.zoomScale;
            CGFloat height = fromFrame.size.height / fromFrame.size.width * cell.imageContainerView.width;
            if (isnan(height)) height = cell.imageContainerView.height;
            
            cell.imageContainerView.height = height;
            cell.imageContainerView.center = CGPointMake(CGRectGetMidX(fromFrame), CGRectGetMinY(fromFrame));
            [cell.imageContainerView.layer setValue:@(scale) forKeyPath:@"transform.scale"];
            
        } else {
            CGRect fromFrame = [fromView convertRect:fromView.bounds toView:cell.imageContainerView];
            cell.imageContainerView.clipsToBounds = NO;
            cell.imageView.contentMode = fromView.contentMode;
            cell.imageView.frame = fromFrame;
        }
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:animated ? 0.15 : 0 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            cell.imageContainerView.layer.anchorPoint = CGPointMake(0.5, 0.5);
            [self removeFromSuperview];
            if (completion) completion();
        }];
    }];
    
    
}

#pragma scrollviewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
   
    [self updateCellsForReuse];
    CGFloat floatPage = _scrollView.contentOffset.x / _scrollView.width;
    NSInteger page = _scrollView.contentOffset.x / _scrollView.width + 0.5;
    //预加载
    for (NSInteger i = page - 1; i <= page + 1; i++) {
        
        if (i >= 0 && i < _groupItems.count) {
            GLDPhotoCell *cell = [self cellForPage:i];
            if (!cell) {//没有取到cell
                cell = [self dequeueReusableCell];
                
                cell.page = i;
                cell.left = (self.width + kPadding) * i + kPadding / 2;
                if (_isPresented) {
                    cell.item = _groupItems[i];
                }
                [self.scrollView addSubview:cell];
            }else{
                
                //找到了，并且没有在展示
                if (_isPresented && !cell.item) {
                    cell.item = _groupItems[i];
                }
            }
        }
    }
    NSInteger intPage = floatPage + 0.5;
       intPage = intPage < 0 ? 0 : intPage >= _groupItems.count ? (int)_groupItems.count - 1 : intPage;
       _pager.currentPage = intPage;
       [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
           self.pager.alpha = 1;
       }completion:^(BOOL finish) {
       }];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate) {
        [self hidePager];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self hidePager];
   
    if ([self.delegate respondsToSelector:@selector(scrollToIndex:)]) {
        [self.delegate scrollToIndex:self.currentPage];
    }
}

#pragma mark - Private Methods

- (void)doubleTap:(UITapGestureRecognizer *)g {
    if (!_isPresented) return;
    GLDPhotoCell *tile = [self cellForPage:self.currentPage];
    if(tile.item.isVideo)return;
    if (tile) {
        if (tile.zoomScale > 1) {
            [tile setZoomScale:1 animated:YES];
        } else {
            CGPoint touchPoint = [g locationInView:tile.imageView];
            CGFloat newZoomScale = tile.maximumZoomScale;
            CGFloat xsize = self.width / newZoomScale;
            CGFloat ysize = self.height / newZoomScale;
            [tile zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
        }
    }
}
- (void)updateCellsForReuse {
    for (GLDPhotoCell *cell in self.cells) {
        if (cell.superview) {
            if (cell.left > _scrollView.contentOffset.x + _scrollView.width * 2||
                cell.right < _scrollView.contentOffset.x - _scrollView.width) {
                [cell removeFromSuperview];
                cell.page = -1;
                cell.item = nil;
            }
        }
    }
}
- (GLDPhotoCell *)dequeueReusableCell {
    GLDPhotoCell *cell = nil;
    for (cell in self.cells) {
        if (!cell.superview) {
            return cell;
        }
    }
    
    cell = [GLDPhotoCell new];
    cell.frame = self.bounds;
    cell.imageContainerView.frame = self.bounds;
    cell.imageView.frame = cell.bounds;
    cell.page = -1;
    cell.item = nil;
    
    [self.cells addObject:cell];
    return cell;
}
- (GLDPhotoCell *)cellForPage:(NSInteger)page {
    for (GLDPhotoCell *cell in self.cells) {
        if (cell.page == page) {
            return cell;
        }
    }
    return nil;
}
- (void)hidePager {
    WS(weakSelf);
    [UIView animateWithDuration:0.3 delay:0.8 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut animations:^{
        weakSelf.pager.alpha = 0;
    }completion:^(BOOL finish) {
    }];
}
- (NSInteger)currentPage {
    NSInteger page = _scrollView.contentOffset.x / _scrollView.width + 0.5;
    if (page >= _groupItems.count) page = (NSInteger)_groupItems.count - 1;
    if (page < 0) page = 0;
    return page;
}

- (UIImageView *)getBgImageV{
    
    UIImageView *imageV = UIImageView.new;
    imageV.frame = self.bounds;
//    imageV.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    return imageV;
}
- (UIPageControl *)pager{
    if (!_pager) {
        _pager = [[UIPageControl alloc] init];
        _pager.hidesForSinglePage = YES;
        _pager.userInteractionEnabled = NO;
        _pager.width = self.width - 36;
        _pager.height = 10;
        _pager.center = CGPointMake(self.width / 2, self.height - 18);
//        _pager.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    }
    return _pager;
}
- (UIView *)contentView{
    if (_contentView == nil) {
        _contentView = [UIView new];
        _contentView.frame = self.bounds;
//        _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _contentView;
}
- (UIScrollView *)scrollView{
    if (!_scrollView) {

        _scrollView = UIScrollView.new;
        _scrollView.frame = CGRectMake(-kPadding / 2, 0, self.width + kPadding, self.height);
        _scrollView.delegate = self;
        _scrollView.scrollsToTop = NO;
        _scrollView.pagingEnabled = YES;
        //如果该值设为YES，并且bounces也设置为YES，那么，即使设置的contentSize比scrollView的size小，那么也是可以拖动的
        _scrollView.alwaysBounceHorizontal = self.groupItems.count > 1;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        //在屏幕旋转时，scrollView就可以自动调整布局
//        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//        //默认值为YES；如果设置为NO，则无论手指移动的多么快，始终都会将触摸事件传递给内部控件；设置为NO可能会影响到UIScrollView的滚动功能
//        _scrollView.delaysContentTouches = NO;
//        //为YES 点击后在移动而产生其他动作，会取消点击动作，进行其他动作
//        _scrollView.canCancelContentTouches = YES;
    }
    return _scrollView;
}
- (NSMutableArray *)cells{
    if (!_cells) {
        _cells = [NSMutableArray array];
        
    }
    return _cells;
}

@end
