//
//  GLD_MinePersonalCell.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/5.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_MinePersonalCell.h"
#import "GLD_IndustryCollecCell.h"
#import "GLD_IndustryModel.h"
#import "GLD_MyCollectionController.h"
#import "GLD_MyOrderController.h"
NSString *const GLD_MinePersonalCellIdentifier = @"GLD_MinePersonalCellIdentifier";
@interface GLD_MinePersonalCell ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, copy)NSArray<GLD_IndustryModel *> *listData;
@end
@implementation GLD_MinePersonalCell

- (void)setupUI{
    [self.contentView addSubview:self.collectionView];
    GLD_IndustryModel *model = [GLD_IndustryModel new];
    model.title = @"我的订单";
    model.iconImage = @"我的订单";
    GLD_IndustryModel *model1 = [GLD_IndustryModel new];
    model1.title = @"门店收藏";
    model1.iconImage = @"门店收藏";
    self.listData = @[model, model1];
}

- (void)layout{
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
//    self.collectionView.sd_layout
//    .leftEqualToView(self.contentView)
//    .rightEqualToView(self.contentView)
//    .topEqualToView(self.contentView)
//    .heightIs(W(80));
    
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
    if (indexPath.row == 0) {
        GLD_MyOrderController *myCollect = [[GLD_MyOrderController alloc]init];
        [self.contentView.navigationController pushViewController:myCollect animated:YES];
        NSLog(@"我的订单");
    }else{
        GLD_MyCollectionController *myCollect = [[GLD_MyCollectionController alloc]init];
        [self.contentView.navigationController pushViewController:myCollect animated:YES];
    }
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        //展示产品
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        //不知道为什么 cell 比collectionView大  就不会调用
        //        flowLayout.itemSize = self.listCollection.bounds.size;
        flowLayout.itemSize = CGSizeMake(W(50), W(80));
        flowLayout.minimumInteritemSpacing = W(90);
//        flowLayout.minimumLineSpacing = 20;
        flowLayout.sectionInset = UIEdgeInsetsMake(W(10), W(90), W(10), W(90));
//        flowLayout.scrollDirection =UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(-10, -10, 10, 10) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.scrollEnabled = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[GLD_IndustryCollecCell class] forCellWithReuseIdentifier:GLD_IndustryCollecCellIdentifier];
        
        
    }
    return _collectionView;
}


@end
