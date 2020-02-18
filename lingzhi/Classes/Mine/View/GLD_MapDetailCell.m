//
//  GLD_MapDetailCell.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/7.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_MapDetailCell.h"
#import "GLD_SearchResultCell.h"

#import "GLD_MapModel.h"


#define cellHeight W(80)
#define GEORGIA_TECH_LATITUDE +39.86576800
#define GEORGIA_TECH_LONGITUDE +116.46185600

#define ZOOM_LEVEL 1
NSString *const GLD_MapDetailCellIdentifier = @"GLD_MapDetailCellIdentifier";
@interface GLD_MapDetailCell ()<UITableViewDelegate, UITableViewDataSource,MAMapViewDelegate,AMapSearchDelegate>

@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UITextField *keyWordField;
@property (nonatomic, strong)UIButton *searchBut;
@property (nonatomic, strong)UIView *lineView;
@property (nonatomic, copy)NSArray *dataArr;
//高德地图
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)AMapSearchAPI *searchAPI;
@end

@implementation GLD_MapDetailCell

- (void)nextButClick{
    if (!IsExist_String(self.keyWordField.text)) {
        [CAToast showWithText:@"请输入地址"];
        return;
    }
    
    [self.keyWordField resignFirstResponder];
    [self setAddrssKeyWord:self.keyWordField.text];
}

- (void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    [self.tableView reloadData];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(self.dataArr.count * cellHeight));
    }];
    if ([self.mapDelegate respondsToSelector:@selector(reloadApplyListHeight:)]) {
        [self.mapDelegate reloadApplyListHeight:(W(260) + self.dataArr.count * cellHeight)];
    }
}

- (void)setBusnessModel:(GLD_BusnessModel *)busnessModel{
    _busnessModel = busnessModel;
    if (busnessModel) {
        self.keyWordField.text = busnessModel.address;
        AMapPOI *p = [AMapPOI new];
        p.location.latitude = busnessModel.xpoint.floatValue;
        p.location.longitude = busnessModel.ypoint.floatValue;
        p.address = busnessModel.address;
        p.name = busnessModel.address;
        [self didSelectedMapPOI:p];
    }
}
-(void)setAddrssKeyWord:(NSString *)addrssKeyWord
{
    
    //发起输入提示搜索
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];//附近
    AMapPOIKeywordsSearchRequest *requestKey = [[AMapPOIKeywordsSearchRequest alloc]init];
    
   
    //关键字
    requestKey.keywords = addrssKeyWord;
    // types属性表示限定搜索POI的类别，默认为：餐饮服务|商务住宅|生活服务
    // POI的类型共分为20种大类别，分别为：
    // 汽车服务|汽车销售|汽车维修|摩托车服务|餐饮服务|购物服务|生活服务|体育休闲服务|
    // 医疗保健服务|住宿服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|
    // 交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施
    //    request.types = @"餐饮服务|生活服务";
    request.radius =  5000;///< 查询半径，范围：0-50000，单位：米 [default = 3000]
    request.sortrule = 0;
    requestKey.requireExtension = YES;
    requestKey.requireSubPOIs      = YES;
    //发起周边搜索
//    [self.searchAPI AMapPOIAroundSearch:request];
    [self.searchAPI AMapPOIKeywordsSearch:requestKey];
}

//实现POI搜索对应的回调函数
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    //通过 AMapPOISearchResponse 对象处理搜索结果
    NSString *strCount = [NSString stringWithFormat:@"count: %ld",response.count];
    if (response.count == 0) {
        [CAToast showWithText: @"没有搜索出结果，请换个关键词搜索"];
        self.keyWordField.text = @"";
//        [self.keyWordField becomeFirstResponder];
        return;
    }else{
    [CAToast showWithText: [NSString stringWithFormat:@"搜索出%zd个结果",response.count]];
    }
    NSString *strSuggestion = [NSString stringWithFormat:@"Suggestion: %@", response.suggestion];
    NSString *strPoi = @"";
    for (int i = 0; i < response.pois.count; i++) {
        AMapPOI *p = response.pois[i];
        MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
        CLLocationCoordinate2D coordinate ;
        coordinate.latitude = p.location.latitude;
        coordinate.longitude = p.location.longitude;
        pointAnnotation.coordinate = coordinate;
        pointAnnotation.title = p.name;
        pointAnnotation.subtitle = p.tel;
        [_mapView addAnnotation:pointAnnotation];
        if (i == 0) {
            [_mapView selectAnnotation:pointAnnotation animated:YES];
        }
    }
   
    NSString *result = [NSString stringWithFormat:@"%@ \n %@ \n %@", strCount, strSuggestion, strPoi];
    NSLog(@"Place: %@", result);
    self.dataArr = response.pois;
}


