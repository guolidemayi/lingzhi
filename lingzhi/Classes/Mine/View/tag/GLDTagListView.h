//
//  GLDTagListView.h
//  HLFamily
//
//  Created by 博学明辨 on 2019/11/25.
//  Copyright © 2019 博学明辨. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN



@protocol GLDTagListViewDelegate <NSObject>

- (void)didSelectTagItem:(nullable NSArray *)viewModelArr;

@end
@class GLDTagViewModel;
@interface GLDTagListView : UIView

+ (instancetype)instanceWithtagViewWithDelegate:(id<GLDTagListViewDelegate>)delegate;
- (void)show:(GLDTagViewModel *)model;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) NSMutableArray *selectArr;
@end

NS_ASSUME_NONNULL_END
