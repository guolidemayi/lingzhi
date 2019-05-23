//
//  GLD_PostExressManager.h
//  lingzhi
//
//  Created by 锅里的 on 2019/5/15.
//  Copyright © 2019 com.lingzhi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class GLD_ExpressModel;
@interface GLD_PostExressManager : NSObject

- (instancetype)initWith:(UITableView *)tableView andViewC:(UIViewController *)vc;
- (GLD_ExpressModel *)expressModel;
- (void)reloadData;
@end

NS_ASSUME_NONNULL_END
