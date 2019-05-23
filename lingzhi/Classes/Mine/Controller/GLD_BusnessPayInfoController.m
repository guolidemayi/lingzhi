//
//  GLD_BusnessPayInfoController.m
//  lingzhi
//
//  Created by yiyangkeji on 2018/7/3.
//  Copyright © 2018年 com.lingzhi. All rights reserved.
//

#import "GLD_BusnessPayInfoController.h"
#import "GLD_BusnessOrderCell.h"


@interface GLD_BusnessPayInfoController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *table_apply;
@property (nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic, strong)GLD_NetworkAPIManager *NetManager;
@end

@implementation GLD_BusnessPayInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.table_apply];
    
    [self.table_apply mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.equalTo(self.view);
        make.top.equalTo(self.view);
    }];
    self.dataArr = [NSMutableArray array];
    self.title = @"商家明细";
      self.NetManager = [GLD_NetworkAPIManager shareNetManager];
    [self getOrderList];
}
- (void)getOrderList{
    WS(weakSelf);
    NSInteger offset = self.dataArr.count;
    
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    config.requestType = gld_networkRequestTypePOST;
    config.urlPath = @"api/order/getShopOrderList";
    config.requestParameters = @{@"userId" : GetString([AppDelegate shareDelegate].userModel.userId),
                                 @"limit" : @"10",
                                 @"offset" : [NSString stringWithFormat:@"%zd",offset]
                                 };
    
    [self.NetManager dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
        if (!error) {
            GLD_OrderModelListModel *orderListModel = [[GLD_OrderModelListModel alloc] initWithDictionary:result error:nil];
            if (orderListModel.data.count == 0 && !IsExist_Array(weakSelf.dataArr)) {
                weakSelf.noDataLabel.text = @"暂无订单消息";
                weakSelf.noDataLabel.hidden = NO;
                [weakSelf.view bringSubviewToFront:weakSelf.noDataLabel];
            }else{
                weakSelf.noDataLabel.hidden = YES;
            }
            [weakSelf.dataArr addObjectsFromArray:orderListModel.data];
            
            
        }else{
            [CAToast showWithText:@"请求失败，请重试"];
        }
        [weakSelf.table_apply reloadData];
        [weakSelf.table_apply.mj_footer endRefreshing];
        [weakSelf.table_apply.mj_header endRefreshing];
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return W(10);
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self getMyorderCell:indexPath];
}
- (GLD_BusnessOrderCell *)getMyorderCell:(NSIndexPath *)indexPath{
    GLD_BusnessOrderCell *cell = [self.table_apply dequeueReusableCellWithIdentifier:@"GLD_BusnessOrderCell"];
    
    cell.orderModel = self.dataArr[indexPath.section];
    return cell;
}

- (UITableView *)table_apply{
    if (!_table_apply) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        self.table_apply = tableView;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        [tableView setSeparatorInset:UIEdgeInsetsMake(0, W(15), 0, W(15))];
        tableView.rowHeight = 200;
        
        [tableView registerNib:[UINib nibWithNibName:@"GLD_BusnessOrderCell" bundle:nil] forCellReuseIdentifier:@"GLD_BusnessOrderCell"];
        //        tableView.rowHeight = 0;
        WS(weakSelf);
        tableView.mj_header = [GLD_RefreshHeader headerWithRefreshingBlock:^{
            [weakSelf.dataArr removeAllObjects];
            [weakSelf getOrderList];
        }];
        tableView.mj_footer = [YXFooterRefresh footerWithRefreshingBlock:^{
            [weakSelf getOrderList];
        }];
        tableView.sectionFooterHeight = 0.001;
    }
    return _table_apply;
}
@end
