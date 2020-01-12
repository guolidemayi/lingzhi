//
//  GLDPhotoGroupBrowser.h
//  HLFamily
//
//  Created by 博学明辨 on 2019/10/11.
//  Copyright © 2019 王卫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLDPhotoItem.h"
NS_ASSUME_NONNULL_BEGIN


@protocol GLDPhotoGroupBrowserDelegate <NSObject>

- (void)scrollToIndex:(NSInteger)index;

@end
@interface GLDPhotoGroupBrowser : UIView


- (instancetype)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithFrame:(CGRect)frame UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithGroupItems:(NSArray *)items;


@property (nonatomic, weak) id<GLDPhotoGroupBrowserDelegate> delegate;
- (void)presentFromImageView:(UIView *)fromView
                 toContainer:(UIView *)toContainer
                    animated:(BOOL)animated
                 currentPage:(NSInteger)currentPage
                  completion:(void (^)(void))completion;
@end

NS_ASSUME_NONNULL_END
