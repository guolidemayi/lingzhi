//
//  GLD_BaseTableManager.h
//  lingzhi
//
//  Created by yiyangkeji on 2017/11/29.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIView+gldController.h"

@interface GLD_BaseTableManager : GLD_NetworkAPIManager <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *mainDataArrM;
//初始化方法
- (instancetype)initWithTableView:(UITableView *)tableView;
//配饰方法
- (void)setComponentCorner;
//请求数据
- (void)fetchMainData;
//刷新或加载更多
- (void)reloadOrLoadMoreData;
@end
