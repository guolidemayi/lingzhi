//
//  GLD_BusinessViewManager.h
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/4.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_BaseTableManager.h"

@interface GLD_BusinessViewManager : GLD_BaseTableManager

- (void)fetchMainDataWithCondition:(NSDictionary *)condition;
@end
