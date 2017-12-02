//
//  GLD_HomeViewManager.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/11/29.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_HomeViewManager.h"

@interface GLD_HomeViewManager ()


@end
@implementation GLD_HomeViewManager

- (void)fetchMainData{
    NSLog(@"请求首页方法了");
}
- (void)reloadOrLoadMoreData{
    [self.tableView.mj_header endRefreshing];
    NSLog(@"刷新啦");
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return [UITableViewCell new];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mainDataArrM.count;
}
@end