//添加大头针
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{
    NSLog(@"%@", view.annotation.title);
    for (int i = 0; i < self.dataArr.count; i++) {
        AMapPOI *p = self.dataArr[i];
        if ([p.name isEqualToString:view.annotation.title]) {
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
            if ([self.mapDelegate respondsToSelector:@selector(selectLocation:)]) {
                [self.mapDelegate selectLocation:p];
                self.keyWordField.text = p.address;
            }
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AMapPOI *p = self.dataArr[indexPath.row];
    [self didSelectedMapPOI:p];
}
- (void)didSelectedMapPOI:(AMapPOI *)p{
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    CLLocationCoordinate2D coordinate ;
    coordinate.latitude = p.location.latitude;
    coordinate.longitude = p.location.longitude;
    pointAnnotation.coordinate = coordinate;
    pointAnnotation.title = p.name;
    pointAnnotation.subtitle = p.tel;
    [_mapView addAnnotation:pointAnnotation];
    [self.mapView selectAnnotation:pointAnnotation animated:YES];
    if ([self.mapDelegate respondsToSelector:@selector(selectLocation:)]) {
        [self.mapDelegate selectLocation:p];
    }
}
//大头针的回调
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    
    /* 自定义userLocation对应的annotationView. */
    if ([annotation isKindOfClass:[MAUserLocation class]])
    {
        static NSString *userLocationStyleReuseIndetifier = @"userLocationStyleReuseIndetifier";
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:userLocationStyleReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:userLocationStyleReuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"userPosition"];
        
        return annotationView;
    }
    
    //大头针
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorPurple;
        
        return annotationView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHeight;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GLD_SearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:GLD_SearchResultCellIdentifier];
    cell.item = self.dataArr[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (void)setupUI {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.keyWordField];
    [self.contentView addSubview:self.searchBut];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.mapView];
    [self.contentView addSubview:self.tableView];
   

}

- (void)layout{

    // Configure the view for the selected state
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(W(15));
        make.width.equalTo(WIDTH(80));
    }];
    [self.searchBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.right.equalTo(self.contentView).offset(W(-15));
        make.height.equalTo(WIDTH(40));
        make.width.equalTo(WIDTH(40));
    }];
    
    [self.keyWordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.right.equalTo(self.searchBut.mas_left);
        make.left.equalTo(self.titleLabel.mas_right);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.titleLabel).offset(W(15));
        make.right.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(W(15));
        make.height.equalTo(@(1));
    }];
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(W(15));
        make.top.equalTo(self.lineView).offset(W(5));
        make.right.equalTo(self.contentView).offset(W(-15));
        make.height.equalTo(WIDTH(200));
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.mapView);
        make.top.equalTo(self.mapView.mas_bottom);
        make.height.equalTo(@(0.01));
        make.centerX.equalTo(self.mapView);
    }];
}



- (UITextField *)keyWordField{
    if (!_keyWordField) {
        UITextField *textField = [[UITextField alloc]init];
        textField.backgroundColor = [UIColor clearColor];
        textField.font = [UIFont systemFontOfSize:16.0f];
        textField.textAlignment = NSTextAlignmentRight;
        textField.textColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTnewGray];
        if (IsExist_String([AppDelegate shareDelegate].userAddress)) {
            textField.text = [AppDelegate shareDelegate].userAddress;
        }else{
            textField.placeholder = @"请输入";
            
        }
        _keyWordField = textField;
    }
    return _keyWordField;
}
- (UIButton *)searchBut{
    if (!_searchBut) {
        UIButton *nextBut = [[UIButton alloc]init];
        _searchBut = nextBut;
    
        [nextBut addTarget:self action:@selector(nextButClick) forControlEvents:UIControlEventTouchUpInside];
        [nextBut setImage:WTImage(@"搜索-搜索") forState:UIControlStateNormal];
    }
    return _searchBut;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.text = @"详细地址";
        _titleLabel.font = WTFont(16);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTBLACK];
    }
    return _titleLabel;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [YXUniversal colorWithHexString:@"#EBEBEB"];
    }
    return _lineView;
}
- (MAMapView *)mapView {
    if (!_mapView) {
        _mapView = [[MAMapView alloc] initWithFrame:self.bounds];
        [_mapView setShowsScale:NO];
        [_mapView setShowsCompass:NO];
        [_mapView setRotateEnabled:NO];
        [_mapView setDelegate:self];
        [_mapView setShowsUserLocation:YES];
        [_mapView setUserTrackingMode:MAUserTrackingModeNone animated:YES];
        [_mapView setZoomLevel:11];
        _mapView.desiredAccuracy = kCLLocationAccuracyBest;
        [_mapView setCustomizeUserLocationAccuracyCircleRepresentation:YES];//自定义用户精度圈
        //后台定位
//        self.keyWordField.text = _mapView.userLocation.
        [self addSubview:_mapView];
    }
    return _mapView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView = tableView;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        [tableView setSeparatorInset:UIEdgeInsetsMake(0, W(15), 0, W(15))];
        tableView.mj_insetB = W(80);
        tableView.scrollEnabled = NO;
        //        tableView.rowHeight = 0;
        tableView.sectionFooterHeight = 0.001;
        [tableView registerClass:[GLD_SearchResultCell class] forCellReuseIdentifier:GLD_SearchResultCellIdentifier];
    }
    return _tableView;
}

- (AMapSearchAPI *)searchAPI {
    if (!_searchAPI) {
        _searchAPI = [[AMapSearchAPI alloc]init];
        _searchAPI.delegate = self;
    }
    return _searchAPI;
}
@end
