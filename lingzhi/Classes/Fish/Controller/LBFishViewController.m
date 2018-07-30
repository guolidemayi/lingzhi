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
#import "SDCycleScrollView.h"
#import "GLD_BannerDetailController.h"
#import "GLD_BannerModel.h"
#import "GLD_StoreCell.h"

@interface LBFishViewController ()<UITableViewDelegate, UITableViewDataSource,SDCycleScrollViewDelegate>
@property (nonatomic, weak)GLD_CustomBut *locationBut;
@property (nonatomic, copy)NSString *locationStr;
@property (nonatomic, strong)GLD_BusnessLisModel *busnessListModel;
@property (nonatomic, copy)UITableView *home_table;
@property (nonatomic, strong)GLD_NetworkAPIManager *netManager;

@property (nonatomic, strong)NSMutableArray *dataArrM;

//banner

@property (nonatomic, strong)SDCycleScrollView *cycleView;
@property (nonatomic, strong)GLD_BannerLisModel *bannerListModel;
@end

@implementation LBFishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.home_table];
    self.netManager = [GLD_NetworkAPIManager new];
    //导航到深圳火车站
    [self setNavUi];
   
    [self getBannerData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) return 1;
    return self.dataArrM.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) return [self getStoreCell:indexPath];
    return [self getBusinessCell:indexPath];
}
-  (void)getbusnessList :(NSInteger)type{//0(推荐门店)、1(最新开通)、2(附近门店)
    WS(weakSelf);
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    config.requestType = gld_networkRequestTypePOST;
    config.urlPath = @"api/main/shopList";
    config.requestParameters = @{
                                 @"type" : @(type),
                                 @"city":[AppDelegate shareDelegate].placemark.area_name ? [AppDelegate shareDelegate].placemark.area_name:@"衡水",
                                 @"lat:":[NSString stringWithFormat:@"%lf",[AppDelegate shareDelegate].placemark.lat],
                                 @"lng:" : [NSString stringWithFormat:@"%lf",[AppDelegate shareDelegate].placemark.lon],
                                 @"limit":[NSString stringWithFormat:@"10"],
                                 @"offset" : [NSString stringWithFormat:@"%zd",self.dataArrM.count]
                                 };
    
    
    [self.netManager dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
        
        weakSelf.busnessListModel = [[GLD_BusnessLisModel alloc] initWithDictionary:result error:nil];
        [weakSelf.home_table.mj_header endRefreshing];
        [weakSelf.home_table.mj_footer endRefreshing];
        [weakSelf.dataArrM addObjectsFromArray:weakSelf.busnessListModel.data];
        [weakSelf.home_table reloadData];
    }];
}
- (GLD_StoreCell *)getStoreCell:(NSIndexPath *)indexPath{
    GLD_StoreCell *cell = [self.home_table dequeueReusableCellWithIdentifier:@"GLD_StoreCell"];
    
    return cell;
}
- (GLD_BusinessCell *)getBusinessCell:(NSIndexPath *)indexPath{
    GLD_BusinessCell *cell = [self.home_table dequeueReusableCellWithIdentifier:GLD_BusinessCellIdentifier];
    cell.model = self.dataArrM[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section > 0) return 0.01;
    return W(150);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UITableViewHeaderFooterView *headView = [UITableViewHeaderFooterView new];
    if (section > 0) return headView;
    [headView addSubview:self.cycleView];
    return headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) return H(150);
    return H(100);
}
- (void)getBannerData{
    WS(weakSelf);
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    config.requestType = gld_networkRequestTypePOST;
    config.urlPath = @"api/main/banner";
    config.requestParameters = @{@"type":@"2"};
    [self.netManager dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
        
        weakSelf.bannerListModel = [[GLD_BannerLisModel alloc] initWithDictionary:result error:nil];
        NSMutableArray *arrM = [NSMutableArray array];
        for (GLD_BannerModel *model in weakSelf.bannerListModel.data) {
            [arrM addObject:GetString(model.Pic)];
        }
        if (arrM.count > 0) {
            weakSelf.cycleView.imageURLStringsGroup = arrM.copy;
        }
        [weakSelf.home_table reloadData];
    }];
}
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"%zd", index);
    GLD_BannerDetailController *bannerVc =[GLD_BannerDetailController new];
    bannerVc.bannerModel = self.bannerListModel.data[index];
    [self.navigationController pushViewController:bannerVc animated:YES];
}
- (SDCycleScrollView *)cycleView{
    if (!_cycleView) {
        _cycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero
                                                        delegate:self
                                                placeholderImage:[UIImage imageNamed:@"tabbar_icon0_normal"]];
        
        
        _cycleView.autoScrollTimeInterval = 3;// 自动滚动时间间隔
        _cycleView.autoScroll = YES;
        _cycleView.frame = CGRectMake(0, 0, DEVICE_WIDTH, W(150));
        //        _cycleView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;// 翻页 右下角
    }
    return _cycleView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLD_BusinessDetailController *detaileVc = [GLD_BusinessDetailController new];
    detaileVc.busnessModel = self.dataArrM[indexPath.row];
    [self.navigationController pushViewController:detaileVc animated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if([AppDelegate shareDelegate].placemark){
        [self.locationBut title:[AppDelegate shareDelegate].placemark.area_name];
    }else{
        [self.locationBut title:@"定位失败"];
    }
    if(!IsExist_Array(self.dataArrM))
    [self getbusnessList:2];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)setNavUi{
    GLD_CustomBut *locationBut = [[GLD_CustomBut alloc]init];;
    self.locationBut = locationBut;
    [locationBut setTitle:@"ddddddd" forState:UIControlStateNormal];
    [locationBut setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    locationBut.frame = CGRectMake(0, 0, 50, 44);
    [locationBut image:@"更多"];
    [locationBut addTarget:self action:@selector(mapNav) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:locationBut];
    self.navigationItem.leftBarButtonItem = item;
    
    UIButton *titleBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleBut setTitle:@"搜索" forState:UIControlStateNormal];
    [titleBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [titleBut setImage:WTImage(@"搜索-搜索") forState:UIControlStateNormal];
    titleBut.frame = CGRectMake(0, 0, W(180), W(30));
    titleBut.layer.cornerRadius = W(15);
    titleBut.layer.masksToBounds = YES;
    [titleBut addTarget:self action:@selector(SearchCLick) forControlEvents:UIControlEventTouchUpInside];
    titleBut.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleBut;
    
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
    cityList.cityListBlock = ^(GLD_CityModel *placemar) {
        [weakSelf.locationBut title:placemar.area_name];
        //        weakSelf.locationStr = name;
        [AppDelegate shareDelegate].placemark = placemar;
        [weakSelf getbusnessList:2];
    };
    [self.navigationController pushViewController:cityList animated:YES];
    
}


- (UITableView *)home_table{
    if (!_home_table) {
        UITableView *table = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        
        table.delegate = self;
        table.dataSource = self;
        table.estimatedRowHeight = 0;
        table.estimatedSectionHeaderHeight = 0;
        table.estimatedSectionFooterHeight = 0;
        [table setSeparatorInset:UIEdgeInsetsMake(0, W(15), 0, W(15))];
//        [table mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self.view);
//        }];
        WS(weakSelf);
        table.mj_footer = [YXFooterRefresh footerWithRefreshingBlock:^{
            [weakSelf getbusnessList:2];
            
        }];
        table.mj_header = [GLD_RefreshHeader headerWithRefreshingBlock:^{
            [weakSelf.dataArrM removeAllObjects];
            weakSelf.bannerListModel = nil;
            [weakSelf getBannerData];
            [weakSelf getbusnessList:2];
        }];
//        table.rowHeight = W(100);
        [table registerClass:[GLD_BusinessCell class] forCellReuseIdentifier:GLD_BusinessCellIdentifier];
        [table registerNib:[UINib nibWithNibName:@"GLD_StoreCell" bundle:nil] forCellReuseIdentifier:@"GLD_StoreCell"];
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
