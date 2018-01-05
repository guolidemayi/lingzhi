//
//  GLD_CityListController.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/4.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_CityListController.h"
#import "GLD_CityModel.h"

@interface GLD_CityListController ()<UITableViewDelegate, UITableViewDataSource>
/** 列表视图 */
@property (strong, nonatomic) UITableView *tableView;

/** 区头数组 */
@property (copy, nonatomic) NSArray *sectionArray;

/** 区头数组 */
@property (copy, nonatomic) NSDictionary *dataDict;
/** 定位城市ID */
@property (assign, nonatomic) NSInteger Id;
@property (nonatomic, strong)GLD_NetworkAPIManager *NetManager;
@end

@implementation GLD_CityListController


- (void)setupTopView{
    
    UILabel *titleL = [[UILabel alloc]init];
    titleL = [UILabel new];
    titleL.font = WTFont(12);
    titleL.text = @"定位城市";
    titleL.textAlignment = NSTextAlignmentLeft;
    titleL.textColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTBLACK];
    [self.view addSubview:titleL];
    [ titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.view).offset(W(10));
    }];
    
    UIButton *locationBut = [[UIButton alloc]init];
    [locationBut setTitle:self.locationCity forState:UIControlStateNormal];
    [locationBut setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKwirte] forState:UIControlStateNormal];
    [locationBut setImage:WTImage(@"定位") forState:UIControlStateNormal];
    locationBut.titleLabel.font = WTFont(15);
    locationBut.backgroundColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTTopLine];
    locationBut.layer.cornerRadius = 3;
    locationBut.layer.masksToBounds = YES;
    [self.view addSubview:locationBut];
    [locationBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleL.mas_bottom).offset(W(5));
        make.left.equalTo(titleL);
    }];
    
    [self getbusnessList];
}

-  (void)getbusnessList {
    self.NetManager = [GLD_NetworkAPIManager new];
    WS(weakSelf);
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    config.requestType = gld_networkRequestTypePOST;
    config.urlPath = @"api/main/city";
    
    
    [self.NetManager dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
        if (!error) {
            weakSelf.dataDict = result[@"data"];
            weakSelf.sectionArray = [weakSelf.dataDict.allKeys sortedArrayUsingSelector:@selector(compare:)];
            [weakSelf.tableView reloadData];
        }
        
    }];
}



- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, DEVICE_WIDTH, DEVICE_HEIGHT-60) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.sectionIndexBackgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0];
        _tableView.sectionIndexColor = [UIColor blueColor];
        
    }
    return _tableView;
}


#pragma mark -- 视图加载
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置navigationBar
    [self setupNavigationBar];
    self.view .backgroundColor = [UIColor whiteColor];
    [self setupTopView];
    // 定位方法
    //    [self locationAction:self.cityLocationView];
 
    [self.view addSubview:self.tableView];
    
    // 定位索引图片
    UIImageView *locationImageView = [UIImageView new];
    locationImageView.image = [UIImage imageNamed:@"location"];
    [self.view addSubview:locationImageView];
    CGFloat centerOffset = self.sectionArray.count * 13 / 2.5;
    [locationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-3.5);
        make.width.height.mas_equalTo(20);
        make.centerY.equalTo(self.view.mas_centerY).offset(-centerOffset);
    }];
   
    
}

#pragma mark -- 设置navigationBar
- (void)setupNavigationBar {
    
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    // 设置标题
//    self.navigationItem.title = self.cityModel.selectedCityId? [NSString stringWithFormat:@"当前选择-%@", self.cityModel.selectedCity]: @"选择城市";
    
}


#pragma mark -- 定位
/// 定位选择
- (void)locationCitySelected:(UIButton *)button {
    
    if (_delegate && [_delegate respondsToSelector:@selector(sl_cityListSelectedCity:Id:)]) {
        
        [_delegate sl_cityListSelectedCity:button.titleLabel.text Id:self.Id];
        
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


#pragma mark -- tableView 的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
   NSArray *arr = self.dataDict[self.sectionArray[section]];
    
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    }
    cell.textLabel.font = WTFont(15);
    NSArray *arr = self.dataDict[self.sectionArray[indexPath.section]];
    NSDictionary *dict = arr[indexPath.row];
    cell.textLabel.text = dict[@"city"];
    //    SLCityListCell *cell = [tableView dequeueReusableCellWithIdentifier:cityListCell forIndexPath:indexPath];
    //    cell.city = self.cityModel.list[indexPath.section - 1].citys[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return W(44);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return W(30);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UITableViewHeaderFooterView *header = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:@"sysHeaderView"];
    if (header == nil) {
        header = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:@"sysHeaderView"];
    }
    UILabel *titleLabel = [UILabel creatLableWithText:@"" andFont:WTFont(12) textAlignment:NSTextAlignmentLeft textColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKBLUE]];
    [header.contentView addSubview:titleLabel];
    titleLabel.frame = CGRectMake(15, 0, 100, W(30));
    titleLabel.text = self.sectionArray[section];
    return header;
}
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    return self.sectionArray;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *arr = self.dataDict[self.sectionArray[indexPath.section]];
    NSDictionary *dict = arr[indexPath.row];
    
    if (self.cityListBlock) {
        GLD_CityModel *placemar = [GLD_CityModel new];
        placemar.area_name = dict[@"city"];
        placemar.lat = [dict[@"Lat"] floatValue];
        placemar.lon = [dict[@"Lng"] floatValue];
        self.cityListBlock(placemar);
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (indexPath.section == 0) return;
    
    if (_delegate && [_delegate respondsToSelector:@selector(sl_cityListSelectedCity:Id:)]) {
        
        //        SLCity *city = self.cityModel.list[indexPath.section - 1].citys[indexPath.row];
        //        [_delegate sl_cityListSelectedCity:city.name Id:city.Id];
        //
    }
    
//    [self dismissViewControllerAnimated:YES completion:nil];
    
}


@end
