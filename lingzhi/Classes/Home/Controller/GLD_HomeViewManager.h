//
//  GLD_HomeViewManager.h
//  lingzhi
//
//  Created by yiyangkeji on 2017/11/29.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_BaseTableManager.h"

@interface GLD_HomeViewManager : GLD_BaseTableManager

- (void)fetchMainUserData;
@property (nonatomic, copy)void(^versonUpdate)(void);
@end
