//
//  GLD_StoreViewController.m
//  lingzhi
//
//  Created by yiyangkeji on 2018/7/30.
//  Copyright © 2018年 com.lingzhi. All rights reserved.
//

#import "GLD_StoreViewController.h"
#import "GLD_StoreDetailCell.h"
#import "GLD_GoodsDetailController.h"

@interface GLD_StoreViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, copy)UITableView *home_table;
@property (nonatomic, strong)NSMutableArray *dataArrM;
@end

@implementation GLD_StoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.home_table];
    [self.home_table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self getStoreListData];
}
- (void)setType:(NSInteger)type{
    _type = type;
    switch (type) {
        case 1:
            self.title = @"积分商城";
            break;
        case 2:
            self.title = @"代金券商城";
            break;
        case 3:
            self.title = @"特价商城";
            break;
    }
}
- (void)getStoreListData{
    WS(weakSelf);
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    config.requestType = gld_networkRequestTypePOST;
    config.urlPath = storeListRequest;
    config.requestParameters = @{@"type":@(self.type)};
    [self.NetManager dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
//        
        GLD_StoreDetaiListlModel *StoreModel = [[GLD_StoreDetaiListlModel alloc] initWithDictionary:result error:nil];
        if (StoreModel.list.count > 0) {
            [weakSelf.dataArrM addObjectsFromArray:StoreModel.list];
            [weakSelf.home_table.mj_footer endRefreshing];
        }else{
            [weakSelf.home_table.mj_footer endRefreshingWithNoMoreData];
        }
        [weakSelf.home_table.mj_header endRefreshing];
        GLD_StoreDetailModel *model = [GLD_StoreDetailModel new];
        model.storeImg = @"http://www.hhlmcn.com:8080/img/hhlm_bailongma.png,http://www.hhlmcn.com:8080/img/hhlm_bailongma.png";
        model.storeName = @"name";
        model.storeDetail = @"http://www.hhlmcn.com:8080/img/hhlm_bailongma.pnghttp://www.hhlmcn.com:8080/img/hhlm_bailongma.png";
        [weakSelf.dataArrM addObject:model];
        [weakSelf.home_table reloadData];
    }];
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
    GLD_GoodsDetailController *detailVc = [[GLD_GoodsDetailController alloc]init];
    detailVc.storeModel = self.dataArrM[indexPath.row];
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
        table.mj_footer = [YXFooterRefresh footerWithRefreshingBlock:^{
            [weakSelf getStoreListData];
            
        }];
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
