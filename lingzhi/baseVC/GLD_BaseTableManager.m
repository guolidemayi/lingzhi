//
//  GLD_BaseTableManager.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/11/29.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_BaseTableManager.h"


@interface GLD_BaseTableManager ()



@end

@implementation GLD_BaseTableManager


- (instancetype)initWithTableView:(UITableView *)tableView
{
    self = [super init];
    if (self) {
        self.tableView = tableView;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        [tableView setSeparatorInset:UIEdgeInsetsMake(0, W(15), 0, W(15))];
        
        WS(weakSelf);
        tableView.mj_header = [GLD_RefreshHeader headerWithRefreshingBlock:^{
            [weakSelf.mainDataArrM removeAllObjects];
            [weakSelf fetchMainData];
        }];
        tableView.mj_footer = [YXFooterRefresh footerWithRefreshingBlock:^{
            [weakSelf reloadOrLoadMoreData];
        }];
        [self setComponentCorner];
    }
    return self;
}
- (void)setComponentCorner{
    
}
- (void)fetchMainData{
    
}
- (void)reloadOrLoadMoreData{
    
}

- (NSMutableArray *)mainDataArrM{
    if (!_mainDataArrM) {
        _mainDataArrM = [NSMutableArray array];
    }
    return _mainDataArrM;
}

@end
