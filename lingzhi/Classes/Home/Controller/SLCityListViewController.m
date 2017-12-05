//
//  SLCityListViewController.m
//  SLCityListSearchDemo
//
//  Created by 武传亮 on 2017/6/26.
//  Copyright © 2017年 武传亮. All rights reserved.
//

#import "SLCityListViewController.h"



@interface SLCityListViewController ()<UITableViewDelegate, UITableViewDataSource>


/** 列表视图 */
@property (strong, nonatomic) UITableView *tableView;

/** 区头数组 */
@property (strong, nonatomic) NSMutableArray *sectionArray;
/** 分区中心动画label */
@property (strong, nonatomic) UILabel *sectionTitle;
/** 定位城市ID */
@property (assign, nonatomic) NSInteger Id;


@end


#define kSectionTitleWidth 50
#define kTimeInterval 1



@implementation SLCityListViewController

#pragma mark -- 懒加载
// 区头数组
- (NSMutableArray *)sectionArray {
    if (!_sectionArray) {
        _sectionArray = [NSMutableArray new];
        for (GLD_CityListModel *cityList in self.cityModel.list) {
            [_sectionArray addObject:cityList.initial];
        }
        [_sectionArray insertObject:@"热门" atIndex:0];
    }
    return _sectionArray;
}

// 分区动画标题
- (UILabel *)sectionTitle {
    if (!_sectionTitle) {
        _sectionTitle = [UILabel new];
        _sectionTitle.backgroundColor = [UIColor redColor];
        _sectionTitle.textColor = [UIColor whiteColor];
        _sectionTitle.layer.cornerRadius = kSectionTitleWidth / 2.0;
        _sectionTitle.layer.masksToBounds = YES;
        _sectionTitle.alpha = 0;
        _sectionTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _sectionTitle;
}

- (GLD_CityMainModel *)cityModel {
    if (!_cityModel) {
//        NSString *path = [[NSBundle mainBundle] pathForResource:kCityData ofType:nil];
//        NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:path];
//        _cityModel = [SLCityModel mj_objectWithKeyValues:data];
    }
    return _cityModel;
}



- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40 + 64, DEVICE_WIDTH, DEVICE_HEIGHT - 64 - 40) style:UITableViewStylePlain];
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
    // 动画
    [self sectionAnimationView];

}

#pragma mark -- 设置navigationBar
- (void)setupNavigationBar {
    
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    // 设置标题
    self.navigationItem.title = self.cityModel.selectedCityId? [NSString stringWithFormat:@"当前选择-%@", self.cityModel.selectedCity]: @"选择城市";
    [self selectdeCity];
}
- (void)selectdeCity {
    
    // 遍历选择
    for (GLD_CityListModel *cityList in self.cityModel.list) {
        for (GLD_CityModel *city in cityList.citys) {
            
            if (city.Id == self.cityModel.selectedCityId) {
                city.selected = YES;
            } else {
                city.selected = NO;
            }
        }
    }
    
    
}

#pragma mark -- 定位
/// 定位选择
- (void)locationCitySelected:(UIButton *)button {

    if (_delegate && [_delegate respondsToSelector:@selector(sl_cityListSelectedCity:Id:)]) {
        
        [_delegate sl_cityListSelectedCity:button.titleLabel.text Id:self.Id];
        
    }
    [self dismissViewControllerAnimated:YES completion:nil];

}




#pragma mark -- 分区中心动画视图添加
- (void)sectionAnimationView {
    [self.tableView.superview addSubview:self.sectionTitle];
    [self.sectionTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.tableView.superview);
        make.width.height.mas_equalTo(kSectionTitleWidth);
    }];
}


#pragma mark -- tableView 的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    GLD_CityListModel *model = self.cityModel.list[section - 1];
    return section? model.citys.count: 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
//    SLCityListCell *cell = [tableView dequeueReusableCellWithIdentifier:cityListCell forIndexPath:indexPath];
//    cell.city = self.cityModel.list[indexPath.section - 1].citys[indexPath.row];
    
    return [UITableViewCell new ];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return indexPath.section? 33: self.cityModel.hotCellH;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    return self.sectionArray;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return section? 18: 0.;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) return;
    
    if (_delegate && [_delegate respondsToSelector:@selector(sl_cityListSelectedCity:Id:)]) {
        
//        SLCity *city = self.cityModel.list[indexPath.section - 1].citys[indexPath.row];
//        [_delegate sl_cityListSelectedCity:city.name Id:city.Id];
//
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)dealloc {
    
}

@end
