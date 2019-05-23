//
//  GLD_PostTypeManager.h
//  lingzhi
//
//  Created by 锅里的 on 2019/5/15.
//  Copyright © 2019 com.lingzhi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GLD_PostTypeManagerDelegate <NSObject>

- (void)didSeletedPoseType:(NSInteger)type;

@end

@interface GLD_PostTypeManager : NSObject
- (instancetype)initWithDelegate:(id<GLD_PostTypeManagerDelegate>)delegate;
- (UICollectionView *)collectionView;
@end

NS_ASSUME_NONNULL_END
