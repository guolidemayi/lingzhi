//
//  GLD_ChooseGoodsView.m
//  lingzhi
//
//  Created by 锅里的 on 2019/5/8.
//  Copyright © 2019 com.lingzhi. All rights reserved.
//

#import "GLD_ChooseGoodsView.h"
#import "GLD_StoreDetailModel.h"

@interface GLD_TimeCell : UICollectionViewCell

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *contentLabel;
- (void)cellDeSelected;
- (void)cellSelected;
@end

@implementation GLD_TimeCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self layout];
        
    }
    return self;
}

- (void)cellSelected{
    self.bgView.backgroundColor = [YXUniversal colorWithHexString:COLOR_YX_Text_Red alpha:.3];
    self.bgView.layer.borderWidth = 1;
    
}
- (void)cellDeSelected{
    
    self.bgView.backgroundColor = [YXUniversal colorWithHexString:COLOR_YX_DRAKgray alpha:.1];
    self.bgView.layer.borderWidth = 0;
}
- (void)setupUI{
    [self.contentView addSubview:self.bgView];
    [self.contentView addSubview:self.contentLabel];
    
}
- (void)layout{
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(W(15));
        make.top.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.bgView);
        make.left.equalTo(self.bgView).offset(10);
        make.right.bottom.equalTo(self.bgView);
    }];
}
- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [UILabel creatLableWithText:@"" andFont:WTFont(12) textAlignment:NSTextAlignmentCenter textColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKblack]];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
    
}
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.layer.cornerRadius = 3;
        _bgView.layer.borderColor = [YXUniversal colorWithHexString:COLOR_YX_Text_Red].CGColor;
        _bgView.layer.borderWidth = 1;
        
    }
    return _bgView;
    
}
@end

@interface GLD_ChooseGoodsView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *iconImageV;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabrel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIButton *addCountBut;
@property (weak, nonatomic) IBOutlet UIButton *deleteCountBut;

@property (nonatomic, assign) NSInteger selecterCount;//数量

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) NSArray *dataArr;
@end
@implementation GLD_ChooseGoodsView


+ (instancetype)instanceChooseGoodsView{
    GLD_ChooseGoodsView *chooseView = [[NSBundle mainBundle]loadNibNamed:@"GLD_ChooseGoodsView" owner:nil options:nil].firstObject;
    [chooseView setConfigure];
//    [chooseView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:chooseView action:@selector(dismissClick)]];
    return chooseView;
}

- (void)setConfigure{
    self.selectedIndex = 0;
    self.selecterCount = 1;
    self.userInteractionEnabled = YES;
    self.collectionView.userInteractionEnabled = YES;
    [self.collectionView registerClass:[GLD_TimeCell class] forCellWithReuseIdentifier:@"GLD_TimeCell"];
}
//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
//    CGPoint newP = [self convertPoint:point toView:self.collectionView];
//    if ( [self.collectionView pointInside:newP withEvent:event]) {
//        return self.collectionView;
//    }else{
//        return [super hitTest:point withEvent:event];
//    }
//}
- (void)setStoreModel:(GLD_StoreDetailModel *)storeModel{
    _storeModel = storeModel;
    [self.iconImageV yy_setImageWithURL:[NSURL URLWithString:storeModel.pic] placeholder:WTImage(@"")];
    self.goodsNameLabrel.text = storeModel.title;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%ld",storeModel.price];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissClick];
}
- (void)dismissClick{
    if ([self.timeDelegate respondsToSelector:@selector(didSelectedTimeItem:andChooseCount:)]) {
        [self.timeDelegate didSelectedTimeItem:-1 andChooseCount:-1];
    }
}
- (IBAction)addCountButClick:(id)sender {
    self.countLabel.text = [NSString stringWithFormat:@"%ld",++self.selecterCount];
    
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",self.storeModel.price.floatValue * self.selecterCount];
}
- (IBAction)deleteCountButClick:(id)sender {
    if (self.selecterCount == 1) {
        return;
    }
    self.countLabel.text = [NSString stringWithFormat:@"%ld",--self.selecterCount];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",self.storeModel.price.floatValue * self.selecterCount];
}
- (IBAction)commitButClick:(id)sender {
//    [self dismissClick];
    if ([self.timeDelegate respondsToSelector:@selector(didSelectedTimeItem:andChooseCount:)]) {
        [self.timeDelegate didSelectedTimeItem:self.selectedIndex andChooseCount:self.selecterCount];
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    GLD_TimeCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"GLD_TimeCell" forIndexPath:indexPath];
//    GLD_NativePackageModel *model = self.dataArr[indexPath.item];
    cell.contentLabel.text = self.dataArr[indexPath.item];
//
//    cell.contentLabel.text = [NSString stringWithFormat:@"%@ %@",self.time,[model.timing substringToIndex:5]];
    if (self.selectedIndex == indexPath.item) {
        [cell cellSelected];
    }else{
        [cell cellDeSelected];
    }
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(W(150), H(30));
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectedIndex == indexPath.item) return;
    self.selectedIndex = indexPath.item;
    
    [self.collectionView reloadData];
}

- (NSArray *)dataArr{
    if (!_dataArr) {
        _dataArr = @[@"jldjljjlkjl",@"hkjhglksajh",@"jldjljjlkjl",@"hkjhglksajh",@"jldjljjlkjl",@"hkjhglksajh",@"jldjljjlkjl",@"hkjhglksajh",@"jldjljjlkjl",@"hkjhglksajh",@"jldjljjlkjl",@"hkjhglksajh",@"jldjljjlkjl",@"hkjhglksajh",@"jldjljjlkjl",@"hkjhglksajh",@"jldjljjlkjl",@"hkjhglksajh",@"jldjljjlkjl",@"hkjhglksajh"];
        
    }
    return _dataArr;
}
@end
