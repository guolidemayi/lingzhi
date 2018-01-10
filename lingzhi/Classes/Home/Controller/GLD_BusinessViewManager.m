//
//  GLD_BusinessViewManager.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/4.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_BusinessViewManager.h"
#import "GLD_BusinessCell.h"
#import "GLD_BusnessModel.h"
#import "GLD_BusinessDetailController.h"

@interface GLD_BusinessViewManager ()

@property (nonatomic, strong)GLD_BusnessLisModel *busnessListModel;
@property (nonatomic, copy)NSDictionary *condition;
@end
@implementation GLD_BusinessViewManager

- (void)setComponentCorner{
    [self.tableView registerClass:[GLD_BusinessCell class] forCellReuseIdentifier:GLD_BusinessCellIdentifier];
    self.tableView.rowHeight = W(100);
}
- (void)fetchMainDataWithCondition:(NSDictionary *)condition{
    WS(weakSelf);
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    config.requestType = gld_networkRequestTypePOST;
    config.urlPath = @"api/main/categoryShop";
    config.requestParameters = condition;
    self.condition = condition;
    [super dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
        
        weakSelf.busnessListModel = [[GLD_BusnessLisModel alloc] initWithDictionary:result error:nil];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
    }];

}
- (void)reloadOrLoadMoreData{
    [self.tableView.mj_footer endRefreshing];
}
- (void)fetchMainData{
    [self fetchMainDataWithCondition:self.condition];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLD_BusinessDetailController *detaileVc = [GLD_BusinessDetailController new];
    detaileVc.busnessModel = self.busnessListModel.data[indexPath.row];
    [self.tableView.navigationController pushViewController:detaileVc animated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.busnessListModel.data.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self getBusinessCell:indexPath];
}
- (GLD_BusinessCell *)getBusinessCell:(NSIndexPath *)indexPath{
    GLD_BusinessCell *cell = [self.tableView dequeueReusableCellWithIdentifier:GLD_BusinessCellIdentifier];
    cell.model = self.busnessListModel.data[indexPath.row];
    return cell;
}


@end
