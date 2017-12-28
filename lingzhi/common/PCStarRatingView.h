//
//  PCStarRatingView.h
//  PCStarRatingView
//
//  Created by xpc on 16/12/14.
//  Copyright © 2016年 xpc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PCStarRatingDelegate <NSObject>

- (void)mannerGrade:(NSString *)grade withView:(UIView *)starView;

@end

@interface PCStarRatingView : UIView

@property (weak, nonatomic) id<PCStarRatingDelegate> delegate;

//  是否需要半星
@property (assign, nonatomic) BOOL isNeedHalf;
//  评分图片的宽
@property (assign, nonatomic) CGFloat imageWidth;
//  评分图片的高
@property (assign, nonatomic) CGFloat imageHeight;
//  图片数量
@property (assign, nonatomic) NSInteger imageCount;

@end
