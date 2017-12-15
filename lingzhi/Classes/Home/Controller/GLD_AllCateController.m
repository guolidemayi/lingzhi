//
//  GLD_AllCateController.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/14.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_AllCateController.h"
#import "GLD_IndustryCollecCell.h"
#import "GLD_IndustryModel.h"
#import "UIView+gldController.h"
#import "GLD_BusinessListController.h"

@interface GLD_AllCateController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong)UICollectionView *collectionView;
@end
@implementation GLD_AllCateController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setupUI];
    [self layout];
}

- (void)setListData:(NSArray *)listData{
    _listData = listData;
    
    [self.collectionView reloadData];
}
- (void)setupUI{
    [self.view addSubview:self.collectionView];
}

- (void)layout{
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    
    return self.listData.count;
}
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return [self getIndustryCollecCell:indexPath];
}

- (GLD_IndustryCollecCell *)getIndustryCollecCell:(NSIndexPath *)indexPath{
    GLD_IndustryCollecCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:GLD_IndustryCollecCellIdentifier forIndexPath:indexPath];
    cell.model = self.listData[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   
    GLD_BusinessListController *listVc = [[GLD_BusinessListController alloc]init];
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
        flowLayout.sectionInset = UIEdgeInsetsMake(0.1, 0.1, 0.1, 0.1);
        flowLayout.scrollDirection =UICollectionViewScrollDirectionVertical;
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
