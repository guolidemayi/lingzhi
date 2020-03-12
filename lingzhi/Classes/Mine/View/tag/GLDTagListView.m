//
//  GLDTagListView.m
//  HLFamily
//
//  Created by 博学明辨 on 2019/11/25.
//  Copyright © 2019 博学明辨. All rights reserved.
//

#import "GLDTagListView.h"
#import "GLD_PersonalTagFlowLayout.h"
#import "GLDTagItemCell.h"
#import "GLDTagViewModel.h"

@interface GLDTagListView ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *pickupBut;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, weak) id<GLDTagListViewDelegate> tagDelegate;

@end
@implementation GLDTagListView


+ (instancetype)instanceWithtagViewWithDelegate:(id<GLDTagListViewDelegate>)delegate;{
    GLDTagListView *tag = [GLDTagListView new];
    tag.tagDelegate = delegate;
    tag.alpha = 0;
    tag.backgroundColor = [YXUniversal colorWithHexString:@"000000" alpha:.5];
    [tag setupUI];
    [tag layout];
    return tag;
}

- (void)show:(GLDTagViewModel *)model{
    
    if (model) {
        for (GLDTagViewModel *mm in self.selectArr) {
            if ([mm.tagId isEqualToString:model.tagId]) {
                [self.selectArr removeObject:mm];break;
            }
        }
        [self.collectionView reloadData];
    }
    [self.superview bringSubviewToFront:self];
    [UIView animateWithDuration:.3 animations:^{
        self.alpha = 1;
    }];
}

- (void)pickupButClick{
    
    [UIView animateWithDuration:.3 animations:^{
        self.alpha = 0;
    }completion:^(BOOL finished) {
       [self.superview sendSubviewToBack:self];
    }];
}

- (void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    [self.collectionView reloadData];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self pickupButClick];
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   
   
    
    GLDTagViewModel *viewModel = self.dataArr[indexPath.row];
//    if(self.dataArr.count > indexPath.row){
//        viewModel = self.dataArr[indexPath.row];
//        if ([self containObj:viewModel]) {
//            [self.selectArr removeObject:viewModel];
//        }else{
//            //最多三个
//            if (self.selectArr.count == 3) {
//
//                return;
//            }
//            [self.selectArr addObject:viewModel];
//
//        }
//        [collectionView reloadData];
//        if ([self.tagDelegate respondsToSelector:@selector(didSelectTagItem:)]) {
//            [self.tagDelegate didSelectTagItem:self.selectArr];
//        }
//        return;
//    }
    if ([self.tagDelegate respondsToSelector:@selector(didSelectTagItem:)]) {
        [self.tagDelegate didSelectTagItem:@[viewModel]];
    }
    [self pickupButClick];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataArr.count == indexPath.row) return CGSizeMake(W(100), W(35));
    GLDTagViewModel *viewModel = self.dataArr[indexPath.row];
    return CGSizeMake(viewModel.itemWidth, W(35));
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    GLDTagItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GLDTagItemCell" forIndexPath:indexPath];
    if (self.dataArr.count <= indexPath.row) {
        [cell hasBorder:YES];
        cell.tagLabel.text = @"+ 新增主题";
        cell.tagLabel.textColor = [YXUniversal colorWithHexString:COLOR_YX_blackLabelColor];
        cell.tagLabel.backgroundColor = [UIColor whiteColor];
    }else{
        
        GLDTagViewModel *viewModel = self.dataArr[indexPath.row];
        cell.tagLabel.backgroundColor = [YXUniversal colorWithHexString:THEM_LightBgYellow];
        [cell hasBorder:NO];
        [cell hasSelect:[self containObj:viewModel]];
        cell.tagLabel.text = viewModel.nameStr;
    }
    return cell;
}

- (BOOL)containObj:(GLDTagViewModel *)viewModel{
    
    for (GLDTagViewModel *viewM in self.selectArr) {
        if ([viewModel.tagId isEqualToString:viewM.tagId]) {
            return YES;
        }
    }
    return NO;
}
- (void)setupUI{
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.pickupBut];
    [self.bgView addSubview:self.collectionView];
    
}
- (void)layout{
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.equalTo(self);
        make.height.equalTo(@(W(343) + iPhoneXTopHeight));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(W(20));
        make.left.equalTo(self.bgView).offset(W(10));
    }];
    
    [self.pickupBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView).offset(-W(10));
        make.centerY.equalTo(self.titleLabel);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgView);
        make.right.left.equalTo(self.bgView);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(W(10));
    }];
}
- (UILabel *)titleLabel {
   if (!_titleLabel) {
       _titleLabel = [UILabel new];
       _titleLabel.text = @"请选择类别";
//       _titleLabel.attributedText = [GLDUnitTool changeColorLabel:@"选择主题 最多可选择3个主题" find:@"最多可选择3个主题" flMaxFont:20 flMinFont:18 maxColor:[UIColor colorWithHexString:@"#040303"] minColor:[UIColor colorWithHexString:@"#666666"]];
   }
   return _titleLabel;
}

- (UIButton *)pickupBut {
   if (!_pickupBut) {
       _pickupBut = [UIButton buttonWithType:UIButtonTypeCustom];
       _pickupBut.titleLabel.font = WTFont(16);
       [_pickupBut setTitle:@"取消" forState:UIControlStateNormal];
       [_pickupBut setTitleColor:[YXUniversal colorWithHexString:@"#576B93"] forState:UIControlStateNormal];
       [_pickupBut addTarget:self action:@selector(pickupButClick) forControlEvents:UIControlEventTouchUpInside];
   }
   return _pickupBut;
}

- (UICollectionView *)collectionView {
   if (!_collectionView) {
        GLD_PersonalTagFlowLayout *flowLayout = [[GLD_PersonalTagFlowLayout alloc] initWithType:AlignWithLeft betweenOfCell:W(20)];
//        flowLayout.minimumInteritemSpacing = W(20);
       _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
       _collectionView.backgroundColor = [UIColor whiteColor];
       _collectionView.delegate = self;
       _collectionView.dataSource = self;
       [_collectionView registerClass:[GLDTagItemCell class] forCellWithReuseIdentifier:@"GLDTagItemCell"];
   }
   return _collectionView;
}

- (UIView *)bgView {
   if (!_bgView) {
       _bgView = [UIView new];
       _bgView.backgroundColor = [UIColor whiteColor];
       _bgView.frame = CGRectMake(0, 0, W(375), W(190));
   }
   return _bgView;
}

- (NSMutableArray *)selectArr{
    if (!_selectArr) {
        _selectArr = [NSMutableArray array];
    }
    return _selectArr;
}
@end
