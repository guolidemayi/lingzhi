//
//  GLD_PostTypeManager.m
//  lingzhi
//
//  Created by 锅里的 on 2019/5/15.
//  Copyright © 2019 com.lingzhi. All rights reserved.
//

#import "GLD_PostTypeManager.h"
#import "GLD_PersonalTagFlowLayout.h"
@interface GLD_postTypeCell : UICollectionViewCell

@property (nonatomic, strong) UIButton *but;
@end

@implementation GLD_postTypeCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self.contentView addSubview:self.but];
        self.but.frame = self.bounds;
    }
    return self;
}

- (UIButton *)but{
    if (!_but) {
        _but = [[UIButton alloc]init];
        _but.userInteractionEnabled = NO;
        [_but setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_blackLabelColor] forState:UIControlStateNormal];
        [_but setImage:WTImage(@"默认选中支付方式_icon") forState:UIControlStateSelected];
        [_but setImage:WTImage(@"未选中支付_icon") forState:UIControlStateNormal];
        
    }
    return _but;

}
@end
@interface GLD_PostTypeManager ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, assign) NSInteger seletedType;
@property (nonatomic, weak) id<GLD_PostTypeManagerDelegate> delegate;
@end
@implementation GLD_PostTypeManager

- (instancetype)initWithDelegate:(id<GLD_PostTypeManagerDelegate>)delegate{
    if (self = [super init]) {
        self.delegate = delegate;
        self.seletedType = 0;
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    GLD_postTypeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GLD_postTypeCell" forIndexPath:indexPath];
    
    if (self.seletedType == indexPath.item) {
        cell.but.selected = YES;
    }else{
        cell.but.selected = NO;
    }
    [cell.but setTitle:self.dataArr[indexPath.item] forState:UIControlStateNormal];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.seletedType = indexPath.item;
    
    if ([self.delegate respondsToSelector:@selector(didSeletedPoseType:)]) {
        [self.delegate didSeletedPoseType:self.seletedType + 1];
    }
    [collectionView reloadData];
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        //展示产品
        
        GLD_PersonalTagFlowLayout *flowLayout = [[GLD_PersonalTagFlowLayout alloc]initWithType:AlignWithCenter betweenOfCell:14];
        //不知道为什么 cell 比collectionView大  就不会调用
        //        flowLayout.itemSize = self.listCollection.bounds.size;
        flowLayout.itemSize = CGSizeMake(W(100), W(44));
//        flowLayout.minimumInteritemSpacing = 0;
//        flowLayout.minimumLineSpacing = 0;
//        flowLayout.sectionInset = UIEdgeInsetsMake(W(10), 0.1, 0.1, 0.1);
//        flowLayout.scrollDirection =UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(-10, -10, 10, 10) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[GLD_postTypeCell class] forCellWithReuseIdentifier:@"GLD_postTypeCell"];
        
        
    }
    return _collectionView;
}
- (NSArray *)dataArr{
    if (!_dataArr) {
        _dataArr = @[@" 跑腿服务",@" 帮办服务",@" 代买服务"];
        
    }
    return _dataArr;
}
@end
