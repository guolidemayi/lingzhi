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
#import "GLD_BannerModel.h"
#import "GLD_IndustryModel.h"
#import "GLD_BusnessModel.h"
#import "GLD_BusinessDetailController.h"

@interface GLD_HomeViewManager ()

@property (nonatomic, strong)UIView *blueLineView;//选择列表蓝条
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong)GLD_BannerLisModel *bannerListModel;
@property (nonatomic, strong)GLD_IndustryListModel *industryListModel;
@property (nonatomic, strong)GLD_BusnessLisModel *busnessListModel;
@property (nonatomic, strong) UIButton *selecBut; //

@property (nonatomic, assign)NSInteger listType;//1 推荐  2 附近  3最新
@end
@implementation GLD_HomeViewManager

- (void)setComponentCorner{
    [self.tableView registerClass:[GLD_BannerCell class] forCellReuseIdentifier:GLD_BannerCellIdentifier];
    [self.tableView registerClass:[GLD_BusinessCell class] forCellReuseIdentifier:GLD_BusinessCellIdentifier];
    [self.tableView registerClass:[GLD_HomeListCell class] forCellReuseIdentifier:GLD_HomeListCellIdentifier];
    self.listType = 2;
}
- (void)fetchMainData{
    NSLog(@"请求首页方法了");
    
    [self getBannerData];
    [self getListData];
    [self getbusnessList:self.listType];
    
}
- (void)fetchMainUserData{
    
    WS(weakSelf);
    NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"loginToken"];
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    config.requestType = gld_networkRequestTypePOST;
    config.urlPath = @"api/user/getUserInfo";
    config.requestParameters = @{@"loginToken":GetString(str)};
    [super dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
        
        if (!error) {
            
            GLD_UserModel *model = [[GLD_UserModel alloc] initWithDictionary:result error:nil];
            
            [AppDelegate shareDelegate].userModel = model.data;
            [weakSelf.tableView reloadData];
        }
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}
- (void)getBannerData{
    WS(weakSelf);
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    config.requestType = gld_networkRequestTypePOST;
    config.urlPath = @"api/main/banner";
    config.requestParameters = @{@"type":@"1"};
    [super dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
        
        weakSelf.bannerListModel = [[GLD_BannerLisModel alloc] initWithDictionary:result error:nil];
        [weakSelf.tableView reloadData];
    }];
}
-  (void)getListData{
    WS(weakSelf);
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    config.requestType = gld_networkRequestTypePOST;
    config.urlPath = @"api/main/category";
    config.requestParameters = @{};
    [super dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
        
        weakSelf.industryListModel = [[GLD_IndustryListModel alloc] initWithDictionary:result error:nil];
        [weakSelf.tableView reloadData];
    }];
}
-  (void)getbusnessList :(NSInteger)type{//0(推荐门店)、1(最新开通)、2(附近门店)
    WS(weakSelf);
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    config.requestType = gld_networkRequestTypePOST;
    config.urlPath = @"api/main/shopList";
    config.requestParameters = @{
                                 @"type" : @(type),
                                 @"city":[AppDelegate shareDelegate].placemark.area_name ? [AppDelegate shareDelegate].placemark.area_name : @"衡水",
                                 @"lat":[NSString stringWithFormat:@"%lf",[AppDelegate shareDelegate].placemark.lat],
                                 @"lng" : [NSString stringWithFormat:@"%lf",[AppDelegate shareDelegate].placemark.lon]
                                 };
    
    
    [super dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
        
        [weakSelf.tableView.mj_header endRefreshing];
        weakSelf.busnessListModel = [[GLD_BusnessLisModel alloc] initWithDictionary:result error:nil];
        
        [weakSelf.tableView reloadData];
    }];
}
- (void)reloadOrLoadMoreData{
    [self.tableView.mj_footer endRefreshing];
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
    cell.bannerData = self.bannerListModel.data;
    return cell;
}
- (GLD_HomeListCell *)getHomeListCell:(NSIndexPath *)indexPath{
    GLD_HomeListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:GLD_HomeListCellIdentifier];
    cell.listData = self.industryListModel.data;
    return cell;
}
- (GLD_BusinessCell *)getBusinessCell:(NSIndexPath *)indexPath{
    GLD_BusinessCell *cell = [self.tableView dequeueReusableCellWithIdentifier:GLD_BusinessCellIdentifier];
    cell.model = self.busnessListModel.data[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        GLD_BusinessDetailController *detaileVc = [GLD_BusinessDetailController new];
        detaileVc.busnessModel = self.busnessListModel.data[indexPath.row];
        [self.tableView.navigationController pushViewController:detaileVc animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            if (indexPath.row == 0) {
                return W(100);
            }
            return W(180);
        }break;
            
        case 1:{
            return W(100);
        }break;
    }
    return 0.001;
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)return 2;
    return self.busnessListModel.data.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0) return [UIView new];
    
    return self.headView;
}
- (UIView *)headView{
    if (!_headView) {
        _headView = [UIView new];
        NSArray *titleArr = @[@"推荐门店",@"附近门店",@"最新开通"];
        
        for (int i = 0; i < titleArr.count; i++) {
            UIButton * button = [UIButton new];
            [button addTarget:self action:@selector(businessListClick:) forControlEvents:UIControlEventTouchUpInside];
            if (i == 1) {
                [button setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKBLUE] forState:UIControlStateNormal];
                self.selecBut = button;
            }else{
                [button setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTBLACK] forState:UIControlStateNormal];
            }
            button.tag = 201 + i;
            button.frame = CGRectMake(DEVICE_WIDTH / 3 * i, 0, DEVICE_WIDTH / 3, W(44));
            [button setTitle:titleArr[i] forState:UIControlStateNormal];
            [_headView addSubview:button];
        }
        [_headView addSubview:self.blueLineView];
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, W(43), DEVICE_WIDTH, 1)];
        lineView.backgroundColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTline2Gray];
        [_headView addSubview:lineView];
        self.blueLineView.frame = CGRectMake(DEVICE_WIDTH / 3 , W(42), DEVICE_WIDTH / 3, 2);
    }
    return _headView;
}
- (void)businessListClick:(UIButton *)senser{
    [UIView animateWithDuration:.3 animations:^{        
        self.blueLineView.mj_x = senser.mj_x;
    }];
    [self.selecBut setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTBLACK] forState:UIControlStateNormal];
    
    [senser setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKBLUE] forState:UIControlStateNormal];

    self.listType = senser.tag - 200;
    [self getbusnessList:self.listType];
    self.selecBut = senser;
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
