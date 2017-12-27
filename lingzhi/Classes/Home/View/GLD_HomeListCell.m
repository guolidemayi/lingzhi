//
//  GLD_HomeListCell.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/11/29.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_HomeListCell.h"
#import "GLD_IndustryCollecCell.h"
#import "GLD_IndustryModel.h"
#import "UIView+gldController.h"
#import "GLD_BusinessListController.h"
#import "GLD_AllCateController.h"

NSString *const GLD_HomeListCellIdentifier = @"GLD_HomeListCellIdentifier";
@interface GLD_HomeListCell ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong)UICollectionView *collectionView;
@end
@implementation GLD_HomeListCell


- (void)setListData:(NSMutableArray *)listData{
    _listData = listData;
    
    [self.collectionView reloadData];
}
- (void)setupUI{
    [self.contentView addSubview:self.collectionView];
}

- (void)layout{
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}
- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    
    return MIN(self.listData.count, 15);
}
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return [self getIndustryCollecCell:indexPath];
}

- (GLD_IndustryCollecCell *)getIndustryCollecCell:(NSIndexPath *)indexPath{
    GLD_IndustryCollecCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:GLD_IndustryCollecCellIdentifier forIndexPath:indexPath];
    if (indexPath.row == 14) {
        GLD_IndustryModel *model = [GLD_IndustryModel new];
        model.iconImage = @"所有分类";
        model.title = @"所有分类";
        cell.model = model;
    }else{
        
        cell.model = self.listData[indexPath.item];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 14) {
        //所有分类
        GLD_AllCateController *allVc = [GLD_AllCateController new];
        allVc.listData = self.listData;
        [self.contentView.navigationController pushViewController:allVc animated:YES];
        return;
    }
    GLD_BusinessListController *listVc = [[GLD_BusinessListController alloc]init];
    listVc.cityName = [AppDelegate shareDelegate].placemark.locality;

    listVc.model = self.listData[indexPath.row];
    [self.collectionView.navigationController pushViewController:listVc animated:YES];
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        //展示产品
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        //不知道为什么 cell 比collectionView大  就不会调用
        //        flowLayout.itemSize = self.listCollection.bounds.size;
        flowLayout.itemSize = CGSizeMake(W(75), W(50));
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(W(10), 0.1, 0.1, 0.1);
        flowLayout.scrollDirection =UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(-10, -10, 10, 10) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[GLD_IndustryCollecCell class] forCellWithReuseIdentifier:GLD_IndustryCollecCellIdentifier];

        
    }
    return _collectionView;
}


@end
