//
//  LBFishViewController.m
//  XianYu
//
//  Created by li  bo on 16/5/28.
//  Copyright © 2016年 li  bo. All rights reserved.
//

#import "LBFishViewController.h"
#import "GLD_CustomBut.h"
#import "GLD_SearchController.h"
#import "GLD_CityListController.h"
#import <MapKit/MapKit.h>
#import "MapNavigationManager.h"
#import "GLD_LocationHelp.h"
#import "GLD_BusnessModel.h"
#import "GLD_BusinessCell.h"
#import "GLD_BusinessDetailController.h"

@interface LBFishViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak)GLD_CustomBut *locationBut;
@property (nonatomic, copy)NSString *locationStr;
@property (nonatomic, strong)GLD_BusnessLisModel *busnessListModel;
@property (nonatomic, copy)UITableView *home_table;
@property (nonatomic, strong)GLD_NetworkAPIManager *netManager;

@property (nonatomic, strong)NSMutableArray *dataArrM;
@end

@implementation LBFishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.netManager = [GLD_NetworkAPIManager new];
    
    //导航到深圳火车站
    [self setNavUi];
    [self getbusnessList:2];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArrM.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self getBusinessCell:indexPath];
}
-  (void)getbusnessList :(NSInteger)type{//0(推荐门店)、1(最新开通)、2(附近门店)
    WS(weakSelf);
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    config.requestType = gld_networkRequestTypePOST;
    config.urlPath = @"api/main/shopList";
    config.requestParameters = @{
                                 @"type" : @(type),
                                 @"city":@"北京",
                                 @"lat:":[NSString stringWithFormat:@"%lf",[AppDelegate shareDelegate].placemark.location.coordinate.latitude],
                                 @"lng:" : [NSString stringWithFormat:@"%lf",[AppDelegate shareDelegate].placemark.location.coordinate.longitude]
                                 };
    
    
    [self.netManager dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
        
        weakSelf.busnessListModel = [[GLD_BusnessLisModel alloc] initWithDictionary:result error:nil];
        [weakSelf.home_table.mj_header endRefreshing];
        [weakSelf.home_table.mj_footer endRefreshing];
        [weakSelf.dataArrM addObjectsFromArray:weakSelf.busnessListModel.shop];
        [weakSelf.home_table reloadData];
    }];
}
- (GLD_BusinessCell *)getBusinessCell:(NSIndexPath *)indexPath{
    GLD_BusinessCell *cell = [self.home_table dequeueReusableCellWithIdentifier:GLD_BusinessCellIdentifier];
    cell.model = self.dataArrM[indexPath.row];
    return cell;
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
    detaileVc.busnessModel = self.dataArrM[indexPath.row];
    [self.navigationController pushViewController:detaileVc animated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    if([AppDelegate shareDelegate].placemark){
        [self.locationBut title:[AppDelegate shareDelegate].placemark.locality];
    }else{
        [self.locationBut title:@"定位失败"];
    }
}
- (void)setNavUi{
    GLD_CustomBut *locationBut = [[GLD_CustomBut alloc]init];;
    self.locationBut = locationBut;
    
    locationBut.frame = CGRectMake(0, 0, 50, 44);
    [locationBut image:@"更多"];
    [locationBut addTarget:self action:@selector(mapNav) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:locationBut];
    self.navigationItem.leftBarButtonItem = item;
    
    UIButton *titleBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleBut setTitle:@"搜索" forState:UIControlStateNormal];
    [titleBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [titleBut setImage:WTImage(@"搜索-搜索") forState:UIControlStateNormal];
    titleBut.frame = CGRectMake(0, 0, 150, 40);
    titleBut.layer.cornerRadius = 20;
    titleBut.layer.masksToBounds = YES;
    [titleBut addTarget:self action:@selector(SearchCLick) forControlEvents:UIControlEventTouchUpInside];
    titleBut.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleBut;
    
    GLD_CustomBut *rightBut = [[GLD_CustomBut alloc]init];;
    
    rightBut.frame = CGRectMake(0, 0, 50, 44);
    [rightBut image:@"消息"];
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithCustomView:rightBut];
    self.navigationItem.rightBarButtonItem = item1;
    
}
//搜索
- (void)SearchCLick{
    GLD_SearchController *searchVc = [GLD_SearchController new];
    [self.navigationController pushViewController:searchVc animated:YES];
}
//城市列表
- (void)mapNav{
    GLD_CityListController *cityList = [GLD_CityListController new];
    cityList.locationCity = self.locationStr;
    WS(weakSelf);
    cityList.cityListBlock = ^(NSString *name) {
        [weakSelf.locationBut title:name];
    };
    [self.navigationController pushViewController:cityList animated:YES];
    
}


- (UITableView *)home_table{
    if (!_home_table) {
        UITableView *table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.view addSubview:table];
        table.delegate = self;
        table.dataSource = self;
        table.estimatedRowHeight = 0;
        table.estimatedSectionHeaderHeight = 0;
        table.estimatedSectionFooterHeight = 0;
        [table setSeparatorInset:UIEdgeInsetsMake(0, W(15), 0, W(15))];
        [table mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        WS(weakSelf);
        table.mj_footer = [YXFooterRefresh footerWithRefreshingBlock:^{
            [weakSelf getbusnessList:2];
        }];
        table.mj_header = [GLD_RefreshHeader headerWithRefreshingBlock:^{
            [weakSelf.dataArrM removeAllObjects];
            [weakSelf getbusnessList:2];
        }];
        table.rowHeight = W(100);
        [table registerClass:[GLD_BusinessCell class] forCellReuseIdentifier:GLD_BusinessCellIdentifier];
        _home_table = table;
    }
    return _home_table;
}
//定位

- (NSMutableArray *)dataArrM{
    if (!_dataArrM) {
        _dataArrM = [NSMutableArray array];
    }
    return _dataArrM;
}

@end
