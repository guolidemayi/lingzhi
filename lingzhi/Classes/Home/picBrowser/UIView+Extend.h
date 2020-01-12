//
//  UIView+Extend.h
//  HLFamily
//
//  Created by 胡红磊 on 2019/9/19.
//  Copyright © 2019 胡红磊. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Extend)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize  size;
@property (nonatomic, assign) CGPoint origin;

@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

/**
 *  添加一组子view：
 */
-(void)addSubviewsWithArray:(NSArray *)subViews;

/**
 *  批量移除视图
 *
 *  @param views 需要移除的视图数组
 */
+(void)removeViews:(NSArray *)views;

+ (instancetype)IBInstance;
//屏幕截图
- (UIImage *)snapshotImage;
//屏幕截图
- (UIImage *)snapshotImageAfterScreenUpdates:(BOOL)afterUpdates;
@end

NS_ASSUME_NONNULL_END
