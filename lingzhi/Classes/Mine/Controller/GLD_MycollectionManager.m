//
//  GLD_MycollectionManager.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/11.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_MycollectionManager.h"
#import "GLD_BusinessCell.h"
#import "GLD_BusnessModel.h"
#import "GLD_BusinessDetailController.h"

@implementation GLD_MycollectionManager

- (void)setComponentCorner{
    [self.tableView registerClass:[GLD_BusinessCell class] forCellReuseIdentifier:GLD_BusinessCellIdentifier];
    self.tableView.rowHeight = W(120);
}
- (void)fetchMainData{
 //我的收藏接口
    WS(weakSelf);
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    config.requestType = gld_networkRequestTypePOST;
    config.urlPath = @"api/main/getCollectionShop";
    config.requestParameters = @{@"userId":GetString([AppDelegate shareDelegate].userModel.userId),
                                 @"offset":[NSString stringWithFormat:@"%zd",self.mainDataArrM.count],
                                 @"limit":@"10"
                                 };
    [super dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
        
        [weakSelf.tableView.mj_header endRefreshing];
        GLD_BusnessLisModel *busnessListModel = [[GLD_BusnessLisModel alloc] initWithDictionary:result error:nil];
        [weakSelf.mainDataArrM addObjectsFromArray:busnessListModel.data];
        if ([weakSelf.mycollecDeleagte respondsToSelector:@selector(complate:)]) {
            if (!IsExist_Array(weakSelf.mainDataArrM)) {
                [weakSelf.mycollecDeleagte complate:result];
            }
        }
        [weakSelf.tableView reloadData];
    }];
}

- (void)reloadOrLoadMoreData{
    [self fetchMainData];
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 刷新
    
    GLD_BusnessModel *model = self.mainDataArrM[indexPath.row];
    
    [self.mainDataArrM removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLD_BusinessDetailController *detaileVc = [GLD_BusinessDetailController new];
    detaileVc.busnessModel = self.mainDataArrM[indexPath.row];
    [self.tableView.navigationController pushViewController:detaileVc animated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mainDataArrM.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self getBusinessCell:indexPath];
}
- (GLD_BusinessCell *)getBusinessCell:(NSIndexPath *)indexPath{
    GLD_BusinessCell *cell = [self.tableView dequeueReusableCellWithIdentifier:GLD_BusinessCellIdentifier];
    cell.model = self.mainDataArrM[indexPath.row];
    return cell;
}

@end
