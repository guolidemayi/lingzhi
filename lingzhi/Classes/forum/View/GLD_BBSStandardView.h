//
//  GLD_BBSStandardView.h
//  yxvzb
//
//  Created by yiyangkeji on 2017/6/12.
//  Copyright © 2017年 sendiyang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^bbsAgreetBlock)();

@interface GLD_BBSStandardView : UIView
+ (void)showBBSStandardView:(bbsAgreetBlock)bbsblock;
@end
