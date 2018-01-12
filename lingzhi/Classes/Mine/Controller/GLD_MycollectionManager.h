//
//  GLD_MycollectionManager.h
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/11.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_BaseTableManager.h"

@protocol GLD_MycollectionManagerdelegate <NSObject>

- (void)complate:(id)data;
@end
@interface GLD_MycollectionManager : GLD_BaseTableManager

@property (nonatomic, weak)id<GLD_MycollectionManagerdelegate> mycollecDeleagte;
@end
