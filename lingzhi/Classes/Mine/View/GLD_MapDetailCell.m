//
//  GLD_MapDetailCell.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/7.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_MapDetailCell.h"
#import "GLD_SearchResultCell.h"
#import "MKMapView+ZoomLevel.h"
#import "GLD_MapModel.h"

#define cellHeight W(80)
#define GEORGIA_TECH_LATITUDE +39.86576800
#define GEORGIA_TECH_LONGITUDE +116.46185600

#define ZOOM_LEVEL 1
NSString *const GLD_MapDetailCellIdentifier = @"GLD_MapDetailCellIdentifier";
@interface GLD_MapDetailCell ()<MKMapViewDelegate,UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UITextField *keyWordField;
@property (nonatomic, strong)UIButton *searchBut;
@property (nonatomic, strong)UIView *lineView;
@property (nonatomic,strong)MKMapView *mapView;
@property (nonatomic, strong)UITableView *tableView;
@end

@implementation GLD_MapDetailCell

- (void)nextButClick{
    [self searchData:self.keyWordField.text];
}
- (void)searchData:(NSString *)data {
    
    CLLocationCoordinate2D tocoor = CLLocationCoordinate2DMake(25.02583306, 102.72613118);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(tocoor, 5000, 5000);
    
    MKLocalSearchRequest * req = [[MKLocalSearchRequest alloc]init];
    req.region = region ;
    req.naturalLanguageQuery = data ;
    MKLocalSearch *ser = [[MKLocalSearch alloc]initWithRequest:req];
    WS(weakSelf);
    [ser startWithCompletionHandler:^(MKLocalSearchResponse * _Nullable response, NSError * _Nullable error) {
        NSArray *array = [NSArray arrayWithArray:response.mapItems];
        NSLog(@"%@",array);
        for (int i=0; i<array.count; i++) {
            MKMapItem * item=array[i];
            MKPointAnnotation * point = [[MKPointAnnotation alloc]init];
            point.title=item.name;
            point.subtitle=item.phoneNumber;
            point.coordinate=item.placemark.coordinate;
            
            [_mapView addAnnotation:point];
            // 显示第一大头针的头部视图
            if (i == 0) {
                [_mapView selectAnnotation:point animated:YES];
            }
            
            
        }
        weakSelf.dataArr = array;
    }];
    
}
- (void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    [self.tableView reloadData];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(self.dataArr.count * cellHeight));
    }];
}


#pragma mark - MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    if ([annotation isKindOfClass:[MKPointAnnotation class]]) {
        
        MKPinAnnotationView *customPinView = (MKPinAnnotationView*)[mapView  dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        if (!customPinView){
            
            customPinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                            reuseIdentifier:@"CustomPinAnnotationView"];
        }
        
//        customPinView.pinTintColor = [UIColor redColor];
//        customPinView.animatesDrop = YES;
//        customPinView.canShowCallout = YES;
//        customPinView.selected = YES ;
//        customPinView.animatesDrop = YES ;
//        customPinView.userInteractionEnabled = YES ;
//        customPinView.animatesDrop = YES ;
//        UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60 *1.25, 60)];
//        rightButton.backgroundColor = [UIColor whiteColor];
//        
//        [rightButton setBackgroundImage:[UIImage imageNamed:@"map_goto"] forState:UIControlStateNormal];
//        rightButton.backgroundColor = [UIColor grayColor];
//        
//        customPinView.rightCalloutAccessoryView = rightButton;
//        
        
        
        return customPinView;
        
    }
    //返回nil代表使用默认样式
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
        make.height.with.equalTo(WIDTH(30));
    }];
    
    [self.keyWordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.right.equalTo(self.searchBut.mas_left);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.titleLabel).offset(W(15));
        make.right.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(W(15));
        make.height.equalTo(@(1));
    }];
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(W(15));
        make.right.bottom.equalTo(self.contentView).offset(W(-15));
        make.height.equalTo(WIDTH(150));
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.mapView);
        make.top.equalTo(self.mapView.mas_bottom);
        make.height.equalTo(@(0.01));
    }];
}



- (UITextField *)keyWordField{
    if (!_keyWordField) {
        UITextField *textField = [[UITextField alloc]init];
        textField.backgroundColor = [UIColor clearColor];
        textField.font = [UIFont systemFontOfSize:16.0f];
        textField.textAlignment = NSTextAlignmentRight;
        textField.textColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTnewGray];
        textField.placeholder = @"请输入";
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
        _titleLabel.font = WTFont(15);
        _titleLabel.textAlignment = NSTextAlignmentRight;
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
- (MKMapView *)mapView{
    if (!_mapView) {
        _mapView = [[MKMapView alloc]init];
        _mapView.showsUserLocation = YES ;
        _mapView.showsTraffic = NO ;
        _mapView.delegate = self ;
        _mapView.showsScale = NO;
        _mapView.userInteractionEnabled = YES;
        //    _mapView.centerCoordinate = tocoor ;
//        MKCoordinateSpan span = MKCoordinateSpanMake(1, 1);
//        
//        [_mapView setRegion:MKCoordinateRegionMake(self.mapView.userLocation.coordinate, span) animated:YES];
//        // 开启定位
//        _mapView.showsUserLocation = YES;
        
        
        CLLocationCoordinate2D centerCoord = { GEORGIA_TECH_LATITUDE, GEORGIA_TECH_LONGITUDE };
        [_mapView setCenterCoordinate:centerCoord zoomLevel:ZOOM_LEVEL animated:NO];
        
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
        //        tableView.rowHeight = 0;
        tableView.sectionFooterHeight = 0.001;
        [tableView registerClass:[GLD_SearchResultCell class] forCellReuseIdentifier:GLD_SearchResultCellIdentifier];
    }
    return _tableView;
}
@end
