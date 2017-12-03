//
//  GLD_HomeViewManager.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/11/29.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_HomeViewManager.h"
#import "GLD_BannerCell.h"
#import "GLD_HomeListCell.h"
#import "GLD_BusinessCell.h"

@interface GLD_HomeViewManager ()

@property (nonatomic, strong)UIView *blueLineView;//选择列表蓝条
@property (nonatomic, strong) UIView *headView;
@end
@implementation GLD_HomeViewManager

- (void)setComponentCorner{
    [self.tableView registerClass:[GLD_BannerCell class] forCellReuseIdentifier:GLD_BannerCellIdentifier];
    [self.tableView registerClass:[GLD_BusinessCell class] forCellReuseIdentifier:GLD_BusinessCellIdentifier];
    [self.tableView registerClass:[GLD_HomeListCell class] forCellReuseIdentifier:GLD_HomeListCellIdentifier];
}
- (void)fetchMainData{
    NSLog(@"请求首页方法了");
}
- (void)reloadOrLoadMoreData{
    [self.tableView.mj_header endRefreshing];
    NSLog(@"刷新啦");
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:{
            if (indexPath.row == 0) {
                return [self getBannerCell:indexPath];
            }
            return [self getHomeListCell:indexPath];
        } break;
            
        case 1:{
            return [self getBusinessCell:indexPath];
        }break;
    }
    return [UITableViewCell new];
}

- (GLD_BannerCell *)getBannerCell:(NSIndexPath *)indexPath{
    GLD_BannerCell *cell = [self.tableView dequeueReusableCellWithIdentifier:GLD_BannerCellIdentifier];
    return cell;
}
- (GLD_HomeListCell *)getHomeListCell:(NSIndexPath *)indexPath{
    GLD_HomeListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:GLD_HomeListCellIdentifier];
    return cell;
}
- (GLD_BusinessCell *)getBusinessCell:(NSIndexPath *)indexPath{
    GLD_BusinessCell *cell = [self.tableView dequeueReusableCellWithIdentifier:GLD_BusinessCellIdentifier];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            if (indexPath.row == 0) {
                return W(100);
            }
            return W(150);
        }break;
            
        case 1:{
            return W(100);
        }break;
    }
    return 0.001;
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)return 2;
    return self.mainDataArrM.count + 4;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0) return [UIView new];
    UITableViewHeaderFooterView  *headerView = [UITableViewHeaderFooterView new];
    NSArray *titleArr = @[@"推荐门店",@"附近门店",@"最新开通"];
    
    for (int i = 0; i < titleArr.count; i++) {
        UIButton * button = [UIButton new];
        [button addTarget:self action:@selector(businessListClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTBLACK] forState:UIControlStateNormal];
        button.frame = CGRectMake(DEVICE_WIDTH / 3 * i, 0, DEVICE_WIDTH / 3, W(44));
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        [headerView addSubview:button];
    }
    [headerView addSubview:self.blueLineView];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, W(43), DEVICE_WIDTH, 1)];
    lineView.backgroundColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTline2Gray];
    [headerView addSubview:lineView];
    self.blueLineView.frame = CGRectMake(DEVICE_WIDTH / 3 , W(42), DEVICE_WIDTH / 3, 2);
    return headerView;
}

- (void)businessListClick:(UIButton *)senser{
    [UIView animateWithDuration:.3 animations:^{        
        self.blueLineView.mj_x = senser.mj_x;
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return W(44);
    }
    return 0.001;
}
- (UIView *)blueLineView{
    if (!_blueLineView) {
        _blueLineView = [UIView new];
        _blueLineView.backgroundColor = [YXUniversal colorWithHexString:COLOR_YX_DRAKBLUE];
    }
    return _blueLineView;
}
@end
