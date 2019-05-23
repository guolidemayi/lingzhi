//
//  GLD_GoodsCarListController.m
//  lingzhi
//
//  Created by 锅里的 on 2019/5/12.
//  Copyright © 2019 com.lingzhi. All rights reserved.
//

#import "GLD_GoodsCarListController.h"
#import "GLD_StoreDetailCell.h"
#import "GLD_GoodsDetailController.h"
#import "GLD_PayForBusinessController.h"
#import "GLD_MessageUserInfoTool.h"

@interface GLD_GoodsCarListController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, copy)UITableView *home_table;
@property (nonatomic, strong)NSMutableArray *dataArrM;
@end

@implementation GLD_GoodsCarListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.home_table];
    [self.home_table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self getStoreListData];
}

- (void)getStoreListData{
    
    NSArray *arr = [GLD_MessageUserInfoTool readDiskAllCache];
    WS(weakSelf);
    if (arr.count > 0) {
        [weakSelf.dataArrM addObjectsFromArray:arr];
//        [weakSelf.home_table.mj_footer endRefreshing];
    }else{
//        [weakSelf.home_table.mj_footer endRefreshingWithNoMoreData];
    }
    [weakSelf.home_table.mj_header endRefreshing];
    [weakSelf.home_table reloadData];
  
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 刷新
    GLD_StoreDetailModel *storeModel = self.dataArrM[indexPath.row];
    [GLD_MessageUserInfoTool removeAdsList:storeModel];
    [self.dataArrM removeObjectAtIndex:indexPath.row];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArrM.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self getStoreDetailCell:indexPath];
}
- (GLD_StoreDetailCell *)getStoreDetailCell:(NSIndexPath *)indexPath{
    GLD_StoreDetailCell *cell = [self.home_table dequeueReusableCellWithIdentifier:@"GLD_StoreDetailCell"];
    cell.storeModel = self.dataArrM[indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GLD_StoreDetailModel *storeModel = self.dataArrM[indexPath.row];
    
    //            self.title = @"积分商城";
    GLD_GoodsDetailController *detailVc = [[GLD_GoodsDetailController alloc]init];
    detailVc.storeModel = storeModel;
    detailVc.type = storeModel.type;
    [self.navigationController pushViewController:detailVc animated:YES];
    
}


- (UITableView *)home_table{
    if (!_home_table) {
        UITableView *table = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        
        table.delegate = self;
        table.dataSource = self;
        table.estimatedRowHeight = 0;
        table.estimatedSectionHeaderHeight = 0;
        table.estimatedSectionFooterHeight = 0;
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        [table setSeparatorInset:UIEdgeInsetsMake(0, W(15), 0, W(15))];
        //        [table mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.edges.equalTo(self.view);
        //        }];
        WS(weakSelf);
        //        table.mj_footer = [YXFooterRefresh footerWithRefreshingBlock:^{
        //            [weakSelf getStoreListData];
        //
        //        }];
        table.mj_header = [GLD_RefreshHeader headerWithRefreshingBlock:^{
            [weakSelf.dataArrM removeAllObjects];
            [weakSelf getStoreListData];
            
        }];
        table.rowHeight = 130;
        [table registerNib:[UINib nibWithNibName:@"GLD_StoreDetailCell" bundle:nil] forCellReuseIdentifier:@"GLD_StoreDetailCell"];
        _home_table = table;
    }
    return _home_table;
}
- (NSMutableArray *)dataArrM{
    if (!_dataArrM) {
        _dataArrM = [NSMutableArray array];
    }
    return _dataArrM;
}
@end
