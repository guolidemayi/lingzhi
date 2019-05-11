//
//  GLD_TwoStoreCell.m
//  lingzhi
//
//  Created by 锅里的 on 2019/5/7.
//  Copyright © 2019 com.lingzhi. All rights reserved.
//

#import "GLD_TwoStoreCell.h"
#import "CollectionViewCell.h"
#import "GLD_GoodsDetailController.h"


@interface GLD_TwoStoreCell ()

@property (nonatomic, strong) CollectionViewCell *store1Cell;
@property (nonatomic, strong) CollectionViewCell *store2Cell;

@end

@implementation GLD_TwoStoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel1:(GLD_StoreDetailModel *)model1 andModel2:(GLD_StoreDetailModel *__nullable)model2{
    self.store1Cell.model = model1;
    self.store2Cell.model = model2;
}
- (void)setupUI{
    self.store1Cell = [[CollectionViewCell alloc]initWithFrame:CGRectMake(15, 0, 160, 120)];
    self.store2Cell = [[CollectionViewCell alloc]initWithFrame:CGRectMake(DEVICE_WIDTH - 160 - 15, 0, 160, 120)];
    [self.contentView addSubview:self.store1Cell];
    [self.contentView addSubview:self.store2Cell];
    [self.store1Cell addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(store1Click:)]];
    [self.store2Cell addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(store1Click:)]];
}
- (void)store1Click:(UITapGestureRecognizer *)tap{
    CollectionViewCell *cell = (CollectionViewCell *)tap.view;
    GLD_GoodsDetailController *goodsVc = [GLD_GoodsDetailController new];
    goodsVc.storeModel = cell.model;
    [self.contentView.navigationController pushViewController:goodsVc animated:YES];
}
- (void)store2Click:(UITapGestureRecognizer *)tap{
    CollectionViewCell *cell = (CollectionViewCell *)tap.view;
    GLD_GoodsDetailController *goodsVc = [GLD_GoodsDetailController new];
    goodsVc.type = 1;
    goodsVc.storeModel = cell.model;
    [self.contentView.navigationController pushViewController:goodsVc animated:YES];
}

@end
