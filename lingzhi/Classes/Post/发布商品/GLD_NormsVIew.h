//
//  GLD_NormsVIew.h
//  lingzhi
//
//  Created by 锅里的 on 2019/5/16.
//  Copyright © 2019 com.lingzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLD_NormsVIew : UIView
+ (instancetype)showInWindow:(void(^)(NSString *key))finishBlock;
@end

NS_ASSUME_NONNULL_END
